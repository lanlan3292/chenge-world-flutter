import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../l10n/generated/app_localizations.dart';
import 'package:flutter/services.dart';

import '../services/chenge_api.dart';
import '../services/settings_store.dart';
import '../services/app_icon_service.dart';
import 'chenge_core_page.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.signedIn,
    required this.settings,
    required this.onSettingsChanged,
    required this.onLogout,
    this.token,
    this.api,
    this.onTokenChanged,
  });

  final bool signedIn;
  final SettingsStore settings;
  final Future<void> Function() onSettingsChanged;
  final Future<void> Function() onLogout;
  final String? token;
  final ChengeApi? api;
  /// 用户在设置里修改 Token 后回调（已通过 /home/me 校验）。
  final Future<void> Function(String token)? onTokenChanged;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _useDynamic;
  late Color _seed;
  late bool _statusImmersive;
  late bool _navImmersive;
  late bool _autoHideTop;
  late bool _autoHideBottom;
  late bool _statusBarTopHideMask;
  late bool _predictiveBack;
  late int _feedMinColumns;
  late int _feedMaxColumns;
  late int _shopMinColumns;
  late int _shopMaxColumns;
  late bool _chatShowSelfAvatar;
  late bool _chatShowPeerAvatar;
  late ThemeMode _themeMode;
  late String _localeCode;
  late String _appIcon;

  @override
  void initState() {
    super.initState();
    _useDynamic = widget.settings.useDynamicColor;
    _themeMode = widget.settings.themeMode;
    _localeCode = widget.settings.localeCode;
    _seed = widget.settings.seedColor;
    _statusImmersive = widget.settings.statusBarImmersive;
    _navImmersive = widget.settings.navigationBarImmersive;
    _autoHideTop = widget.settings.autoHideTopBar;
    _autoHideBottom = widget.settings.autoHideBottomBar;
    _statusBarTopHideMask = widget.settings.statusBarTopHideMask;
    _predictiveBack = widget.settings.predictiveBack;
    _feedMinColumns = widget.settings.feedMinColumns;
    _feedMaxColumns = widget.settings.feedMaxColumns;
    _shopMinColumns = widget.settings.shopMinColumns;
    _shopMaxColumns = widget.settings.shopMaxColumns;
    _chatShowSelfAvatar = widget.settings.chatShowSelfAvatar;
    _chatShowPeerAvatar = widget.settings.chatShowPeerAvatar;
    _appIcon = AppIconService.defaultIcon;
    _loadAppIcon();
  }

  Future<void> _loadAppIcon() async {
    final icon = await AppIconService.getIcon();
    if (mounted) {
      setState(() => _appIcon = icon);
    }
  }

  Future<void> _updateSetting(Future<void> Function() update) async {
    await update();
    await widget.onSettingsChanged();
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> setValue,
    required Future<void> Function(bool) saveValue,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      secondary: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (nextValue) async {
        setState(() => setValue(nextValue));
        await _updateSetting(() => saveValue(nextValue));
      },
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, top: 12, bottom: 6),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    ),
  );

  /// Discrete range slider for min…max columns (1–3). Min never exceeds max.
  Widget _columnRangeSlider({
    required String title,
    required int minValue,
    required int maxValue,
    required void Function(int min, int max) setLocal,
    required Future<void> Function(int min, int max) saveRange,
  }) {
    final theme = Theme.of(context);
    final lo = minValue.clamp(1, 3);
    final hi = maxValue.clamp(lo, 3);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            AppLocalizations.of(context).columnRange(lo, hi),
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                '1',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: RangeSlider(
                  values: RangeValues(lo.toDouble(), hi.toDouble()),
                  min: 1,
                  max: 3,
                  divisions: 2,
                  labels: RangeLabels('$lo', '$hi'),
                  onChanged: (values) {
                    final nextMin = values.start.round().clamp(1, 3);
                    final nextMax = values.end.round().clamp(1, 3);
                    setState(
                      () => setLocal(
                        nextMin <= nextMax ? nextMin : nextMax,
                        nextMin <= nextMax ? nextMax : nextMin,
                      ),
                    );
                  },
                  onChangeEnd: (values) async {
                    final nextMin = values.start.round().clamp(1, 3);
                    final nextMax = values.end.round().clamp(1, 3);
                    final a = nextMin <= nextMax ? nextMin : nextMax;
                    final b = nextMin <= nextMax ? nextMax : nextMin;
                    setState(() => setLocal(a, b));
                    await _updateSetting(() => saveRange(a, b));
                  },
                ),
              ),
              Text(
                '3',
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context).minimumColumns(lo),
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  AppLocalizations.of(context).maximumColumns(hi),
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).settings,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
              children: [
                _sectionTitle(AppLocalizations.of(context).appearance),
                _selectionTile<ThemeMode>(
                  title: AppLocalizations.of(context).themeMode,
                  value: _themeMode,
                  items: {
                    ThemeMode.system: AppLocalizations.of(context).followSystem,
                    ThemeMode.light: AppLocalizations.of(context).light,
                    ThemeMode.dark: AppLocalizations.of(context).dark,
                  },
                  onChanged: (value) async {
                    setState(() => _themeMode = value);
                    await _updateSetting(
                      () => widget.settings.setThemeMode(value),
                    );
                  },
                ),
                _selectionTile<String>(
                  title: AppLocalizations.of(context).language,
                  value: _localeCode,
                  items: {
                    'system': AppLocalizations.of(context).followSystem,
                    'zh_CN': "中文 (中国)",
                    'zh_TW': "中文 (台灣)",
                    'zh_Hans': "中文 (简体)",
                    'zh_Hant': "中文 (繁體)",
                    'en_US': "English (United States)",
                    'ko_KR': "한국어 (대한민국)",
                    'ja_JP': "日本語 (日本)",
                  },
                  onChanged: (value) async {
                    setState(() => _localeCode = value);
                    await _updateSetting(
                      () => widget.settings.setLocaleCode(value),
                    );
                  },
                ),
                // App icon selection (Android only, uses Activity Alias)
                if (Theme.of(context).platform == TargetPlatform.android)
                  _selectionTile<String>(
                    title: '应用图标 / App Icon',
                    value: _appIcon,
                    items: {
                      for (final name in AppIconService.availableIcons)
                        name: AppIconService.labelOf(name),
                    },
                    onChanged: (value) async {
                      setState(() => _appIcon = value);
                      await AppIconService.setIcon(value);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              '图标已切换。可能需要退出应用或重启桌面启动器后才能看到新图标。',
                            ),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    },
                  ),
                _switchTile(
                  icon: Icons.wallpaper_rounded,
                  title: AppLocalizations.of(context).dynamicColor,
                  subtitle: AppLocalizations.of(context).dynamicColorDescription,
                  value: _useDynamic,
                  setValue: (value) => _useDynamic = value,
                  saveValue: widget.settings.setUseDynamicColor,
                ),
                if (!_useDynamic) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 4, top: 8, bottom: 10),
                    child: Text(
                      AppLocalizations.of(context).themeColor,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final color in AppTheme.presetSeeds)
                          _ColorSwatch(
                            color: color,
                            selected: _seed.toARGB32() == color.toARGB32(),
                            onTap: () async {
                              setState(() => _seed = color);
                              await _updateSetting(
                                () => widget.settings.setSeedColor(color),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                _sectionTitle(AppLocalizations.of(context).systemBars),
                _switchTile(
                  icon: Icons.vertical_align_top_rounded,
                  title: AppLocalizations.of(context).statusBarImmersive,
                  subtitle: AppLocalizations.of(context).statusBarDescription,
                  value: _statusImmersive,
                  setValue: (value) => _statusImmersive = value,
                  saveValue: widget.settings.setStatusBarImmersive,
                ),
                _switchTile(
                  icon: Icons.vertical_align_bottom_rounded,
                  title: AppLocalizations.of(context).navigationBarImmersive,
                  subtitle: AppLocalizations.of(context).navigationBarDescription,
                  value: _navImmersive,
                  setValue: (value) => _navImmersive = value,
                  saveValue: widget.settings.setNavigationBarImmersive,
                ),
                _sectionTitle(AppLocalizations.of(context).scrollBehavior),
                _switchTile(
                  icon: Icons.vertical_align_top_rounded,
                  title: AppLocalizations.of(context).autoHideTopBar,
                  subtitle: AppLocalizations.of(context).autoHideTopDescription,
                  value: _autoHideTop,
                  setValue: (value) => _autoHideTop = value,
                  saveValue: widget.settings.setAutoHideTopBar,
                ),
                _switchTile(
                  icon: Icons.blur_on_rounded,
                  title: AppLocalizations.of(context).statusBarTopHideMask,
                  subtitle: AppLocalizations.of(context).statusBarTopHideMaskDescription,
                  value: _statusBarTopHideMask,
                  setValue: (value) => _statusBarTopHideMask = value,
                  saveValue: widget.settings.setStatusBarTopHideMask,
                ),
                _switchTile(
                  icon: Icons.vertical_align_bottom_rounded,
                  title: AppLocalizations.of(context).autoHideBottomBar,
                  subtitle: AppLocalizations.of(context).autoHideBottomDescription,
                  value: _autoHideBottom,
                  setValue: (value) => _autoHideBottom = value,
                  saveValue: widget.settings.setAutoHideBottomBar,
                ),
                _sectionTitle(AppLocalizations.of(context).chat),
                _switchTile(
                  icon: Icons.account_circle_outlined,
                  title: AppLocalizations.of(context).showSelfAvatar,
                  subtitle: AppLocalizations.of(context).showSelfAvatarDescription,
                  value: _chatShowSelfAvatar,
                  setValue: (value) => _chatShowSelfAvatar = value,
                  saveValue: widget.settings.setChatShowSelfAvatar,
                ),
                _switchTile(
                  icon: Icons.face_outlined,
                  title: AppLocalizations.of(context).showPeerAvatar,
                  subtitle: AppLocalizations.of(context).showPeerAvatarDescription,
                  value: _chatShowPeerAvatar,
                  setValue: (value) => _chatShowPeerAvatar = value,
                  saveValue: widget.settings.setChatShowPeerAvatar,
                ),
                _sectionTitle(AppLocalizations.of(context).systemGestures),
                _switchTile(
                  icon: Icons.swipe_left_rounded,
                  title: AppLocalizations.of(context).predictiveBack,
                  subtitle: AppLocalizations.of(context).predictiveBackDescription,
                  value: _predictiveBack,
                  setValue: (value) => _predictiveBack = value,
                  saveValue: widget.settings.setPredictiveBack,
                ),
                _sectionTitle(AppLocalizations.of(context).layout),
                _columnRangeSlider(
                  title: AppLocalizations.of(context).feedColumns,
                  minValue: _feedMinColumns,
                  maxValue: _feedMaxColumns,
                  setLocal: (min, max) {
                    _feedMinColumns = min;
                    _feedMaxColumns = max;
                  },
                  saveRange: widget.settings.setFeedColumnRange,
                ),
                _columnRangeSlider(
                  title: AppLocalizations.of(context).shopColumns,
                  minValue: _shopMinColumns,
                  maxValue: _shopMaxColumns,
                  setLocal: (min, max) {
                    _shopMinColumns = min;
                    _shopMaxColumns = max;
                  },
                  saveRange: widget.settings.setShopColumnRange,
                ),
                _sectionTitle(AppLocalizations.of(context).siteAndToken),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(
                    Icons.language_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context).openOfficialSiteWithWebView,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).webViewNotSupportedOnAllOs,
                  ),
                  onTap: _openOfficialSite,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(
                    Icons.key_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context).accessToken,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).accessTokenDescription,
                  ),
                  onTap: _showTokenDialog,
                ),
                const Divider(height: 28),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(
                    Icons.cleaning_services_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context).clearCache,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).clearCacheDescription,
                  ),
                  onTap: _confirmClearCache,
                ),
                const Divider(height: 28),
                if (widget.signedIn)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: Icon(
                      Icons.logout_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      AppLocalizations.of(context).signOut,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: _confirmLogout,
                  )
                else
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: Icon(
                      Icons.lock_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context).accountSettingsSignIn,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openOfficialSite() {
    final api = widget.api;
    if (api == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).cannotOpenSiteMissingConfig),
        ),
      );
      return;
    }
    final token = widget.token ?? '';
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => OfficialSitePage(
              baseUrl: api.baseUrl,
              token: token,
            ),
      ),
    );
  }

  Future<void> _showTokenDialog() async {
    final current = widget.token ?? '';

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => _EditTokenDialog(
            initialToken: current,
            api: widget.api,
          ),
    );
    if (result == null || !mounted) return;

    try {
      final cb = widget.onTokenChanged;
      if (cb != null) {
        await cb(result);
      }
      if (mounted) {
        final msg = result.trim().isEmpty
            ? AppLocalizations.of(context).accessTokenCleared
            : AppLocalizations.of(context).accessTokenUpdated;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(AppLocalizations.of(context).signOut),
            content: Text(
              AppLocalizations.of(context).confirmSignOut,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(AppLocalizations.of(context).exit),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    await widget.onLogout();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).signedOut)),
    );
  }

  Future<void> _confirmClearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(AppLocalizations.of(context).clearCache),
            content: Text(AppLocalizations.of(context).clearCacheConfirm),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(AppLocalizations.of(context).confirm),
              ),
            ],
          ),
    );
    if (confirmed != true) return;

    try {
      await DefaultCacheManager().emptyCache();
      final imageCache = PaintingBinding.instance.imageCache;
      imageCache.clear();
      imageCache.clearLiveImages();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).clearCacheDone)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Widget _selectionTile<T>({
    required String title,
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      trailing: DropdownButton<T>(
        value: value,
        underline: const SizedBox.shrink(),
        items: [
          for (final entry in items.entries)
            DropdownMenuItem(
              value: entry.key,
              child: Text(entry.value),
            ),
        ],
        onChanged: (next) {
          if (next != null) onChanged(next);
        },
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? colorScheme.onSurface : Colors.transparent,
            width: selected ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.35),
              blurRadius: selected ? 8 : 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child:
            selected
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
                : null,
      ),
    );
  }
}

