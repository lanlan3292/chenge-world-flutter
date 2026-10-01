import 'dart:convert';

import 'package:chenge_world_app/screens/shop_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:flutter/material.dart';
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
}