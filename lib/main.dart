import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/account_page.dart';
import 'screens/feed_page.dart';
import 'screens/shop_page.dart';
import 'screens/social_page.dart';
import 'screens/tasks_page.dart';
import 'services/chenge_api.dart';
import 'services/settings_store.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChengeWorldApp());
}

class ChengeWorldApp extends StatefulWidget {
  const ChengeWorldApp({super.key});

  @override
  State<ChengeWorldApp> createState() => _ChengeWorldAppState();
}

class _ChengeWorldAppState extends State<ChengeWorldApp> {
  final _settings = SettingsStore();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await _settings.load();
    _applySystemUi();
    if (mounted) setState(() => _ready = true);
  }

  void _applySystemUi() {
    final immersive = _settings.statusBarImmersive || _settings.navigationBarImmersive;
    if (immersive) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: _settings.statusBarImmersive ? Colors.transparent : AppTheme.mist,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor:
          _settings.navigationBarImmersive ? Colors.transparent : Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarContrastEnforced: !_settings.navigationBarImmersive,
    ));
  }

  Future<void> _onSettingsChanged() async {
    _applySystemUi();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final useDynamic = _settings.useDynamicColor && lightDynamic != null;
        final theme = AppTheme.build(
          dynamicScheme: useDynamic ? lightDynamic : null,
          seedColor: _settings.seedColor,
          statusBarImmersive: _settings.statusBarImmersive,
          navigationBarImmersive: _settings.navigationBarImmersive,
        );

        return MaterialApp(
          title: 'ChengeWorld',
          debugShowCheckedModeBanner: false,
          theme: theme,
          home: AppShell(
            settings: _settings,
            onSettingsChanged: _onSettingsChanged,
          ),
        );
      },
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.settings,
    required this.onSettingsChanged,
  });

  final SettingsStore settings;
  final Future<void> Function() onSettingsChanged;

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
        : value.contains('friend') || value.contains('chat')
            ? 1
            : 0;
    setState(() => _selectedIndex = destination);
  }

  void _openTasks() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => TasksPage(
        api: _api,
        token: _token,
        onLoginRequested: () {
          Navigator.of(context).pop();
          setState(() => _selectedIndex = 3);
        },
        onOpenLink: (link) {
          Navigator.of(context).pop();
          _openTaskLink(link);
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (_restoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final wide = MediaQuery.sizeOf(context).width >= 760;
    final statusImmersive = widget.settings.statusBarImmersive;
    final navImmersive = widget.settings.navigationBarImmersive;

    final pages = <Widget>[
      FeedPage(api: _api, token: _token),
      SocialPage(
        api: _api,
        token: _token,
        userId: _userId,
        onLoginRequested: () => setState(() => _selectedIndex = 3),
      ),
      ShopPage(
        api: _api,
        token: _token,
        userId: _userId,
        onLoginRequested: () => setState(() => _selectedIndex = 3),
      ),
      AccountPage(
        api: _api,
        token: _token,
        username: _username,
        onLogin: _onLogin,
        onLogout: _onLogout,
        onOpenTasks: _openTasks,
        settings: widget.settings,
        onSettingsChanged: widget.onSettingsChanged,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        top: !statusImmersive,
        bottom: !navImmersive || wide,
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
                      icon: Icon(Icons.person_outline_rounded),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: Text('我的'),
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
                  icon: Icon(Icons.person_outline_rounded),
                  selectedIcon: Icon(Icons.person_rounded),
                  label: '我的',
                ),
              ],
            ),
    );
  }
}
