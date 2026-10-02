import 'dart:async';

import 'package:flutter/material.dart';

import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import 'chat_thread_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.api,
    required this.token,
    required this.userId,
    required this.launchPeerId,
    required this.launchNonce,
    required this.onOpenFriends,
    required this.onLoginRequested,
    this.showAppBar = true,
  });

  final ChengeApi api;
  final String? token;
  final int? userId;
  final int? launchPeerId;
  final int launchNonce;
  final VoidCallback onOpenFriends;
  final VoidCallback onLoginRequested;
  final bool showAppBar;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _searchController = TextEditingController();
  final _conversations = <ChatConversation>[];
  ChatConversation? _active;
  Timer? _pollTimer;
  String _error = '';
  String _listQuery = '';
  bool _loadingList = false;

  @override
  void initState() {
    super.initState();
    _startSession();
  }

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _pollTimer?.cancel();
      _conversations.clear();
      _active = null;
      if (widget.token != null) _startSession();
    }
    if (oldWidget.launchNonce != widget.launchNonce && widget.launchPeerId != null && widget.token != null) {
      _openPeer(widget.launchPeerId!);
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startSession() {
    if (widget.token == null) return;
    _loadConversations();
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _loadConversations(silent: true);
    });
    if (widget.launchPeerId != null) _openPeer(widget.launchPeerId!);
  }

  Future<void> _loadConversations({bool silent = false}) async {
    final token = widget.token;
    if (token == null || _loadingList) return;
    if (!silent && mounted) setState(() => _loadingList = true);
    try {
      final conversations = await widget.api.conversations(token);
      if (!mounted) return;
      setState(() {
        _conversations
          ..clear()
          ..addAll(conversations.where((item) => item.type == 'single'));
        _error = '';
        final activeId = _active?.id;
        if (activeId != null) {
          for (final item in _conversations) {
            if (item.id == activeId) {
              _active = item;
              break;
            }
          }
        }
      });
    } on ApiException catch (error) {
      if (mounted && !silent) setState(() => _error = error.message);
    } finally {
      if (mounted && !silent) setState(() => _loadingList = false);
    }
  }

  Future<void> _openPeer(int peerId) async {
    final token = widget.token;
    if (token == null) return;
    try {
      final conversation = await widget.api.openSingleChat(peerId, token);
      if (!mounted) return;
      await _loadConversations();
      if (!mounted) return;
      if (!_conversations.any((item) => item.id == conversation.id)) {
        setState(() => _conversations.insert(0, conversation));
      }
      _selectConversation(conversation);
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  void _selectConversation(ChatConversation conversation) {
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    setState(() => _active = conversation);
    if (!isWide) {
      _pushThread(conversation);
    }
  }

  Future<void> _pushThread(ChatConversation conversation) async {
    final token = widget.token;
    if (token == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatThreadPage(
          api: widget.api,
          token: token,
          userId: widget.userId,
          conversation: conversation,
        ),
      ),
    );
    if (mounted) _loadConversations(silent: true);
  }

  void _showError(String message) {
    setState(() => _error = message);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.coral));
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 760;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('聊天', style: TextStyle(fontWeight: FontWeight.w800)),
              actions: [
                IconButton(
                    tooltip: '好友',
                    onPressed: widget.onOpenFriends,
                    icon: const Icon(Icons.people_outline_rounded)),
                IconButton(
                    tooltip: '刷新会话',
                    onPressed: _loadConversations,
                    icon: const Icon(Icons.refresh_rounded)),
                const SizedBox(width: 4),
              ],
            )
          : null,
      body: widget.token == null
          ? _signedOut()
          : isWide
              ? _wideLayout()
              : _conversationList(),
    );
  }

  Widget _signedOut() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: AppTheme.leaf, size: 54),
            const SizedBox(height: 12),
            const Text('登录后开始聊天', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 16),
            FilledButton.icon(
                onPressed: widget.onLoginRequested,
                icon: const Icon(Icons.login_rounded),
                label: const Text('前往登录')),
          ],
        ),
      );

  Widget _wideLayout() => Row(
        children: [
          SizedBox(width: 320, child: _conversationList()),
          const VerticalDivider(width: 1),
          Expanded(
            child: _active == null
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline_rounded, size: 56, color: Color(0xFF9DB5AB)),
                        SizedBox(height: 12),
                        Text('选择一个会话，开始聊天', style: TextStyle(color: Color(0xFF70817D))),
                      ],
                    ),
                  )
                : ChatThreadPage(
                    key: ValueKey('wide-thread-${_active!.id}'),
                    api: widget.api,
                    token: widget.token!,
                    userId: widget.userId,
                    conversation: _active!,
                    showBackButton: false,
                  ),
          ),
        ],
      );

  Widget _conversationList() {
    final query = _listQuery.trim().toLowerCase();
    final visible = _conversations.where((item) => item.name.toLowerCase().contains(query)).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _listQuery = value),
            decoration: const InputDecoration(hintText: '搜索会话', prefixIcon: Icon(Icons.search_rounded)),
          ),
        ),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Text(
              _error,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppTheme.coral, fontSize: 12),
            ),
          ),
        Expanded(
          child: _loadingList && _conversations.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : visible.isEmpty
                  ? _emptyConversations()
                  : RefreshIndicator(
                      onRefresh: _loadConversations,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: visible.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 5),
                        itemBuilder: (context, index) => _conversationTile(visible[index]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _conversationTile(ChatConversation conversation) {
    final active = _active?.id == conversation.id;
    return Material(
      color: active ? AppTheme.leaf.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _selectConversation(conversation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 11),
          child: Row(
            children: [
              _avatar(conversation.name, conversation.avatar, radius: 22),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          _shortTime(conversation.updatedAt),
                          style: const TextStyle(fontSize: 10, color: Color(0xFF70817D)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _preview(conversation.lastMessage),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
                          ),
                        ),
                        if (conversation.unread > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            constraints: const BoxConstraints(minWidth: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration:
                                BoxDecoration(color: AppTheme.coral, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '${conversation.unread}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyConversations() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.forum_outlined, size: 48, color: AppTheme.leaf),
              const SizedBox(height: 10),
              Text(
                _listQuery.isNotEmpty ? '没有匹配的会话' : '还没有私聊',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              TextButton.icon(
                onPressed: widget.onOpenFriends,
                icon: const Icon(Icons.people_outline_rounded),
                label: const Text('去好友列表发起聊天'),
              ),
            ],
          ),
        ),
      );

  Widget _avatar(String name, String? url, {required double radius}) => CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFFFE8C5),
        foregroundImage: url == null ? null : NetworkImage(url),
        onForegroundImageError: url == null ? null : (_, __) {},
        child: Text(
          name.isEmpty ? '友' : name.characters.first,
          style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w700),
        ),
      );

  static String _preview(ChatMessage? message) {
    if (message == null) return '还没有消息';
    if (message.type == 'emoji') return '[表情] ${_emojiKey(message.content)}';
    if (message.type == 'post') return '[分享帖子]';
    if (message.type == 'order') return '[分享商品]';
    return message.content;
  }

  static String _emojiKey(String content) => EmojiMessageContent.tryParse(content)?.key ?? '表情消息';

  static String _shortTime(DateTime? value) {
    if (value == null) return '';
    final date = value.toLocal();
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.month}/${date.day}';
  }
}
