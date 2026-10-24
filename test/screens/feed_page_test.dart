import 'dart:convert';

import 'package:chenge_world_app/screens/feed_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:chenge_world_app/theme/app_theme.dart';
import 'package:chenge_world_app/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:chenge_world_app/l10n/generated/app_localizations.dart';
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
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        theme: AppTheme.light, home: FeedPage(api: api, token: null)),
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
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        theme: AppTheme.light, home: FeedPage(api: api, token: null)),
    );
    await tester.pumpAndSettle();

    // Row-aligned grid: heights follow content; only assert cards render.
    expect(find.byType(PostCard), findsWidgets);

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

  testWidgets('compose fab clears the shell bottom bar on tall safe areas', (
    tester,
  ) async {
    // A large gesture inset used to push the FAB into the shell bar, because
    // the shell paints its bar over the page and hides the inset from
    // descendant MediaQuery data.
    const inset = 96.0;
    const shellBarHeight = 80.0 + inset;
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((_) async => http.Response(
        jsonEncode({
          'code': 200,
          'data': {'records': <Map<String, Object>>[], 'total': 0, 'pages': 0},
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      )),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        theme: AppTheme.light,
        home: Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: const Size(400, 800),
              padding: const EdgeInsets.only(bottom: inset),
              viewPadding: const EdgeInsets.only(bottom: inset),
            ),
            child: Scaffold(
              extendBody: true,
              body: FeedPage(
                api: api,
                token: 'token',
                bottomBarHeight: shellBarHeight,
                systemBottomInset: inset,
              ),
              bottomNavigationBar: Material(
                child: NavigationBar(
                  selectedIndex: 0,
                  destinations: const [
                    NavigationDestination(icon: Icon(Icons.home), label: 'A'),
                    NavigationDestination(icon: Icon(Icons.person), label: 'B'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final barRect = tester.getRect(find.byType(NavigationBar));
    final fabRect = tester.getRect(find.byType(RawMaterialButton));
    expect(barRect.top - fabRect.bottom, moreOrLessEquals(16, epsilon: 0.01));
  });
}
