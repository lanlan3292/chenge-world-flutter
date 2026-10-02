import 'package:flutter_test/flutter_test.dart';
import 'package:chenge_world_app/models/blog_post.dart';

void main() {
  test('parses a post and derives a readable summary from markdown', () {
    final post = BlogPost.fromJson({
      'id': 56,
      'title': '社区讨论',
      'content': '# 欢迎\n\n这是 **一篇帖子**，欢迎 [阅读](https://example.com)。',
      'authorName': 'Chenge 用户',
      'createdAt': '2026-09-27T15:01:32',
      'viewCount': 12,
      'likeCount': 3,
      'commentCount': 2,
      'liked': true,
      'tags': ['交流'],
    });

    expect(post.id, 56);
    expect(post.summary, '欢迎 这是 一篇帖子，欢迎 阅读。');
    expect(post.tags, ['交流']);
    expect(post.viewCount, 12);
    expect(post.liked, isTrue);
  });

  test('uses safe defaults for optional fields', () {
    final post = BlogPost.fromJson({'id': '7'});

    expect(post.title, '未命名帖子');
    expect(post.authorName, 'Chenge 用户');
    expect(post.createdAt, isNull);
    expect(post.tags, isEmpty);
    expect(post.liked, isFalse);
  });
}