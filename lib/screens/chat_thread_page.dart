import 'dart:async';

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
  });

  final ChengeApi api;
  final String token;
  final int? userId;
  final ChatConversation conversation;
  final bool showBackButton;

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
        title: Text(
          _conversation.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
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

  Widget _composer() => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2EAE5))),
          ),
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
