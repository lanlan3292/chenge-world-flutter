import 'package:flutter/material.dart';

import '../services/settings_store.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
    required this.signedIn,
    required this.settings,
    required this.onSettingsChanged,
    required this.onLogout,
  });

  final bool signedIn;
  final SettingsStore settings;
  final Future<void> Function() onSettingsChanged;
  final Future<void> Function() onLogout;

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
  late bool _predictiveBack;
  late int _feedMinColumns;
  late int _feedMaxColumns;
  late int _shopMinColumns;
  late int _shopMaxColumns;
  late bool _chatShowSelfAvatar;
  late bool _chatShowPeerAvatar;

  @override
  void initState() {
    super.initState();
    _useDynamic = widget.settings.useDynamicColor;
    _seed = widget.settings.seedColor;
    _statusImmersive = widget.settings.statusBarImmersive;
    _navImmersive = widget.settings.navigationBarImmersive;
    _autoHideTop = widget.settings.autoHideTopBar;
    _autoHideBottom = widget.settings.autoHideBottomBar;
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
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF70817D),
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
            '当前：$lo – $hi 列（宽度足够时在此范围内自适应）',
            style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text('1', style: TextStyle(fontSize: 12, color: Color(0xFF70817D))),
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
                    setState(() => setLocal(
                          nextMin <= nextMax ? nextMin : nextMax,
                          nextMin <= nextMax ? nextMax : nextMin,
                        ));
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
              const Text('3', style: TextStyle(fontSize: 12, color: Color(0xFF70817D))),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('最小 $lo', style: const TextStyle(fontSize: 11, color: Color(0xFF70817D))),
                Text('最大 $hi', style: const TextStyle(fontSize: 11, color: Color(0xFF70817D))),
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
        title: const Text('设置', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
              children: [
                _sectionTitle('外观'),
                _switchTile(
                  icon: Icons.wallpaper_rounded,
                  title: '动态取色',
                  subtitle: '使用 Android 12+ 壁纸配色（Material You）',
                  value: _useDynamic,
                  setValue: (value) => _useDynamic = value,
                  saveValue: widget.settings.setUseDynamicColor,
                ),
                if (!_useDynamic) ...[
                  const Padding(
                    padding: EdgeInsets.only(left: 4, top: 8, bottom: 10),
                    child: Text(
                      '主题色',
                      style: TextStyle(fontWeight: FontWeight.w700),
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
                const Divider(height: 28),
                if (widget.signedIn)
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    leading: const Icon(
                      Icons.logout_rounded,
                      color: AppTheme.coral,
                    ),
                    title: const Text(
                      '退出登录',
                      style: TextStyle(
                        color: AppTheme.coral,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: _confirmLogout,
                  )
                else
                  const ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 4),
                    leading: Icon(
                      Icons.lock_outline_rounded,
                      color: AppTheme.leaf,
                    ),
                    title: Text('登录后可管理账户设置'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('退出登录'),
            content: const Text('确定退出当前 ChengeWorld 账户？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('取消'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('退出'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    await widget.onLogout();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('已退出登录')));
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
            color: selected ? Colors.black87 : Colors.transparent,
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
