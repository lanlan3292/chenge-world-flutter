import 'package:chenge_world_app/screens/account_page.dart';
import 'package:chenge_world_app/services/chenge_api.dart';
import 'package:chenge_world_app/services/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows task center and keeps logout inside settings', (tester) async {
    var taskOpens = 0;
    var logoutCalls = 0;
    final api = ChengeApi(baseUrl: 'http://example.test');
    final settings = SettingsStore();

    await tester.pumpWidget(MaterialApp(
      home: AccountPage(
        api: api,
        token: 'session-token',
        username: 'test-user',
        onLogin: (_) async {},
        onLogout: () async => logoutCalls++,
        onOpenTasks: () => taskOpens++,
        settings: settings,
        onSettingsChanged: () async {},
      ),
    ));

    expect(find.text('我的'), findsOneWidget);
    await tester.tap(find.text('任务中心'));
    expect(taskOpens, 1);
    expect(find.text('退出登录'), findsNothing);

    await tester.tap(find.byTooltip('设置'));
    await tester.pumpAndSettle();
    expect(find.text('退出登录'), findsOneWidget);
    expect(find.text('动态取色'), findsOneWidget);
    expect(find.text('状态栏沉浸'), findsOneWidget);
    expect(find.text('导航栏沉浸'), findsOneWidget);
    expect(logoutCalls, 0);
  });
}
