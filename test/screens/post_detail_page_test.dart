import 'dart:convert';

import 'package:chenge_world_app/models/blog_post.dart';
import 'package:chenge_world_app/screens/post_detail_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:chenge_world_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('likes a post and submits a top-level comment', (tester) async {
    var liked = false;
    final comments = <Map<String, dynamic>>[];
    final client = MockClient((request) async {
      if (request.url.path == '/blog/post/56') {
        return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'id': 56,
              'title': '测试帖子',
              'summary': '正文',
              'content': '正文',
              'authorName': '作者',
              'viewCount': 1,
              'likeCount': liked ? 3 : 2,
              'commentCount': comments.length,
              'liked': liked,
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      if (request.url.path == '/blog/comment/list') {
        return http.Response(
          jsonEncode({'code': 200, 'data': comments}),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }
      if (request.url.path == '/blog/like/toggle') {
        liked = true;
        return http.Response(jsonEncode({'code': 200, 'data': {'liked': true}}), 200);
      }
      if (request.url.path == '/blog/comment' && request.method == 'POST') {
        final body = jsonDecode(request.body) as Map<String, dynamic>;
        comments.add({
          'id': 90,
          'blogId': body['blogId'],
          'userId': 7,
          'authorName': '当前用户',
          'content': body['content'],
          'parentId': body['parentId'],
          'likeCount': 0,
          'children': [],
        });
        return http.Response(jsonEncode({'code': 200, 'data': 90}), 200);
      }
      return http.Response(jsonEncode({'code': 404, 'msg': 'not found'}), 404);
    });
    final post = BlogPost.fromJson({
      'id': 56,
      'title': '测试帖子',
      'summary': '正文',
      'content': '正文',
      'authorName': '作者',
      'viewCount': 1,
      'likeCount': 2,
      'commentCount': 0,
    });

    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.light,
      home: PostDetailPage(api: ChengeApi(client: client, baseUrl: 'http://example.test'), post: post, token: 'session-token'),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('点赞 · 2'));
    await tester.pumpAndSettle();
    expect(find.text('已点赞 · 3'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '写一条评论');
    await tester.pump();
    await tester.tap(find.text('发表评论'));
    await tester.pumpAndSettle();

    expect(find.text('当前用户'), findsOneWidget);
    expect(find.text('写一条评论'), findsOneWidget);
    expect(find.text('评论 (1)'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
