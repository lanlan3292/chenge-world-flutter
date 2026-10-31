import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/generated/app_localizations.dart';

import '../models/ai_session.dart';
import '../models/ai_skill.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import '../widgets/ai_rich_text.dart';

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
  bool _contentReady = false;
  bool _sending = false;
  bool _stickToBottom = true;
  bool _popScheduled = false;

  /// 联网搜索（后端 web_search，养成场景会被强制关闭）。
  bool _webSearch = false;

  /// 画图设置；null 表示不启用画图。
  AiDrawModel? _drawModel;
  List<AiDrawModel> _drawModels = const [];
  bool _drawModelsLoading = false;
  String _drawAspect = '1:1';
  String _drawQuality = 'standard';

  /// 史官模式：只在客户端切换，发送时给 user_input 加前缀。
  bool _historian = false;

  /// 会话技能（技能选择弹窗）。
  List<AiSkill> _skills = const [];
  bool _skillsLoading = false;

  /// 待发送的图片附件（data URL，直接进 images 字段）。
  final _attachments = <_AiAttachment>[];
  final _picker = ImagePicker();

  /// 最近一次 `interaction`（任务清单/提问）与待确认写操作。
  AiInteraction? _interaction;
  List<AiPendingOp> _pendingOps = const [];

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
      _contentReady = false;
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
    setState(() => _contentReady = false);
    try {
      final history = await widget.api.aiChatHistory(_session.sessionId, widget.token);
      if (!mounted) return;
      final bubbles = history.map(AiChatBubble.fromHistory).toList();
      // 历史消息没有 messageKey 时补一个稳定键，点赞点踩仍可用。
      for (var index = 0; index < bubbles.length; index++) {
        final bubble = bubbles[index];
        bubble.messageKey ??= '${_session.sessionId}-h-$index';
      }
      setState(() {
        _messages
          ..clear()
          ..addAll(bubbles);
      });
      if (_messages.isEmpty) {
        setState(() => _contentReady = true);
      } else {
        await _scrollToBottomInitial();
      }
    } on ApiException catch (error) {
      if (mounted) {
        setState(() => _contentReady = true);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
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
      final max = _messageScrollController.position.maxScrollExtent;
      _messageScrollController.jumpTo(max);
    }

    jump();
    await WidgetsBinding.instance.endOfFrame;
    if (!mounted) return;
    jump();

    if (mounted) setState(() => _contentReady = true);
  }

  /// 画图设置弹窗：选择模型、画面比例与画质。
  Future<void> _openDrawSettings() async {
    final l10n = AppLocalizations.of(context);
    if (_drawModels.isEmpty && !_drawModelsLoading) {
      setState(() => _drawModelsLoading = true);
      try {
        final models = await widget.api.aiDrawModels(widget.token);
        if (!mounted) return;
        setState(() => _drawModels = models);
      } on ApiException catch (error) {
        if (!mounted) return;
        _showError(error.message);
      } finally {
        if (mounted) setState(() => _drawModelsLoading = false);
      }
    }
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          void update(VoidCallback change) {
            setSheetState(change);
            setState(change);
          }

          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aiDrawing,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.aiDrawModel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF70817D),
                    ),
                  ),
                  if (_drawModelsLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_drawModels.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        l10n.aiDrawNoModels,
                        style: const TextStyle(color: Color(0xFF70817D)),
                      ),
                    )
                  else
                    RadioGroup<String>(
                      groupValue: _drawModel?.task ?? '',
                      onChanged: (value) {
                        update(() {
                          _drawModel = value == null || value.isEmpty
                              ? null
                              : _drawModels.firstWhere(
                                  (model) => model.task == value,
                                  orElse: () => _drawModels.first,
                                );
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final model in _drawModels)
                            RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              dense: true,
                              value: model.task,
                              title: Text(model.title),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.aiDrawAspect,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF70817D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final aspect in const ['1:1', '3:4', '4:3', '9:16', '16:9'])
                        ChoiceChip(
                          label: Text(aspect),
                          selected: _drawAspect == aspect,
                          onSelected: (_) => update(() => _drawAspect = aspect),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.aiDrawQuality,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF70817D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final quality in const ['standard', 'high'])
                        ChoiceChip(
                          label: Text(quality),
                          selected: _drawQuality == quality,
                          onSelected: (_) => update(() => _drawQuality = quality),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => update(() => _drawModel = null),
                          child: Text(l10n.close),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 点赞/点踩：rating 1 赞、-1 踩；再次点击同一按钮取消（0）。
  Future<void> _rateMessage(AiChatBubble bubble, int rating) async {
    final messageKey = bubble.messageKey;
    if (messageKey == null || messageKey.isEmpty) return;
    final next = bubble.rating == rating ? 0 : rating;
    final previous = bubble.rating;
    setState(() => bubble.rating = next == 0 ? null : next);
    try {
      await widget.api.submitAiFeedback(
        token: widget.token,
        sessionId: _session.sessionId,
        messageKey: messageKey,
        rating: next,
        answerSnapshot: bubble.content,
        scene: 'chat',
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => bubble.rating = previous);
      _showError(error.message);
    }
  }

  /// 从 sources/artifacts 事件里提取图片地址。
  List<String> _extractImages(dynamic data) {
    final urls = <String>[];
    void visit(dynamic node) {
      if (node == null) return;
      if (node is String) {
        final url = node.trim();
        if (url.startsWith('http') &&
            (RegExp(r'\.(png|jpe?g|webp|gif)(\?|$)', caseSensitive: false).hasMatch(url) ||
                url.contains('/image/') ||
                url.contains('/file/'))) {
          urls.add(url);
        }
        return;
      }
      if (node is List) {
        for (final item in node) {
          visit(item);
        }
        return;
      }
      if (node is Map) {
        for (final entry in const ['url', 'file_url', 'fileUrl', 'image', 'images', 'src']) {
          if (!node.containsKey(entry)) continue;
          final value = node[entry];
          if (value is String && value.startsWith('http')) {
            urls.add(value);
          } else {
            visit(value);
          }
        }
        for (final entry in node.values) {
          if (entry is Map || entry is List) visit(entry);
        }
      }
    }

    visit(data);
    return urls.toSet().toList();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), backgroundColor: AppTheme.coral));
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    final images = [for (final attachment in _attachments) attachment.dataUrl];
    if ((text.isEmpty && images.isEmpty) || _sending) return;

    final turnId = 'flutter-${DateTime.now().microsecondsSinceEpoch}';
    final l10n = AppLocalizations.of(context);
    final userBubble = AiChatBubble(
      role: 'user',
      content: text.isEmpty ? l10n.chatImage : text,
      messageKey: '${_session.sessionId}-u-$turnId',
    );
    final assistantBubble = AiChatBubble(
      role: 'assistant',
      content: '',
      streaming: true,
      status: _historian ? l10n.aiHistorianWorking : l10n.thinking,
      messageKey: '${_session.sessionId}-a-$turnId',
    );

    final draw = _historian || _drawModel == null
        ? null
        : <String, dynamic>{
            'task': _drawModel!.task,
            'aspect': _drawAspect,
            'quality': _drawQuality,
          };

    setState(() {
      _sending = true;
      _messageController.clear();
      _attachments.clear();
      _messages.addAll([userBubble, assistantBubble]);
      _stickToBottom = true;
    });
    _scrollToBottom(animate: true);

    try {
      await for (final event in widget.api.streamAiAgent(
        token: widget.token,
        sessionId: _session.sessionId,
        userInput: _historian ? '__GENERAL_LIBRARY_QA__\n$text' : text,
        turnId: turnId,
        webSearch: _historian ? null : (_webSearch ? true : null),
        draw: draw,
        images: images.isEmpty ? null : images,
      )) {
        if (!mounted) return;
        final type = event.type;
        final data = event.data;

        if (type == 'error') {
          final message = data is Map
              ? (data['message'] ?? data['msg'] ?? AppLocalizations.of(context).aiRequestFailed).toString()
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
              assistantBubble.content = AppLocalizations.of(context).noTextReply;
            }
          });
          if (_session.name == AppLocalizations.of(context).newConversation || _session.name.isEmpty) {
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

        if (type == 'sources' || type == 'artifacts') {
          final images = _extractImages(data);
          if (images.isNotEmpty) {
            setState(() {
              for (final url in images) {
                if (!assistantBubble.images.contains(url)) {
                  assistantBubble.images.add(url);
                }
              }
            });
            if (_stickToBottom) _scrollToBottom(animate: true);
          }
          setState(
            () => assistantBubble.status = AppLocalizations.of(
              context,
            ).receivedType(type),
          );
          continue;
        }

        if (type == 'pending') {
          final ops = data is Map && data['ops'] is List
              ? (data['ops'] as List)
                    .whereType<Map<String, dynamic>>()
                    .map(AiPendingOp.fromJson)
                    .toList()
              : const <AiPendingOp>[];
          setState(() {
            assistantBubble.status = AppLocalizations.of(context).waitingConfirm;
            if (ops.isNotEmpty) _pendingOps = ops;
          });
          continue;
        }

        if (type == 'interaction') {
          if (data is Map<String, dynamic>) {
            final interaction = AiInteraction.fromJson(data);
            setState(() {
              _interaction = interaction;
              assistantBubble.status = AppLocalizations.of(context).aiTasksReady;
            });
            if (_stickToBottom) _scrollToBottom(animate: true);
          }
          continue;
        }

        if (type == 'interaction_status') {
          final id = data is Map ? (data['id'] ?? '').toString() : '';
          final status = data is Map ? (data['status'] ?? '').toString() : '';
          final current = _interaction;
          if (current != null && (id.isEmpty || current.id == id) && status.isNotEmpty) {
            setState(() => _interaction = current.copyWith(status: status));
          }
          continue;
        }

        if (type == 'archive_preview' || type == 'archive_update') {
          final message = data is Map ? (data['message'] ?? '').toString() : '';
          setState(() {
            if (message.isNotEmpty) assistantBubble.content = message;
            assistantBubble.status = type == 'archive_preview'
                ? AppLocalizations.of(context).aiArchivePreview
                : AppLocalizations.of(context).aiArchiveSaving;
          });
          if (_stickToBottom) _scrollToBottom(animate: true);
          continue;
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
                tooltip: AppLocalizations.of(context).backToSessionList,
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
        actions: [
          if (!_historian)
            IconButton(
              tooltip: AppLocalizations.of(context).aiWebSearch,
            onPressed:
                _sending ? null : () => setState(() => _webSearch = !_webSearch),
            color: _webSearch ? AppTheme.leaf : null,
            icon: Icon(
              _webSearch
                  ? Icons.travel_explore_rounded
                  : Icons.travel_explore_outlined,
            ),
          ),
          if (!_historian)
            IconButton(
              tooltip: AppLocalizations.of(context).aiDrawing,
            onPressed: _sending ? null : _openDrawSettings,
            color: _drawModel == null ? null : AppTheme.leaf,
            icon: Icon(
              _drawModel == null ? Icons.image_outlined : Icons.image_rounded,
            ),
          ),
        ],
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
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _bubble(_messages[index]),
                  ),
                ),
                if (!_contentReady)
                  const ColoredBox(
                    color: Color(0xFFF7F9F8),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_messages.isEmpty)
                  Center(
                    child: Text(AppLocalizations.of(context).sendMessageToStart, style: const TextStyle(color: Color(0xFF70817D))),
                  ),
              ],
            ),
          ),
          _composer(),
        ],
      ),
    );
  }

  /// 去掉史官模式的内部前缀/尾注，避免污染展示。
  String _displayContent(String content) {
    var text = content.replaceAll('__GENERAL_LIBRARY_QA__', '').replaceAll('【AI史官】', '');
    const tail = '请依据站内史料查证、对照并整理带证据的 history 档案。';
    final trimmed = text.trimRight();
    if (trimmed.endsWith(tail)) {
      text = trimmed.substring(0, trimmed.length - tail.length);
    }
    return text.trim();
  }

  Future<void> _pickAttachment() async {
    if (_sending) return;
    try {
      final files = await _picker.pickMultiImage(imageQuality: 82, maxWidth: 1600);
      if (files.isEmpty) return;
      final picked = <_AiAttachment>[];
      for (final file in files.take(4 - _attachments.length)) {
        final bytes = await file.readAsBytes();
        final mime = file.mimeType ?? _mimeOf(file.name);
        picked.add(
          _AiAttachment(
            name: file.name,
            dataUrl: 'data:$mime;base64,${base64Encode(bytes)}',
          ),
        );
      }
      if (!mounted) return;
      setState(() => _attachments.addAll(picked));
    } on Exception {
      if (!mounted) return;
      _showError(AppLocalizations.of(context).attachmentFailed);
    }
  }

  String _mimeOf(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
  }

  Future<void> _openSkills() async {
    if (_skillsLoading) return;
    setState(() => _skillsLoading = true);
    try {
      final skills = await widget.api.aiSkills(_session.sessionId, widget.token);
      if (!mounted) return;
      setState(() => _skills = skills);
    } on ApiException catch (error) {
      if (!mounted) return;
      _showError(error.message);
      setState(() => _skillsLoading = false);
      return;
    }
    if (!mounted) return;
    setState(() => _skillsLoading = false);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder:
          (sheetContext) => StatefulBuilder(
            builder: (context, setSheetState) {
              final l10n = AppLocalizations.of(context);
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.aiSkillsTitle,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      if (_skills.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(l10n.aiSkillsEmpty, style: const TextStyle(color: Color(0xFF70817D))),
                        )
                      else
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              for (final skill in _skills)
                                SwitchListTile(
                                  contentPadding: EdgeInsets.zero,
                                  value: skill.enabled,
                                  title: Row(
                                    children: [
                                      Flexible(child: Text(skill.name)),
                                      if (skill.isPurchased) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: AppTheme.leaf.withValues(alpha: 0.12),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            l10n.aiSkillPurchased,
                                            style: const TextStyle(fontSize: 10, color: AppTheme.leaf),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  subtitle: Text(
                                    skill.description.isEmpty ? '（无描述）' : skill.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onChanged: _sending
                                      ? null
                                      : (next) async {
                                          final previous = skill.enabled;
                                          setSheetState(() {
                                            _skills = [
                                              for (final item in _skills)
                                                item.key == skill.key ? item.copyWith(enabled: next) : item,
                                            ];
                                          });
                                          try {
                                            await widget.api.setAiSkill(
                                              token: widget.token,
                                              sessionId: _session.sessionId,
                                              key: skill.key,
                                              enabled: next,
                                            );
                                          } on ApiException catch (error) {
                                            setSheetState(() {
                                              _skills = [
                                                for (final item in _skills)
                                                  item.key == skill.key
                                                      ? item.copyWith(enabled: previous)
                                                      : item,
                                              ];
                                            });
                                            if (mounted) _showError(error.message);
                                          }
                                        },
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Future<void> _openTasks() async {
    final interaction = _interaction;
    if (interaction == null && _pendingOps.isEmpty) return;
    final answers = <String, Map<String, dynamic>>{};
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder:
          (sheetContext) => StatefulBuilder(
            builder: (context, setSheetState) {
              final l10n = AppLocalizations.of(context);
              final pendingInteraction = _interaction;
              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    16 + MediaQuery.viewInsetsOf(context).bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (pendingInteraction != null) ...[
                          Text(
                            l10n.aiTasksTitle,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          if (pendingInteraction.tasks.isEmpty)
                            Text(l10n.aiTasksEmpty, style: const TextStyle(color: Color(0xFF70817D)))
                          else
                            for (final task in pendingInteraction.tasks)
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(task.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                                          if (task.detail.isNotEmpty)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 2),
                                              child: Text(
                                                task.detail,
                                                style: const TextStyle(fontSize: 12, color: Color(0xFF5B6B66)),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE7EEE9),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _taskStatusLabel(l10n, task.status),
                                        style: const TextStyle(fontSize: 10.5, color: Color(0xFF3F514B)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          if (pendingInteraction.questions.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              pendingInteraction.questions.first.multiple
                                  ? l10n.aiQuestionMultiHint
                                  : l10n.aiQuestionSingleHint,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
                            ),
                            for (final question in pendingInteraction.questions)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      question.question,
                                      style: const TextStyle(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 6),
                                    Wrap(
                                      spacing: 6,
                                      runSpacing: 4,
                                      children: [
                                        for (final option in question.options)
                                          FilterChip(
                                            label: Text(option),
                                            selected: ((answers[question.id]?['selected']) as List?)
                                                    ?.contains(option) ??
                                                false,
                                            onSelected: (selected) {
                                              final entry = answers.putIfAbsent(
                                                question.id,
                                                () => {'selected': <String>[], 'custom': ''},
                                              );
                                              final selectedList =
                                                  (entry['selected'] as List).cast<String>();
                                              if (question.multiple) {
                                                selected
                                                    ? selectedList.add(option)
                                                    : selectedList.remove(option);
                                              } else {
                                                selectedList
                                                  ..clear()
                                                  ..add(option);
                                              }
                                              setSheetState(() {});
                                            },
                                          ),
                                      ],
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: '${question.customLabel} · ${l10n.aiQuestionCustomHint}',
                                        isDense: true,
                                      ),
                                      onChanged: (value) {
                                        final entry = answers.putIfAbsent(
                                          question.id,
                                          () => {'selected': <String>[], 'custom': ''},
                                        );
                                        entry['custom'] = value;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          const SizedBox(height: 12),
                          Text(
                            l10n.aiTasksFooter(pendingInteraction.tasks.length),
                            style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _respondInteraction(pendingInteraction, approve: false);
                                },
                                child: Text(l10n.aiTasksCancel),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _respondInteraction(
                                    pendingInteraction,
                                    approve: true,
                                    answers: [
                                      for (final question in pendingInteraction.questions)
                                        {
                                          'selected': (answers[question.id]?['selected'] as List?) ?? const [],
                                          'custom': (answers[question.id]?['custom'] ?? '').toString(),
                                        },
                                    ],
                                  );
                                },
                                child: Text(l10n.aiTasksConfirm),
                              ),
                            ],
                          ),
                        ],
                        if (_pendingOps.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            l10n.aiPendingTitle(_pendingOps.length),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                          for (final op in _pendingOps)
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(op.label),
                              subtitle: Text(op.paramsText, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _confirmPending(approve: false);
                                },
                                child: Text(l10n.aiPendingReject),
                              ),
                              const SizedBox(width: 8),
                              FilledButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await _confirmPending(approve: true);
                                },
                                child: Text(l10n.aiPendingApprove),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
    );
  }

  String _taskStatusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'running':
        return l10n.aiTaskRunning;
      case 'done':
      case 'completed':
        return l10n.aiTaskDone;
      case 'failed':
        return l10n.aiTaskFailed;
      case 'cancelled':
        return l10n.aiTaskCancelled;
      case 'approved':
        return l10n.aiTaskApproved;
      default:
        return l10n.aiTaskPending;
    }
  }

  Future<void> _respondInteraction(
    AiInteraction interaction, {
    required bool approve,
    List<Map<String, dynamic>> answers = const [],
  }) async {
    try {
      await widget.api.submitAiInteraction(
        token: widget.token,
        sessionId: _session.sessionId,
        interactionId: interaction.id,
        approve: approve,
        answers: answers,
      );
      if (!mounted) return;
      setState(() {
        _interaction = interaction.copyWith(
          status: approve ? 'approved' : 'cancelled',
        );
      });
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
  }

  Future<void> _confirmPending({required bool approve}) async {
    try {
      final result = await widget.api.confirmAiPending(
        token: widget.token,
        sessionId: _session.sessionId,
        approve: approve,
      );
      if (!mounted) return;
      setState(() => _pendingOps = const []);
      final message = result['message']?.toString();
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(message?.isNotEmpty == true ? message! : AppLocalizations.of(context).aiPendingSubmitted)),
        );
    } on ApiException catch (error) {
      if (mounted) _showError(error.message);
    }
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
              isUser
                  ? SelectableText(
                      bubble.content,
                      style: TextStyle(color: fg, height: 1.4),
                    )
                  : AiRichText(
                      content: _displayContent(bubble.content),
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(
                        p: TextStyle(color: fg, height: 1.45),
                        listBullet: TextStyle(color: fg),
                      ),
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
            if (bubble.images.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final url in bubble.images)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        width: 168,
                        height: 168,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 168,
                              height: 168,
                              color: const Color(0xFFEAF2ED),
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                      ),
                    ),
                ],
              ),
            ],
            if (!isUser && !bubble.streaming && bubble.content.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _feedbackButton(bubble, 1, Icons.thumb_up_outlined),
                    _feedbackButton(bubble, -1, Icons.thumb_down_outlined),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _feedbackButton(AiChatBubble bubble, int rating, IconData icon) {
    final selected = bubble.rating == rating;
    final l10n = AppLocalizations.of(context);
    return IconButton(
      visualDensity: VisualDensity.compact,
      iconSize: 17,
      tooltip: rating > 0 ? l10n.aiFeedbackHelpful : l10n.aiFeedbackNotHelpful,
      onPressed: () => _rateMessage(bubble, rating),
      color: selected
          ? (rating > 0 ? AppTheme.leaf : AppTheme.coral)
          : const Color(0xFF9AA9A4),
      icon: Icon(icon),
    );
  }

  Widget _composer() {
    final l10n = AppLocalizations.of(context);
    final hasTasks = _interaction != null || _pendingOps.isNotEmpty;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SegmentedButton<bool>(
                  showSelectedIcon: false,
                  style: const ButtonStyle(
                    visualDensity: VisualDensity.compact,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  segments: [
                    ButtonSegment(value: false, label: Text(l10n.aiModeChat)),
                    ButtonSegment(value: true, label: Text(l10n.aiModeHistorian)),
                  ],
                  selected: {_historian},
                  onSelectionChanged: _sending
                      ? null
                      : (selection) => setState(() => _historian = selection.first),
                ),
                const Spacer(),
                if (!_historian)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.aiSkillsTitle,
                    onPressed: _sending ? null : _openSkills,
                    icon: Badge(
                      isLabelVisible: _skills.any((skill) => skill.enabled),
                      label: Text('${_skills.where((skill) => skill.enabled).length}'),
                      backgroundColor: AppTheme.leaf,
                      child: const Icon(Icons.auto_awesome_outlined, size: 20),
                    ),
                  ),
                if (!_historian)
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: l10n.aiTasksTitle,
                    onPressed: _sending && _interaction == null ? null : _openTasks,
                    icon: Badge(
                      isLabelVisible: hasTasks,
                      label: Text('${_interaction?.tasks.length ?? _pendingOps.length}'),
                      backgroundColor: AppTheme.coral,
                      child: const Icon(Icons.checklist_rounded, size: 20),
                    ),
                  ),
              ],
            ),
            if (_attachments.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (var i = 0; i < _attachments.length; i++)
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              base64Decode(_attachments[i].dataUrl.split(',').last),
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => setState(() => _attachments.removeAt(i)),
                              child: const CircleAvatar(
                                radius: 9,
                                backgroundColor: Color(0xFF3F514B),
                                child: Icon(Icons.close_rounded, size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            if (_historian)
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 2),
                child: Text(
                  l10n.aiHistorianHint,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF7A6A4F)),
                ),
              ),
            Row(
              children: [
                if (!_historian)
                  IconButton(
                    tooltip: l10n.addAttachment,
                    onPressed: _sending ? null : _pickAttachment,
                    icon: const Icon(Icons.add_photo_alternate_outlined),
                  ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    minLines: 1,
                    maxLines: 5,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _send(),
                    enabled: !_sending,
                    decoration: InputDecoration(
                      hintText: _historian ? l10n.aiHistorianPlaceholder : l10n.askAiAgent,
                      prefixIcon: Icon(
                        _historian ? Icons.history_edu_rounded : Icons.smart_toy_outlined,
                      ),
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
          ],
        ),
      ),
    );
  }
}

class _AiAttachment {
  const _AiAttachment({required this.name, required this.dataUrl});

  final String name;
  final String dataUrl;
}
