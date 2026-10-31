import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/resource_models.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

/// 资料：资料库 / 图库 / 经验库。
class ResourcesPage extends StatefulWidget {
  const ResourcesPage({
    super.key,
    required this.api,
    required this.token,
    this.onLoginRequested,
  });

  final ChengeApi api;
  final String? token;
  final VoidCallback? onLoginRequested;

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.resources, style: const TextStyle(fontWeight: FontWeight.w800)),
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: l10n.resourceLibrary),
            Tab(text: l10n.gallery),
            Tab(text: l10n.experience),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _LibraryTab(api: widget.api, token: widget.token, onLoginRequested: widget.onLoginRequested),
          _GalleryTab(api: widget.api, token: widget.token),
          _ExperienceTab(api: widget.api, token: widget.token, onLoginRequested: widget.onLoginRequested),
        ],
      ),
    );
  }
}

// ————————————————————————— 资料库 —————————————————————————

class _LibraryTab extends StatefulWidget {
  const _LibraryTab({required this.api, required this.token, this.onLoginRequested});

  final ChengeApi api;
  final String? token;
  final VoidCallback? onLoginRequested;

  @override
  State<_LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<_LibraryTab> {
  final _searchController = TextEditingController();
  final _docs = <KnowledgeDoc>[];
  String _category = 'all';
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.token != null) _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final token = widget.token;
    if (token == null) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final docs = await widget.api.knowledgeDocs(token: token);
      if (!mounted) return;
      setState(() {
        _docs
          ..clear()
          ..addAll(docs.where((doc) => doc.isReady));
        _docs.sort((a, b) => b.displayDate.compareTo(a.displayDate));
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<KnowledgeDoc> get _filtered {
    final keyword = _searchController.text.trim().toLowerCase();
    return _docs.where((doc) {
      if (_category != 'all' && doc.category != _category) return false;
      if (keyword.isEmpty) return true;
      return doc.fileName.toLowerCase().contains(keyword);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.token == null) {
      return _locked(
        icon: Icons.lock_outline_rounded,
        title: l10n.resourceLoginRequired,
        action: FilledButton.icon(
          onPressed: widget.onLoginRequested,
          icon: const Icon(Icons.login_rounded),
          label: Text(l10n.goSignIn),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: l10n.resourceSearch,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryChip(l10n.resourceTypeAll, 'all'),
                _categoryChip(l10n.resourceTypeDoc, 'doc'),
                _categoryChip(l10n.resourceTypeMd, 'md'),
                _categoryChip(l10n.resourceTypeWord, 'docx'),
                _categoryChip(l10n.resourceTypePpt, 'pptx'),
                _categoryChip(l10n.resourceTypePdf, 'pdf'),
                _categoryChip(l10n.resourceTypeSheet, 'sheet'),
                _categoryChip(l10n.resourceTypeImage, 'image'),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (_loading && _docs.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error.isNotEmpty)
            _errorBox(context, _error, _load)
          else if (_filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  const Icon(Icons.menu_book_outlined, size: 42, color: Color(0xFF70817D)),
                  const SizedBox(height: 10),
                  Text(l10n.resourceLibraryEmpty, style: const TextStyle(color: Color(0xFF70817D))),
                ],
              ),
            )
          else
            for (final doc in _filtered) ...[
              _docTile(doc),
              const SizedBox(height: 8),
            ],
        ],
      ),
    );
  }

  Widget _categoryChip(String label, String value) {
    final selected = _category == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => setState(() => _category = value),
      ),
    );
  }

  Widget _docTile(KnowledgeDoc doc) {
    final thumbnail = doc.thumbnail;
    final title = doc.fileName.isEmpty ? '#${doc.docId}' : doc.fileName;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _openDoc(doc),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: thumbnail == null
                      ? Container(
                          color: AppTheme.leaf.withValues(alpha: 0.10),
                          child: Icon(_typeIcon(doc.fileType), color: AppTheme.leaf),
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.api.resolveMediaUrl(thumbnail),
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: AppTheme.leaf.withValues(alpha: 0.10),
                            child: Icon(_typeIcon(doc.fileType), color: AppTheme.leaf),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [doc.fileType.toUpperCase(), doc.displayDate]
                          .where((part) => part.isNotEmpty)
                          .join(' · '),
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF70817D)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF9AA8A3)),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _typeIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'md':
      case 'markdown':
        return Icons.article_outlined;
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'docx':
      case 'doc':
        return Icons.description_outlined;
      case 'pptx':
      case 'ppt':
        return Icons.slideshow_outlined;
      case 'xlsx':
      case 'xls':
      case 'csv':
        return Icons.table_chart_outlined;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  Future<void> _openDoc(KnowledgeDoc doc) async {
    final type = doc.fileType.toLowerCase();
    if (type == 'png' || type == 'jpg' || type == 'jpeg' || type == 'webp' || type == 'gif') {
      final url = doc.thumbnail ?? doc.fileUrl;
      if (url.isNotEmpty) {
        await showDialog<void>(
          context: context,
          builder:
              (_) => _ImageViewerDialog(
                images: [widget.api.resolveMediaUrl(url)],
                initialIndex: 0,
              ),
        );
      }
      return;
    }
    if (type == 'md' || type == 'markdown' || type == 'txt' || type == 'csv' || type == 'json' || type == 'log') {
      await Navigator.of(context).push<void>(
        MaterialPageRoute<void>(
          builder:
              (_) => _DocPreviewPage(
                api: widget.api,
                token: widget.token,
                doc: doc,
              ),
        ),
      );
      return;
    }
    // 其他二进制类型：无内置预览，直接打开原文件。
    if (doc.fileUrl.isNotEmpty) {
      final uri = Uri.tryParse(widget.api.resolveMediaUrl(doc.fileUrl));
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).docPreviewUnavailable)),
      );
    }
  }
}

