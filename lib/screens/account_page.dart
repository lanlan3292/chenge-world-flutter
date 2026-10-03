import 'package:flutter/material.dart';

import '../l10n/app_localizations_text.dart';
import '../services/chenge_api.dart';
import '../services/settings_store.dart';
import 'chenge_core_page.dart';
import 'settings_page.dart';
import '../theme/app_theme.dart';

class AccountPage extends StatefulWidget {
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
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? _avatarUrl;
  bool _avatarLoading = false;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  @override
  void didUpdateWidget(covariant AccountPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _avatarUrl = null;
      _loadAvatar();
    }
  }

  Future<void> _loadAvatar() async {
    final token = widget.token;
    if (token == null) {
      if (mounted) setState(() => _avatarUrl = null);
      return;
    }
    setState(() => _avatarLoading = true);
    try {
      final current = await widget.api.currentUser(token);
      // 后端 /home/me：avatar 在 profiles.avatar，不在 user 上
      String? avatar = _pickAvatar(current);
      if (mounted) setState(() => _avatarUrl = avatar);
    } on ApiException {
      // 保持占位头像
    } finally {
      if (mounted) setState(() => _avatarLoading = false);
    }
  }

  Widget _profileAvatar(BuildContext context, bool signedIn) {
    final scheme = Theme.of(context).colorScheme;
    final hasAvatar =
        signedIn && _avatarUrl != null && _avatarUrl!.trim().isNotEmpty;
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          hasAvatar
              ? Image.network(
                _avatarUrl!,
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                errorBuilder:
                    (_, __, ___) => Icon(
                      Icons.person_rounded,
                      color: scheme.onTertiaryContainer,
                      size: 30,
                    ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: scheme.onTertiaryContainer,
                      ),
                    ),
                  );
                },
              )
              : Icon(
                signedIn
                    ? (_avatarLoading
                        ? Icons.person_outline_rounded
                        : Icons.person_rounded)
                    : Icons.lock_open_rounded,
                color: scheme.onTertiaryContainer,
                size: 30,
              ),
    );
  }

  void _openChengeCore(BuildContext context) {
    final token = widget.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).text('请先登录后再使用 ChengeCore')),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => ChengeCorePage(
              baseUrl: widget.api.baseUrl,
              token: token,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = widget.token != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).text('我的'),
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).text('设置'),
            onPressed: () => _openSettings(context, signedIn),
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
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _profileAvatar(context, signedIn),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            signedIn
                                ? (widget.username ??
                                    AppLocalizations.of(context).text('已登录'))
                                : AppLocalizations.of(context).text('欢迎来到社区'),
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                              fontSize: 21,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AppLocalizations.of(context).text(
                              signedIn ? '账户已连接到 ChengeWorld' : '登录后浏览个性化内容',
                            ),
                            style: TextStyle(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Material(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  onTap: widget.onOpenTasks,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 3,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.task_alt_rounded,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).text('任务中心'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).text('签到、完成任务并领取 ChengeCoin'),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  onTap: () => _openChengeCore(context),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 3,
                  ),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.hub_rounded,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).text('ChengeCore'),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).text('打开核心生态'),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
              const SizedBox(height: 24),
              if (!signedIn)
                FilledButton.icon(
                  onPressed: () => _showLogin(context),
                  icon: const Icon(Icons.login_rounded),
                  label: Text(AppLocalizations.of(context).text('登录账户')),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSettings(BuildContext context, bool signedIn) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder:
            (_) => SettingsPage(
              signedIn: signedIn,
              settings: widget.settings,
              onSettingsChanged: widget.onSettingsChanged,
              onLogout: widget.onLogout,
            ),
      ),
    );
  }

  Future<void> _showLogin(BuildContext context) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => _LoginDialog(api: widget.api),
    );
    if (result == null || !context.mounted) return;
    await widget.onLogin(result);
    final fromLogin = _pickAvatar(result);
    if (fromLogin != null && mounted) {
      setState(() => _avatarUrl = fromLogin);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).text('登录成功'))),
      );
    }
    await _loadAvatar();
  }

  /// 从 /home/me 或登录响应中取出头像 URL（profiles.avatar 优先）。
  static String? _pickAvatar(Map<String, dynamic> payload) {
    String? clean(Object? v) {
      final s = v?.toString().trim();
      if (s == null || s.isEmpty || s == 'null' || s == 'undefined') return null;
      return s;
    }

    final profiles = payload['profiles'];
    if (profiles is Map) {
      final a = clean(profiles['avatar'] ?? profiles['avatarUrl']);
      if (a != null) return a;
    }
    final user = payload['user'];
    if (user is Map) {
      final a = clean(user['avatar'] ?? user['avatarUrl']);
      if (a != null) return a;
    }
    return clean(payload['avatar'] ?? payload['avatarUrl']);
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
      final result = await widget.api.login(
        _username.text.trim(),
        _password.text,
      );
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        Icons.waving_hand_rounded,
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    ),
    title: Text(
      AppLocalizations.of(context).text('登录 ChengeWorld'),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
    ),
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).text('用户名'),
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context).text('请输入用户名')
                          : null,
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
                labelText: AppLocalizations.of(context).text('密码'),
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: AppLocalizations.of(
                    context,
                  ).text(_obscurePassword ? '显示密码' : '隐藏密码'),
                  onPressed:
                      () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator:
                  (value) =>
                      value == null || value.isEmpty
                          ? AppLocalizations.of(context).text('请输入密码')
                          : null,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                _error!,
                style: const TextStyle(color: AppTheme.coral),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    ),
    actionsAlignment: MainAxisAlignment.center,
    actions: [
      TextButton(
        onPressed: _loading ? null : () => Navigator.pop(context),
        child: Text(AppLocalizations.of(context).text('取消')),
      ),
      FilledButton.icon(
        onPressed: _loading ? null : _submit,
        icon:
            _loading
                ? const SizedBox.square(
                  dimension: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : const Icon(Icons.login_rounded),
        label: Text(
          AppLocalizations.of(context).text(_loading ? '正在登录' : '登录'),
        ),
      ),
    ],
  );
}
