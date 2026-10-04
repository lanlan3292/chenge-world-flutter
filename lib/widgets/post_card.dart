import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/blog_post.dart';

/// Feed card.
///
/// Reports an intrinsic height from cover (16:9) + content so a row-aligned
/// grid can size each row to the tallest card. When the parent gives more
/// height than intrinsic, the body expands and the footer stays at the bottom.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final hasBoundedHeight =
            constraints.maxHeight.isFinite && constraints.maxHeight < double.infinity;
        final narrow = w < 200;
        final veryNarrow = w < 150;
        final padH = narrow ? 10.0 : 14.0;
        final padV = narrow ? 8.0 : 11.0;
        final hasTag = post.categoryName != null || post.tags.isNotEmpty;
        final summary = post.summary.trim();
        final showSummary = summary.isNotEmpty;

        final body = Padding(
          padding: EdgeInsets.fromLTRB(padH, padV, padH, padV),
          child: Column(
            mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
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
                          maxWidth: veryNarrow ? 72 : (narrow ? 100 : 140),
                          compact: narrow,
                        ),
                      ),
                    if (post.tags.isNotEmpty) ...[
                      if (post.categoryName != null) const SizedBox(width: 6),
                      Flexible(
                        child: _label(
                          '#${post.tags.first}',
                          theme.colorScheme.secondaryContainer,
                          theme.colorScheme.onSecondaryContainer,
                          maxWidth: veryNarrow ? 72 : (narrow ? 100 : 140),
                          compact: narrow,
                        ),
                      ),
                    ],
                  ],
                ),
              if (hasTag) SizedBox(height: narrow ? 5 : 7),
              Text(
                post.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                  fontSize: veryNarrow ? 13.0 : (narrow ? 14.0 : null),
                ),
              ),
              if (showSummary) ...[
                SizedBox(height: narrow ? 4 : 6),
                Text(
                  summary,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                    fontSize: narrow ? 11.5 : null,
                  ),
                ),
              ],
              if (hasBoundedHeight) const Spacer(),
              SizedBox(height: narrow ? 8 : 10),
              _footer(context, theme, narrow: narrow, veryNarrow: veryNarrow),
            ],
          ),
        );

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Column(
              mainAxisSize: hasBoundedHeight ? MainAxisSize.max : MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: _cover(context, width: w),
                ),
                if (hasBoundedHeight) Expanded(child: body) else body,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _footer(
    BuildContext context,
    ThemeData theme, {
    required bool narrow,
    required bool veryNarrow,
  }) {
    final radius = veryNarrow ? 8.0 : (narrow ? 10.0 : 12.0);
    return Row(
      children: [
        _avatar(context, radius: radius),
        SizedBox(width: narrow ? 5 : 8),
        Expanded(
          child: Text(
            veryNarrow
                ? post.authorName
                : '${post.authorName} · ${_dateLabel(post.createdAt)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: veryNarrow ? 10 : 11,
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.1,
            ),
          ),
        ),
        _metric(context, Icons.visibility_outlined, post.viewCount, compact: narrow),
        SizedBox(width: narrow ? 5 : 8),
        _metric(
          context,
          Icons.chat_bubble_outline_rounded,
          post.commentCount,
          compact: narrow,
        ),
      ],
    );
  }

  Widget _cover(BuildContext context, {required double width}) {
    final imageUrl = post.coverImage;
    if (imageUrl == null || imageUrl.isEmpty) return _coverPlaceholder(context);

    // 按展示宽度限制解码尺寸，避免瀑布流里按原图解码导致卡顿
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final memW = (width * dpr).round().clamp(64, 720);
    final memH = (memW * 9 / 16).round().clamp(36, 405);

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      // 列表滚动时淡入也会抢帧，封面直接显示
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      memCacheWidth: memW,
      memCacheHeight: memH,
      maxWidthDiskCache: memW,
      maxHeightDiskCache: memH,
      filterQuality: FilterQuality.low,
      // 静态占位，避免每张图一个转圈动画
      placeholder: (_, __) => _coverPlaceholder(context),
      errorWidget: (_, __, ___) => _coverPlaceholder(context),
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
          horizontal: compact ? 6 : 8,
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
            fontSize: compact ? 9.5 : 10,
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
      );

  Widget _avatar(BuildContext context, {double radius = 12}) {
    final avatar = post.authorAvatar;
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final px = (radius * 2 * dpr).round().clamp(24, 96);

    if (avatar == null || avatar.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        child: Icon(
          Icons.person_rounded,
          size: radius + 2,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatar,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          memCacheWidth: px,
          memCacheHeight: px,
          maxWidthDiskCache: px,
          maxHeightDiskCache: px,
          filterQuality: FilterQuality.low,
          placeholder: (_, __) => Icon(
            Icons.person_rounded,
            size: radius + 2,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
          errorWidget: (_, __, ___) => Icon(
            Icons.person_rounded,
            size: radius + 2,
            color: Theme.of(context).colorScheme.onTertiaryContainer,
          ),
        ),
      ),
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
            size: compact ? 12 : 13,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 2),
          Text(
            '$value',
            style: TextStyle(
              fontSize: compact ? 9.5 : 10,
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