class _DocPreviewPage extends StatefulWidget {
  const _DocPreviewPage({required this.api, required this.token, required this.doc});

  final ChengeApi api;
  final String? token;
  final KnowledgeDoc doc;

  @override
  State<_DocPreviewPage> createState() => _DocPreviewPageState();
}

class _DocPreviewPageState extends State<_DocPreviewPage> {
  String _content = '';
  String _error = '';
  bool _loading = true;
  List<KnowledgeDocImage> _images = const [];

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
      final content = await widget.api.filePreviewText(
        widget.doc.docId,
        token: widget.token,
      );
      if (!mounted) return;
      setState(() => _content = content);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
    await _loadImages();
  }

  /// 文档可能只是一段标题，真正的画面在「资料图片」里（后端把来源图、
  /// 解析时抠出的图都挂在 `/ai/knowledge/{docId}/images`）。
  Future<void> _loadImages() async {
    try {
      final images = await widget.api.knowledgeImages(
        widget.doc.docId,
        token: widget.token,
      );
      if (!mounted || images.isEmpty) return;
      setState(() => _images = images);
    } on ApiException {
      // 图片只是锦上添花，失败时静默保持纯文本预览。
    }
  }

  void _openImage(int index) {
    showDialog<void>(
      context: context,
      builder:
          (_) => _ImageViewerDialog(
            images:
                _images
                    .map((image) => widget.api.resolveMediaUrl(image.url))
                    .toList(),
            initialIndex: index,
          ),
    );
  }

  Widget _imagesSection(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.photo_library_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.docImages,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.galleryDayCount(_images.length),
                style: const TextStyle(fontSize: 12, color: Color(0xFF7B8C86)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              const gap = 8.0;
              final columns = constraints.maxWidth >= 520 ? 4 : 3;
              final itemWidth =
                  (constraints.maxWidth - gap * (columns - 1)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (var i = 0; i < _images.length; i++)
                    GestureDetector(
                      onTap: () => _openImage(i),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: itemWidth,
                          height: itemWidth,
                          child: CachedNetworkImage(
                            imageUrl: widget.api.resolveMediaUrl(_images[i].url),
                            fit: BoxFit.cover,
                            placeholder:
                                (_, __) => const ColoredBox(
                                  color: Color(0xFFEAF2ED),
                                  child: Center(
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                ),
                            errorWidget:
                                (_, __, ___) => const ColoredBox(
                                  color: Color(0xFFEAF2ED),
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image_outlined,
                                      size: 20,
                                      color: Color(0xFF9AA8A3),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          if (_images.any((image) => image.caption.isNotEmpty)) ...[
            const SizedBox(height: 10),
            Text(
              _images
                  .map((image) => image.caption)
                  .where((caption) => caption.isNotEmpty)
                  .join(' · '),
              style: const TextStyle(fontSize: 12, color: Color(0xFF7B8C86)),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final type = widget.doc.fileType.toLowerCase();
    final isMarkdown = type == 'md' || type == 'markdown';
    final isImage =
        widget.doc.category == 'image' ||
        const ['png', 'jpg', 'jpeg', 'webp', 'gif', 'bmp'].contains(type);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.doc.fileName.isEmpty ? l10n.resourceLibrary : widget.doc.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          if (widget.doc.fileUrl.isNotEmpty)
            IconButton(
              tooltip: l10n.openOriginal,
              onPressed: () async {
                final uri = Uri.tryParse(widget.api.resolveMediaUrl(widget.doc.fileUrl));
                if (uri != null) await launchUrl(uri, mode: LaunchMode.externalApplication);
              },
              icon: const Icon(Icons.open_in_new_rounded),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error, style: const TextStyle(color: AppTheme.coral)),
                    const SizedBox(height: 8),
                    TextButton(onPressed: _load, child: Text(l10n.retry)),
                  ],
                ),
              ),
            )
          : isImage && _images.isEmpty && widget.doc.fileUrl.isNotEmpty
          ? Center(
              child: GestureDetector(
                onTap: () => showDialog<void>(
                  context: context,
                  builder:
                      (_) => _ImageViewerDialog(
                        images: [widget.api.resolveMediaUrl(widget.doc.fileUrl)],
                        initialIndex: 0,
                      ),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.api.resolveMediaUrl(
                    widget.doc.thumbnail ?? widget.doc.fileUrl,
                  ),
                  fit: BoxFit.contain,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_content.trim().isNotEmpty)
                    isMarkdown
                        ? MarkdownBody(
                            data: _content,
                            selectable: true,
                            styleSheet: MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              p: const TextStyle(fontSize: 15, height: 1.7),
                            ),
                            sizedImageBuilder: (config) {
                              final url = widget.api.resolveMediaUrl(
                                config.uri.toString(),
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: GestureDetector(
                                  onTap: () => showDialog<void>(
                                    context: context,
                                    builder:
                                        (_) => _ImageViewerDialog(
                                          images: [url],
                                          initialIndex: 0,
                                        ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl: url,
                                      fit: BoxFit.contain,
                                      errorWidget:
                                          (_, __, ___) => const SizedBox(
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                '图片加载失败',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF9AA8A3),
                                                ),
                                              ),
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : Padding(
                            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                            child: SelectableText(
                              _content,
                              style: const TextStyle(fontSize: 14, height: 1.55),
                            ),
                          ),
                  if (_images.isNotEmpty) _imagesSection(l10n),
                  if (_content.trim().isEmpty && _images.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        l10n.docPreviewUnavailable,
                        style: const TextStyle(color: Color(0xFF7B8C86)),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

// ————————————————————————— 图库 —————————————————————————

class _GalleryTab extends StatefulWidget {
  const _GalleryTab({required this.api, required this.token});

  final ChengeApi api;
  final String? token;

  @override
  State<_GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<_GalleryTab> {
  GalleryIndex _index = const GalleryIndex();
  String _error = '';
  bool _loading = false;

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
      final index = await widget.api.galleryIndex(token: widget.token);
      if (!mounted) return;
      setState(() => _index = index);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (_loading && _index.days.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty && _index.days.isEmpty) {
      return _errorBox(context, _error, _load);
    }
    if (_index.days.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.photo_library_outlined, size: 42, color: Color(0xFF70817D)),
            const SizedBox(height: 10),
            Text(l10n.galleryEmpty, style: const TextStyle(color: Color(0xFF70817D))),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: _index.days.length,
        itemBuilder: (context, position) {
          final day = _index.days[position];
          return Material(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(12),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder:
                        (_) => _GalleryDayPage(
                          api: widget.api,
                          token: widget.token,
                          day: day,
                        ),
                  ),
                );
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (day.cover.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: widget.api.resolveMediaUrl(day.cover),
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFFE7EEE9)),
                    )
                  else
                    const ColoredBox(color: Color(0xFFE7EEE9)),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(8, 14, 8, 6),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xCC12302C)],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day.short.isEmpty ? day.day : day.short,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            l10n.galleryDayCount(day.count),
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
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
}

class _GalleryDayPage extends StatefulWidget {
  const _GalleryDayPage({required this.api, required this.token, required this.day});

  final ChengeApi api;
  final String? token;
  final GalleryDay day;

  @override
  State<_GalleryDayPage> createState() => _GalleryDayPageState();
}

class _GalleryDayPageState extends State<_GalleryDayPage> {
  GalleryDay? _day;
  String _error = '';
  bool _loading = true;

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
      final day = await widget.api.galleryDay(widget.day.day, token: widget.token);
      if (!mounted) return;
      setState(() => _day = day);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final day = _day;
    final photos = day?.items ?? widget.day.items;
    final urls = [
      for (final photo in photos)
        if (photo.url.isNotEmpty) widget.api.resolveMediaUrl(photo.url),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.day.label.isEmpty ? widget.day.day : widget.day.label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: _loading && photos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty && photos.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error, style: const TextStyle(color: AppTheme.coral)),
                  const SizedBox(height: 8),
                  TextButton(onPressed: _load, child: Text(AppLocalizations.of(context).retry)),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 140,
                mainAxisSpacing: 6,
                crossAxisSpacing: 6,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                final url = widget.api.resolveMediaUrl(photo.url);
                return InkWell(
                  onTap: () => showDialog<void>(
                    context: context,
                    builder: (_) => _ImageViewerDialog(images: urls, initialIndex: index),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const ColoredBox(color: Color(0xFFE7EEE9)),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _ImageViewerDialog extends StatefulWidget {
  const _ImageViewerDialog({required this.images, this.initialIndex = 0});

  final List<String> images;
  final int initialIndex;

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _index = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (value) => setState(() => _index = value),
            itemBuilder: (context, position) => InteractiveViewer(
              maxScale: 4,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.images[position],
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (_, __, ___) => const Icon(Icons.broken_image_outlined, color: Colors.white54, size: 42),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                  ),
                  const Spacer(),
                  if (widget.images.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Text(
                        '${_index + 1} / ${widget.images.length}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ————————————————————————— 经验库 —————————————————————————

class _ExperienceTab extends StatefulWidget {
  const _ExperienceTab({required this.api, required this.token, this.onLoginRequested});

  final ChengeApi api;
  final String? token;
  final VoidCallback? onLoginRequested;

  @override
  State<_ExperienceTab> createState() => _ExperienceTabState();
}

class _ExperienceTabState extends State<_ExperienceTab> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  final _records = <ExperienceRecord>[];
  int _polarity = 1;
  int _page = 1;
  int _total = 0;
  String _error = '';
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    if (widget.token != null) _load(reset: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    final token = widget.token;
    if (token == null || _loading) return;
    if (!reset && _records.length >= _total && _total > 0) return;
    setState(() {
      _loading = true;
      _error = '';
      if (reset) {
        _page = 1;
        _records.clear();
        _total = 0;
      }
    });
    try {
      final result = await widget.api.experienceLibrary(
        polarity: _polarity,
        keyword: _searchController.text,
        page: _page,
        token: token,
      );
      if (!mounted) return;
      setState(() {
        _records.addAll(result.records);
        _total = result.total;
        _page += 1;
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _sceneLabel(BuildContext context, String scene) {
    final l10n = AppLocalizations.of(context);
    switch (scene) {
      case 'nurture':
        return l10n.sceneNurture;
      case 'global':
        return l10n.sceneGlobal;
      default:
        return l10n.sceneNormal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.token == null) {
      return _locked(
        icon: Icons.lock_outline_rounded,
        title: l10n.experienceLoginRequired,
        action: FilledButton.icon(
          onPressed: widget.onLoginRequested,
          icon: const Icon(Icons.login_rounded),
          label: Text(l10n.goSignIn),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _load(reset: true),
      child: ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
        children: [
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: [
              ButtonSegment(value: 1, label: Text(l10n.experiencePositive)),
              ButtonSegment(value: -1, label: Text(l10n.experienceNegative)),
            ],
            selected: {_polarity},
            onSelectionChanged: (selection) {
              setState(() => _polarity = selection.first);
              _load(reset: true);
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _load(reset: true),
            decoration: InputDecoration(
              hintText: l10n.experienceSearch,
              prefixIcon: const Icon(Icons.search_rounded),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _total > 0 ? l10n.experienceTotal(_total) : '',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
                ),
              ),
              if (_error.isNotEmpty)
                Text(_error, style: const TextStyle(fontSize: 12, color: AppTheme.coral)),
            ],
          ),
          const SizedBox(height: 4),
          if (_records.isEmpty && _loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 48),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Column(
                children: [
                  const Icon(Icons.auto_stories_outlined, size: 42, color: Color(0xFF70817D)),
                  const SizedBox(height: 10),
                  Text(l10n.experienceEmpty, style: const TextStyle(color: Color(0xFF70817D))),
                ],
              ),
            )
          else
            for (final record in _records) ...[
              Container(
                padding: const EdgeInsets.all(13),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (record.polarity == 1 ? AppTheme.leaf : AppTheme.coral)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _sceneLabel(context, record.scene),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: record.polarity == 1 ? AppTheme.leaf : AppTheme.coral,
                            ),
                          ),
                        ),
                        if (record.skill.isNotEmpty) ...[
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              '${l10n.skillLabel}: ${record.skill}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF70817D)),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      record.pattern,
                      style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, height: 1.45),
                    ),
                    if (record.rule.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        record.rule,
                        style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF3F514B)),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          if (_loading && _records.isNotEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            ),
        ],
      ),
    );
  }
}

// ————————————————————————— 共用 —————————————————————————

Widget _locked({
  required IconData icon,
  required String title,
  required Widget action,
}) => Center(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 46, color: const Color(0xFF70817D)),
        const SizedBox(height: 12),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 14),
        action,
      ],
    ),
  ),
);

Widget _errorBox(BuildContext context, String message, VoidCallback onRetry) => Center(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(message, style: const TextStyle(color: AppTheme.coral), textAlign: TextAlign.center),
      const SizedBox(height: 8),
      TextButton(onPressed: onRetry, child: Text(AppLocalizations.of(context).retry)),
    ],
  ),
);