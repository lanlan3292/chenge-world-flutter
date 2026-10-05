import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../l10n/generated/app_localizations.dart';

/// ChengeCore: aqua skin, route `#/chengecore`
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
      hideXPaths: const [
        '/html/body/div[1]/div/div[6]/aside',
        '/html/body/div[1]/div/nav',
        '/html/body/div[7]',
        '/html/body/div[1]/div/header',
        '/html/body/div[4]',
      ],
    );
  }
}

/// Nurture: cute skin, route `#/intelligence?mode=nurture`
/// Separate page so skin/state is not shared with ChengeCore.
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
      hideXPaths: const [
        '/html/body/div[10]/div/div/div/button[1]',
      ],
    );
  }
}

/// Official site home: aqua skin, no hash
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

/// Embedded site WebView (loadRequest, not loadHtmlString).
///
/// - Close (leading): pop this route
/// - Back (trailing): WebView history only
/// - System back: history first, else pop
///
/// Theme is **client-specified** via [themeSkin] (`aqua` / `cute`).
/// Server `GET /home/settings` and SPA writes must not override it:
/// - localStorage `chengehr-theme` is forced to the client skin
/// - `document.documentElement.dataset.skin` + stylesheet toggles match the
///   site bootstrap script
/// - fetch / XHR responses for `/home/settings` are patched so
///   `data.appearance.skin` stays the client value
/// - `localStorage.setItem('chengehr-theme', …)` is guarded against later
///   overwrites by the SPA
class _SiteWebViewPage extends StatefulWidget {
  const _SiteWebViewPage({
    required this.baseUrl,
    required this.token,
    required this.title,
    required this.hashRoute,
    required this.themeSkin,
    this.hideXPaths = const [],
  });

  final String baseUrl;
  final String token;
  final String title;
  final String hashRoute;

  /// Client-fixed skin for this page (`aqua` or `cute`).
  final String themeSkin;

  /// Absolute XPaths to remove after load (empty = no DOM stripping).
  final List<String> hideXPaths;

  @override
  State<_SiteWebViewPage> createState() => _SiteWebViewPageState();
}

class _SiteWebViewPageState extends State<_SiteWebViewPage> {
  WebViewController? _controller;
  var _loading = true;
  var _canGoBack = false;

  /// After first storage + intercept injection, reload once so SPA cold-start
  /// reads the client skin and patched network.
  var _needsThemeReload = true;
  String? _error;
  var _unsupported = false;

  String get _root => widget.baseUrl.replaceFirst(RegExp(r'/+$'), '');

  /// Normalize to the two skins the site bootstrap understands.
  String get _skin {
    final raw = widget.themeSkin.trim().toLowerCase();
    return raw == 'aqua' ? 'aqua' : 'cute';
  }

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
    await _injectClientThemeLock();
    // First inject then reload so cold-start HTML bootstrap sees client skin.
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

