import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/blog_category.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({
    super.key,
    required this.api,
    required this.token,
  });

  final ChengeApi api;
  final String token;

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  final _contentFocus = FocusNode();
  final _picker = ImagePicker();

  List<BlogCategory> _categories = const [];
  BlogCategory? _selectedCategory;
  String? _coverUrl;
  final List<String> _uploadedImages = [];
  bool _loadingCategories = true;
  bool _publishing = false;
  bool _uploading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    _contentFocus.dispose();
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

  Future<String?> _uploadBytes(Uint8List bytes, String name, {String type = 'post_image'}) async {
    setState(() => _uploading = true);
    try {
      final url = await widget.api.uploadFile(
        bytes: bytes,
        filename: name,
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

  Future<void> _pickAndInsertImage() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2400,
      imageQuality: 88,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final name = file.name.isNotEmpty ? file.name : 'image.jpg';
    final url = await _uploadBytes(bytes, name, type: 'post_image');
    if (url == null || !mounted) return;
    setState(() => _uploadedImages.add(url));
    _insertAtCursor('![image]($url)\n');
  }

  Future<void> _pickCover() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (file == null) return;
    final bytes = await file.readAsBytes();
    final name = file.name.isNotEmpty ? file.name : 'cover.jpg';
    final url = await _uploadBytes(bytes, name, type: 'post_cover');
    if (url == null || !mounted) return;
    setState(() => _coverUrl = url);
  }

  void _insertAtCursor(String markdown) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final next = text.replaceRange(start, end, markdown);
    _contentController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + markdown.length),
    );
    _contentFocus.requestFocus();
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
      final tags = _tagsController.text
          .split(RegExp(r'[,，\s]+'))
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      final id = await widget.api.publishPost(
        token: widget.token,
        categoryId: category.id,
        title: title,
        content: content,
        coverImage: _coverUrl,
        images: _uploadedImages.isEmpty ? null : List<String>.from(_uploadedImages),
        tags: tags.isEmpty ? null : tags,
      );
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
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: (_publishing || _uploading || _loadingCategories) ? null : _publish,
              child: _publishing
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.publishPost),
            ),
          ),
        ],
      ),
      body: _loadingCategories
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
                Text(l10n.category, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (_categories.isEmpty)
                  Text(l10n.noCategories, style: TextStyle(color: scheme.onSurfaceVariant))
                else
                  DropdownButtonFormField<BlogCategory>(
                    initialValue: _selectedCategory,
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                    onChanged: (c) => setState(() => _selectedCategory = c),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  maxLength: 120,
                  decoration: InputDecoration(
                    labelText: l10n.postTitle,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(l10n.coverImage, style: const TextStyle(fontWeight: FontWeight.w700)),
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
                        onPressed: () => setState(() => _coverUrl = null),
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
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: scheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image_outlined),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(l10n.postContent, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    if (_uploading)
                      const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        tooltip: l10n.insertImage,
                        onPressed: _pickAndInsertImage,
                        icon: const Icon(Icons.add_photo_alternate_outlined),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  focusNode: _contentFocus,
                  minLines: 12,
                  maxLines: 24,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: l10n.markdownHint,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _tagsController,
                  decoration: InputDecoration(
                    labelText: l10n.tagsOptional,
                    hintText: l10n.tagsHint,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
    );
  }
}
