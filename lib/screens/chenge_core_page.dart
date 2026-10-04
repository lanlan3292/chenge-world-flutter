import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/generated/app_localizations.dart';

/// ChengeCore：aqua 主题，路由 `#/chengecore`
class ChengeCorePage extends StatelessWidget {
  const ChengeCorePage({
    super.key,
    required this.baseUrl,
    required this.token,
  });

  final String baseUrl;
  final String token;

  @override
  Widget build(BuildContext context) {
    return _SiteWebViewPage(
      baseUrl: baseUrl,
      token: token,
      title: AppLocalizations.of(context).chengeCore,
      hashRoute: '#/chengecore',
      themeSkin: 'aqua',
    );
  }
}

/// 养成：cute 主题，路由 `#/intelligence?mode=nurture`
/// 独立页面，避免与 ChengeCore 共用同一 State 导致皮肤串用。
class NurturePage extends StatelessWidget {
  const NurturePage({
    super.key,
    required this.baseUrl,
    required this.token,
  });

  final String baseUrl;
  final String token;

  @override
  Widget build(BuildContext context) {
    return _SiteWebViewPage(
      baseUrl: baseUrl,
      token: token,
      title: AppLocalizations.of(context).raising,
      hashRoute: '#/intelligence?mode=nurture',
      themeSkin: 'cute',
    );
  }
}

/// 官网首页：aqua 主题，无 hash
class OfficialSitePage extends StatelessWidget {
  const OfficialSitePage({
    super.key,
    required this.baseUrl,
    required this.token,
  });

  final String baseUrl;
  final String token;

  @override
  Widget build(BuildContext context) {
    return _SiteWebViewPage(
      baseUrl: baseUrl,
      token: token,
      title: AppLocalizations.of(context).officialSite,
      hashRoute: '',
      themeSkin: 'aqua',
    );
  }
}

/// 内嵌站点 WebView（不使用 loadHtmlString，直接 loadRequest）。
///
/// - **关闭（左侧 ✕）**：退出本页
/// - **返回（右侧箭头）**：仅 WebView 历史后退；无历史时禁用
/// - **系统返回**：有历史先后退，否则退出
class _SiteWebViewPage extends StatefulWidget {
  const _SiteWebViewPage({
    required this.baseUrl,
    required this.token,
    required this.title,
    required this.hashRoute,
    required this.themeSkin,
  });

  final String baseUrl;
  final String token;
  final String title;
  final String hashRoute;
  final String themeSkin;

  @override
  State<_SiteWebViewPage> createState() => _SiteWebViewPageState();
}

class _SiteWebViewPageState extends State<_SiteWebViewPage> {
  WebViewController? _controller;
  var _loading = true;
  var _canGoBack = false;
  /// 首次注入 localStorage 后做一次 reload，让 SPA 冷启动读到正确主题。
  var _needsThemeReload = true;
  String? _error;
  var _unsupported = false;

  String get _root => widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');

  Uri get _targetUri {
    final hash = widget.hashRoute.trim();
    if (hash.isEmpty) return Uri.parse('$_root/');
    final fragment = hash.startsWith('#') ? hash.substring(1) : hash;
    return Uri.parse('$_root/#$fragment');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initWebView();
    });
  }

  Future<void> _initWebView() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
      _unsupported = false;
      _canGoBack = false;
      _needsThemeReload = true;
    });

    try {
      final controller = WebViewController();
      Color bg = const Color(0xFFF3F7F3);
      try {
        if (mounted) bg = Theme.of(context).colorScheme.surface;
      } catch (_) {}

      try {
        await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      } catch (_) {}

      try {
        await controller.setBackgroundColor(bg);
      } catch (_) {}

      try {
        await controller.setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) setState(() => _loading = true);
            },
            onPageFinished: (url) async {
              await _onPageFinished(url);
            },
            onNavigationRequest: (request) => NavigationDecision.navigate,
            onWebResourceError: (error) {
              if (error.isForMainFrame == false) return;
              if (!mounted) return;
              final desc = error.description;
              if (desc.isEmpty) return;
              setState(() {
                _loading = false;
                _error = desc;
              });
            },
            onUrlChange: (_) {
              _refreshCanGoBack();
            },
          ),
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _unsupported = true;
            _loading = false;
            _error = e.toString();
          });
        }
        return;
      }

      try {
        await controller.loadRequest(_targetUri);
      } catch (e) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = e.toString();
          });
        }
        return;
      }

      if (!mounted) return;
      setState(() {
        _controller = controller;
        _unsupported = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _unsupported = true;
        _loading = false;
        _error = AppLocalizations.of(context).webViewInitFailed(
          e.runtimeType.toString(),
          e.toString(),
        );
      });
    }
  }

  Future<void> _onPageFinished(String url) async {
    await _injectStorage();
    // 第一次注入后 reload，让前端在冷启动时读取新的 chengehr-theme
    if (_needsThemeReload) {
      _needsThemeReload = false;
      final c = _controller;
      if (c != null) {
        try {
          await c.reload();
          return;
        } catch (_) {}
      }
    }
    await _refreshCanGoBack();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _injectStorage() async {
    final controller = _controller;
    if (controller == null) return;
    final tokenLiteral = jsonEncode(widget.token);
    // 双重 encode → JS 字符串，setItem 得到 {"skin":"..."}
    final themeLiteral = jsonEncode(jsonEncode({'skin': widget.themeSkin}));
    try {
      await controller.runJavaScript(
        "try {"
        "  localStorage.setItem('chengehr-token', $tokenLiteral);"
        "  localStorage.setItem('chengehr-theme', $themeLiteral);"
        "} catch (e) {}",
      );
    } catch (_) {}
  }

  Future<void> _refreshCanGoBack() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      final can = await controller.canGoBack();
      if (mounted && can != _canGoBack) {
        setState(() => _canGoBack = can);
      }
    } catch (_) {}
  }

  Future<void> _reload() async {
    final controller = _controller;
    if (controller == null) {
      await _initWebView();
      return;
    }
    setState(() {
      _error = null;
      _loading = true;
      _canGoBack = false;
      _needsThemeReload = true;
    });
    try {
      await controller.loadRequest(_targetUri);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _goBackInWebView() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      if (await controller.canGoBack()) {
        await controller.goBack();
        await _refreshCanGoBack();
      }
    } catch (_) {}
  }

  void _closeWebView() {
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _onSystemBack() async {
    final controller = _controller;
    if (controller != null) {
      try {
        if (await controller.canGoBack()) {
          await controller.goBack();
          await _refreshCanGoBack();
          return;
        }
      } catch (_) {}
    }
    _closeWebView();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pageBg = scheme.surface;
    final l10n = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _onSystemBack();
      },
      child: Scaffold(
        backgroundColor: pageBg,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          leading: IconButton(
            tooltip: l10n.close,
            icon: const Icon(Icons.close_rounded),
            onPressed: _closeWebView,
          ),
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            IconButton(
              tooltip: l10n.back,
              onPressed: _canGoBack ? _goBackInWebView : null,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            IconButton(
              tooltip: l10n.refresh,
              onPressed: _reload,
              icon: const Icon(Icons.refresh_rounded),
            ),
            const SizedBox(width: 4),
          ],
        ),
        body: ColoredBox(
          color: pageBg,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (_unsupported || _error != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.wifi_off_rounded,
                          size: 42,
                          color: scheme.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error ?? l10n.platformWebViewNotSupported,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _reload,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_controller != null)
                WebViewWidget(controller: _controller!)
              else
                const Center(child: CircularProgressIndicator()),
              if (_loading && _error == null && !_unsupported)
                const Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
