import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations_text.dart';
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

class _ChengeWorldAppState extends State<ChengeWorldApp>
    with WidgetsBindingObserver {
  final _settings = SettingsStore();
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void didChangePlatformBrightness() {
    if (_settings.themeMode == ThemeMode.system) _applySystemUi();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _bootstrap() async {
    await _settings.load();
    _applySystemUi();
    if (mounted) setState(() => _ready = true);
  }

  void _applySystemUi() {
    final brightness =
        _settings.themeMode == ThemeMode.system
            ? WidgetsBinding.instance.platformDispatcher.platformBrightness
            : _settings.themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
    final background =
        brightness == Brightness.dark ? const Color(0xFF141D1B) : AppTheme.mist;
    final immersive =
        _settings.statusBarImmersive || _settings.navigationBarImmersive;
    if (immersive) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
    // 顶栏可自动隐藏时，可选半透明主题色状态栏遮罩，避免内容顶穿状态栏。
    final useTopHideMask =
        _settings.statusBarImmersive &&
        _settings.statusBarTopHideMask &&
        _settings.autoHideTopBar;
    final statusBarColor =
        !_settings.statusBarImmersive
            ? background
            : useTopHideMask
            ? background.withValues(alpha: 0.72)
            : Colors.transparent;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            brightness == Brightness.dark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            _settings.navigationBarImmersive
                ? Colors.transparent
                : brightness == Brightness.dark
                ? const Color(0xFF1D2725)
                : Colors.white,
        systemNavigationBarIconBrightness:
            brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        systemNavigationBarContrastEnforced: !_settings.navigationBarImmersive,
      ),
    );
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
        final useStatusMask =
            _settings.statusBarImmersive &&
            _settings.statusBarTopHideMask &&
            _settings.autoHideTopBar;
        // 半透明主题背景，覆盖在状态栏区域（AppBar 也会带上同一 systemOverlayStyle）。
        final lightMask =
            useStatusMask
                ? (useDynamic
                        ? lightDynamic.surface
                        : AppTheme.mist)
                    .withValues(alpha: 0.78)
                : null;
        final darkMask =
            useStatusMask
                ? (useDynamic && darkDynamic != null
                        ? darkDynamic.surface
                        : const Color(0xFF141D1B))
                    .withValues(alpha: 0.78)
                : null;

        var theme = AppTheme.build(
          dynamicScheme: useDynamic ? lightDynamic : null,
          seedColor: _settings.seedColor,
          brightness: Brightness.light,
          statusBarImmersive: _settings.statusBarImmersive,
          navigationBarImmersive: _settings.navigationBarImmersive,
          statusBarMaskColor: lightMask,
        );
        var darkTheme = AppTheme.build(
          dynamicScheme: useDynamic ? darkDynamic : null,
          seedColor: _settings.seedColor,
          brightness: Brightness.dark,
          statusBarImmersive: _settings.statusBarImmersive,
          navigationBarImmersive: _settings.navigationBarImmersive,
          statusBarMaskColor: darkMask,
        );
        final transitions = PageTransitionsTheme(
          builders: {
            ...theme.pageTransitionsTheme.builders,
            TargetPlatform.android:
                _settings.predictiveBack
                    ? const PredictiveBackPageTransitionsBuilder()
                    : const ZoomPageTransitionsBuilder(),
          },
        );
        theme = theme.copyWith(pageTransitionsTheme: transitions);
        darkTheme = darkTheme.copyWith(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              ...darkTheme.pageTransitionsTheme.builders,
              TargetPlatform.android:
                  _settings.predictiveBack
                      ? const PredictiveBackPageTransitionsBuilder()
                      : const ZoomPageTransitionsBuilder(),
            },
          ),
        );

        return MaterialApp(
          title: 'ChengeWorld',
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          themeMode: _settings.themeMode,
          locale: switch (_settings.localeCode) {
            'zh_CN' => const Locale('zh', 'CN'),
            'zh_TW' => const Locale('zh', 'TW'),
            'en_US' => const Locale('en', 'US'),
            _ => null,
          },
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('zh', 'TW'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          // 物理层遮罩：部分机型上 statusBarColor 会被忽略，用一层半透明色盖住状态栏区域。
          builder: (context, child) {
            final showMask =
                _settings.statusBarImmersive &&
                _settings.statusBarTopHideMask &&
                _settings.autoHideTopBar;
            if (!showMask || child == null) return child ?? const SizedBox.shrink();
            final top = MediaQuery.paddingOf(context).top;
            if (top <= 0) return child;
            final maskColor = Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.78);
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: top,
                  child: IgnorePointer(
                    child: ColoredBox(color: maskColor),
                  ),
                ),
              ],
            );
          },
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

  /// Bottom nav chrome visibility; driven by feed/shop scroll without full rebuilds.
  final ValueNotifier<bool> _chromeVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  @override
  void dispose() {
    _chromeVisible.dispose();
    super.dispose();
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
        userId =
            user is Map && user['id'] is num
                ? (user['id'] as num).toInt()
                : null;
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
      _userId =
          user is Map && user['id'] is num ? (user['id'] as num).toInt() : null;
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
    final destination =
        value.contains('shop')
            ? 2
            : value.contains('friend') || value.contains('chat')
            ? 1
            : 0;
    setState(() => _selectedIndex = destination);
  }

  void _openTasks() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => TasksPage(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_restoring) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final wide = MediaQuery.sizeOf(context).width >= 760;
    final hideBottomBar = !wide && widget.settings.autoHideBottomBar;

    void onChromeVisibilityChanged(bool visible) {
      if (wide) return;
      if (_selectedIndex != 0 && _selectedIndex != 2) return;
      if (!hideBottomBar) {
        if (!_chromeVisible.value) _chromeVisible.value = true;
        return;
      }
      if (_chromeVisible.value == visible) return;
      // ValueNotifier: only the bottom bar ListenableBuilder rebuilds.
      _chromeVisible.value = visible;
    }

    final pages = <Widget>[
      FeedPage(
        api: _api,
        token: _token,
        autoHideTopBar: widget.settings.autoHideTopBar,
        autoHideBottomBar: hideBottomBar,
        minColumns: widget.settings.feedMinColumns,
        maxColumns: widget.settings.feedMaxColumns,
        onChromeVisibilityChanged: onChromeVisibilityChanged,
      ),
      SocialPage(
        api: _api,
        token: _token,
        userId: _userId,
        settings: widget.settings,
        isActive: _selectedIndex == 1,
        onLoginRequested:
            () => setState(() {
              _selectedIndex = 3;
              _chromeVisible.value = true;
            }),
      ),
      ShopPage(
        api: _api,
        token: _token,
        userId: _userId,
        onLoginRequested:
            () => setState(() {
              _selectedIndex = 3;
              _chromeVisible.value = true;
            }),
        autoHideTopBar: widget.settings.autoHideTopBar,
        autoHideBottomBar: hideBottomBar,
        minColumns: widget.settings.shopMinColumns,
        maxColumns: widget.settings.shopMaxColumns,
        onChromeVisibilityChanged: onChromeVisibilityChanged,
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
      extendBody: !wide,
      body: Row(
        children: [
          if (wide)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
              child: NavigationRail(
                selectedIndex: _selectedIndex,
                onDestinationSelected:
                    (index) => setState(() {
                      _selectedIndex = index;
                      _chromeVisible.value = true;
                    }),
                labelType: NavigationRailLabelType.all,
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DecoratedBox(
                    decoration: BoxDecoration(),
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.dynamic_feed_outlined),
                    selectedIcon: Icon(Icons.dynamic_feed_rounded),
                    label: Text(AppLocalizations.of(context).text('发现')),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.people_outline_rounded),
                    selectedIcon: Icon(Icons.people_rounded),
                    label: Text(AppLocalizations.of(context).text('社交')),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.storefront_outlined),
                    selectedIcon: Icon(Icons.storefront_rounded),
                    label: Text(AppLocalizations.of(context).text('商城')),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.person_outline_rounded),
                    selectedIcon: Icon(Icons.person_rounded),
                    label: Text(AppLocalizations.of(context).text('我的')),
                  ),
                ],
              ),
            ),
          Expanded(child: IndexedStack(index: _selectedIndex, children: pages)),
        ],
      ),
      bottomNavigationBar:
          wide
              ? null
              : ListenableBuilder(
                listenable: _chromeVisible,
                builder: (context, _) {
                  final shown = !hideBottomBar || _chromeVisible.value;
                  return AnimatedSlide(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    offset: shown ? Offset.zero : const Offset(0, 1),
                    child: Material(
                      elevation: shown ? 3 : 0,
                      color:
                          Theme.of(context).navigationBarTheme.backgroundColor ??
                          Colors.white,
                      child: NavigationBar(
                        selectedIndex: _selectedIndex,
                        onDestinationSelected:
                            (index) => setState(() {
                              _selectedIndex = index;
                              _chromeVisible.value = true;
                            }),
                        destinations: [
                          NavigationDestination(
                            icon: Icon(Icons.dynamic_feed_outlined),
                            selectedIcon: Icon(Icons.dynamic_feed_rounded),
                            label: AppLocalizations.of(context).text('发现'),
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.people_outline_rounded),
                            selectedIcon: Icon(Icons.people_rounded),
                            label: AppLocalizations.of(context).text('社交'),
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.storefront_outlined),
                            selectedIcon: Icon(Icons.storefront_rounded),
                            label: AppLocalizations.of(context).text('商城'),
                          ),
                          NavigationDestination(
                            icon: Icon(Icons.person_outline_rounded),
                            selectedIcon: Icon(Icons.person_rounded),
                            label: AppLocalizations.of(context).text('我的'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
