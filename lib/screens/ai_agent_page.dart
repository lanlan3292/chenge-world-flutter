import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

import '../models/ai_session.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import 'ai_thread_page.dart';

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
  final _sessions = <AiSession>[];
  AiSession? _active;
  String _error = '';
  bool _loadingList = false;
  bool _busy = false;
  bool _routeOpen = false;
  bool? _lastWide;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) _loadSessions();
  }

  @override
  void didUpdateWidget(covariant AiAgentPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _sessions.clear();
      _active = null;
      if (widget.token != null) _loadSessions();
    }
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
    if (token == null || _busy) return;
    setState(() => _busy = true);
    try {
      final session = await widget.api.createAiSession(token, name: AppLocalizations.of(context).newConversation);
      if (!mounted) return;
      setState(() {
        _sessions.insert(0, session);
      });
      _selectSession(session);
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteSession(AiSession session) async {
    final token = widget.token;
    if (token == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteSession),
        content: Text(AppLocalizations.of(context).confirmDeleteSession(session.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context).cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context).delete),
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
        }
      });
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  void _selectSession(AiSession session) {
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    setState(() => _active = session);
    if (!isWide) {
      _pushThread(session);
    }
  }

  Future<void> _pushThread(AiSession session) async {
    final token = widget.token;
    if (token == null || _routeOpen) return;
    _routeOpen = true;
    final keep = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AiThreadPage(
          api: widget.api,
          token: token,
          session: session,
          onSessionRenamed: (updated) {
            final index = _sessions.indexWhere((s) => s.sessionId == updated.sessionId);
            if (index >= 0) {
              setState(() {
                _sessions[index] = updated;
                if (_active?.sessionId == updated.sessionId) _active = updated;
              });
            }
          },
        ),
      ),
    );
    _routeOpen = false;
    if (!mounted) return;
    if (keep != true) {
      setState(() => _active = null);
    } else {
      setState(() {});
    }
    _loadSessions(silent: true);
  }

  void _handleWidthChange(bool isWide) {
    if (_lastWide == isWide) return;
    final wasWide = _lastWide;
    _lastWide = isWide;
    if (wasWide == null) return;
    if (wasWide && !isWide && _active != null && !_routeOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && MediaQuery.sizeOf(context).width < 760 && _active != null) {
          _pushThread(_active!);
        }
      });
    }
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
    _handleWidthChange(isWide);

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('AI Agent', style: TextStyle(fontWeight: FontWeight.w800)),
              actions: [
                IconButton(
                  tooltip: AppLocalizations.of(context).newChat,
                  onPressed: widget.token == null || _busy ? null : _createSession,
                  icon: const Icon(Icons.add_comment_rounded),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context).refreshSessions,
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
              : _sessionList(),
    );
  }

  Widget _signedOut() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.smart_toy_outlined, color: AppTheme.leaf, size: 54),
            const SizedBox(height: 12),
            Text(AppLocalizations.of(context).signInToUseAiAgent, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).aiAgentSubtitle, style: const TextStyle(color: Color(0xFF70817D))),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: widget.onLoginRequested,
              icon: const Icon(Icons.login_rounded),
              label: Text(AppLocalizations.of(context).goSignIn),
            ),
          ],
        ),
      );

  Widget _wideLayout() => Row(
        children: [
          SizedBox(width: 300, child: _sessionList()),
          const VerticalDivider(width: 1),
          Expanded(
            child: _active == null
                ? Center(
                    child: Text(AppLocalizations.of(context).selectOrCreateAiSession, style: const TextStyle(color: Color(0xFF70817D))),
                  )
                : AiThreadPage(
                    key: ValueKey('wide-ai-${_active!.sessionId}'),
                    api: widget.api,
                    token: widget.token!,
                    session: _active!,
                    showBackButton: false,
                    onSessionRenamed: (updated) {
                      final index = _sessions.indexWhere((s) => s.sessionId == updated.sessionId);
                      if (index >= 0) {
                        setState(() {
                          _sessions[index] = updated;
                          _active = updated;
                        });
                      }
                    },
                  ),
          ),
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
                Expanded(
                  child: Text(AppLocalizations.of(context).aiSessions, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context).newChat,
                  onPressed: _busy ? null : _createSession,
                  icon: const Icon(Icons.add_comment_rounded),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context).refresh,
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
            Text(AppLocalizations.of(context).noAiChatsYet, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context).tapNewToStartChat, style: const TextStyle(color: Color(0xFF70817D), fontSize: 13)),
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _createSession,
              icon: const Icon(Icons.add_rounded),
              label: Text(AppLocalizations.of(context).newChat),
            ),
          ],
        ),
      );

  Widget _sessionTile(AiSession session) {
    final active = _active?.sessionId == session.sessionId;
    return Material(
      color: active
          ? Theme.of(context).colorScheme.secondaryContainer
          : Theme.of(context).colorScheme.surfaceContainerLow,
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
                tooltip: AppLocalizations.of(context).delete,
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

  String _shortTime(DateTime time) {
    final local = time.toLocal();
    final now = DateTime.now();
    if (local.year == now.year && local.month == now.month && local.day == now.day) {
      return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    }
    return '${local.month}/${local.day}';
  }
}
