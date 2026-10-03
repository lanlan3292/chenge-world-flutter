import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/app_localizations_text.dart';

/// 在应用内 WebView 打开站点页面，写入 localStorage：
/// - `chengehr-token`：保持登录
/// - `chengehr-theme`：主题皮肤 JSON，如 `{"skin":"aqua"}`
///
/// 先加载同源根路径再注入并跳转到 [hashRoute]，避免跨页丢 token。
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
  String? _error;
  var _unsupported = false;

  String get _root {
    return widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');
  }

  Uri get _originUri => Uri.parse('$_root/');

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    // Windows 上透明背景会导致整窗发灰；统一使用不透明 surface。
    try {
      const bg = Color(0xFFF3F7F3);
      final controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setBackgroundColor(bg)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (_) {
                  if (mounted) setState(() => _loading = true);
                },
                onPageFinished: (url) async {
                  await _injectAndNavigate(url);
                  if (mounted) setState(() => _loading = false);
                },
                onWebResourceError: (error) {
                  if (error.isForMainFrame == false) return;
                  if (!mounted) return;
                  setState(() {
                    _loading = false;
                    _error = error.description;
                  });
                },
              ),
            )
            ..loadRequest(_originUri);

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

  Future<void> _injectAndNavigate(String url) async {
    final controller = _controller;
    if (controller == null) return;

    final tokenLiteral = jsonEncode(widget.token);
    final themeLiteral = jsonEncode({'skin': widget.themeSkin});
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
    });
    final controller = _controller;
    if (controller == null) {
      await _initWebView();
      return;
    }
    await controller.loadRequest(_originUri);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // 不透明背景，避免 Windows 透明 WebView 把整窗染成灰色
    final pageBg = scheme.surface;

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        backgroundColor: scheme.surface,
        title: Text(
          AppLocalizations.of(context).text(widget.title),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
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
                            AppLocalizations.of(context).text('当前平台暂不支持内置网页'),
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
    );
  }
}
