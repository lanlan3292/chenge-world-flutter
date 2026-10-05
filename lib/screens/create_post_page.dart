import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/blog_category.dart';
import '../models/blog_tag.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    super.key,
    required this.api,
    required this.token,
    this.editPostId,
  });

  final ChengeApi api;
  final String token;
  final int? editPostId;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  static const _draftPrefix = 'blog:draft:';
  static const _maxImages = 5;

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _contentFocus = FocusNode();
  final _picker = ImagePicker();
  final _mediaControllers = <TextEditingController>[];

  List<BlogCategory> _categories = const [];
  List<BlogTag> _hotTags = const [];
  BlogCategory? _selectedCategory;
  String? _coverUrl;
  final List<String> _uploadedImages = [];
  bool _loadingCategories = true;
  bool _publishing = false;
  bool _uploading = false;
  bool _savingDraft = false;
  bool _previewMode = false;
  String? _error;
  String? _draftSavedAt;
  Timer? _draftTimer;
  bool _restoringDraft = false;

  String get _draftKey => '$_draftPrefix${widget.editPostId ?? 'new'}';

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_scheduleDraftSave);
    _contentController.addListener(_scheduleDraftSave);
    _tagsController.addListener(_scheduleDraftSave);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future.wait([_loadCategories(), _loadHotTags()]);
    if (!mounted) return;
    await _maybeRestoreDraft();
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    _titleController.removeListener(_scheduleDraftSave);
    _contentController.removeListener(_scheduleDraftSave);
    _tagsController.removeListener(_scheduleDraftSave);
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _contentFocus.dispose();
    for (final c in _mediaControllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _loadingCategories = true;
      _error = null;
    });
    try {
      final list = await widget.api.listCategories(token: widget.token);
      if (!mounted) return;
      setState(() {
        _categories = list;
        if (list.isNotEmpty) {
          _selectedCategory ??= list.first;
        }
      });
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loadingCategories = false);
    }
  }

  Future<void> _loadHotTags() async {
    try {
      final tags = await widget.api.hotTags(limit: 15, token: widget.token);
      if (!mounted) return;
      setState(() => _hotTags = tags.where((t) => t.name.isNotEmpty).toList());
    } on ApiException {
      // Hot tags are optional; ignore failures.
    }
  }

  void _addTag(String name) {
    final value = name.trim();
    if (value.isEmpty) return;
    final existing =
        _tagsController.text
            .split(RegExp(r'[,，\s]+'))
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
    if (existing.any((t) => t.toLowerCase() == value.toLowerCase())) return;
    existing.add(value);
    _tagsController.text = existing.join(', ');
    _scheduleDraftSave();
  }

  void _addMediaField({String initial = ''}) {
    final c = TextEditingController(text: initial);
    c.addListener(_scheduleDraftSave);
    setState(() => _mediaControllers.add(c));
    _scheduleDraftSave();
  }

  void _removeMediaField(int index) {
    final c = _mediaControllers.removeAt(index);
    c.dispose();
    setState(() {});
    _scheduleDraftSave();
  }

  List<String> _mediaUrls() =>
      _mediaControllers
          .map((c) => c.text.trim())
          .where((u) => u.isNotEmpty)
          .toList();

  Map<String, dynamic> _snapshot() => {
    'at': DateTime.now().toIso8601String(),
    'form': {
      'categoryId': _selectedCategory?.id,
      'title': _titleController.text,
      'coverImage': _coverUrl ?? '',
      'content': _contentController.text,
      'media': _mediaUrls(),
      'images': List<String>.from(_uploadedImages),
    },
    'tagText': _tagsController.text,
  };

  void _scheduleDraftSave() {
    if (_restoringDraft) return;
    _draftTimer?.cancel();
    _draftTimer = Timer(const Duration(milliseconds: 800), _saveDraftNow);
  }

  Future<void> _saveDraftNow() async {
    final hasContent =
        _titleController.text.trim().isNotEmpty ||
        _contentController.text.trim().isNotEmpty ||
        _mediaUrls().isNotEmpty ||
        _uploadedImages.isNotEmpty ||
        (_coverUrl != null && _coverUrl!.isNotEmpty);
    if (!hasContent) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final snap = _snapshot();
      await prefs.setString(_draftKey, jsonEncode(snap));
      if (!mounted) return;
      setState(() => _draftSavedAt = snap['at'] as String);
    } catch (_) {
      // Draft is best-effort.
    }
  }

  Future<void> _saveDraftManual() async {
    setState(() => _savingDraft = true);
    await _saveDraftNow();
    if (!mounted) return;
    setState(() => _savingDraft = false);
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.draftSaved)));
  }

  Future<void> _clearDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } catch (_) {}
    if (mounted) setState(() => _draftSavedAt = null);
  }

  Future<void> _maybeRestoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_draftKey);
      if (raw == null || raw.isEmpty) return;
      final data = jsonDecode(raw);
      if (data is! Map) return;
      final form = data['form'];
      if (form is! Map) return;
      final hasContent =
          '${form['title'] ?? ''}'.trim().isNotEmpty ||
          '${form['content'] ?? ''}'.trim().isNotEmpty ||
          (form['media'] is List && (form['media'] as List).isNotEmpty) ||
          (form['images'] is List && (form['images'] as List).isNotEmpty);
      if (!hasContent) return;

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final action = await showDialog<String>(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: Text(l10n.restoreDraftTitle),
              content: Text(l10n.restoreDraftMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'discard'),
                  child: Text(l10n.discardDraft),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, 'restore'),
                  child: Text(l10n.restoreDraft),
                ),
              ],
            ),
      );
      if (!mounted) return;
      if (action == 'discard') {
        await _clearDraft();
        return;
      }
      if (action != 'restore') return;

      _restoringDraft = true;
      final catId = form['categoryId'];
      if (catId is num || catId is String) {
        final id = catId is num ? catId.toInt() : int.tryParse('$catId');
        if (id != null) {
          final match = _categories.where((c) => c.id == id);
          if (match.isNotEmpty) _selectedCategory = match.first;
        }
      }
      _titleController.text = '${form['title'] ?? ''}';
      _contentController.text = '${form['content'] ?? ''}';
      final cover = '${form['coverImage'] ?? ''}'.trim();
      _coverUrl = cover.isEmpty ? null : cover;
      _uploadedImages
        ..clear()
        ..addAll(
          (form['images'] is List)
              ? (form['images'] as List)
                  .map((e) => '$e')
                  .where((e) => e.isNotEmpty)
              : const [],
        );
      for (final c in _mediaControllers) {
        c.dispose();
      }
      _mediaControllers.clear();
      final media = form['media'] is List ? form['media'] as List : const [];
      for (final m in media) {
        final url = '$m'.trim();
        if (url.isNotEmpty) _addMediaField(initial: url);
      }
      _tagsController.text = '${data['tagText'] ?? ''}';
      _draftSavedAt = '${data['at'] ?? ''}';
      _restoringDraft = false;
      setState(() {});
    } catch (_) {
      _restoringDraft = false;
    }
  }

  Future<String?> _uploadBytes(
    Uint8List bytes,
    String name, {
    String type = 'post_image',
  }) async {
    setState(() => _uploading = true);
    try {
      final safeName = _ensureImageFilename(name);
      final url = await widget.api.uploadFile(
        bytes: bytes,
        filename: safeName,
        token: widget.token,
        businessType: type,
      );
      return url;
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(e.message), backgroundColor: AppTheme.coral),
          );
      }
      return null;
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  /// Android/iOS pickers sometimes omit extension or mime; normalize for the server.
  static String _ensureImageFilename(String name) {
    final trimmed = name.trim();
    final lower = trimmed.toLowerCase();
    const exts = [
      '.jpg',
      '.jpeg',
      '.png',
      '.gif',
      '.webp',
      '.bmp',
      '.heic',
      '.heif',
    ];
    if (exts.any(lower.endsWith)) {
      return trimmed.isEmpty ? 'image.jpg' : trimmed;
    }
    if (trimmed.isEmpty) return 'image.jpg';
    return '$trimmed.jpg';
  }

  Future<void> _pickAndInsertImage() async {
    if (_uploadedImages.length >= _maxImages) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).maxImagesReached(_maxImages),
            ),
          ),
        );
      return;
    }
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      imageQuality: 88,
      requestFullMetadata: false,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final name = file.name.isNotEmpty ? file.name : 'image.jpg';
    final url = await _uploadBytes(bytes, name, type: 'post_image');
    if (url == null || !mounted) return;
    setState(() => _uploadedImages.add(url));
    _scheduleDraftSave();
  }

  Future<void> _pickCover() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
      requestFullMetadata: false,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final name = file.name.isNotEmpty ? file.name : 'cover.jpg';
    final url = await _uploadBytes(bytes, name, type: 'post_cover');
    if (url == null || !mounted) return;
    setState(() => _coverUrl = url);
    _scheduleDraftSave();
  }

  Future<void> _publish() async {
    final l10n = AppLocalizations.of(context);
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final category = _selectedCategory;
    if (category == null) {
      setState(() => _error = l10n.selectCategoryHint);
      return;
    }
    if (title.isEmpty) {
      setState(() => _error = l10n.titleRequired);
      return;
    }
    if (content.isEmpty) {
      setState(() => _error = l10n.contentRequired);
      return;
    }
    if (_publishing) return;
    setState(() {
      _publishing = true;
      _error = null;
    });
    try {
      final tags =
          _tagsController.text
              .split(RegExp(r'[,，\s]+'))
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList();
      final media = _mediaUrls();
      final id = await widget.api.publishPost(
        token: widget.token,
        categoryId: category.id,
        title: title,
        content: content,
        coverImage: _coverUrl,
        images:
            _uploadedImages.isEmpty ? null : List<String>.from(_uploadedImages),
        media: media.isEmpty ? null : media,
        tags: tags.isEmpty ? null : tags,
      );
      if (!mounted) return;
      await _clearDraft();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.postPublished)));
      Navigator.pop(context, id);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _publishing = false);
    }
  }

  String _formatDraftTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    final local = dt.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.createPost,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
            onPressed: (_savingDraft || _publishing) ? null : _saveDraftManual,
            child: Text(l10n.saveDraft),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed:
                  (_publishing || _uploading || _loadingCategories)
                      ? null
                      : _publish,
              child:
                  _publishing
                      ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : Text(l10n.publishPost),
            ),
          ),
        ],
      ),
      body:
          _loadingCategories
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                children: [
                  if (_error != null) ...[
                    Material(
                      color: scheme.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          _error!,
                          style: TextStyle(color: scheme.onErrorContainer),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (_draftSavedAt != null && _draftSavedAt!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        l10n.draftAutoSaved(_formatDraftTime(_draftSavedAt!)),
                        style: TextStyle(
                          fontSize: 12,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  Text(
                    l10n.category,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  if (_categories.isEmpty)
                    Text(
                      l10n.noCategories,
                      style: TextStyle(color: scheme.onSurfaceVariant),
                    )
                  else
                    DropdownButtonFormField<BlogCategory>(
                      initialValue: _selectedCategory,
                      items:
                          _categories
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(
                                    c.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged: (c) {
                        setState(() => _selectedCategory = c);
                        _scheduleDraftSave();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    maxLength: 120,
                    decoration: InputDecoration(
                      labelText: l10n.postTitle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.coverImage,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _uploading ? null : _pickCover,
                        icon: const Icon(Icons.image_outlined),
                        label: Text(l10n.chooseCover),
                      ),
                      if (_coverUrl != null) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {
                            setState(() => _coverUrl = null);
                            _scheduleDraftSave();
                          },
                          child: Text(l10n.removeCover),
                        ),
                      ],
                    ],
                  ),
                  if (_coverUrl != null) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          _coverUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => ColoredBox(
                                color: scheme.surfaceContainerHighest,
                                child: const Icon(Icons.broken_image_outlined),
                              ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    l10n.articleImages,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.articleImagesHint,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ...List.generate(_uploadedImages.length, (index) {
                        final url = _uploadedImages[index];
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                url,
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Container(
                                      width: 88,
                                      height: 88,
                                      color: scheme.surfaceContainerHighest,
                                      child: const Icon(
                                        Icons.broken_image_outlined,
                                      ),
                                    ),
                              ),
                            ),
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Material(
                                color: scheme.error,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () {
                                    setState(
                                      () => _uploadedImages.removeAt(index),
                                    );
                                    _scheduleDraftSave();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                      if (_uploadedImages.length < _maxImages)
                        Material(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: _uploading ? null : _pickAndInsertImage,
                            child: SizedBox(
                              width: 88,
                              height: 88,
                              child:
                                  _uploading
                                      ? const Center(
                                        child: SizedBox.square(
                                          dimension: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                      : Icon(
                                        Icons.add_rounded,
                                        color: scheme.onSurfaceVariant,
                                      ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        l10n.postContent,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      SegmentedButton<bool>(
                        segments: [
                          ButtonSegment<bool>(
                            value: false,
                            label: Text(l10n.editMarkdown),
                            icon: const Icon(Icons.edit_outlined, size: 16),
                          ),
                          ButtonSegment<bool>(
                            value: true,
                            label: Text(l10n.previewMarkdown),
                            icon: const Icon(Icons.visibility_outlined, size: 16),
                          ),
                        ],
                        selected: {_previewMode},
                        onSelectionChanged: (s) =>
                            setState(() => _previewMode = s.first),
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_previewMode)
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(minHeight: 240),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border.all(color: scheme.outlineVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _contentController.text.trim().isEmpty
                          ? Text(
                              l10n.previewEmpty,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                            )
                          : MarkdownBody(
                              data: _contentController.text,
                              selectable: true,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                    )
                  else
                    TextField(
                      controller: _contentController,
                      focusNode: _contentFocus,
                      minLines: 12,
                      maxLines: 24,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: l10n.markdownHint,
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.attachmentUrls,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.attachmentUrlsHint,
                    style: TextStyle(
                      fontSize: 12,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(_mediaControllers.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _mediaControllers[index],
                              decoration: InputDecoration(
                                hintText: l10n.attachmentUrlHint,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: l10n.removeAttachment,
                            onPressed: () => _removeMediaField(index),
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ],
                      ),
                    );
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () => _addMediaField(),
                      icon: const Icon(Icons.link_rounded),
                      label: Text(l10n.addAttachmentUrl),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _tagsController,
                    decoration: InputDecoration(
                      labelText: l10n.tagsOptional,
                      hintText: l10n.tagsHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  if (_hotTags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      l10n.hotTags,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          _hotTags
                              .map(
                                (tag) => ActionChip(
                                  label: Text(
                                    tag.postCount > 0
                                        ? '${tag.name} (${tag.postCount})'
                                        : tag.name,
                                  ),
                                  onPressed: () => _addTag(tag.name),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ],
              ),
    );
  }
}
