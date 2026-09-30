import 'dart:async';

import 'package:flutter/material.dart';

import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

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
  final _messageController = TextEditingController();
  final _messageScrollController = ScrollController();
  final _conversations = <ChatConversation>[];
  final _messages = <ChatMessage>[];
  ChatConversation? _active;
  Timer? _pollTimer;
  String _error = '';
  String _listQuery = '';
  bool _loadingList = false;
  bool _loadingMessages = false;
  bool _loadingOlder = false;
  bool _sending = false;
  bool _hasMore = false;
  bool _mobileThread = false;
  bool _stickToBottom = true;

  @override
  void initState() {
    super.initState();
    _messageScrollController.addListener(_onScroll);
    _startSession();
  }

  @override
  void didUpdateWidget(covariant ChatPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _pollTimer?.cancel();
      _conversations.clear();
      _messages.clear();
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
    _messageController.dispose();
    _messageScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _startSession() {
    if (widget.token == null) return;
    _loadConversations();
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      _loadConversations(silent: true);
      final conversation = _active;
      if (conversation != null) _loadMessages(conversation.id, silent: true);
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
      setState(() => _mobileThread = true);
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
    setState(() {
      _active = conversation;
      _mobileThread = true;
      _messages.clear();
      _loadingMessages = false;
      _hasMore = false;
      _stickToBottom = true;
    });
    _loadMessages(conversation.id);
  }

  Future<void> _loadMessages(int conversationId, {bool silent = false}) async {
    final token = widget.token;
    if (token == null || (_loadingMessages && !silent)) return;
    if (!silent && mounted) setState(() => _loadingMessages = true);
    try {
      final messages = await widget.api.chatMessages(conversationId, token);
      if (!mounted || _active?.id != conversationId) return;
      final byId = {for (final message in _messages) message.id: message};
      for (final message in messages) {
        byId[message.id] = message;
      }
      final merged = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
      setState(() {
        _messages
          ..clear()
          ..addAll(merged);
        _hasMore = messages.length >= 30;
        _error = '';
      });
      final lastId = merged.isEmpty ? null : merged.last.id;
      await widget.api.markChatRead(conversationId, token, messageId: lastId);
      if (_stickToBottom) _scrollToBottom();
    } on ApiException catch (error) {
      if (mounted && !silent && _active?.id == conversationId) _showError(error.message);
    } finally {
      if (mounted && !silent && _active?.id == conversationId) setState(() => _loadingMessages = false);
    }
  }

  Future<void> _loadOlder() async {
    final token = widget.token;
    final active = _active;
    if (token == null || active == null || _loadingOlder || !_hasMore || _messages.isEmpty) return;
    setState(() => _loadingOlder = true);
    try {
      final older = await widget.api.chatMessages(active.id, token, beforeId: _messages.first.id);
      if (!mounted || _active?.id != active.id) return;
      setState(() {
        _messages.insertAll(0, older);
        _hasMore = older.length >= 30;
      });
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } finally {
      if (mounted) setState(() => _loadingOlder = false);
    }
  }

  Future<void> _send() async {
    final token = widget.token;
    final active = _active;
    final text = _messageController.text.trim();
    if (token == null || active == null || text.isEmpty || _sending) return;
    setState(() => _sending = true);
    try {
      final message = await widget.api.sendChatMessage(active.id, text, token);
      if (!mounted || _active?.id != active.id) return;
      setState(() {
        if (!_messages.any((item) => item.id == message.id)) _messages.add(message);
        _messageController.clear();
        _stickToBottom = true;
      });
      await _loadConversations(silent: true);
      _scrollToBottom();
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  void _onScroll() {
    if (!_messageScrollController.hasClients) return;
    final position = _messageScrollController.position;
    _stickToBottom = position.maxScrollExtent - position.pixels < 80;
    if (position.pixels < 60) _loadOlder();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_messageScrollController.hasClients) {
        _messageScrollController.animateTo(
          _messageScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
        );
      }
    });
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
      appBar: widget.showAppBar ? AppBar(
        leading: !isWide && _mobileThread
            ? IconButton(
                tooltip: '返回会话列表',
                onPressed: () => setState(() => _mobileThread = false),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Text(!isWide && _mobileThread ? (_active?.name ?? '聊天') : '聊天',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(tooltip: '好友', onPressed: widget.onOpenFriends, icon: const Icon(Icons.people_outline_rounded)),
          IconButton(tooltip: '刷新会话', onPressed: _loadConversations, icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 4),
        ],
      ) : null,
      body: widget.token == null
          ? _signedOut()
          : isWide
              ? _wideLayout()
              : _mobileThread
                  ? _thread()
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
            FilledButton.icon(onPressed: widget.onLoginRequested, icon: const Icon(Icons.login_rounded), label: const Text('前往登录')),
          ],
        ),
      );

  Widget _wideLayout() => Row(
        children: [
          SizedBox(width: 320, child: _conversationList()),
          const VerticalDivider(width: 1),
          Expanded(child: _thread()),
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
        if (_error.isNotEmpty) _errorStrip(),
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
                        Expanded(child: Text(conversation.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w700))),
                        Text(_shortTime(conversation.updatedAt), style: const TextStyle(fontSize: 10, color: Color(0xFF70817D))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(child: Text(_preview(conversation.lastMessage), maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)))),
                        if (conversation.unread > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            constraints: const BoxConstraints(minWidth: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppTheme.coral, borderRadius: BorderRadius.circular(10)),
                            child: Text('${conversation.unread}', textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
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
              Text(_listQuery.isNotEmpty ? '没有匹配的会话' : '还没有私聊', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              TextButton.icon(onPressed: widget.onOpenFriends, icon: const Icon(Icons.people_outline_rounded), label: const Text('去好友列表发起聊天')),
            ],
          ),
        ),
      );

  Widget _thread() {
    final active = _active;
    if (active == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 56, color: Color(0xFF9DB5AB)),
            SizedBox(height: 12),
            Text('选择一个会话，开始聊天', style: TextStyle(color: Color(0xFF70817D))),
          ],
        ),
      );
    }
    return Column(
      children: [
        if (MediaQuery.sizeOf(context).width >= 760)
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE2EAE5)))),
            child: Row(children: [_avatar(active.name, active.avatar, radius: 17), const SizedBox(width: 10),
              Text(active.name, style: const TextStyle(fontWeight: FontWeight.w800))]),
          ),
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
                            ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.expand_less_rounded),
                        label: const Text('加载更早消息'),
                      ),
                    );
                  }
                  final message = _messages[index - (_hasMore ? 1 : 0)];
                  return _messageTile(message);
                },
              ),
              if (_loadingMessages && _messages.isEmpty) const Center(child: CircularProgressIndicator()),
              if (_messages.isEmpty && !_loadingMessages)
                const Center(child: Text('还没有消息，打个招呼吧', style: TextStyle(color: Color(0xFF70817D)))),
            ],
          ),
        ),
        _composer(),
      ],
    );
  }

  Widget _messageTile(ChatMessage message) {
    final mine = message.senderId == widget.userId;
    final bubbleColor = mine ? AppTheme.leaf : Colors.white;
    final textColor = mine ? Colors.white : AppTheme.ink;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!mine) ...[_avatar(message.senderName ?? _active?.name ?? '用户', message.senderAvatar, radius: 15), const SizedBox(width: 8)],
          Flexible(
            child: Column(
              crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!mine) Padding(padding: const EdgeInsets.only(left: 4, bottom: 4), child: Text(message.senderName ?? _active?.name ?? '用户',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)))),
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
                if (message.type == 'emoji') _emojiImage(message),
                Padding(padding: const EdgeInsets.only(top: 3, left: 4, right: 4), child: Text(_shortTime(message.createdAt),
                  style: const TextStyle(fontSize: 10, color: Color(0xFF83918D)))),
              ],
            ),
          ),
          if (mine) const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _composer() => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE2EAE5)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.newline,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(hintText: '输入消息…', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12)),
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

  Widget _errorStrip() => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: Text(_error, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppTheme.coral, fontSize: 12)),
      );

  Widget _avatar(String name, String? url, {required double radius}) => CircleAvatar(
        radius: radius,
        backgroundColor: const Color(0xFFFFE8C5),
        foregroundImage: url == null ? null : NetworkImage(url),
        onForegroundImageError: url == null ? null : (_, __) {},
        child: Text(name.isEmpty ? '友' : name.characters.first, style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w700)),
      );

  static String _preview(ChatMessage? message) {
    if (message == null) return '还没有消息';
    if (message.type == 'emoji') return '[表情] ${_emojiKey(message.content)}';
    if (message.type == 'post') return '[分享帖子]';
    if (message.type == 'order') return '[分享商品]';
    return message.content;
  }

  static String _specialMessage(ChatMessage message) {
    if (message.type == 'emoji') return '[表情] ${_emojiKey(message.content)}';
    if (message.type == 'post') return '[分享帖子]';
    if (message.type == 'order') return '[商品订单]';
    return '[${message.type}] ${message.content}';
  }

  Widget _emojiImage(ChatMessage message) {
    final emoji = message.emoji;
    if (emoji == null) return const Text('[无法识别的表情]');
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (emoji.key?.isNotEmpty == true)
            Padding(padding: const EdgeInsets.only(bottom: 5), child: Text(emoji.key!,
              style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w700, fontSize: 12))),
          if (emoji.url?.isNotEmpty == true)
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: Image.network(
                emoji.url!,
                width: 132,
                height: 132,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _emojiPlaceholder(emoji.key),
                loadingBuilder: (context, child, progress) => progress == null ? child : _emojiPlaceholder(emoji.key),
              ),
            )
          else
            _emojiPlaceholder(emoji.key),
        ],
      ),
    );
  }

  Widget _emojiPlaceholder(String? key) => Container(
        width: 132,
        height: 84,
        decoration: BoxDecoration(color: const Color(0xFFEAF2ED), borderRadius: BorderRadius.circular(9)),
        alignment: Alignment.center,
        child: Text(key?.isNotEmpty == true ? key! : '表情', style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w700)),
      );

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