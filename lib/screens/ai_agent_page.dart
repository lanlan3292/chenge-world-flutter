import 'package:flutter/material.dart';

import '../models/ai_session.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class AiAgentPage extends StatefulWidget {
  const AiAgentPage({
    super.key,
    required this.api,
    required this.token,
    required this.onLoginRequested,
    this.showAppBar = true,
  });

  final ChengeApi api;
  final String? token;
  final VoidCallback onLoginRequested;
  final bool showAppBar;

  @override
  State<AiAgentPage> createState() => _AiAgentPageState();
}

class _AiAgentPageState extends State<AiAgentPage> {
  final _messageController = TextEditingController();
  final _messageScrollController = ScrollController();
  final _sessions = <AiSession>[];
  final _messages = <AiChatBubble>[];

  AiSession? _active;
  String _error = '';
  bool _loadingList = false;
  bool _loadingHistory = false;
  bool _sending = false;
  bool _mobileThread = false;
  bool _stickToBottom = true;

  @override
  void initState() {
    super.initState();
    _messageScrollController.addListener(_onScroll);
    if (widget.token != null) _loadSessions();
  }

  @override
  void didUpdateWidget(covariant AiAgentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _sessions.clear();
      _messages.clear();
      _active = null;
      _mobileThread = false;
      if (widget.token != null) _loadSessions();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageScrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  Future<void> _loadSessions({bool silent = false}) async {
    final token = widget.token;
    if (token == null || _loadingList) return;
    if (!silent && mounted) setState(() => _loadingList = true);
    try {
      final sessions = await widget.api.aiSessions(token);
      if (!mounted) return;
      setState(() {
        _sessions
          ..clear()
          ..addAll(sessions);
        _error = '';
        final activeId = _active?.sessionId;
        if (activeId != null) {
          for (final item in _sessions) {
            if (item.sessionId == activeId) {
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

  Future<void> _createSession() async {
    final token = widget.token;
    if (token == null || _sending) return;
    setState(() => _sending = true);
    try {
      final session = await widget.api.createAiSession(token, name: '新对话');
      if (!mounted) return;
      setState(() {
        _sessions.insert(0, session);
        _selectSession(session);
      });
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _deleteSession(AiSession session) async {
    final token = widget.token;
    if (token == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除会话'),
        content: Text('确定删除「${session.name}」？聊天记录将一并清除。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await widget.api.deleteAiSession(session.sessionId, token);
      if (!mounted) return;
      setState(() {
        _sessions.removeWhere((item) => item.sessionId == session.sessionId);
        if (_active?.sessionId == session.sessionId) {
          _active = null;
          _messages.clear();
          _mobileThread = false;
        }
      });
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  void _selectSession(AiSession session) {
    setState(() {
      _active = session;
      _mobileThread = true;
      _messages.clear();
      _loadingHistory = true;
      _stickToBottom = true;
    });
    _loadHistory(session.sessionId);
  }

  Future<void> _loadHistory(String sessionId) async {
    final token = widget.token;
    if (token == null) return;
    try {
      final history = await widget.api.aiChatHistory(sessionId, token);
      if (!mounted || _active?.sessionId != sessionId) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(history.map(AiChatBubble.fromHistory));
        _loadingHistory = false;
        _error = '';
      });
      _scrollToBottom();
    } on ApiException catch (error) {
      if (mounted && _active?.sessionId == sessionId) {
        setState(() => _loadingHistory = false);
        _showError(error.message);
      }
    }
  }

  Future<void> _send() async {
    final token = widget.token;
    final text = _messageController.text.trim();
    if (token == null || text.isEmpty || _sending) return;

    late final AiSession session;
    if (_active != null) {
      session = _active!;
    } else {
      setState(() => _sending = true);
      try {
        session = await widget.api.createAiSession(
          token,
          name: text.length > 18 ? '${text.substring(0, 18)}…' : text,
        );
        if (!mounted) return;
        setState(() {
          _sessions.insert(0, session);
          _active = session;
          _mobileThread = true;
          _messages.clear();
        });
      } on ApiException catch (error) {
        if (mounted) {
          setState(() => _sending = false);
          _showError(error.message);
        }
        return;
      }
    }

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
    _scrollToBottom();

    try {
      await for (final event in widget.api.streamAiAgent(
        token: token,
        sessionId: session.sessionId,
        userInput: text,
        turnId: turnId,
      )) {
        if (!mounted || _active?.sessionId != session.sessionId) return;
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
          _showError(message);
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
            if (_stickToBottom) _scrollToBottom();
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
          if (session.name == '新对话' || session.name.isEmpty) {
            final title = text.length > 18 ? '${text.substring(0, 18)}…' : text;
            try {
              await widget.api.renameAiSession(session.sessionId, title, token);
              if (mounted) {
                setState(() {
                  final index = _sessions.indexWhere((item) => item.sessionId == session.sessionId);
                  if (index >= 0) {
                    _sessions[index] = AiSession(
                      id: session.id,
                      sessionId: session.sessionId,
                      name: title,
                      userId: session.userId,
                      scene: session.scene,
                      createTime: session.createTime,
                    );
                    _active = _sessions[index];
                  }
                });
              }
            } on ApiException {
              // ignore rename failures
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
        _showError(error.message);
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
        _scrollToBottom();
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
      appBar: widget.showAppBar
          ? AppBar(
              leading: !isWide && _mobileThread
                  ? IconButton(
                      tooltip: '返回会话列表',
                      onPressed: () => setState(() => _mobileThread = false),
                      icon: const Icon(Icons.arrow_back_rounded),
                    )
                  : null,
              title: Text(
                !isWide && _mobileThread ? (_active?.name ?? 'AI Agent') : 'AI Agent',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              actions: [
                IconButton(
                  tooltip: '新建对话',
                  onPressed: widget.token == null || _sending ? null : _createSession,
                  icon: const Icon(Icons.add_comment_rounded),
                ),
                IconButton(
                  tooltip: '刷新会话',
                  onPressed: widget.token == null ? null : () => _loadSessions(),
                  icon: const Icon(Icons.refresh_rounded),
                ),
                const SizedBox(width: 4),
              ],
            )
          : null,
      body: widget.token == null
          ? _signedOut()
          : isWide
              ? _wideLayout()
              : _mobileThread
                  ? _thread()
                  : _sessionList(),
    );
  }

  Widget _signedOut() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.smart_toy_outlined, color: AppTheme.leaf, size: 54),
            const SizedBox(height: 12),
            const Text('登录后使用 AI Agent', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text('支持多会话、流式回复与 MCP 工具', style: TextStyle(color: Color(0xFF70817D))),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: widget.onLoginRequested,
              icon: const Icon(Icons.login_rounded),
              label: const Text('前往登录'),
            ),
          ],
        ),
      );

  Widget _wideLayout() => Row(
        children: [
          SizedBox(width: 300, child: _sessionList()),
          const VerticalDivider(width: 1),
          Expanded(child: _thread()),
        ],
      );

  Widget _sessionList() {
    return Column(
      children: [
        if (!widget.showAppBar)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text('AI 会话', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                IconButton(
                  tooltip: '新建对话',
                  onPressed: _sending ? null : _createSession,
                  icon: const Icon(Icons.add_comment_rounded),
                ),
                IconButton(
                  tooltip: '刷新',
                  onPressed: () => _loadSessions(),
                  icon: const Icon(Icons.refresh_rounded),
                ),
              ],
            ),
          ),
        if (_error.isNotEmpty && _sessions.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(_error, style: const TextStyle(color: AppTheme.coral, fontSize: 13)),
          ),
        Expanded(
          child: _loadingList && _sessions.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : _sessions.isEmpty
                  ? _emptySessions()
                  : RefreshIndicator(
                      onRefresh: _loadSessions,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemCount: _sessions.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 5),
                        itemBuilder: (context, index) => _sessionTile(_sessions[index]),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _emptySessions() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.forum_outlined, size: 48, color: Color(0xFF70817D)),
            const SizedBox(height: 12),
            const Text('还没有 AI 对话', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('点下方新建，或直接在输入框发第一句', style: TextStyle(color: Color(0xFF70817D), fontSize: 13)),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: _sending ? null : _createSession,
              icon: const Icon(Icons.add_rounded),
              label: const Text('新建对话'),
            ),
          ],
        ),
      );

  Widget _sessionTile(AiSession session) {
    final active = _active?.sessionId == session.sessionId;
    return Material(
      color: active ? AppTheme.leaf.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _selectSession(session),
        onLongPress: () => _deleteSession(session),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.leaf.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.smart_toy_outlined, color: AppTheme.leaf, size: 22),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (session.createTime != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        _shortTime(session.createTime!),
                        style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: '删除',
                iconSize: 18,
                onPressed: () => _deleteSession(session),
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFF70817D)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _thread() {
    final active = _active;
    return Column(
      children: [
        if (active == null)
          const Expanded(
            child: Center(
              child: Text('选择或新建一个 AI 会话', style: TextStyle(color: Color(0xFF70817D))),
            ),
          )
        else ...[
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
      ],
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

  String _shortTime(DateTime time) {
    final local = time.toLocal();
    final now = DateTime.now();
    if (local.year == now.year && local.month == now.month && local.day == now.day) {
      return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    }
    return '${local.month}/${local.day}';
  }
}
