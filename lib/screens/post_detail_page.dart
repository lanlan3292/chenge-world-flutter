import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/blog_comment.dart';
import '../models/blog_post.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import '../widgets/image_viewer_page.dart';
import '../widgets/post_images_carousel.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({
    super.key,
    required this.api,
    required this.post,
    this.token,
  });

  final ChengeApi api;
  final BlogPost post;
  final String? token;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<BlogPost> _detail;
  final _commentController = TextEditingController();
  final _commentFocusNode = FocusNode();
  final _commentSectionKey = GlobalKey();
  final _composerKey = GlobalKey();
  final _comments = <BlogComment>[];
  BlogComment? _replyTo;
  String? _commentError;
  bool _commentsLoading = true;
  bool _commentPosting = false;
  bool _likeBusy = false;
  bool _liked = false;
  int _likeCount = 0;
  int _commentCount = 0;

  @override
  void initState() {
    super.initState();
    final cached = widget.api.cachedPostLiked(widget.post.id);
    _liked = cached ?? widget.post.liked;
    _likeCount = widget.post.likeCount;
    _commentCount = widget.post.commentCount;
    _detail = _loadDetail();
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<BlogPost> _loadDetail() async {
    try {
      final post = await widget.api.postDetail(
        widget.post.id,
        token: widget.token,
      );
      if (mounted) {
        setState(() {
          // Prefer server liked when token is present; otherwise keep cache / list state.
          final cached = widget.api.cachedPostLiked(widget.post.id);
          if (widget.token != null && widget.token!.isNotEmpty) {
            if (post.liked) {
              _liked = true;
              widget.api.rememberPostLiked(widget.post.id, true);
            } else if (cached != null) {
              _liked = cached;
            } else {
              _liked = post.liked;
            }
          } else if (cached != null) {
            _liked = cached;
          } else {
            _liked = post.liked;
          }
          _likeCount = post.likeCount;
          if (_liked && _likeCount <= 0) {
            _likeCount = 1;
          }
          _commentCount = post.commentCount;
        });
      }
      return post;
    } on ApiException {
      return widget.post;
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _commentsLoading = true;
      _commentError = null;
    });
    try {
      final comments = await widget.api.postComments(widget.post.id);
      if (!mounted) return;
      setState(() {
        _comments
          ..clear()
          ..addAll(comments);
        _commentCount = comments.fold<int>(
          0,
          (count, comment) => count + 1 + comment.children.length,
        );
      });
    } on ApiException catch (error) {
      if (mounted) setState(() => _commentError = error.message);
    } finally {
      if (mounted) setState(() => _commentsLoading = false);
    }
  }

  Future<void> _toggleLike() async {
    final token = widget.token;
    if (token == null) {
      _showMessage(AppLocalizations.of(context).signInToLike);
      return;
    }
    if (_likeBusy) return;
    setState(() => _likeBusy = true);
    try {
      final liked = await widget.api.togglePostLike(widget.post.id, token);
      if (!mounted) return;
      setState(() {
        if (_liked != liked) {
          _likeCount = (_likeCount + (liked ? 1 : -1)).clamp(0, 1 << 30);
        }
        _liked = liked;
      });
      widget.api.rememberPostLiked(widget.post.id, liked);
    } on ApiException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } finally {
      if (mounted) setState(() => _likeBusy = false);
    }
  }

  Future<void> _submitComment() async {
    final token = widget.token;
    final content = _commentController.text.trim();
    if (token == null) {
      _showMessage(AppLocalizations.of(context).signInToComment);
      return;
    }
    if (content.isEmpty || _commentPosting) return;
    setState(() {
      _commentPosting = true;
      _commentError = null;
    });
    try {
      // Nested reply: attach under the root parent so the UI (2-level) can show it.
      final replyTarget = _replyTo;
      final parentId =
          replyTarget == null
              ? 0
              : (replyTarget.parentId != 0
                  ? replyTarget.parentId
                  : replyTarget.id);
      await widget.api.addPostComment(
        blogId: widget.post.id,
        content: content,
        parentId: parentId,
        token: token,
      );
      if (!mounted) return;
      _commentController.clear();
      setState(() => _replyTo = null);
      await _loadComments();
      if (mounted) _showMessage(AppLocalizations.of(context).commentPublished);
    } on ApiException catch (error) {
      if (mounted) setState(() => _commentError = error.message);
    } finally {
      if (mounted) setState(() => _commentPosting = false);
    }
  }

  Future<void> _replyToComment(BlogComment comment) async {
    setState(() => _replyTo = comment);
    final composerContext = _composerKey.currentContext;
    if (composerContext == null) return;
    await Scrollable.ensureVisible(
      composerContext,
      duration: const Duration(milliseconds: 220),
      alignment: 0.75,
    );
    if (mounted) _commentFocusNode.requestFocus();
  }

  Future<void> _scrollToComments() async {
    final target = _commentSectionKey.currentContext;
    if (target != null) {
      await Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 240),
      );
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppTheme.coral : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final result = widget.post.copyWith(
      liked: _liked,
      likeCount: _likeCount,
      commentCount: _commentCount,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          Navigator.pop(context, result);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            tooltip: AppLocalizations.of(context).back,
            onPressed: () => Navigator.pop(context, result),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text(
            AppLocalizations.of(context).post,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: FutureBuilder<BlogPost>(
          future: _detail,
          builder:
              (context, snapshot) =>
                  _body(snapshot.data ?? widget.post, bottomInset),
        ),
      ),
    );
  }

  Widget _body(BlogPost post, double bottomInset) {
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: width > 780 ? 760 : double.infinity,
        ),
        child: ListView(
          // Use system bottom inset so content clears the nav/gesture bar under edge-to-edge.
          padding: EdgeInsets.fromLTRB(22, 12, 22, 28 + bottomInset),
          children: [
            if (post.categoryName != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    post.categoryName!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            if (post.coverImage != null) ...[
              GestureDetector(
                onTap: () => ImageViewerPage.openSingle(
                  context,
                  imageUrl: widget.api.resolveMediaUrl(post.coverImage!),
                  heroTag: 'post-cover-${post.id}',
                ),
                child: Hero(
                  tag: 'post-cover-${post.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.network(
                        widget.api.resolveMediaUrl(post.coverImage!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => ColoredBox(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          child: const Center(
                            child: Icon(Icons.broken_image_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 30,
                height: 1.15,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor:
                      Theme.of(context).colorScheme.tertiaryContainer,
                  foregroundImage:
                      post.authorAvatar == null
                          ? null
                          : NetworkImage(post.authorAvatar!),
                  child:
                      post.authorAvatar == null
                          ? Icon(
                            Icons.person_rounded,
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.onTertiaryContainer,
                          )
                          : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        _date(context, post.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF70817D),
                        ),
                      ),
                    ],
                  ),
                ),
                _stat(Icons.visibility_outlined, post.viewCount),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: _likeBusy ? null : _toggleLike,
                  icon:
                      _likeBusy
                          ? const SizedBox.square(
                            dimension: 17,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Icon(
                            _liked
                                ? Icons.thumb_up_alt_rounded
                                : Icons.thumb_up_alt_outlined,
                          ),
                  label: Text(
                    '${_liked ? AppLocalizations.of(context).liked : AppLocalizations.of(context).like} · $_likeCount',
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _scrollToComments,
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                  label: Text(
                    AppLocalizations.of(context).commentCount(_commentCount),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    post.tags
                        .map(
                          (tag) => Chip(
                            label: Text('#$tag'),
                            visualDensity: VisualDensity.compact,
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            side: BorderSide.none,
                          ),
                        )
                        .toList(),
              ),
            if (_galleryImages(post).isNotEmpty)
              PostImagesCarousel(
                images: _galleryImages(post),
                resolveUrl: widget.api.resolveMediaUrl,
              ),
            if (_biliLinks(post).isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._biliLinks(post).map((url) => _biliTile(context, url)),
            ],
            if (_fileLinks(post).isNotEmpty) ...[
              const SizedBox(height: 12),
              ..._fileLinks(post).map((url) => _attachmentTile(context, url)),
            ],
            MarkdownBody(
              data: post.content.isNotEmpty ? post.content : post.summary,
              selectable: true,
              sizedImageBuilder: (image) {
                final url = widget.api.resolveMediaUrl(image.uri.toString());
                return GestureDetector(
                  onTap: () => ImageViewerPage.openSingle(context, imageUrl: url),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: image.width,
                        height: image.height,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, __, ___) =>
                                const Icon(Icons.broken_image_outlined),
                      ),
                    ),
                  ),
                );
              },
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 16,
                  height: 1.75,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                h1: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                h2: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                blockquoteDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 3,
                    ),
                  ),
                ),
                codeblockDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 26),
            _commentSection(),
          ],
        ),
      ),
    );
  }

  Widget _commentSection() => Column(
    key: _commentSectionKey,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context).commentsWithCount(_commentCount),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).refreshComments,
            onPressed: _commentsLoading ? null : _loadComments,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Container(
        key: _composerKey,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_replyTo != null) ...[
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).replyToUser(
                        _replyTo!.authorName ??
                            AppLocalizations.of(context).user,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: AppLocalizations.of(context).cancelReply,
                    visualDensity: VisualDensity.compact,
                    onPressed: () => setState(() => _replyTo = null),
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
            ],
            TextField(
              controller: _commentController,
              focusNode: _commentFocusNode,
              minLines: 2,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              enabled: !_commentPosting,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).writeComment,
                border: InputBorder.none,
                filled: false,
              ),
            ),
            if (_commentError != null) ...[
              const SizedBox(height: 6),
              Text(
                _commentError!,
                style: const TextStyle(color: AppTheme.coral, fontSize: 12),
              ),
            ],
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed:
                    _commentPosting || _commentController.text.trim().isEmpty
                        ? null
                        : _submitComment,
                icon:
                    _commentPosting
                        ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.send_rounded),
                label: Text(
                  _commentPosting
                      ? AppLocalizations.of(context).publishing
                      : AppLocalizations.of(context).publishComment,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      if (_commentsLoading && _comments.isEmpty)
        const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (_commentError != null && _comments.isEmpty)
        Center(
          child: Column(
            children: [
              Text(
                _commentError!,
                style: const TextStyle(color: AppTheme.coral),
              ),
              TextButton(
                onPressed: _loadComments,
                child: Text(AppLocalizations.of(context).retry),
              ),
            ],
          ),
        )
      else if (_comments.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: Text(
              AppLocalizations.of(context).noComments,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        )
      else
        ..._comments.map((comment) => _commentTile(comment)),
    ],
  );

  Widget _commentTile(BlogComment comment, {bool isReply = false}) => Padding(
    padding: EdgeInsets.only(left: isReply ? 34 : 0, bottom: 10),
    child: Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color:
            isReply
                ? Theme.of(context).colorScheme.surfaceContainerHigh
                : Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: isReply ? 13 : 16,
            backgroundColor: const Color(0xFFFFE8C5),
            foregroundImage:
                comment.authorAvatar == null
                    ? null
                    : NetworkImage(comment.authorAvatar!),
            child:
                comment.authorAvatar == null
                    ? const Icon(
                      Icons.person_rounded,
                      size: 17,
                      color: AppTheme.ink,
                    )
                    : null,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        comment.authorName ??
                            AppLocalizations.of(context).anonymousUser,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      _date(context, comment.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF87948F),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                if (comment.replyToName?.isNotEmpty == true) ...[
                  const SizedBox(height: 3),
                  Text(
                    AppLocalizations.of(
                      context,
                    ).replyToUser(comment.replyToName ?? ''),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                SelectableText(
                  comment.content,
                  style: TextStyle(
                    height: 1.45,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () => _replyToComment(comment),
                    icon: const Icon(Icons.reply_rounded, size: 16),
                    label: Text(AppLocalizations.of(context).reply),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
                if (!isReply && comment.children.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  ...comment.children.map(
                    (reply) => _commentTile(reply, isReply: true),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _stat(IconData icon, int value) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: const Color(0xFF70817D)),
      const SizedBox(width: 4),
      Text(
        '$value',
        style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
      ),
    ],
  );


  static final _imageExt = RegExp(
    r'\.(png|jpe?g|gif|webp|bmp|svg|avif)(\?.*)?$',
    caseSensitive: false,
  );
  static final _bvRe = RegExp(r'BV([0-9A-Za-z]{10})');

  static bool _isImageUrl(String url) => _imageExt.hasMatch(url);
  static bool _isBiliUrl(String url) => _bvRe.hasMatch(url);

  static List<String> _galleryImages(BlogPost post) {
    final seen = <String>{};
    final out = <String>[];
    for (final u in [...post.images, ...post.media]) {
      final t = u.trim();
      if (t.isEmpty || seen.contains(t)) continue;
      if (post.images.contains(t) || _isImageUrl(t)) {
        seen.add(t);
        out.add(t);
      }
    }
    return out;
  }

  static List<String> _biliLinks(BlogPost post) {
    return post.media
        .map((u) => u.trim())
        .where((u) => u.isNotEmpty && _isBiliUrl(u) && !_isImageUrl(u))
        .toList();
  }

  static List<String> _fileLinks(BlogPost post) {
    return post.media
        .map((u) => u.trim())
        .where((u) => u.isNotEmpty && !_isImageUrl(u) && !_isBiliUrl(u))
        .toList();
  }

  static String? _parseBvid(String text) {
    final m = _bvRe.firstMatch(text);
    return m?.group(0);
  }

  Widget _biliTile(BuildContext context, String url) {
    final l10n = AppLocalizations.of(context);
    final bvid = _parseBvid(url);
    final openUrl = bvid != null
        ? 'https://www.bilibili.com/video/$bvid'
        : url;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.play_circle_outline_rounded),
        title: Text(l10n.bilibiliVideo),
        subtitle: Text(
          bvid ?? url,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: () => _openExternal(openUrl),
      ),
    );
  }

  Widget _attachmentTile(BuildContext context, String url) {
    final l10n = AppLocalizations.of(context);
    final name = _fileNameFromUrl(url);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.attach_file_rounded),
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          l10n.attachmentLink,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.open_in_new_rounded, size: 18),
        onTap: () => _openExternal(widget.api.resolveMediaUrl(url)),
      ),
    );
  }

  static String _fileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.pathSegments.isNotEmpty) {
        final last = uri.pathSegments.last;
        if (last.isNotEmpty) return Uri.decodeComponent(last);
      }
    } catch (_) {}
    return url;
  }

  Future<void> _openExternal(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).cannotOpenLink)),
        );
    }
  }

  static String _date(BuildContext context, DateTime? date) {
    final l10n = AppLocalizations.of(context);
    if (date == null) return l10n.timeUnknown;
    return l10n.dateYmd(date.year, date.month, date.day);
  }
}
