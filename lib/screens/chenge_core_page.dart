import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/app_localizations_text.dart';

/// 在应用内打开 ChengeCore 前端，并把登录 token 写入 localStorage
/// 键名 `chengehr-token`，以便 Web 端保持登录状态。
class ChengeCorePage extends StatefulWidget {
  const ChengeCorePage({
    super.key,
    required this.baseUrl,
    required this.token,
  });

  /// API / 前端同源根地址，例如 `http://8.138.13.61`
  final String baseUrl;

  /// 当前登录 JWT
  final String token;

  @override
  State<ChengeCorePage> createState() => _ChengeCorePageState();
}

class _ChengeCorePageState extends State<ChengeCorePage> {
  late final WebViewController _controller;
  var _loading = true;
  var _tokenInjected = false;
  String? _error;

  Uri get _coreUri {
    final root = widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$root/#/chengecore');
  }

  Uri get _originUri {
    final root = widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');
    return Uri.parse('$root/');
  }

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (_) {
                if (mounted) setState(() => _loading = true);
              },
              onPageFinished: (url) async {
                await _injectTokenAndGoCore(url);
                if (mounted) setState(() => _loading = false);
              },
              onWebResourceError: (error) {
                if (!mounted) return;
                setState(() {
                  _loading = false;
                  _error = error.description;
                });
              },
            ),
          )
          // 先加载同源根路径，确保 localStorage 写入成功后再跳到 #/chengecore
          ..loadRequest(_originUri);
  }

  Future<void> _injectTokenAndGoCore(String url) async {
    final tokenLiteral = jsonEncode(widget.token);
    try {
      await _controller.runJavaScript(
        "try {"
        "  localStorage.setItem('chengehr-token', $tokenLiteral);"
        "  localStorage.setItem('chengehr-theme', '{\"skin\":\"aqua\"}');"
        "} catch (e) {}",
      );
      _tokenInjected = true;

      // 若当前还不在 ChengeCore 路由，则跳转
      final target = _coreUri.toString();
      await _controller.runJavaScript(
        "if (!location.hash || location.hash.indexOf('chengecore') < 0) {"
        "  location.hash = '#/chengecore';"
        "} else if (location.href !== ${jsonEncode(target)} && "
        "location.hash.indexOf('chengecore') < 0) {"
        "  location.href = ${jsonEncode(target)};"
        "}",
      );
    } catch (_) {
      // WebView 未就绪时忽略，下次 onPageFinished 再试
    }
  }

  Future<void> _reload() async {
    setState(() {
      _error = null;
      _loading = true;
      _tokenInjected = false;
    });
    await _controller.loadRequest(_originUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).text('ChengeCore'),
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
      body: Stack(
        children: [
          if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 42,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
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
          else
            WebViewWidget(controller: _controller),
          if (_loading)
            const Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: LinearProgressIndicator(minHeight: 2),
            ),
        ],
      ),
    );
  }
}
