import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/app_notification.dart';
import '../models/chat_conversation.dart';
import '../services/chenge_api.dart';
import '../services/notification_badge.dart';
import '../theme/app_theme.dart';
import 'chat_thread_page.dart';
import 'post_detail_page.dart';
import 'shop_detail_page.dart';

/// 通知中心：站内通知 + 系统公告。
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
    required this.api,
    required this.token,
    this.badge,
    this.userId,
    this.onLoginRequested,
  });

  final ChengeApi api;
  final String token;
  final NotificationBadge? badge;
  final int? userId;
  final VoidCallback? onLoginRequested;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  final _items = <AppNotification>[];
  final _announcements = <Announcement>[];
  String _typeFilter = '';
  String _error = '';
  bool _loading = false;
  bool _busy = false;
  int _unread = 0;
  final Map<String, int> _unreadByType = {};
  bool _forceReadShown = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final results = await Future.wait<Object>([
        widget.api.notifications(widget.token),
        widget.api.announcements(widget.token),
      ]);
      if (!mounted) return;
      final feed = results[0] as AppNotificationFeed;
      setState(() {
        _items
          ..clear()
          ..addAll(feed.items);
        _unread = feed.unread;
        _unreadByType
          ..clear()
          ..addAll(feed.unreadByType);
        _announcements
          ..clear()
          ..addAll(results[1] as List<Announcement>);
      });
      widget.badge?.setUnread(feed.unread);
      _maybeShowForceRead();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _maybeShowForceRead() {
    if (_forceReadShown || !mounted) return;
    final pending = _announcements.where((a) => a.isUnread && a.forceRead).toList();
    if (pending.isEmpty) return;
    _forceReadShown = true;
    final announcement = pending.first;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (sheetContext) => AlertDialog(
          title: Text(
            AppLocalizations.of(sheetContext).systemAnnouncement,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: SizedBox(
            width: 460,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(data: announcement.content),
                ],
              ),
            ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(sheetContext),
              child: Text(AppLocalizations.of(sheetContext).gotIt),
            ),
          ],
        ),
      );
      await _markAnnouncement(announcement);
      _maybeShowForceRead();
    });
  }

  int get _unreadAnnouncements =>
      _announcements.where((item) => item.isUnread).length;

  Future<void> _markRead(AppNotification item) async {
    if (item.isRead) return;
    setState(() {
      final index = _items.indexWhere((element) => element.id == item.id);
      if (index >= 0) _items[index] = _items[index].copyWith(readFlag: 1);
      _unread = _unread > 0 ? _unread - 1 : 0;
      final count = _unreadByType[item.type];
      if (count != null) {
        if (count <= 1) {
          _unreadByType.remove(item.type);
        } else {
          _unreadByType[item.type] = count - 1;
        }
      }
    });
    widget.badge?.setUnread(_unread);
    try {
      await widget.api.markNotificationRead(item.id, widget.token);
    } on ApiException {
      if (mounted) setState(() => _typeFilter = _typeFilter);
    }
  }

  Future<void> _markAllRead() async {
    if (_busy || _unread == 0) return;
    setState(() => _busy = true);
    try {
      await widget.api.markAllNotificationsRead(widget.token);
      if (!mounted) return;
      setState(() {
        for (var i = 0; i < _items.length; i++) {
          _items[i] = _items[i].copyWith(readFlag: 1);
        }
        _unread = 0;
        _unreadByType.clear();
      });
      widget.badge?.clearLocal();
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clearAll() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (sheetContext) => AlertDialog(
        content: Text(l10n.clearNotificationsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(sheetContext, false),
            child: Text(AppLocalizations.of(sheetContext).cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(sheetContext, true),
            child: Text(AppLocalizations.of(sheetContext).clearNotifications),
          ),
        ],
      ),
    );
    if (ok != true || _busy) return;
    setState(() => _busy = true);
    try {
      await widget.api.clearNotifications(widget.token);
      if (!mounted) return;
      setState(() {
        _items.clear();
        _unread = 0;
        _unreadByType.clear();
      });
      widget.badge?.clearLocal();
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _markAnnouncement(Announcement announcement) async {
    if (!announcement.isUnread) return;
    try {
      await widget.api.markAnnouncementRead(
        announcement.id,
        announcement.version,
        widget.token,
      );
      if (!mounted) return;
      setState(() {
        final index = _announcements.indexWhere((item) => item.id == announcement.id);
        if (index >= 0) {
          _announcements[index] = _announcements[index].copyWith(
            readAt: DateTime.now(),
          );
        }
      });
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.coral));
  }

  Future<void> _openNotification(AppNotification item) async {
    await _markRead(item);
    if (!mounted) return;
    final token = widget.token;
    switch (item.targetType) {
      case 'conversation':
        await _openConversation(item);
        return;
      case 'post':
        final postId = int.tryParse(item.targetId);
        if (postId == null) return;
        try {
          final post = await widget.api.postDetail(postId, token: token);
          if (!mounted) return;
          await Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder: (_) => PostDetailPage(api: widget.api, post: post, token: token),
            ),
          );
        } on ApiException catch (error) {
          if (mounted) _showError(error.message);
        }
        return;
      case 'item':
        final itemId = int.tryParse(item.targetId);
        if (itemId == null) return;
        try {
          final shopItem = await widget.api.shopItem(itemId, token: token);
          if (!mounted) return;
          await Navigator.of(context).push<void>(
            MaterialPageRoute<void>(
              builder:
                  (_) => ShopDetailPage(
                    api: widget.api,
                    item: shopItem,
                    token: token,
                    userId: widget.userId,
                    onLoginRequested: widget.onLoginRequested ?? () {},
                  ),
            ),
          );
        } on ApiException catch (error) {
          if (mounted) _showError(error.message);
        }
        return;
      case 'group_invite':
        await _openGroupInvite(item);
        return;
      case 'bill':
        await _showTextDialog(item.title, item.body);
        return;
      default:
        final text = [item.title, item.body]
            .where((part) => part.trim().isNotEmpty)
            .join('\n\n');
        if (text.isEmpty) return;
        await _showTextDialog(item.title, text);
    }
  }

  Future<void> _openConversation(AppNotification item) async {
    final conversationId = item.conversationId;
    if (conversationId == null) return;
    try {
      final conversations = await widget.api.conversations(widget.token);
      ChatConversation? target;
      for (final conversation in conversations) {
        if (conversation.id == conversationId) {
          target = conversation;
          break;
        }
      }
      if (!mounted) return;
      if (target == null) {
        _showError(AppLocalizations.of(context).conversationUnavailable);
        return;
      }
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder:
              (_) => ChatThreadPage(
                api: widget.api,
                token: widget.token,
                userId: widget.userId,
                conversation: target!,
                initialChannelId: item.channelId,
              ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  Future<void> _openGroupInvite(AppNotification item) async {
    final requestId = int.tryParse(item.targetId);
    if (requestId == null) return;
    try {
      final request = await widget.api.groupInviteRequest(requestId, widget.token);
      if (!mounted) return;
      final groupName = (request['group_name'] ?? request['groupName'] ?? '').toString();
      final accept = await showDialog<bool>(
        context: context,
        builder: (sheetContext) => AlertDialog(
          title: Text(
            AppLocalizations.of(sheetContext).notifyGroupInvite,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          content: Text(
            groupName.isEmpty
                ? (request['status']?.toString() ?? '')
                : AppLocalizations.of(sheetContext).groupInvitePrompt(groupName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(sheetContext, false),
              child: Text(AppLocalizations.of(sheetContext).decline),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(sheetContext, true),
              child: Text(AppLocalizations.of(sheetContext).accept),
            ),
          ],
        ),
      );
      if (accept == null) return;
      final result = await widget.api.respondGroupInvite(
        requestId,
        accept,
        widget.token,
      );
      if (!mounted || !accept) return;
      final conversationId = int.tryParse(result['id']?.toString() ?? '');
      if (conversationId == null) return;
      await _openConversationById(conversationId);
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  Future<void> _openConversationById(int conversationId) async {
    try {
      final conversations = await widget.api.conversations(widget.token);
      ChatConversation? target;
      for (final conversation in conversations) {
        if (conversation.id == conversationId) {
          target = conversation;
          break;
        }
      }
      if (target == null || !mounted) return;
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder:
              (_) => ChatThreadPage(
                api: widget.api,
                token: widget.token,
                userId: widget.userId,
                conversation: target!,
              ),
        ),
      );
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  Future<void> _showTextDialog(String title, String body) => showDialog<void>(
    context: context,
    builder: (sheetContext) => AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: SingleChildScrollView(child: Text(body)),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(sheetContext),
          child: Text(AppLocalizations.of(sheetContext).gotIt),
        ),
      ],
    ),
  );

  Future<void> _openAnnouncement(Announcement announcement) async {
    await showDialog<void>(
      context: context,
      builder: (sheetContext) => AlertDialog(
        title: Text(
          announcement.title,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (announcement.publishedAt != null)
                  Text(
                    _formatDate(announcement.publishedAt!),
                    style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                  ),
                const SizedBox(height: 8),
                MarkdownBody(data: announcement.content),
              ],
            ),
          ),
        ),
        actions: [
          if (announcement.isUnread)
            TextButton(
              onPressed: () async {
                Navigator.pop(sheetContext);
                await _markAnnouncement(announcement);
              },
              child: Text(AppLocalizations.of(sheetContext).markAnnouncementRead),
            ),
          FilledButton(
            onPressed: () => Navigator.pop(sheetContext),
            child: Text(AppLocalizations.of(sheetContext).gotIt),
          ),
        ],
      ),
    );
  }

  String _typeLabel(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context);
    switch (type) {
      case 'friend_request':
        return l10n.notifyFriendRequest;
      case 'friend_accept':
        return l10n.notifyFriendAccept;
      case 'message':
        return l10n.notifyMessage;
      case 'like':
        return l10n.notifyLike;
      case 'comment':
        return l10n.notifyComment;
      case 'mention':
        return l10n.notifyMention;
      case 'follow':
        return l10n.notifyFollow;
      case 'share':
        return l10n.notifyShare;
      case 'group_invite':
        return l10n.notifyGroupInvite;
      case 'draw':
        return l10n.notifyDraw;
      case 'bill':
        return l10n.notifyBill;
      default:
        return l10n.notifySystem;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'friend_request':
      case 'friend_accept':
        return Icons.person_add_alt_1_rounded;
      case 'message':
        return Icons.chat_bubble_outline_rounded;
      case 'like':
        return Icons.favorite_border_rounded;
      case 'comment':
        return Icons.mode_comment_outlined;
      case 'mention':
        return Icons.alternate_email_rounded;
      case 'follow':
        return Icons.group_add_outlined;
      case 'share':
        return Icons.share_outlined;
      case 'group_invite':
        return Icons.groups_2_outlined;
      case 'draw':
        return Icons.image_outlined;
      case 'bill':
        return Icons.receipt_long_outlined;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  static String _formatDate(DateTime time) {
    final local = time.toLocal();
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';
  }

  static String _relativeTime(DateTime? time) {
    if (time == null) return '';
    final local = time.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
    if (diff.inHours < 24) return '${diff.inHours} 小时前';
    if (diff.inDays < 7) return '${diff.inDays} 天前';
    return _formatDate(local);
  }

  List<String> get _presentTypes {
    final types = <String>{for (final item in _items) item.type};
    final ordered = [
      'bill',
      'message',
      'friend_request',
      'friend_accept',
      'group_invite',
      'system',
      'draw',
      'like',
      'comment',
      'mention',
      'follow',
      'share',
    ];
    return types.toList()..sort((a, b) {
      final ai = ordered.indexOf(a);
      final bi = ordered.indexOf(b);
      return (ai < 0 ? 99 : ai).compareTo(bi < 0 ? 99 : bi);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.notificationsTabMessages),
                  if (_unread > 0) ...[
                    const SizedBox(width: 6),
                    _badge(_unread),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.notificationsTabAnnouncements),
                  if (_unreadAnnouncements > 0) ...[
                    const SizedBox(width: 6),
                    _badge(_unreadAnnouncements),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [_messagesTab(), _announcementsTab()],
      ),
    );
  }

  Widget _badge(int count) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: AppTheme.coral,
      borderRadius: BorderRadius.circular(9),
    ),
    child: Text(
      count > 99 ? '99+' : '$count',
      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w800),
    ),
  );

  Widget _messagesTab() {
    final l10n = AppLocalizations.of(context);
    if (_loading && _items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty && _items.isEmpty) {
      return _errorView(l10n.retry, _load);
    }
    final filtered = _typeFilter.isEmpty
        ? _items
        : _items.where((item) => item.type == _typeFilter).toList();
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.notificationCount(_items.length),
                  style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
                ),
              ),
              TextButton.icon(
                onPressed: _unread == 0 || _busy ? null : _markAllRead,
                icon: const Icon(Icons.done_all_rounded, size: 16),
                label: Text(l10n.markAllRead),
              ),
              TextButton.icon(
                onPressed: _items.isEmpty || _busy ? null : _clearAll,
                icon: const Icon(Icons.delete_sweep_outlined, size: 16),
                label: Text(l10n.clearNotifications),
              ),
            ],
          ),
          if (_presentTypes.isNotEmpty)
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _typeChip(l10n.allModules, ''),
                  for (final type in _presentTypes)
                    _typeChip(
                      '${_typeLabel(context, type)} ${_unreadByType[type] ?? ''}'.trim(),
                      type,
                    ),
                ],
              ),
            ),
          const SizedBox(height: 6),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 56),
              child: Column(
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 44, color: Color(0xFF70817D)),
                  const SizedBox(height: 10),
                  Text(l10n.notificationsEmpty, style: const TextStyle(color: Color(0xFF70817D))),
                ],
              ),
            )
          else
            for (final item in filtered) ...[
              _notificationTile(item),
              const SizedBox(height: 6),
            ],
        ],
      ),
    );
  }

  Widget _typeChip(String label, String value) {
    final selected = _typeFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _typeFilter = value),
      ),
    );
  }

  Widget _notificationTile(AppNotification item) {
    final unread = !item.isRead;
    return Material(
      color: unread
          ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.28)
          : Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => _openNotification(item),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.leaf.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(_typeIcon(item.type), size: 19, color: AppTheme.leaf),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.title.isEmpty ? _typeLabel(context, item.type) : item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF3F0),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _typeLabel(context, item.type),
                            style: const TextStyle(fontSize: 10, color: Color(0xFF5B6B66)),
                          ),
                        ),
                      ],
                    ),
                    if (item.body.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        item.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12.5, height: 1.4, color: Color(0xFF4A5A55)),
                      ),
                    ],
                    const SizedBox(height: 3),
                    Text(
                      _relativeTime(item.createdAt),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF9AA8A3)),
                    ),
                  ],
                ),
              ),
              if (unread)
                Container(
                  margin: const EdgeInsets.only(left: 6, top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppTheme.coral, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _announcementsTab() {
    final l10n = AppLocalizations.of(context);
    if (_loading && _announcements.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_announcements.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Column(
              children: [
                const Icon(Icons.campaign_outlined, size: 44, color: Color(0xFF70817D)),
                const SizedBox(height: 10),
                Text(l10n.noAnnouncements, style: const TextStyle(color: Color(0xFF70817D))),
              ],
            ),
          ),
        ],
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        itemCount: _announcements.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final announcement = _announcements[index];
          return Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _openAnnouncement(announcement),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (announcement.isUnread) ...[
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(color: AppTheme.coral, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                        ],
                        Expanded(
                          child: Text(
                            announcement.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: announcement.isUnread ? FontWeight.w800 : FontWeight.w600,
                            ),
                          ),
                        ),
                        if (announcement.publishedAt != null)
                          Text(
                            _formatDate(announcement.publishedAt!),
                            style: const TextStyle(fontSize: 11, color: Color(0xFF9AA8A3)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      announcement.content.replaceAll(RegExp(r'[#*`>\-]'), ' ').trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12.5, height: 1.45, color: Color(0xFF4A5A55)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _errorView(String retry, VoidCallback onRetry) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_error, style: const TextStyle(color: AppTheme.coral), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        TextButton(onPressed: onRetry, child: Text(retry)),
      ],
    ),
  );
}
