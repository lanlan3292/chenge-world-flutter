import 'package:flutter/material.dart';

import '../models/blog_post.dart';

/// Feed grid card. Fills the grid cell (no outer AspectRatio).
/// Adapts density by available width/height so narrow cells never overflow.
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
            final narrow = w < 200;
            final veryNarrow = w < 150;

            // Cover: 16:9 preferred, but leave enough room for text block.
            final coverIdeal = w * 9 / 16;
            final coverMaxFrac = narrow ? 0.46 : 0.52;
            final coverH = coverIdeal.clamp(40.0, h * coverMaxFrac);

            final contentH = h - coverH;
            // Budget fixed chrome so we know whether summary can show.
            final padV = narrow ? 6.0 : 10.0;
            final padH = narrow ? 8.0 : 14.0;
            final hasTag = post.categoryName != null || post.tags.isNotEmpty;
            final tagH = hasTag ? (narrow ? 18.0 : 22.0) : 0.0;
            final tagGap = hasTag ? (narrow ? 4.0 : 6.0) : 0.0;
            final titleLineH = narrow ? 17.0 : 20.0;
            final titleLines = contentH < 110 ? 1 : 2;
            final titleH = titleLineH * titleLines;
            final titleGap = narrow ? 2.0 : 4.0;
            final footerH = narrow ? 18.0 : 24.0;
            final footerGap = 2.0;
            final fixed =
                padV * 2 + tagH + tagGap + titleH + titleGap + footerGap + footerH;
            final freeForSummary = contentH - fixed;
            final showSummary = freeForSummary >= (narrow ? 14.0 : 18.0);
            final summaryLines = freeForSummary >= 32 ? 2 : 1;

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
                        if (hasTag)
                          Row(
                            children: [
                              if (post.categoryName != null)
                                Flexible(
                                  child: _label(
                                    post.categoryName!,
                                    theme.colorScheme.primaryContainer,
                                    theme.colorScheme.onPrimaryContainer,
                                    maxWidth: veryNarrow ? 72 : (narrow ? 96 : 140),
                                    compact: narrow,
                                  ),
                                ),
                              if (post.tags.isNotEmpty) ...[
                                if (post.categoryName != null)
                                  const SizedBox(width: 4),
                                Flexible(
                                  child: _label(
                                    '#${post.tags.first}',
                                    theme.colorScheme.secondaryContainer,
                                    theme.colorScheme.onSecondaryContainer,
                                    maxWidth: veryNarrow ? 72 : (narrow ? 96 : 140),
                                    compact: narrow,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        if (hasTag) SizedBox(height: tagGap),
                        Text(
                          post.title,
                          maxLines: titleLines,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            fontSize: veryNarrow
                                ? 12.5
                                : (narrow ? 13.5 : null),
                          ),
                        ),
                        if (showSummary) ...[
                          SizedBox(height: titleGap),
                          Expanded(
                            child: Text(
                              post.summary,
                              maxLines: summaryLines,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.3,
                                fontSize: narrow ? 11.0 : null,
                              ),
                            ),
                          ),
                        ] else
                          const Spacer(),
                        SizedBox(height: footerGap),
                        _footer(context, theme, narrow: narrow, veryNarrow: veryNarrow),
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

  Widget _footer(
    BuildContext context,
    ThemeData theme, {
    required bool narrow,
    required bool veryNarrow,
  }) {
    final radius = veryNarrow ? 8.0 : (narrow ? 9.0 : 12.0);
    return SizedBox(
      height: narrow ? 18 : 24,
      child: Row(
        children: [
          _avatar(context, radius: radius),
          SizedBox(width: narrow ? 4 : 6),
          Expanded(
            child: Text(
              veryNarrow
                  ? post.authorName
                  : '${post.authorName} · ${_dateLabel(post.createdAt)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: veryNarrow ? 9.5 : (narrow ? 10 : 11),
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.1,
              ),
            ),
          ),
          _metric(context, Icons.visibility_outlined, post.viewCount, compact: narrow),
          SizedBox(width: narrow ? 4 : 6),
          _metric(
            context,
            Icons.chat_bubble_outline_rounded,
            post.commentCount,
            compact: narrow,
          ),
        ],
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
                        : progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!,
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

  Widget _label(
    String label,
    Color color,
    Color foreground, {
    double maxWidth = 150,
    bool compact = false,
  }) =>
      Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 5 : 7,
          vertical: compact ? 2 : 3,
        ),
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
            fontSize: compact ? 9 : 10,
            fontWeight: FontWeight.w700,
            height: 1.1,
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
              size: radius + 2,
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            )
          : null,
    );
  }

  Widget _metric(
    BuildContext context,
    IconData icon,
    int value, {
    bool compact = false,
  }) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 11 : 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 2),
          Text(
            '$value',
            style: TextStyle(
              fontSize: compact ? 9 : 10,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.1,
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
