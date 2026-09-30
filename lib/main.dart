import 'package:flutter/material.dart';

import 'screens/account_page.dart';
import 'screens/feed_page.dart';
import 'screens/shop_page.dart';
import 'screens/social_page.dart';
import 'screens/tasks_page.dart';
import 'services/chenge_api.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChengeWorldApp());
}

class ChengeWorldApp extends StatelessWidget {
  const ChengeWorldApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'ChengeWorld',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const AppShell(),
      );
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _api = ChengeApi();
  final _sessionStore = const SessionStore();
  int _selectedIndex = 0;
  String? _token;
  String? _username;
  int? _userId;
  bool _restoring = true;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final token = await _sessionStore.readToken();
    String? username;
    int? userId;
    var sessionValid = token != null;
    if (token != null) {
      try {
        final current = await _api.currentUser(token);
        final user = current['user'];
        username = user is Map ? user['username']?.toString() : null;
        userId = user is Map && user['id'] is num ? (user['id'] as num).toInt() : null;
      } on ApiException catch (error) {
        if (error.statusCode == 401 || error.businessCode == 401) {
          await _sessionStore.clearToken();
          sessionValid = false;
        }
      }
    }
    if (!mounted) return;
    setState(() {
      _token = sessionValid ? token : null;
      _username = username;
      _userId = userId;
      _restoring = false;
    });
  }

  Future<void> _onLogin(Map<String, dynamic> result) async {
    final token = result['token'] as String;
    final user = result['user'];
    await _sessionStore.saveToken(token);
    if (!mounted) return;
    setState(() {
      _token = token;
      _username = user is Map ? user['username']?.toString() : null;
      _userId = user is Map && user['id'] is num ? (user['id'] as num).toInt() : null;
    });
  }

  Future<void> _onLogout() async {
    final token = _token;
    if (token != null) {
      try {
        await _api.logout(token);
      } on ApiException {
        // Local credentials are still cleared if the server is unavailable.
      }
    }
    await _sessionStore.clearToken();
    if (!mounted) return;
    setState(() {
      _token = null;
      _username = null;
      _userId = null;
    });
  }

  void _openTaskLink(String link) {
    final value = link.toLowerCase();
    final destination = value.contains('shop')
        ? 2
        : value.contains('task')
            ? 3
            : value.contains('friend') || value.contains('chat')
                ? 1
                : 0;
    setState(() => _selectedIndex = destination);
  }

  @override
  Widget build(BuildContext context) {
    if (_restoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final wide = MediaQuery.sizeOf(context).width >= 760;
    final pages = <Widget>[
      FeedPage(api: _api, token: _token),
      SocialPage(
        api: _api,
        token: _token,
        userId: _userId,
        onLoginRequested: () => setState(() => _selectedIndex = 4),
      ),
      ShopPage(
        api: _api,
        token: _token,
        userId: _userId,
        onLoginRequested: () => setState(() => _selectedIndex = 4),
      ),
      TasksPage(
        api: _api,
        token: _token,
        onLoginRequested: () => setState(() => _selectedIndex = 4),
        onOpenLink: _openTaskLink,
      ),
      AccountPage(
        api: _api,
        token: _token,
        username: _username,
        onLogin: _onLogin,
        onLogout: _onLogout,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            if (wide)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
                child: NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) => setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  leading: Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.forum_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.dynamic_feed_outlined),
                      selectedIcon: Icon(Icons.dynamic_feed_rounded),
                      label: Text('发现'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline_rounded),
                      selectedIcon: Icon(Icons.people_rounded),
                      label: Text('社交'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.storefront_outlined),
                      selectedIcon: Icon(Icons.storefront_rounded),
                      label: Text('商城'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.task_alt_outlined),
                      selectedIcon: Icon(Icons.task_alt_rounded),
                      label: Text('任务'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('账户'),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: IndexedStack(index: _selectedIndex, children: pages),
            ),
          ],
        ),
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) => setState(() => _selectedIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.dynamic_feed_outlined),
                  selectedIcon: Icon(Icons.dynamic_feed_rounded),
                  label: '发现',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline_rounded),
                  selectedIcon: Icon(Icons.people_rounded),
                  label: '社交',
                ),
                NavigationDestination(
                  icon: Icon(Icons.storefront_outlined),
                  selectedIcon: Icon(Icons.storefront_rounded),
                  label: '商城',
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  selectedIcon: Icon(Icons.task_alt_rounded),
                  label: '任务',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: '账户',
                ),
              ],
            ),
    );
  }
}