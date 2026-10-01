import 'package:flutter/material.dart';

import '../services/chenge_api.dart';
import '../services/settings_store.dart';
import '../theme/app_theme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
    required this.api,
    required this.token,
    required this.username,
    required this.onLogin,
    required this.onLogout,
    required this.onOpenTasks,
    required this.settings,
    required this.onSettingsChanged,
  });

  final ChengeApi api;
  final String? token;
  final String? username;
  final Future<void> Function(Map<String, dynamic>) onLogin;
  final Future<void> Function() onLogout;
  final VoidCallback onOpenTasks;
  final SettingsStore settings;
  final Future<void> Function() onSettingsChanged;

  @override
  Widget build(BuildContext context) {
    final signedIn = token != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            tooltip: '设置',
            onPressed: () => _showSettings(context, signedIn),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.all(22),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppTheme.ink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(color: AppTheme.citrus, borderRadius: BorderRadius.circular(20)),
                      child: Icon(signedIn ? Icons.person_rounded : Icons.lock_open_rounded, color: AppTheme.ink, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(signedIn ? (username ?? '已登录') : '欢迎来到社区',
                            style: const TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text(signedIn ? '账户已连接到 ChengeWorld' : '登录后浏览个性化内容',
                            style: const TextStyle(color: Color(0xFFC4D8D0))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  onTap: onOpenTasks,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(color: const Color(0xFFFFE8C5), borderRadius: BorderRadius.circular(14)),
                    child: const Icon(Icons.task_alt_rounded, color: AppTheme.ink),
                  ),
                  title: const Text('任务中心', style: TextStyle(fontWeight: FontWeight.w800)),
                  subtitle: const Text('签到、完成任务并领取 ChengeCoin'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
              const SizedBox(height: 24),
              if (!signedIn)
                FilledButton.icon(
                  onPressed: () => _showLogin(context),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('登录账户'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSettings(BuildContext context, bool signedIn) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => _SettingsSheet(
        signedIn: signedIn,
        settings: settings,
        onSettingsChanged: onSettingsChanged,
        onLogout: onLogout,
      ),
    );
  }

  Future<void> _showLogin(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _LoginDialog(api: api),
    );
    if (result == null || !context.mounted) return;
    await onLogin(result);
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('登录成功')));
  }
}

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet({
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
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late bool _useDynamic;
  late Color _seed;
  late bool _statusImmersive;
  late bool _navImmersive;

  @override
  void initState() {
    super.initState();
    _useDynamic = widget.settings.useDynamicColor;
    _seed = widget.settings.seedColor;
    _statusImmersive = widget.settings.statusBarImmersive;
    _navImmersive = widget.settings.navigationBarImmersive;
  }

  Future<void> _apply() => widget.onSettingsChanged();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottom = MediaQuery.paddingOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(18, 4, 18, 18 + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              child: Text('设置', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 4, top: 4, bottom: 6),
              child: Text('外观', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF70817D))),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              secondary: Icon(Icons.wallpaper_rounded, color: theme.colorScheme.primary),
              title: const Text('动态取色', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('使用 Android 12+ 壁纸配色（Material You）'),
              value: _useDynamic,
              onChanged: (value) async {
                setState(() => _useDynamic = value);
                await widget.settings.setUseDynamicColor(value);
                await _apply();
              },
            ),
            if (!_useDynamic) ...[
              const Padding(
                padding: EdgeInsets.only(left: 4, top: 8, bottom: 10),
                child: Text('主题色', style: TextStyle(fontWeight: FontWeight.w700)),
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
                          await widget.settings.setSeedColor(color);
                          await _apply();
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
            const Padding(
              padding: EdgeInsets.only(left: 4, top: 12, bottom: 6),
              child: Text('系统栏', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF70817D))),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              secondary: Icon(Icons.vertical_align_top_rounded, color: theme.colorScheme.primary),
              title: const Text('状态栏沉浸', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('内容延伸至状态栏下方，状态栏透明'),
              value: _statusImmersive,
              onChanged: (value) async {
                setState(() => _statusImmersive = value);
                await widget.settings.setStatusBarImmersive(value);
                await _apply();
              },
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              secondary: Icon(Icons.vertical_align_bottom_rounded, color: theme.colorScheme.primary),
              title: const Text('导航栏沉浸', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('内容延伸至导航栏下方，导航栏透明'),
              value: _navImmersive,
              onChanged: (value) async {
                setState(() => _navImmersive = value);
                await widget.settings.setNavigationBarImmersive(value);
                await _apply();
              },
            ),
            const Divider(height: 28),
            if (widget.signedIn)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                leading: const Icon(Icons.logout_rounded, color: AppTheme.coral),
                title: const Text('退出登录', style: TextStyle(color: AppTheme.coral, fontWeight: FontWeight.w700)),
                onTap: () async {
                  Navigator.pop(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text('退出登录'),
                      content: const Text('确定退出当前 ChengeWorld 账户？'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('取消')),
                        FilledButton.tonal(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('退出')),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                  await widget.onLogout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已退出登录')));
                  }
                },
              )
            else
              const ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                leading: Icon(Icons.lock_outline_rounded, color: AppTheme.leaf),
                title: Text('登录后可管理账户设置'),
              ),
          ],
        ),
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
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 20)
            : null,
      ),
    );
  }
}

class _LoginDialog extends StatefulWidget {
  const _LoginDialog({required this.api});

  final ChengeApi api;

  @override
  State<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<_LoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await widget.api.login(_username.text.trim(), _password.text);
      if (mounted) Navigator.pop(context, result);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        icon: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(color: const Color(0xFFE0F0E8), borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.waving_hand_rounded, color: AppTheme.leaf),
        ),
        title: const Text('登录 ChengeWorld', textAlign: TextAlign.center,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
        content: SizedBox(
          width: 390,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _username,
                  autofocus: true,
                  enabled: !_loading,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.username],
                  decoration: const InputDecoration(labelText: '用户名', prefixIcon: Icon(Icons.person_outline_rounded)),
                  validator: (value) => value == null || value.trim().isEmpty ? '请输入用户名' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  enabled: !_loading,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: '密码',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword ? '显示密码' : '隐藏密码',
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  ),
                  validator: (value) => value == null || value.isEmpty ? '请输入密码' : null,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppTheme.coral), textAlign: TextAlign.center),
                ],
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(onPressed: _loading ? null : () => Navigator.pop(context), child: const Text('取消')),
          FilledButton.icon(
            onPressed: _loading ? null : _submit,
            icon: _loading
                ? const SizedBox.square(dimension: 17, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.login_rounded),
            label: Text(_loading ? '正在登录' : '登录'),
          ),
        ],
      );
}
