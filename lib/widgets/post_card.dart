import 'package:flutter/material.dart';

import '../models/blog_post.dart';

/// Feed grid card. Fills the grid cell (no outer AspectRatio) so narrow cells
/// keep readable text and wide cells do not grow excessively tall.
class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    this.featured = false,
  });

  final BlogPost post;
  final VoidCallback onTap;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final narrow = w < 220;
            // Cover: prefer 16:9, but never more than ~52% of cell height so text fits.
            final coverIdeal = w * 9 / 16;
            final coverH = coverIdeal.clamp(48.0, h * 0.52);
            final padH = narrow ? 10.0 : 14.0;
            final padV = narrow ? 8.0 : 11.0;
            final titleLines = h - coverH < 120 ? 1 : 2;
            final summaryLines = h - coverH < 150 ? 1 : 2;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: coverH,
                  width: double.infinity,
                  child: _cover(context),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.categoryName != null || post.tags.isNotEmpty)
                          Row(
                            children: [
                              if (post.categoryName != null)
                                Flexible(
                                  child: _label(
                                    post.categoryName!,
                                    theme.colorScheme.primaryContainer,
                                    theme.colorScheme.onPrimaryContainer,
                                    maxWidth: narrow ? 90 : 140,
                                  ),
                                ),
                              if (post.tags.isNotEmpty) ...[
                                if (post.categoryName != null) const SizedBox(width: 6),
                                Flexible(
                                  child: _label(
                                    '#${post.tags.first}',
                                    theme.colorScheme.secondaryContainer,
                                    theme.colorScheme.onSecondaryContainer,
                                    maxWidth: narrow ? 90 : 140,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        if (post.categoryName != null || post.tags.isNotEmpty)
                          SizedBox(height: narrow ? 5 : 7),
                        Text(
                          post.title,
                          maxLines: titleLines,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                            fontSize: narrow ? 14 : null,
                          ),
                        ),
                        SizedBox(height: narrow ? 3 : 5),
                        Expanded(
                          child: Text(
                            post.summary,
                            maxLines: summaryLines,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.35,
                              fontSize: narrow ? 11.5 : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _avatar(context, radius: narrow ? 10 : 12),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${post.authorName} · ${_dateLabel(post.createdAt)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: narrow ? 10 : 11,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            _metric(context, Icons.visibility_outlined, post.viewCount),
                            const SizedBox(width: 6),
                            _metric(context, Icons.chat_bubble_outline_rounded, post.commentCount),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cover(BuildContext context) {
    final imageUrl = post.coverImage;
    if (imageUrl == null) return _coverPlaceholder(context);
    return Image.network(
      imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _coverPlaceholder(context),
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Stack(
              fit: StackFit.expand,
              children: [
                _coverPlaceholder(context),
                Center(
                  child: CircularProgressIndicator(
                    value: progress.expectedTotalBytes == null
                        ? null
                        : progress.cumulativeBytesLoaded / progress.expectedTotalBytes!,
                    strokeWidth: 2,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _coverPlaceholder(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -34,
              child: _shape(125, Theme.of(context).colorScheme.surfaceContainerHigh),
            ),
            Positioned(
              left: 24,
              bottom: -45,
              child: _shape(110, Theme.of(context).colorScheme.tertiaryContainer),
            ),
            Center(
              child: Icon(
                Icons.article_rounded,
                size: 34,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );

  Widget _shape(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.34),
        ),
      );

  Widget _label(String label, Color color, Color foreground, {double maxWidth = 150}) =>
      Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: foreground,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

  Widget _avatar(BuildContext context, {double radius = 12}) {
    final avatar = post.authorAvatar;
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundImage: avatar == null ? null : NetworkImage(avatar),
      child: avatar == null
          ? Icon(
              Icons.person_rounded,
              size: radius + 3,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            )
          : null,
    );
  }

  Widget _metric(BuildContext context, IconData icon, int value) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 2),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );

  static String _dateLabel(DateTime? date) {
    if (date == null) return '刚刚';
    final difference = DateTime.now().difference(date);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes.clamp(1, 59)} 分钟前';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours} 小时前';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays} 天前';
    }
    return '${date.month}月${date.day}日';
  }
}
