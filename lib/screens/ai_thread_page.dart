import 'package:flutter/material.dart';

import '../models/ai_session.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

/// AI 独立会话页（窄屏 push / 宽屏嵌入）。
class AiThreadPage extends StatefulWidget {
  const AiThreadPage({
    super.key,
    required this.api,
    required this.token,
    required this.session,
    this.showBackButton = true,
    this.onSessionRenamed,
  });

  final ChengeApi api;
  final String token;
  final AiSession session;
  final bool showBackButton;
  final ValueChanged<AiSession>? onSessionRenamed;

  @override
  State<AiThreadPage> createState() => _AiThreadPageState();
}

class _AiThreadPageState extends State<AiThreadPage> {
  final _messageController = TextEditingController();
  final _messageScrollController = ScrollController();
  final _messages = <AiChatBubble>[];

  late AiSession _session;
  bool _loadingHistory = false;
  bool _sending = false;
  bool _stickToBottom = true;
  bool _initialScrollDone = false;
  bool _popScheduled = false;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _messageScrollController.addListener(_onScroll);
    _loadHistory();
  }

  @override
  void didUpdateWidget(covariant AiThreadPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.session.sessionId != widget.session.sessionId) {
      _session = widget.session;
      _messages.clear();
      _initialScrollDone = false;
      _loadHistory();
    }
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
    _messageController.dispose();
    _messageScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _loadingHistory = true);
    try {
      final history = await widget.api.aiChatHistory(_session.sessionId, widget.token);
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(history.map(AiChatBubble.fromHistory));
        _loadingHistory = false;
      });
      _scrollToBottom(animate: false);
      _initialScrollDone = true;
    } on ApiException catch (error) {
      if (mounted) {
        setState(() => _loadingHistory = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    }
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;

    final turnId = 'flutter-${DateTime.now().microsecondsSinceEpoch}';
    final userBubble = AiChatBubble(role: 'user', content: text);
    final assistantBubble = AiChatBubble(
      role: 'assistant',
      content: '',
      streaming: true,
      status: '思考中…',
    );

    setState(() {
      _sending = true;
      _messageController.clear();
      _messages.addAll([userBubble, assistantBubble]);
      _stickToBottom = true;
    });
    _scrollToBottom(animate: true);

    try {
      await for (final event in widget.api.streamAiAgent(
        token: widget.token,
        sessionId: _session.sessionId,
        userInput: text,
        turnId: turnId,
      )) {
        if (!mounted) return;
        final type = event.type;
        final data = event.data;

        if (type == 'error') {
          final message = data is Map
              ? '${data['message'] ?? data['msg'] ?? 'AI 请求失败'}'
              : '$data';
          setState(() {
            assistantBubble
              ..streaming = false
              ..status = null
              ..content = assistantBubble.content.isEmpty ? message : assistantBubble.content;
          });
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.coral));
          break;
        }

        if (type == 'status') {
          final status = data is Map
              ? '${data['message'] ?? data['status'] ?? data['text'] ?? ''}'
              : '$data';
          if (status.isNotEmpty) {
            setState(() => assistantBubble.status = status);
          }
          continue;
        }

        if (type == 'delta') {
          final delta = _extractDelta(data);
          if (delta.isNotEmpty) {
            setState(() {
              assistantBubble
                ..status = null
                ..content = '${assistantBubble.content}$delta';
            });
            if (_stickToBottom) _scrollToBottom(animate: true);
          }
          continue;
        }

        if (type == 'done') {
          final finalText = _extractFinal(data);
          setState(() {
            assistantBubble.streaming = false;
            assistantBubble.status = null;
            if (finalText.isNotEmpty && assistantBubble.content.isEmpty) {
              assistantBubble.content = finalText;
            }
            if (assistantBubble.content.isEmpty) {
              assistantBubble.content = '（无文本回复）';
            }
          });
          if (_session.name == '新对话' || _session.name.isEmpty) {
            final title = text.length > 18 ? '${text.substring(0, 18)}…' : text;
            try {
              await widget.api.renameAiSession(_session.sessionId, title, widget.token);
              if (mounted) {
                final updated = AiSession(
                  id: _session.id,
                  sessionId: _session.sessionId,
                  name: title,
                  userId: _session.userId,
                  scene: _session.scene,
                  createTime: _session.createTime,
                );
                setState(() => _session = updated);
                widget.onSessionRenamed?.call(updated);
              }
            } on ApiException {
              // ignore
            }
          }
          break;
        }

        if (type == 'pending' || type == 'artifacts' || type == 'sources') {
          setState(() => assistantBubble.status = type == 'pending' ? '等待确认…' : '收到 $type');
        }
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          assistantBubble
            ..streaming = false
            ..status = null
            ..content = assistantBubble.content.isEmpty ? error.message : assistantBubble.content;
        });
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
          assistantBubble.streaming = false;
          if (assistantBubble.content.isEmpty && assistantBubble.status != null) {
            assistantBubble.content = assistantBubble.status!;
            assistantBubble.status = null;
          }
        });
        _scrollToBottom(animate: true);
      }
    }
  }

  String _extractDelta(dynamic data) {
    if (data is Map) {
      final delta = data['delta'] ?? data['content'] ?? data['text'] ?? data['message'];
      return delta?.toString() ?? '';
    }
    return data?.toString() ?? '';
  }

  String _extractFinal(dynamic data) {
    if (data is Map) {
      final text = data['content'] ?? data['text'] ?? data['message'] ?? data['answer'];
      return text?.toString() ?? '';
    }
    return data?.toString() ?? '';
  }

  void _onScroll() {
    if (!_messageScrollController.hasClients) return;
    final position = _messageScrollController.position;
    _stickToBottom = position.maxScrollExtent - position.pixels < 80;
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
          _session.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loadingHistory && _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? const Center(
                        child: Text('发一条消息开始对话', style: TextStyle(color: Color(0xFF70817D))),
                      )
                    : ListView.builder(
                        controller: _messageScrollController,
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) => _bubble(_messages[index]),
                      ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _bubble(AiChatBubble bubble) {
    final isUser = bubble.role == 'user';
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bg = isUser ? AppTheme.leaf : Colors.white;
    final fg = isUser ? Colors.white : AppTheme.ink;
    return Align(
      alignment: align,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: isUser ? null : Border.all(color: const Color(0xFFDCE6E1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bubble.status != null && bubble.status!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  bubble.status!,
                  style: TextStyle(
                    fontSize: 12,
                    color: isUser ? Colors.white70 : const Color(0xFF70817D),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (bubble.content.isNotEmpty)
              SelectableText(
                bubble.content,
                style: TextStyle(color: fg, height: 1.4),
              )
            else if (bubble.streaming)
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isUser ? Colors.white : AppTheme.leaf,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _composer() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                enabled: !_sending,
                decoration: const InputDecoration(
                  hintText: '向 AI Agent 提问…',
                  prefixIcon: Icon(Icons.smart_toy_outlined),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: _sending ? null : _send,
              icon: _sending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.send_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
