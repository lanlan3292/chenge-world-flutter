import 'dart:convert';

import 'package:chenge_world_app/screens/feed_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:chenge_world_app/theme/app_theme.dart';
import 'package:chenge_world_app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('pulling down refreshes the feed', (tester) async {
    final requestedPages = <String>[];
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        final page = request.url.queryParameters['pageNum']!;
        requestedPages.add(page);
        final records = requestedPages.length == 1
            ? <Map<String, Object>>[]
            : [
                {
                  'id': requestedPages.length,
                  'title': '帖子 ${requestedPages.length}',
                  'summary': '下拉刷新测试',
                  'authorName': '用户',
                  'viewCount': 1,
                  'likeCount': 0,
                  'commentCount': 0,
                },
              ];
        return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'records': records,
              'total': records.length,
              'pages': records.isEmpty ? 0 : 1,
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: FeedPage(api: api, token: null)),
    );
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, 400));
    await tester.pumpAndSettle();

    expect(requestedPages, ['1', '1']);
    expect(find.text('帖子 2'), findsOneWidget);
  });

  testWidgets('next page button requests the next feed page', (tester) async {
    final requestedPages = <String>[];
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        final page = request.url.queryParameters['pageNum']!;
        requestedPages.add(page);
        return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'records': [
                {
                  'id': int.parse(page),
                  'title': '帖子 $page',
                  'summary': '分页测试',
                  'authorName': '用户',
                  'viewCount': 1,
                  'likeCount': 0,
                  'commentCount': 0,
                },
              ],
              'total': 25,
              'pages': 3,
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );

    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light, home: FeedPage(api: api, token: null)),
    );
    await tester.pumpAndSettle();

    final cardSize = tester.getSize(find.byType(PostCard).first);
    expect(cardSize.width / cardSize.height, closeTo(4 / 3, 0.01));

    await tester.scrollUntilVisible(
      find.byTooltip('下一页'),
      300,
      scrollable:
          find
              .descendant(
                of: find.byType(CustomScrollView),
                matching: find.byType(Scrollable),
              )
              .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('下一页'));
    await tester.pumpAndSettle();

    expect(requestedPages, ['1', '2']);
    expect(find.text('帖子 2'), findsOneWidget);
    expect(find.text('第 2 / 3 页'), findsOneWidget);
  });
}
