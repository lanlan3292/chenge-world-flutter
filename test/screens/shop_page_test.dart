import 'dart:convert';

import 'package:chenge_world_app/screens/shop_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:flutter/material.dart';
import 'package:chenge_world_app/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('renders the shop feed and pagination slivers', (tester) async {
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((_) async => http.Response(
        jsonEncode({
          'code': 200,
          'data': {
            'records': [
              {'id': 5, 'title': '社区图标', 'type': 'file', 'price': 300, 'stock': 4},
            ],
            'total': 1,
          },
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      )),
    );

    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: ShopPage(api: api, token: null, userId: null, onLoginRequested: () {}),
    ));
    await tester.pumpAndSettle();

    expect(find.text('发现好物'), findsOneWidget);
    expect(find.text('社区图标'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('next page button requests the next shop page', (tester) async {
    final requestedPages = <String>[];
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((request) async {
        requestedPages.add(request.url.queryParameters['pageNum']!);
        final page = int.parse(request.url.queryParameters['pageNum']!);
        return http.Response(
          jsonEncode({
            'code': 200,
            'data': {
              'records': [
                {'id': page, 'title': '商品 $page', 'type': 'file', 'price': 300, 'stock': 4},
              ],
              'total': 25,
            },
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: ShopPage(api: api, token: null, userId: null, onLoginRequested: () {}),
    ));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byTooltip('下一页'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('下一页'));
    await tester.pumpAndSettle();

    expect(requestedPages, ['1', '2']);
    expect(find.text('商品 2'), findsOneWidget);
    expect(find.text('第 2 / 3 页'), findsOneWidget);
  });

  testWidgets('shop view selector stays below the pinned shop app bar', (tester) async {
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((_) async => http.Response(
        jsonEncode({
          'code': 200,
          'data': {
            'records': List.generate(
              24,
              (index) => {'id': index + 1, 'title': '商品 $index', 'type': 'file', 'price': 300, 'stock': 4},
            ),
            'total': 24,
          },
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      )),
    );

    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: ShopPage(
        api: api,
        token: null,
        userId: null,
        onLoginRequested: () {},
        autoHideTopBar: false,
      ),
    ));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();

    final titleTop = tester.getTopLeft(find.text('商城')).dy;
    final selectorTop = tester.getTopLeft(find.text('逛商城')).dy;
    expect(selectorTop, greaterThan(titleTop));
    expect(selectorTop, lessThan(160));
  });

  testWidgets('shop view selector hides with the floating shop app bar', (tester) async {
    final api = ChengeApi(
      baseUrl: 'http://example.test',
      client: MockClient((_) async => http.Response(
        jsonEncode({
          'code': 200,
          'data': {
            'records': List.generate(
              24,
              (index) => {'id': index + 1, 'title': '商品 $index', 'type': 'file', 'price': 300, 'stock': 4},
            ),
            'total': 24,
          },
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      )),
    );

    await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: ShopPage(api: api, token: null, userId: null, onLoginRequested: () {}),
    ));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pumpAndSettle();

    expect(find.text('商城'), findsNothing);
    expect(find.text('逛商城'), findsNothing);
  });
}