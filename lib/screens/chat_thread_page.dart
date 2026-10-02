import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

/// 独立会话页。
/// - 窄屏：Navigator.push 进入，带返回键；拉宽到宽屏时自动 pop(true) 交给外层分栏。
/// - 宽屏嵌入：showBackButton=false。
class ChatThreadPage extends StatefulWidget {
  const ChatThreadPage({
    super.key,
    required this.api,
    required this.token,
    required this.userId,
    required this.conversation,
    this.showBackButton = true,
    this.peerOnline,
  });

  final ChengeApi api;
  final String token;
  final int? userId;
  final ChatConversation conversation;
  final bool showBackButton;
  final bool? peerOnline;

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final _messageController = TextEditingController();
  final _messageScrollController = ScrollController();
  final _messages = <ChatMessage>[];
  Timer? _pollTimer;
  bool _loading = false;
  bool _loadingOlder = false;
  bool _sending = false;
  bool _hasMore = false;
  bool _stickToBottom = true;
  bool _initialScrollDone = false;
  bool _popScheduled = false;
  late ChatConversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _messageScrollController.addListener(_onScroll);
    _loadMessages();
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _loadMessages(silent: true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybePopForWideLayout();
  }

  void _maybePopForWideLayout() {
    if (!widget.showBackButton || _popScheduled) return;
    if (MediaQuery.sizeOf(context).width < 760) return;
    _popScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _messageController.dispose();
    _messageScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (_loading && !silent) return;
    if (!silent && mounted) setState(() => _loading = true);
    try {
      final messages = await widget.api.chatMessages(_conversation.id, widget.token);
      if (!mounted) return;
      final byId = {for (final m in _messages) m.id: m};
      for (final m in messages) {
        byId[m.id] = m;
      }
      final merged = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
      setState(() {
        _messages
          ..clear()
          ..addAll(merged);
        _hasMore = messages.length >= 30;
      });
      final lastId = merged.isEmpty ? null : merged.last.id;
      await widget.api.markChatRead(_conversation.id, widget.token, messageId: lastId);
      if (_stickToBottom) {
        _scrollToBottom(animate: _initialScrollDone);
        if (!_initialScrollDone) _initialScrollDone = true;
      }
    } on ApiException catch (error) {
      if (mounted && !silent) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    } finally {
      if (mounted && !silent) setState(() => _loading = false);
    }
  }

  Future<void> _loadOlder() async {
    if (_loadingOlder || !_hasMore || _messages.isEmpty) return;
    setState(() => _loadingOlder = true);
    try {
      final older = await widget.api.chatMessages(
        _conversation.id,
        widget.token,
        beforeId: _messages.first.id,
      );
      if (!mounted) return;
      setState(() {
        _messages.insertAll(0, older);
        _hasMore = older.length >= 30;
      });
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    } finally {
      if (mounted) setState(() => _loadingOlder = false);
    }
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final message = await widget.api.sendChatMessage(_conversation.id, text, widget.token);
      if (!mounted) return;
      setState(() {
        if (!_messages.any((m) => m.id == message.id)) _messages.add(message);
        _messageController.clear();
        _stickToBottom = true;
      });
      _scrollToBottom(animate: true);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendEmoji(EmojiAsset asset) async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      final content = jsonEncode(asset.toSendJson());
      final message = await widget.api.sendChatMessage(
        _conversation.id,
        content,
        widget.token,
        type: 'emoji',
      );
      if (!mounted) return;
      setState(() {
        if (!_messages.any((m) => m.id == message.id)) _messages.add(message);
        _stickToBottom = true;
      });
      _scrollToBottom(animate: true);
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openEmojiPicker() async {
    final assets = await showModalBottomSheet<EmojiAsset>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _EmojiPickerSheet(api: widget.api, token: widget.token),
    );
    if (assets != null && mounted) {
      await _sendEmoji(assets);
    }
  }

  void _onScroll() {
    if (!_messageScrollController.hasClients) return;
    final position = _messageScrollController.position;
    _stickToBottom = position.maxScrollExtent - position.pixels < 80;
    if (position.pixels < 60) _loadOlder();
  }

