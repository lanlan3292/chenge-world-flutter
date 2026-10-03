import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/app_localizations_text.dart';

/// 在应用内 WebView 打开站点页面。
///
/// 通过 `loadHtmlString` + 同源 [baseUrl] 先写入 localStorage，再 `location.replace`
/// 进入目标页，保证 SPA 启动时就能读到正确的 token / theme（避免皮肤串页）。
///
/// - **关闭**：顶栏关闭按钮 → 退出 WebView 页面
/// - **返回**：顶栏返回 / 系统返回 → 仅 WebView 历史后退；无历史时系统返回才退出
class ChengeCorePage extends StatefulWidget {
  const ChengeCorePage({
    super.key,
    required this.baseUrl,
    required this.token,
    this.title = 'ChengeCore',
    this.hashRoute = '#/chengecore',
    this.themeSkin = 'aqua',
  });

  final String baseUrl;
  final String token;
  final String title;

  /// 如 `#/chengecore`、`#/intelligence?mode=nurture`；空表示站点首页
  final String hashRoute;

  /// 写入 `chengehr-theme` 的 skin，如 `aqua` / `cute`
  final String themeSkin;

  @override
  State<ChengeCorePage> createState() => _ChengeCorePageState();
}

class _ChengeCorePageState extends State<ChengeCorePage> {
  WebViewController? _controller;
  var _loading = true;
  var _canGoBack = false;
  var _bootstrapped = false;
  String? _error;
  var _unsupported = false;

  String get _root => widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');

  /// 实际给浏览器的目标 URL（hash 路由必须挂在 origin 后）
  String get _resolvedTarget {
    final hash = widget.hashRoute.trim();
    if (hash.isEmpty) return '$_root/';
    final fragment = hash.startsWith('#') ? hash.substring(1) : hash;
    // 标准 hash 路由：http://host/#/path
    return '$_root/#$fragment';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _initWebView();
    });
  }

  String _bootstrapHtml() {
    final tokenLiteral = jsonEncode(widget.token);
    // 双重 encode → JS 字符串字面量，setItem 得到 {"skin":"aqua"}
    final themeLiteral = jsonEncode(jsonEncode({'skin': widget.themeSkin}));
    final targetLiteral = jsonEncode(_resolvedTarget);
    return '''
<!DOCTYPE html>
<html>
<head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
<body style="margin:0;background:#f3f7f3;font-family:sans-serif;color:#173c3a;display:flex;align-items:center;justify-content:center;height:100vh;">
<div>Loading…</div>
<script>
(function () {
  try {
    localStorage.setItem('chengehr-token', $tokenLiteral);
    localStorage.setItem('chengehr-theme', $themeLiteral);
  } catch (e) {}
  try {
    location.replace($targetLiteral);
  } catch (e) {
    location.href = $targetLiteral;
  }
})();
</script>
</body>
</html>
''';
  }

  Future<void> _initWebView() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
      _unsupported = false;
      _bootstrapped = false;
      _canGoBack = false;
    });

    // 捕获 Error（含 Null check operator），桌面端常因缺少平台实现抛出
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
              // bootstrap 页已写入 localStorage；目标页再补写一次防丢
              if (_bootstrapped) {
                await _injectStorageOnly();
              }
              await _refreshCanGoBack();
              if (mounted) setState(() => _loading = false);
            },
            onNavigationRequest: (request) => NavigationDecision.navigate,
            onWebResourceError: (error) {
              final isMain = error.isForMainFrame;
              if (isMain == false) return;
              if (!mounted) return;
              final desc = error.description;
              if (desc.isEmpty) return;
              // bootstrap 跳转过程中的瞬时错误忽略
              if (!_bootstrapped) return;
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
        // 同源 baseUrl，使 localStorage 作用于真实站点
        await controller.loadHtmlString(
          _bootstrapHtml(),
          baseUrl: '$_root/',
        );
        _bootstrapped = true;
      } catch (e) {
        // 部分平台不支持 loadHtmlString，回退为直接 loadRequest + 事后注入
        try {
          await controller.loadRequest(Uri.parse(_resolvedTarget));
          _bootstrapped = true;
        } catch (e2) {
          if (mounted) {
            setState(() {
              _loading = false;
              _error = e2.toString();
            });
          }
          return;
        }
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
        _error =
            'WebView 初始化失败（${e.runtimeType}）：$e\n'
            'Windows 需安装 Edge WebView2 Runtime，并确保使用支持桌面的 webview 插件。';
      });
    }
  }

  Future<void> _injectStorageOnly() async {
    final controller = _controller;
    if (controller == null) return;
    final tokenLiteral = jsonEncode(widget.token);
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
      _bootstrapped = false;
    });
    try {
      await controller.loadHtmlString(_bootstrapHtml(), baseUrl: '$_root/');
      _bootstrapped = true;
    } catch (_) {
      try {
        await controller.loadRequest(Uri.parse(_resolvedTarget));
        _bootstrapped = true;
      } catch (e) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = e.toString();
          });
        }
      }
    }
  }

  /// 仅 WebView 历史后退（无历史则不做任何事）
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

  /// 关闭 WebView 页面
  void _closeWebView() {
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  /// 系统返回：有历史则后退，否则关闭
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
          // 关闭：始终退出 WebView（与「返回」职责分离）
          leading: IconButton(
            tooltip: l10n.text('关闭'),
            icon: const Icon(Icons.close_rounded),
            onPressed: _closeWebView,
          ),
          title: Text(
            l10n.text(widget.title),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            // 返回：仅历史后退；无历史时禁用
            IconButton(
              tooltip: l10n.text('返回'),
              onPressed: _canGoBack ? _goBackInWebView : null,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            IconButton(
              tooltip: l10n.text('刷新'),
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
                          _error ?? l10n.text('当前平台暂不支持内置网页'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _reload,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(l10n.text('重试')),
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
