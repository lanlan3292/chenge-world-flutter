import 'package:flutter/material.dart';

import '../l10n/app_localizations_text.dart';
import 'package:flutter/services.dart';

import '../services/chenge_api.dart';
import '../services/settings_store.dart';
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
        AppLocalizations.of(context).text(title),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(AppLocalizations.of(context).text(subtitle)),
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
      AppLocalizations.of(context).text(title),
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
          AppLocalizations.of(context).text('设置'),
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
                _sectionTitle('外观'),
                _selectionTile<ThemeMode>(
                  title: '主题模式',
                  value: _themeMode,
                  items: {
                    ThemeMode.system: '跟随系统',
                    ThemeMode.light: '浅色',
                    ThemeMode.dark: '深色',
                  },
                  onChanged: (value) async {
                    setState(() => _themeMode = value);
                    await _updateSetting(
                      () => widget.settings.setThemeMode(value),
                    );
                  },
                ),
                _selectionTile<String>(
                  title: '语言',
                  value: _localeCode,
                  items: {
                    'system': '跟随系统',
                    'zh_CN': '中文（中国）',
                    'zh_TW': '中文（台湾）',
                    'en_US': '英语（美国）',
                  },
                  onChanged: (value) async {
                    setState(() => _localeCode = value);
                    await _updateSetting(
                      () => widget.settings.setLocaleCode(value),
                    );
                  },
                ),
                _switchTile(
                  icon: Icons.wallpaper_rounded,
                  title: '动态取色',
                  subtitle: '使用 Android 12+ 壁纸配色（Material You）',
                  value: _useDynamic,
                  setValue: (value) => _useDynamic = value,
                  saveValue: widget.settings.setUseDynamicColor,
                ),
                if (!_useDynamic) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 4, top: 8, bottom: 10),
                    child: Text(
                      AppLocalizations.of(context).text('主题色'),
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
                _sectionTitle('系统栏'),
                _switchTile(
                  icon: Icons.vertical_align_top_rounded,
                  title: '状态栏沉浸',
                  subtitle: '内容延伸至状态栏下方，状态栏透明',
                  value: _statusImmersive,
                  setValue: (value) => _statusImmersive = value,
                  saveValue: widget.settings.setStatusBarImmersive,
                ),
                _switchTile(
                  icon: Icons.vertical_align_bottom_rounded,
                  title: '导航栏沉浸',
                  subtitle: '内容延伸至导航栏下方，导航栏透明',
                  value: _navImmersive,
                  setValue: (value) => _navImmersive = value,
                  saveValue: widget.settings.setNavigationBarImmersive,
                ),
                _sectionTitle('滚动行为'),
                _switchTile(
                  icon: Icons.vertical_align_top_rounded,
                  title: '自动隐藏顶栏',
                  subtitle: '在发现 / 商城向下滚动时收起页面顶栏（默认开启）',
                  value: _autoHideTop,
                  setValue: (value) => _autoHideTop = value,
                  saveValue: widget.settings.setAutoHideTopBar,
                ),
                _switchTile(
                  icon: Icons.blur_on_rounded,
                  title: '顶栏隐藏时状态栏遮罩',
                  subtitle: '顶栏可自动隐藏时，状态栏使用半透明主题背景，避免内容顶到状态栏（默认开启）',
                  value: _statusBarTopHideMask,
                  setValue: (value) => _statusBarTopHideMask = value,
                  saveValue: widget.settings.setStatusBarTopHideMask,
                ),
                _switchTile(
                  icon: Icons.vertical_align_bottom_rounded,
                  title: '自动隐藏底栏',
                  subtitle: '在发现 / 商城向下滚动时收起底部导航；宽屏侧边栏不会隐藏',
                  value: _autoHideBottom,
                  setValue: (value) => _autoHideBottom = value,
                  saveValue: widget.settings.setAutoHideBottomBar,
                ),
                _sectionTitle('聊天'),
                _switchTile(
                  icon: Icons.account_circle_outlined,
                  title: '在会话聊天显示自己的头像',
                  subtitle: '自己发送的消息右侧显示头像（默认关闭）',
                  value: _chatShowSelfAvatar,
                  setValue: (value) => _chatShowSelfAvatar = value,
                  saveValue: widget.settings.setChatShowSelfAvatar,
                ),
                _switchTile(
                  icon: Icons.face_outlined,
                  title: '在私人会话聊天显示对方的头像',
                  subtitle: '私聊中对方消息左侧显示头像；群聊始终显示成员头像（默认关闭）',
                  value: _chatShowPeerAvatar,
                  setValue: (value) => _chatShowPeerAvatar = value,
                  saveValue: widget.settings.setChatShowPeerAvatar,
                ),
                _sectionTitle('系统手势'),
                _switchTile(
                  icon: Icons.swipe_left_rounded,
                  title: '预见式返回',
                  subtitle: 'Android 13+ 页面过渡使用预见式返回动画（默认关闭）',
                  value: _predictiveBack,
                  setValue: (value) => _predictiveBack = value,
                  saveValue: widget.settings.setPredictiveBack,
                ),
                _sectionTitle('布局'),
                _columnRangeSlider(
                  title: '发现页列数范围',
                  minValue: _feedMinColumns,
                  maxValue: _feedMaxColumns,
                  setLocal: (min, max) {
                    _feedMinColumns = min;
                    _feedMaxColumns = max;
                  },
                  saveRange: widget.settings.setFeedColumnRange,
                ),
                _columnRangeSlider(
                  title: '商店页列数范围',
                  minValue: _shopMinColumns,
                  maxValue: _shopMaxColumns,
                  setLocal: (min, max) {
                    _shopMinColumns = min;
                    _shopMaxColumns = max;
                  },
                  saveRange: widget.settings.setShopColumnRange,
                ),
                _sectionTitle('站点与令牌'),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  leading: Icon(
                    Icons.language_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(
                    AppLocalizations.of(context).text('使用 WebView 打开官网'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).text('自动写入登录状态与 aqua 主题'),
                  ),
                  onTap: _openOfficialSite,
                ),
                if (widget.signedIn && widget.token != null)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: Icon(
                      Icons.key_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context).text('修改 Token'),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      AppLocalizations.of(context).text('查看、编辑并保存登录令牌'),
                    ),
                    onTap: _showTokenDialog,
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
                      AppLocalizations.of(context).text('退出登录'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: _confirmLogout,
                  )
                else
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                    leading: Icon(
                      Icons.lock_outline_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      AppLocalizations.of(context).text('登录后可管理账户设置'),
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
          content: Text(AppLocalizations.of(context).text('无法打开官网：缺少服务配置')),
        ),
      );
      return;
    }
    final token = widget.token ?? '';
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => ChengeCorePage(
              baseUrl: api.baseUrl,
              token: token,
              title: '官网',
              hashRoute: '',
              themeSkin: 'aqua',
            ),
      ),
    );
  }

  Future<void> _showTokenDialog() async {
    final current = widget.token;
    if (current == null || current.isEmpty) return;

    final controller = TextEditingController(text: current);
    final formKey = GlobalKey<FormState>();
    var saving = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context).text('修改 Token'),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              content: SizedBox(
                width: 420,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: controller,
                        maxLines: 5,
                        minLines: 3,
                        enabled: !saving,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).text('访问令牌'),
                          alignLabelWithHint: true,
                          suffixIcon: IconButton(
                            tooltip: AppLocalizations.of(context).text('复制'),
                            onPressed: () async {
                              await Clipboard.setData(
                                ClipboardData(text: controller.text),
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      ).text('Token 已复制'),
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(Icons.copy_rounded),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return AppLocalizations.of(context).text('请输入 Token');
                          }
                          return null;
                        },
                      ),
                      if (errorText != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed:
                      saving ? null : () => Navigator.pop(dialogContext),
                  child: Text(AppLocalizations.of(context).text('取消')),
                ),
                FilledButton(
                  onPressed:
                      saving
                          ? null
                          : () async {
                            if (!formKey.currentState!.validate()) return;
                            final next = controller.text.trim();
                            if (next == current) {
                              Navigator.pop(dialogContext);
                              return;
                            }
                            setDialogState(() {
                              saving = true;
                              errorText = null;
                            });
                            try {
                              final api = widget.api;
                              if (api != null) {
                                await api.currentUser(next);
                              }
                              final cb = widget.onTokenChanged;
                              if (cb != null) {
                                await cb(next);
                              }
                              if (dialogContext.mounted) {
                                Navigator.pop(dialogContext);
                              }
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      AppLocalizations.of(
                                        context,
                                      ).text('Token 已更新'),
                                    ),
                                  ),
                                );
                              }
                            } on ApiException catch (e) {
                              setDialogState(() {
                                saving = false;
                                errorText = e.message;
                              });
                            } catch (e) {
                              setDialogState(() {
                                saving = false;
                                errorText = e.toString();
                              });
                            }
                          },
                  child:
                      saving
                          ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(AppLocalizations.of(context).text('确定')),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(AppLocalizations.of(context).text('退出登录')),
            content: Text(
              AppLocalizations.of(context).text('确定退出当前 ChengeWorld 账户？'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text(AppLocalizations.of(context).text('取消')),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text(AppLocalizations.of(context).text('退出')),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    await widget.onLogout();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).text('已退出登录'))),
    );
  }

  Widget _selectionTile<T>({
    required String title,
    required T value,
    required Map<T, String> items,
    required ValueChanged<T> onChanged,
  }) {
    final localizations = AppLocalizations.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        localizations.text(title),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      trailing: DropdownButton<T>(
        value: value,
        underline: const SizedBox.shrink(),
        items: [
          for (final entry in items.entries)
            DropdownMenuItem(
              value: entry.key,
              child: Text(localizations.text(entry.value)),
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
