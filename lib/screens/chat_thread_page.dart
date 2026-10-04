import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/blog_post.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../l10n/generated/app_localizations.dart';
import '../models/shop_item.dart';
import '../services/chenge_api.dart';
import '../services/chat_socket.dart';
import '../theme/app_theme.dart';
import 'emoji_picker_sheet.dart';
import 'post_detail_page.dart';
import 'shop_detail_page.dart';

class ChatThreadPage extends StatefulWidget {
  const ChatThreadPage({
    super.key,
    required this.api,
    required this.token,
    required this.userId,
    required this.conversation,
    this.chatSocket,
    this.showBackButton = true,
    this.peerOnline,
    this.showSelfAvatar = false,
    this.showPeerAvatar = false,
  });

  final ChengeApi api;
  final String token;
  final int? userId;
  final ChatConversation conversation;
  /// 可选：共享 WebSocket；为空时本页自行建连
  final ChatSocket? chatSocket;
  final bool showBackButton;
  final bool? peerOnline;

  /// 是否在自己的消息旁显示头像（设置项，默认关）
  final bool showSelfAvatar;

  /// 是否在私聊中显示对方头像（设置项，默认关）；群聊始终显示成员头像
  final bool showPeerAvatar;

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final _messageController = TextEditingController();
  final _messageScrollController = ScrollController();
  final _messages = <ChatMessage>[];
  ChatSocket? _ownedSocket;
  StreamSubscription<ChatMessage>? _wsSub;
  /// 断线时的轻量兜底轮询（仅在 WS 不可用时启用）
  Timer? _fallbackPoll;
  bool _loading = false;
  bool _loadingOlder = false;
  bool _sending = false;
  bool _hasMore = false;
  bool _stickToBottom = true;
  bool _initialScrollDone = false;
  bool _contentReady = false;
  bool _popScheduled = false;
  bool _emojiPickerOpen = false;
  late ChatConversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _messageScrollController.addListener(_onScroll);
    _loadMessages();
    _bindSocket();
  }

  void _bindSocket() {
    final shared = widget.chatSocket;
    if (shared != null) {
      shared.connect(widget.token);
      _wsSub = shared.messages.listen(_onWsMessage);
      return;
    }
    final socket = ChatSocket(baseUrl: widget.api.baseUrl);
    _ownedSocket = socket;
    socket.connect(widget.token);
    _wsSub = socket.messages.listen(_onWsMessage);
    // 若 12s 内仍无连接成功的消息活动，启动兜底轮询
    _fallbackPoll = Timer.periodic(const Duration(seconds: 12), (_) {
      if (!mounted) return;
      _loadMessages(silent: true);
    });
  }

  void _onWsMessage(ChatMessage message) {
    if (!mounted) return;
    if (message.conversationId != _conversation.id) return;
    if (_messages.any((m) => m.id == message.id)) return;
    setState(() {
      _messages.add(message);
      _messages.sort((a, b) => a.id.compareTo(b.id));
    });
    if (_stickToBottom) _scrollToBottom(animate: true);
    // 静默已读
    widget.api.markChatRead(
      _conversation.id,
      widget.token,
      messageId: message.id,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybePopForWideLayout();
  }

  void _maybePopForWideLayout() {
    if (!widget.showBackButton || _popScheduled) return;
    if (MediaQuery.sizeOf(context).width < 760) return;
    if (_emojiPickerOpen) return;
    _popScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  void dispose() {
    _fallbackPoll?.cancel();
    _wsSub?.cancel();
    _ownedSocket?.dispose();
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
      final messages = await widget.api.chatMessages(
        _conversation.id,
        widget.token,
      );
      if (!mounted) return;
      final byId = {for (final m in _messages) m.id: m};
      for (final m in messages) {
        byId[m.id] = m;
      }
      final merged = byId.values.toList()..sort((a, b) => a.id.compareTo(b.id));
      final isInitial = !_initialScrollDone;
      setState(() {
        _messages
          ..clear()
          ..addAll(merged);
        _hasMore = messages.length >= 30;
        if (!isInitial) _loading = false;
      });
      final lastId = merged.isEmpty ? null : merged.last.id;
      await widget.api.markChatRead(
        _conversation.id,
        widget.token,
        messageId: lastId,
      );
      if (!mounted) return;
      if (isInitial) {
        if (merged.isEmpty) {
          setState(() {
            _initialScrollDone = true;
            _contentReady = true;
            _loading = false;
          });
        } else {
          await _scrollToBottomInitial();
        }
      } else if (_stickToBottom) {
        _scrollToBottom(animate: true);
      }
    } on ApiException catch (error) {
      if (mounted && !silent) {
        setState(() {
          _loading = false;
          _contentReady = true;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppTheme.coral,
            ),
          );
      }
    } finally {
      if (mounted && !silent && _initialScrollDone && _loading) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _scrollToBottomInitial() async {
    await Future<void>.delayed(Duration.zero);
    if (!mounted) return;
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    void jump() {
      if (!_messageScrollController.hasClients) return;
      _messageScrollController.jumpTo(
        _messageScrollController.position.maxScrollExtent,
      );
    }

    jump();
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    jump();
    if (mounted) {
      setState(() {
        _initialScrollDone = true;
        _contentReady = true;
        _loading = false;
      });
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
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppTheme.coral,
            ),
          );
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
      final message = await widget.api.sendChatMessage(
        _conversation.id,
        text,
        widget.token,
      );
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
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppTheme.coral,
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _sendEmoji(EmojiAsset asset) async {
    if (_sending) return;
    setState(() => _sending = true);
    try {
      final message = await widget.api.sendChatMessage(
        _conversation.id,
        jsonEncode(asset.toSendJson()),
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
          ..showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: AppTheme.coral,
            ),
          );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openEmojiPicker() async {
    if (_emojiPickerOpen) return;
    _emojiPickerOpen = true;
    EmojiAsset? asset;
    try {
      asset = await showModalBottomSheet<EmojiAsset>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder:
            (context) => EmojiPickerSheet(api: widget.api, token: widget.token),
      );
    } finally {
      _emojiPickerOpen = false;
    }
    if (!mounted) return;
    if (MediaQuery.sizeOf(context).width >= 760) _maybePopForWideLayout();
    if (asset != null && mounted) await _sendEmoji(asset);
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
      if (!animate) WidgetsBinding.instance.addPostFrameCallback((_) => go());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showBackButton && MediaQuery.sizeOf(context).width >= 760) {
      _maybePopForWideLayout();
    }
    final isGroup = _conversation.type == 'group';
    final localizations = AppLocalizations.of(context);
    final onlineLabel =
        !isGroup && widget.peerOnline != null
            ? (widget.peerOnline! ? localizations.online : localizations.offline)
            : '';

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        leading:
            widget.showBackButton
                ? IconButton(
                  tooltip: localizations.backToConversations,
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
                isGroup ? localizations.groupChat : onlineLabel,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      !isGroup && widget.peerOnline == true
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
                Opacity(
                  opacity: _contentReady ? 1 : 0,
                  child: ListView.builder(
                    controller: _messageScrollController,
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                    itemCount: _messages.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (_hasMore && index == 0) {
                        return Center(
                          child: TextButton.icon(
                            onPressed: _loadingOlder ? null : _loadOlder,
                            icon:
                                _loadingOlder
                                    ? const SizedBox.square(
                                      dimension: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : const Icon(Icons.expand_less_rounded),
                            label: Text(localizations.loadOlderMessages),
                          ),
                        );
                      }
                      final messageIndex = index - (_hasMore ? 1 : 0);
                      return _messageTile(
                        _messages[messageIndex],
                        showTime: _shouldShowTime(messageIndex),
                      );
                    },
                  ),
                ),
                if (!_contentReady)
                  ColoredBox(
                    color: Theme.of(context).colorScheme.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (_messages.isEmpty)
                  Center(
                    child: Text(
                      localizations.noMessages,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _composer(),
        ],
      ),
    );
  }

  bool _shouldShowTime(int messageIndex) {
    if (messageIndex == 0) return true;
    final previousTime = _messages[messageIndex - 1].createdAt;
    final currentTime = _messages[messageIndex].createdAt;
    if (previousTime == null || currentTime == null) return true;
    final difference = currentTime.difference(previousTime);
    const threshold = Duration(minutes: 5);
    return difference <= -threshold || difference >= threshold;
  }

  Widget _messageTile(ChatMessage message, {required bool showTime}) {
    final mine = message.senderId == widget.userId;
    final isEmoji = message.type == 'emoji';
    final isShare = message.type == 'post' || message.type == 'order';
    final isGroup = _conversation.type == 'group';
    final showOtherAvatar = !mine && (isGroup || widget.showPeerAvatar);
    final showMineAvatar = mine && widget.showSelfAvatar;

    Widget avatarFor(String name, String? url) => CircleAvatar(
      radius: 15,
      backgroundColor: const Color(0xFFFFE8C5),
      foregroundImage: url == null ? null : CachedNetworkImageProvider(url),
      onForegroundImageError: url == null ? null : (_, __) {},
      child: Text(
        name.isEmpty ? AppLocalizations.of(context).friendInitial : name.characters.first,
        style: const TextStyle(
          color: AppTheme.ink,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            mine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showOtherAvatar) ...[
            avatarFor(
              message.senderName ?? _conversation.name,
              message.senderAvatar,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!mine)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      message.senderName ?? _conversation.name,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF70817D),
                      ),
                    ),
                  ),
                if (isEmoji)
                  _emojiImage(message)
                else if (isShare)
                  _shareCard(message)
                else
                  Container(
                    constraints: const BoxConstraints(maxWidth: 520),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          mine
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(mine ? 16 : 4),
                        bottomRight: Radius.circular(mine ? 4 : 16),
                      ),
                    ),
                    child: SelectableText(
                      message.type == 'text'
                          ? message.content
                          : _specialMessage(context, message),
                      style: TextStyle(
                        color:
                            mine
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                if (showTime)
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 4, right: 4),
                    child: Text(
                      _shortTime(message.createdAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF83918D),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (showMineAvatar) ...[
            const SizedBox(width: 8),
            avatarFor(AppLocalizations.of(context).me, message.senderAvatar),
          ],
        ],
      ),
    );
  }

  Widget _shareCard(ChatMessage message) {
    final isPost = message.type == 'post';
    final payload = _sharePayload(message.content);
    final title = (payload['title'] ?? (isPost ? AppLocalizations.of(context).post : AppLocalizations.of(context).product)).toString();
    final tag = isPost ? AppLocalizations.of(context).sharedPost : AppLocalizations.of(context).productOrder;

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openSharedContent(message, payload),
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
              Text(
                tag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color:
                      isPost
                          ? const Color(0xFF3D6BAA)
                          : const Color(0xFFB86B1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _sharePayload(String content) {
    try {
      final decoded = jsonDecode(content);
      return decoded is Map<String, dynamic> ? decoded : {};
    } on FormatException {
      return {};
    }
  }

  Future<void> _openSharedContent(
    ChatMessage message,
    Map<String, dynamic> payload,
  ) async {
    final isPost = message.type == 'post';
    final nested =
        isPost ? payload['post'] : payload['item'] ?? payload['product'];
    final nestedPayload = nested is Map<String, dynamic> ? nested : payload;
    final id = _shareId(
      nestedPayload[isPost ? 'postId' : 'itemId'] ??
          nestedPayload[isPost ? 'blogId' : 'productId'] ??
          nestedPayload['id'] ??
          payload[isPost ? 'postId' : 'itemId'] ??
          payload[isPost ? 'blogId' : 'productId'] ??
          payload['id'],
    );
    if (id == null || id <= 0) {
      _showShareError(isPost ? AppLocalizations.of(context).cannotOpenPostMissingId : AppLocalizations.of(context).cannotOpenProductMissingId);
      return;
    }

    if (isPost) {
      final title = _shareText(nestedPayload['title'], fallback: AppLocalizations.of(context).post);
      final post = BlogPost(
        id: id,
        title: title,
        summary: _shareText(nestedPayload['summary']),
        content: _shareText(nestedPayload['content']),
        authorName: _shareText(
          nestedPayload['authorName'],
          fallback: AppLocalizations.of(context).chengeUser,
        ),
        createdAt: DateTime.tryParse(_shareText(nestedPayload['createdAt'])),
        viewCount: 0,
        likeCount: 0,
        commentCount: 0,
      );
      await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder:
              (_) => PostDetailPage(
                api: widget.api,
                post: post,
                token: widget.token,
              ),
        ),
      );
      return;
    }

    final item = ShopItem(
      id: id,
      title: _shareText(nestedPayload['title'], fallback: AppLocalizations.of(context).product),
      type: _shareText(nestedPayload['type'], fallback: 'file'),
      price: _shareInt(nestedPayload['price']),
      stock: _shareInt(nestedPayload['stock']),
    );
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder:
            (_) => ShopDetailPage(
              api: widget.api,
              item: item,
              token: widget.token,
              userId: widget.userId,
              onLoginRequested: () => _showShareError(AppLocalizations.of(context).signInToPurchase),
            ),
      ),
    );
  }

  void _showShareError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  static int? _shareId(Object? value) {
    if (value is int) return value;
    if (value is num && value == value.toInt()) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static int _shareInt(Object? value) => _shareId(value) ?? 0;

  static String _shareText(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  Widget _composer() {
    final panelColor = Theme.of(context).colorScheme.surfaceContainerLow;
    // ColoredBox 铺满底部安全区，避免系统手势条区域颜色与输入面板不一致。
    return ColoredBox(
      color: panelColor,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 10, 12, 10),
          decoration: BoxDecoration(
            color: panelColor,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                tooltip: AppLocalizations.of(context).emojiPacks,
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
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).typeMessage,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: AppLocalizations.of(context).sendMessage,
                onPressed:
                    _sending || _messageController.text.trim().isEmpty
                        ? null
                        : _send,
                icon:
                    _sending
                        ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.send_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emojiImage(ChatMessage message) {
    final url = message.emoji?.url;
    if (url == null || url.isEmpty) {
      return Container(
        width: 132,
        height: 84,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF2ED),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(AppLocalizations.of(context).emoji, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: CachedNetworkImage(
        imageUrl: url,
        fadeInDuration: const Duration(milliseconds: 120),
        fadeOutDuration: const Duration(milliseconds: 80),
        width: 132,
        height: 132,
        fit: BoxFit.contain,
        placeholder: (_, __) => const SizedBox(
          width: 132,
          height: 84,
          child: Center(
            child: SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        errorWidget: (context, __, ___) => SizedBox(
          width: 132,
          height: 84,
          child: Center(child: Text(AppLocalizations.of(context).emoji)),
        ),
      ),
    );
  }

  static String _specialMessage(BuildContext context, ChatMessage message) {
    final l10n = AppLocalizations.of(context);
    if (message.type == 'emoji') return l10n.previewEmojiOnly;
    if (message.type == 'post') return l10n.previewSharedPost;
    if (message.type == 'order') return l10n.previewOrder;
    return '[${message.type}]';
  }

  static String _shortTime(DateTime? value) {
    if (value == null) return '';
    final date = value.toLocal();
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.month}/${date.day}';
  }
}