class _EditTokenDialog extends StatefulWidget {
  const _EditTokenDialog({
    required this.initialToken,
    this.api,
  });

  final String initialToken;
  final ChengeApi? api;

  @override
  State<_EditTokenDialog> createState() => _EditTokenDialogState();
}

class _EditTokenDialogState extends State<_EditTokenDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  var _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialToken);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    if (!_formKey.currentState!.validate() || _saving) return;
    final next = _controller.text.trim();
    final initial = widget.initialToken.trim();
    if (next == initial) {
      Navigator.of(context).pop(); // 无变化，直接关闭
      return;
    }

    // 允许为空：不请求 /home/me，由外层忽略（不改会话、不注销）
    if (next.isEmpty) {
      Navigator.of(context).pop('');
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final api = widget.api;
      if (api != null) {
        await api.currentUser(next);
      }
      if (!mounted) return;
      // 先 pop 再让外层回调，避免父组件 setState 时 dialog 仍在树中
      Navigator.of(context).pop(next);
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(
        l10n.accessToken,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller,
                maxLines: 5,
                minLines: 3,
                enabled: !_saving,
                decoration: InputDecoration(
                  labelText: l10n.accessToken,
                  alignLabelWithHint: true,
                  suffixIcon: IconButton(
                    tooltip: l10n.copy,
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: _controller.text),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.accessTokenCopied)),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy_rounded),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _confirm,
          child:
              _saving
                  ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(l10n.confirm),
        ),
      ],
    );
  }
}