  /// Force client [themeSkin] into localStorage, DOM, stylesheets, and any
  /// later `/home/settings` payload or localStorage write from the SPA.
  Future<void> _injectClientThemeLock() async {
    final controller = _controller;
    if (controller == null) return;

    final tokenLiteral = jsonEncode(widget.token);
    final skinLiteral = jsonEncode(_skin);
    // Double-encode → JS string value is the JSON object {"skin":"..."}.
    final themeLiteral = jsonEncode(jsonEncode({'skin': _skin}));
    final pathsLiteral = jsonEncode(widget.hideXPaths);

    final script = """
(function() {
  var SKIN = $skinLiteral;
  var THEME_JSON = $themeLiteral;
  var TOKEN = $tokenLiteral;
  var HIDE_PATHS = $pathsLiteral;
  var __chengeHideBusy = false;
  var __chengeHideTimer = null;

  // Soft-hide (do not removeChild): removing nodes from a live SPA tree can
  // unmount the whole parent, or miss the target when div[N] indices shift.
  function softHideNode(node, path) {
    if (!node || !node.style) return false;
    try {
      if (node.getAttribute && node.getAttribute('data-chenge-hidden') === '1') {
        return true;
      }
      // If path ends with button[N], only act on real <button> elements.
      if (/button\\[\\d+\\]\\s*\$/i.test(String(path || '')) &&
          String(node.tagName || '').toUpperCase() !== 'BUTTON') {
        return false;
      }
      node.setAttribute('data-chenge-hidden', '1');
      node.style.setProperty('display', 'none', 'important');
      node.style.setProperty('visibility', 'hidden', 'important');
      node.style.setProperty('pointer-events', 'none', 'important');
      node.style.setProperty('max-height', '0', 'important');
      node.style.setProperty('max-width', '0', 'important');
      node.style.setProperty('overflow', 'hidden', 'important');
      node.setAttribute('aria-hidden', 'true');
      if (node.tabIndex !== undefined) node.tabIndex = -1;
      return true;
    } catch (e) {
      return false;
    }
  }

  function resolveHideNode(path) {
    try {
      var node = document.evaluate(
        path,
        document,
        null,
        XPathResult.FIRST_ORDERED_NODE_TYPE,
        null
      ).singleNodeValue;
      if (node) return node;
    } catch (e) {}
    return null;
  }

  function removeSiteChrome() {
    if (!HIDE_PATHS || !HIDE_PATHS.length || __chengeHideBusy) return;
    __chengeHideBusy = true;
    try {
      for (var i = 0; i < HIDE_PATHS.length; i++) {
        var path = HIDE_PATHS[i];
        var node = resolveHideNode(path);
        softHideNode(node, path);
      }
    } catch (e) {}
    __chengeHideBusy = false;
  }

  function scheduleHide() {
    if (__chengeHideTimer) {
      try { clearTimeout(__chengeHideTimer); } catch (e) {}
    }
    __chengeHideTimer = setTimeout(function() {
      __chengeHideTimer = null;
      removeSiteChrome();
    }, 120);
  }

  function installChromeObserver() {
    if (!HIDE_PATHS || !HIDE_PATHS.length) return;
    var key = HIDE_PATHS.join('|');
    if (window.__chengeChromeObserverKey === key) {
      scheduleHide();
      return;
    }
    window.__chengeChromeObserverKey = key;
    removeSiteChrome();
    try {
      var root = document.body || document.documentElement;
      var obs = new MutationObserver(function() {
        scheduleHide();
      });
      obs.observe(root, { childList: true, subtree: true });
    } catch (e) {}
    try {
      // SPA panels often mount late; staggered retries without tearing the tree.
      var delays = [0, 200, 500, 1000, 2000, 3500, 5000];
      for (var d = 0; d < delays.length; d++) {
        (function(ms) {
          setTimeout(removeSiteChrome, ms);
        })(delays[d]);
      }
    } catch (e) {}
  }

  function applyDomSkin(skin) {
    try {
      document.documentElement.dataset.skin = skin;
    } catch (e) {}
    try {
      var links = document.querySelectorAll('[data-skin-stylesheet]');
      for (var i = 0; i < links.length; i++) {
        var link = links[i];
        var sheetSkin = link.getAttribute('data-skin-stylesheet');
        // Site bootstrap: only exact 'aqua' keeps aqua styles; else cute.
        if (skin === 'aqua') {
          link.disabled = (sheetSkin === 'cute');
        } else {
          link.disabled = (sheetSkin === 'aqua');
        }
      }
    } catch (e) {}
  }

  function writeTheme() {
    try {
      localStorage.setItem('chengehr-token', TOKEN);
      localStorage.setItem('chengehr-theme', THEME_JSON);
    } catch (e) {}
    applyDomSkin(SKIN);
  }

  writeTheme();
  installChromeObserver();

  // Re-apply if SPA mutates theme key after load.
  try {
    if (!window.__chengeThemeSetItemPatched) {
      window.__chengeThemeSetItemPatched = true;
      var origSetItem = Storage.prototype.setItem;
      Storage.prototype.setItem = function(key, value) {
        if (String(key) === 'chengehr-theme') {
          try {
            var parsed = {};
            try { parsed = JSON.parse(String(value) || '{}') || {}; } catch (e) {}
            if (parsed.skin !== SKIN) {
              value = THEME_JSON;
            }
          } catch (e) {
            value = THEME_JSON;
          }
        }
        return origSetItem.apply(this, [key, value]);
      };
    }
  } catch (e) {}

  function patchSettingsBody(text) {
    try {
      var j = JSON.parse(text);
      if (!j || typeof j !== 'object') return text;
      if (!j.data || typeof j.data !== 'object') j.data = {};
      if (!j.data.appearance || typeof j.data.appearance !== 'object') {
        j.data.appearance = {};
      }
      j.data.appearance.skin = SKIN;
      return JSON.stringify(j);
    } catch (e) {
      return text;
    }
  }

  function isSettingsUrl(u) {
    if (!u) return false;
    return String(u).indexOf('/home/settings') !== -1;
  }

  // Patch fetch so SPA receives client skin from /home/settings.
  try {
    if (window.fetch && window.__chengeSettingsFetchSkin !== SKIN) {
      window.__chengeSettingsFetchSkin = SKIN;
      var origFetch = window.fetch.bind(window);
      window.fetch = function(input, init) {
        var url = '';
        try {
          if (typeof input === 'string') url = input;
          else if (input && input.url) url = input.url;
        } catch (e) {}
        return origFetch(input, init).then(function(resp) {
          if (!isSettingsUrl(url) && !isSettingsUrl(resp && resp.url)) {
            return resp;
          }
          return resp.clone().text().then(function(t) {
            var body = patchSettingsBody(t);
            return new Response(body, {
              status: resp.status,
              statusText: resp.statusText,
              headers: resp.headers
            });
          });
        });
      };
    }
  } catch (e) {}

  // Patch XHR the same way.
  try {
    if (window.__chengeSettingsXhrSkin !== SKIN) {
      window.__chengeSettingsXhrSkin = SKIN;
      var XO = XMLHttpRequest.prototype.open;
      var XS = XMLHttpRequest.prototype.send;
      XMLHttpRequest.prototype.open = function(method, url) {
        this.__chengeUrl = url;
        return XO.apply(this, arguments);
      };
      XMLHttpRequest.prototype.send = function() {
        if (isSettingsUrl(this.__chengeUrl)) {
          this.addEventListener('load', function() {
            try {
              var text = this.responseText;
              var patched = patchSettingsBody(text);
              if (patched !== text) {
                Object.defineProperty(this, 'responseText', {
                  configurable: true,
                  get: function() { return patched; }
                });
                try {
                  Object.defineProperty(this, 'response', {
                    configurable: true,
                    get: function() { return patched; }
                  });
                } catch (e) {}
              }
            } catch (e) {}
            writeTheme();
          });
        }
        return XS.apply(this, arguments);
      };
    }
  } catch (e) {}

  // Keep DOM skin aligned after SPA settles.
  try {
    setTimeout(function() { writeTheme(); removeSiteChrome(); }, 0);
    setTimeout(function() { writeTheme(); removeSiteChrome(); }, 300);
    setTimeout(function() { writeTheme(); removeSiteChrome(); }, 1000);
  } catch (e) {}
})();
""";

    try {
      await controller.runJavaScript(script);
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
