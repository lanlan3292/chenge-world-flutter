import 'package:flutter/material.dart';

import '../models/blog_post.dart';

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
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(aspectRatio: 16 / 9, child: _cover(context)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (post.categoryName != null)
                            _label(
                              post.categoryName!,
                              theme.colorScheme.primaryContainer,
                              theme.colorScheme.onPrimaryContainer,
                            ),
                          if (post.tags.isNotEmpty) ...[
                            if (post.categoryName != null)
                              const SizedBox(width: 7),
                            Flexible(
                              child: _label(
                                '#${post.tags.first}',
                                theme.colorScheme.secondaryContainer,
                                theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          post.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _avatar(context),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${post.authorName} · ${_dateLabel(post.createdAt)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          _metric(
                            context,
                            Icons.visibility_outlined,
                            post.viewCount,
                          ),
                          const SizedBox(width: 9),
                          _metric(
                            context,
                            Icons.chat_bubble_outline_rounded,
                            post.commentCount,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _coverPlaceholder(context),
      loadingBuilder:
          (context, child, progress) =>
              progress == null
                  ? child
                  : Stack(
                    fit: StackFit.expand,
                    children: [
                      _coverPlaceholder(context),
                      Center(
                        child: CircularProgressIndicator(
                          value:
                              progress.expectedTotalBytes == null
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
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Stack(
      children: [
        Positioned(
          right: -18,
          top: -34,
          child: _shape(
            125,
            Theme.of(context).colorScheme.surfaceContainerHigh,
          ),
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

  Widget _label(String label, Color color, Color foreground) => Container(
    constraints: const BoxConstraints(maxWidth: 150),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

  Widget _avatar(BuildContext context) {
    final avatar = post.authorAvatar;
    return CircleAvatar(
      radius: 12,
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      foregroundImage: avatar == null ? null : NetworkImage(avatar),
      child:
          avatar == null
              ? Icon(
                Icons.person_rounded,
                size: 15,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              )
              : null,
    );
  }

  Widget _metric(BuildContext context, IconData icon, int value) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        size: 13,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      const SizedBox(width: 3),
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
    if (date == null) {
      return '刚刚';
    }
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