  void _scrollToBottom({bool animate = true}) {
    void go() {
      if (!_messageScrollController.hasClients) return;
      final max = _messageScrollController.position.maxScrollExtent;
      if (animate) {
        _messageScrollController.animateTo(
          max,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      } else {
        _messageScrollController.jumpTo(max);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      go();
      if (!animate) {
        WidgetsBinding.instance.addPostFrameCallback((_) => go());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBackButton && MediaQuery.sizeOf(context).width >= 760) {
      _maybePopForWideLayout();
    }

    final isGroup = _conversation.type == 'group';
    final onlineLabel = !isGroup && widget.peerOnline != null
        ? (widget.peerOnline! ? ' · 在线' : ' · 离线')
        : '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        leading: widget.showBackButton
            ? IconButton(
                tooltip: '返回会话列表',
                onPressed: () => Navigator.of(context).pop(false),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _conversation.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            if (onlineLabel.isNotEmpty || isGroup)
              Text(
                isGroup ? '群聊' : onlineLabel.replaceFirst(' · ', ''),
                style: TextStyle(
                  fontSize: 12,
                  color: !isGroup && widget.peerOnline == true
                      ? const Color(0xFF2ECC71)
                      : const Color(0xFF70817D),
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _messageScrollController,
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  itemCount: _messages.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_hasMore && index == 0) {
                      return Center(
                        child: TextButton.icon(
                          onPressed: _loadingOlder ? null : _loadOlder,
                          icon: _loadingOlder
                              ? const SizedBox.square(
                                  dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.expand_less_rounded),
                          label: const Text('加载更早消息'),
                        ),
                      );
                    }
                    final message = _messages[index - (_hasMore ? 1 : 0)];
                    return _messageTile(message);
                  },
                ),
                if (_loading && _messages.isEmpty) const Center(child: CircularProgressIndicator()),
                if (_messages.isEmpty && !_loading)
                  const Center(child: Text('还没有消息，打个招呼吧', style: TextStyle(color: Color(0xFF70817D)))),
              ],
            ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _messageTile(ChatMessage message) {
    final mine = message.senderId == widget.userId;
    final bubbleColor = mine ? AppTheme.leaf : Colors.white;
    final textColor = mine ? Colors.white : AppTheme.ink;
    final isEmoji = message.type == 'emoji';
    final isShare = message.type == 'post' || message.type == 'order';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[
            _avatar(message.senderName ?? _conversation.name, message.senderAvatar, radius: 15),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!mine)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName ?? _conversation.name,
                      style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                    ),
                  ),
                if (isEmoji)
                  _emojiImage(message)
                else if (isShare)
                  _shareCard(message)
                else
                  Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(mine ? 16 : 4),
                        bottomRight: Radius.circular(mine ? 4 : 16),
                      ),
                    ),
                    child: SelectableText(
                      message.type == 'text' ? message.content : _specialMessage(message),
                      style: TextStyle(color: textColor, height: 1.4),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                  child: Text(
                    _shortTime(message.createdAt),
                    style: const TextStyle(fontSize: 10, color: Color(0xFF83918D)),
                  ),
                ),
              ],
            ),
          ),
          if (mine) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _shareCard(ChatMessage message) {
    final isPost = message.type == 'post';
    Map<String, dynamic> payload = {};
    try {
      final decoded = jsonDecode(message.content);
      if (decoded is Map<String, dynamic>) payload = decoded;
    } catch (_) {}
    final title = (payload['title'] ?? (isPost ? '帖子' : '商品')).toString();
    final subtitle = isPost ? '点击查看该帖子 ›' : '点击查看该商品的订单 ›';

    return Material(
      color: Colors.white,
      elevation: 0.5,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigation to post/shop can be wired later; show snack for now.
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(isPost ? '帖子：$title' : '订单：$title')));
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 280, minWidth: 180),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2EAE5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPost ? const Color(0xFFE8F0FF) : const Color(0xFFFFF0E0),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isPost ? '分享帖子' : '商品订单',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isPost ? const Color(0xFF3D6BAA) : const Color(0xFFB86B1A),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _composer() => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2EAE5))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                tooltip: '表情包',
                onPressed: _sending ? null : _openEmojiPicker,
                icon: const Icon(Icons.emoji_emotions_outlined),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: '输入消息…',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: '发送消息',
                onPressed: _sending || _messageController.text.trim().isEmpty ? null : _send,
                icon: _sending
                    ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.send_rounded),
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

  Widget _emojiImage(ChatMessage message) {
    final emoji = message.emoji;
    if (emoji == null) return _emojiPlaceholder();
    if (emoji.url?.isNotEmpty == true) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Image.network(
          emoji.url!,
          width: 132,
          height: 132,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _emojiPlaceholder(),
          loadingBuilder: (context, child, progress) => progress == null ? child : _emojiPlaceholder(),
        ),
      );
    }
    return _emojiPlaceholder();
  }

  Widget _emojiPlaceholder() => Container(
        width: 132,
        height: 84,
        decoration: BoxDecoration(color: const Color(0xFFEAF2ED), borderRadius: BorderRadius.circular(9)),
        alignment: Alignment.center,
        child: const Text('表情', style: TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w700)),
      );

  static String _specialMessage(ChatMessage message) {
    if (message.type == 'emoji') return '[表情]';
    if (message.type == 'post') return '[分享帖子]';
    if (message.type == 'order') return '[商品订单]';
    return '[${message.type}]';
  }

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

class _EmojiPickerSheet extends StatefulWidget {
  const _EmojiPickerSheet({required this.api, required this.token});

  final ChengeApi api;
  final String token;

  @override
  State<_EmojiPickerSheet> createState() => _EmojiPickerSheetState();
}

class _EmojiPickerSheetState extends State<_EmojiPickerSheet> {
  List<EmojiAsset> _assets = const [];
  bool _loading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final list = await widget.api.myEmojiAssets(widget.token);
      if (!mounted) return;
      setState(() {
        _assets = list;
        _loading = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.55;
    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('表情包', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error.isNotEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(_error, style: const TextStyle(color: AppTheme.coral)),
                              TextButton(onPressed: _load, child: const Text('重试')),
                            ],
                          ),
                        )
                      : _assets.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(24),
                                child: Text(
                                  '还没有表情包\n去商店购买表情包后再来发送',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF70817D)),
                                ),
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemCount: _assets.length,
                              itemBuilder: (context, index) {
                                final asset = _assets[index];
                                return InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () => Navigator.pop(context, asset),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF4F8F5),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    child: asset.url?.isNotEmpty == true
                                        ? Image.network(
                                            asset.url!,
                                            fit: BoxFit.contain,
                                            errorBuilder: (_, __, ___) => Center(
                                              child: Text(
                                                asset.displayName.characters.first,
                                                style: const TextStyle(fontWeight: FontWeight.w700),
                                              ),
                                            ),
                                          )
                                        : Center(
                                            child: Text(
                                              asset.displayName,
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
