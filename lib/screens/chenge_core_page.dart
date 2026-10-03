import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/app_localizations_text.dart';

/// 在应用内 WebView 打开站点页面，写入 localStorage：
/// - `chengehr-token`：保持登录
/// - `chengehr-theme`：主题皮肤 JSON 字符串，如 `{"skin":"aqua"}`
///
/// 先加载同源根路径再注入并跳转到 [hashRoute]，避免跨页丢 token。
/// 系统返回键 / 顶栏返回：优先 WebView 历史后退，没有历史再关闭页面。
class ChengeCorePage extends StatefulWidget {
  const ChengeCorePage({
    super.key,
    required this.baseUrl,
    required this.token,
    this.title = 'ChengeCore',
    this.hashRoute = '#/chengecore',
    this.themeSkin = 'aqua',
  });

  /// API / 前端同源根地址，例如 `http://8.138.13.61`
  final String baseUrl;

  /// 当前登录 JWT；可为空（仅浏览）
  final String token;

  /// 顶栏标题
  final String title;

  /// 目标路由，如 `#/chengecore`、`#/intelligence?mode=nurture`；空字符串表示停留在首页
  final String hashRoute;

  /// 写入 `chengehr-theme` 的 skin 值，如 `aqua` / `cute`
  final String themeSkin;

  @override
  State<ChengeCorePage> createState() => _ChengeCorePageState();
}

class _ChengeCorePageState extends State<ChengeCorePage> {
  WebViewController? _controller;
  var _loading = true;
  var _canGoBack = false;
  String? _error;
  var _unsupported = false;

  String get _root => widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');

  Uri get _originUri => Uri.parse('$_root/');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initWebView());
  }

  Future<void> _initWebView() async {
    // Windows 上透明背景会导致整窗发灰；统一不透明。
    // 分步初始化，避免级联调用在桌面端插件未就绪时触发 Null check。
    try {
      final controller = WebViewController();
      final backgroundColor = Theme.of(context).colorScheme.surface;

      try {
        await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      } catch (_) {
        // 部分平台可能不支持，继续
      }

      try {
        await controller.setBackgroundColor(backgroundColor);
      } catch (_) {
        try {
          await controller.setBackgroundColor(const Color(0xFFF3F7F3));
        } catch (_) {}
      }

      try {
        await controller.setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) setState(() => _loading = true);
            },
            onPageFinished: (url) async {
              await _injectAndNavigate(url);
              await _refreshCanGoBack();
              if (mounted) setState(() => _loading = false);
            },
            onNavigationRequest: (request) {
              return NavigationDecision.navigate;
            },
            onWebResourceError: (error) {
              // isForMainFrame 在部分桌面实现上可能为 null
              final isMain = error.isForMainFrame;
              if (isMain == false) return;
              if (!mounted) return;
              final desc = error.description;
              setState(() {
                _loading = false;
                if (desc.isNotEmpty) _error = desc;
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
        await controller.loadRequest(_originUri);
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
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _unsupported = true;
        _loading = false;
        _error = e.toString();
      });
    }
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

  /// 正确把 JSON **字符串** 写入 localStorage（值必须是 JS 字符串字面量）。
  Future<void> _injectAndNavigate(String url) async {
    final controller = _controller;
    if (controller == null) return;

    final tokenLiteral = jsonEncode(widget.token);
    // 先编码成 JSON 文本，再编码成 JS 字符串字面量：
    // 结果形如 "{\"skin\":\"aqua\"}"，setItem 得到字符串 {"skin":"aqua"}
    final themeValue = jsonEncode({'skin': widget.themeSkin});
    final themeLiteral = jsonEncode(themeValue);

    try {
      await controller.runJavaScript(
        "try {"
        "  localStorage.setItem('chengehr-token', $tokenLiteral);"
        "  localStorage.setItem('chengehr-theme', $themeLiteral);"
        "} catch (e) {}",
      );

      final hash = widget.hashRoute.trim();
      if (hash.isEmpty) return;

      final normalized = hash.startsWith('#') ? hash : '#$hash';
      await controller.runJavaScript(
        "try {"
        "  if (location.hash !== ${jsonEncode(normalized)}) {"
        "    location.hash = ${jsonEncode(normalized)};"
        "  }"
        "} catch (e) {}",
      );
    } catch (_) {
      // WebView 未就绪时忽略，等待下次 onPageFinished
    }
  }

  Future<void> _reload() async {
    setState(() {
      _error = null;
      _loading = true;
      _canGoBack = false;
    });
    final controller = _controller;
    if (controller == null) {
      await _initWebView();
      return;
    }
    try {
      await controller.loadRequest(_originUri);
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  /// 优先 WebView 后退；无历史则关闭本页。
  Future<void> _handleBack() async {
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
    if (mounted && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pageBg = scheme.surface;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _handleBack();
      },
      child: Scaffold(
        backgroundColor: pageBg,
        appBar: AppBar(
          backgroundColor: scheme.surface,
          // 显式返回键：优先历史后退
          leading: IconButton(
            tooltip: AppLocalizations.of(context).text('返回'),
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: _handleBack,
          ),
          title: Text(
            AppLocalizations.of(context).text(widget.title),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          actions: [
            if (_canGoBack)
              IconButton(
                tooltip: AppLocalizations.of(context).text('后退'),
                onPressed: () async {
                  final c = _controller;
                  if (c == null) return;
                  try {
                    await c.goBack();
                    await _refreshCanGoBack();
                  } catch (_) {}
                },
                icon: const Icon(Icons.subdirectory_arrow_left_rounded),
              ),
            IconButton(
              tooltip: AppLocalizations.of(context).text('刷新'),
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
                          _error ??
                              AppLocalizations.of(
                                context,
                              ).text('当前平台暂不支持内置网页'),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: scheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _reload,
                          icon: const Icon(Icons.refresh_rounded),
                          label: Text(AppLocalizations.of(context).text('重试')),
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
