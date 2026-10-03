import 'dart:convert';

import 'package:chenge_world_app/screens/chat_page.dart';
import 'package:chenge_world_app/screens/chat_thread_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:chenge_world_app/services/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets(
    'does not open the selected conversation after leaving social page',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      var isActive = true;
      late StateSetter updateHarness;
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              updateHarness = setState;
              return ChatPage(
                api: _api(),
                token: 'token',
                userId: 1,
                settings: SettingsStore(),
                launchPeerId: null,
                launchNonce: 0,
                onOpenFriends: () {},
                onLoginRequested: () {},
                isActive: isActive,
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('好友'));
      await tester.pumpAndSettle();
      expect(find.byType(ChatThreadPage), findsOneWidget);

      updateHarness(() => isActive = false);
      tester.view.physicalSize = const Size(400, 800);
      await tester.pumpAndSettle();

      expect(find.byType(ChatThreadPage), findsNothing);
      expect(find.text('好友'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}

ChengeApi _api() => ChengeApi(
  baseUrl: 'http://example.test',
  client: MockClient((request) async {
    if (request.url.path == '/chat/conversations') {
      return http.Response(
        jsonEncode({
          'code': 200,
          'data': [
            {
              'id': 12,
              'type': 'single',
              'name': '好友',
              'peerId': 2,
              'unread': 0,
            },
          ],
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }
    if (request.url.path == '/chat/12/messages') {
      return http.Response(
        jsonEncode({'code': 200, 'data': []}),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );
    }
    return http.Response(
      jsonEncode({'code': 200, 'data': 'ok'}),
      200,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );
  }),
);
