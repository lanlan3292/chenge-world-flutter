import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../models/blog_post.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.api, required this.post, this.token});

  final ChengeApi api;
  final BlogPost post;
  final String? token;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Future<BlogPost> _detail;

  @override
  void initState() {
    super.initState();
    _detail = widget.api.postDetail(widget.post.id, token: widget.token).catchError((_) => widget.post);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: '返回',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('帖子', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: FutureBuilder<BlogPost>(
        future: _detail,
        builder: (context, snapshot) => _body(snapshot.data ?? widget.post, bottomInset),
      ),
    );
  }

  Widget _body(BlogPost post, double bottomInset) {
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width > 780 ? 760 : double.infinity),
        child: ListView(
          // Use system bottom inset so content clears the nav/gesture bar under edge-to-edge.
          padding: EdgeInsets.fromLTRB(22, 12, 22, 28 + bottomInset),
          children: [
            if (post.categoryName != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: const Color(0xFFE0F0E8), borderRadius: BorderRadius.circular(20)),
                  child: Text(post.categoryName!, style: const TextStyle(color: AppTheme.leaf, fontWeight: FontWeight.w700)),
                ),
              ),
            const SizedBox(height: 12),
            Text(post.title, style: const TextStyle(fontSize: 30, height: 1.15, fontWeight: FontWeight.w900)),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFFFE8C5),
                  foregroundImage: post.authorAvatar == null ? null : NetworkImage(post.authorAvatar!),
                  child: post.authorAvatar == null ? const Icon(Icons.person_rounded, color: AppTheme.ink) : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post.authorName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text(_date(post.createdAt), style: const TextStyle(fontSize: 12, color: Color(0xFF70817D))),
                    ],
                  ),
                ),
                _stat(Icons.visibility_outlined, post.viewCount),
                const SizedBox(width: 12),
                _stat(Icons.thumb_up_alt_outlined, post.likeCount),
                const SizedBox(width: 12),
                _stat(Icons.chat_bubble_outline_rounded, post.commentCount),
              ],
            ),
            if (post.coverImage != null) ...[
              const SizedBox(height: 22),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  post.coverImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (post.tags.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: post.tags
                    .map(
                      (tag) => Chip(
                        label: Text('#$tag'),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: const Color(0xFFFFE8E1),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            MarkdownBody(
              data: post.content.isNotEmpty ? post.content : post.summary,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, height: 1.75, color: AppTheme.ink),
                h1: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: AppTheme.ink),
                h2: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: AppTheme.ink),
                blockquoteDecoration: const BoxDecoration(
                  color: Color(0xFFEAF2ED),
                  border: Border(left: BorderSide(color: AppTheme.leaf, width: 3)),
                ),
                codeblockDecoration: BoxDecoration(color: const Color(0xFFEAF2ED), borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(IconData icon, int value) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF70817D)),
          const SizedBox(width: 4),
          Text('$value', style: const TextStyle(fontSize: 12, color: Color(0xFF70817D))),
        ],
      );

  static String _date(DateTime? date) {
    if (date == null) return '时间未知';
    return '${date.year}年${date.month}月${date.day}日';
  }
}
