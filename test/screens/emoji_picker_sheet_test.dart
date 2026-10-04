import 'dart:convert';

import 'package:chenge_world_app/models/chat_conversation.dart';
import 'package:chenge_world_app/screens/chat_thread_page.dart';
import 'package:chenge_world_app/screens/emoji_picker_sheet.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:flutter/material.dart';
import 'package:chenge_world_app/l10n/generated/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('uses three quarters of the screen height', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = _api();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: Builder(
          builder:
              (context) => Scaffold(
                body: TextButton(
                  onPressed:
                      () => showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        builder:
                            (_) => EmojiPickerSheet(api: api, token: 'token'),
                      ),
                  child: const Text('打开'),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(EmojiPickerSheet),
        matching: find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.height == 600,
        ),
      ),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('filters emoji by pack category', (tester) async {
    final api = _api();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: Builder(
          builder:
              (context) => Scaffold(
                body: TextButton(
                  onPressed:
                      () => showModalBottomSheet<void>(
                        context: context,
                        builder:
                            (_) => EmojiPickerSheet(api: api, token: 'token'),
                      ),
                  child: const Text('打开'),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();

    expect(find.text('全部'), findsOneWidget);
    expect(find.text('动物表情'), findsOneWidget);
    expect(find.text('日常表情'), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(3));

    await tester.tap(find.widgetWithText(ChoiceChip, '动物表情'));
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('closes picker when resizing from wide to narrow', (tester) async {
    tester.view.physicalSize = const Size(1000, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = _api();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                const Text('主页'),
                TextButton(
                  onPressed: () => showModalBottomSheet<void>(
                    context: context,
                    builder: (_) => EmojiPickerSheet(api: api, token: 'token'),
                  ),
                  child: const Text('打开'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    final closeButton = find.ancestor(
      of: find.byIcon(Icons.close_rounded),
      matching: find.byType(IconButton),
    );
    expect(tester.widget<IconButton>(closeButton).onPressed, isNotNull);

    tester.view.physicalSize = const Size(400, 800);
    await tester.pumpAndSettle();

    expect(find.text('主页'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('closes picker on narrow-to-wide change without popping main', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = _api();
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('zh', 'CN'),
        home: Builder(
          builder:
              (context) => Scaffold(
                body: Column(
                  children: [
                    const Text('主页'),
                    TextButton(
                      onPressed:
                          () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder:
                                  (_) => ChatThreadPage(
                                    api: api,
                                    token: 'token',
                                    userId: 1,
                                    conversation: const ChatConversation(
                                      id: 12,
                                      type: 'single',
                                      name: '聊天',
                                      unread: 0,
                                    ),
                                  ),
                            ),
                          ),
                      child: const Text('打开聊天'),
                    ),
                  ],
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('打开聊天'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('表情包'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('关闭'), findsOneWidget);

    tester.view.physicalSize = const Size(1000, 800);
    await tester.pump();
    final closeButton = find.ancestor(
      of: find.byIcon(Icons.close_rounded),
      matching: find.byType(IconButton),
    );
    if (closeButton.evaluate().isNotEmpty) {
      final button = tester.widget<IconButton>(closeButton);
      expect(button.onPressed, isNull);
      await tester.tap(closeButton);
      await tester.tap(closeButton);
    }
    await tester.pumpAndSettle();

    expect(find.text('主页'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

ChengeApi _api() => ChengeApi(
  baseUrl: 'http://example.test',
  client: MockClient((request) async {
    if (request.url.path == '/shop/assets') {
      return http.Response(
        jsonEncode({
          'code': 200,
          'data': [
            _pack(101, '动物表情', [
              {'key': '狗狗', 'fileId': 1, 'url': 'https://example.test/dog.png'},
              {'key': '猫猫', 'fileId': 2, 'url': 'https://example.test/cat.png'},
            ]),
            _pack(102, '日常表情', [
              {
                'key': '你好',
                'fileId': 3,
                'url': 'https://example.test/hello.png',
              },
            ]),
          ],
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }
    if (request.url.path == '/shop/my/items') {
      return http.Response(
        jsonEncode({
          'code': 200,
          'data': {'records': [], 'total': 0},
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }
    if (request.url.path == '/chat/12/messages') {
      return http.Response(jsonEncode({'code': 200, 'data': []}), 200);
    }
    if (request.url.path == '/chat/12/read') {
      return http.Response(jsonEncode({'code': 200, 'data': 'ok'}), 200);
    }
    return http.Response('not found', 404);
  }),
);

Map<String, dynamic> _pack(
  int id,
  String title,
  List<Map<String, Object>> entries,
) => {
  'itemId': id,
  'type': 'emoji',
  'title': title,
  'content': jsonEncode(entries),
};
