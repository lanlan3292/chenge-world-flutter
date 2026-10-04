import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
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
              ? CachedNetworkImage(
                imageUrl: _avatarUrl!,
                fadeInDuration: const Duration(milliseconds: 120),
                fadeOutDuration: const Duration(milliseconds: 80),
                fit: BoxFit.cover,
                width: 60,
                height: 60,
                errorWidget:
                    (_, __, ___) => Icon(
                      Icons.person_rounded,
                      color: scheme.onTertiaryContainer,
                      size: 30,
                    ),
                placeholder: (context, _) => Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.onTertiaryContainer,
                    ),
                  ),
                ),
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
          content: Text(
            AppLocalizations.of(context).signInToUseChengeCore,
          ),
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

  void _openNurture(BuildContext context) {
    final token = widget.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).signInToUseRaising,
          ),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => NurturePage(
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
          AppLocalizations.of(context).account,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            tooltip: AppLocalizations.of(context).settings,
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
                                    AppLocalizations.of(context).signedIn)
                                : AppLocalizations.of(context).welcome,
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
                            signedIn ? AppLocalizations.of(context).accountConnected : AppLocalizations.of(context).signInForPersonalized,
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
                    AppLocalizations.of(context).taskCenter,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).taskCenterDescription,
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
                    AppLocalizations.of(context).chengeCore,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).openCoreEcosystem,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
              const SizedBox(height: 12),
              Material(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
                child: ListTile(
                  onTap: () => _openNurture(context),
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
                      Icons.pets_rounded,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).raising,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  subtitle: Text(
                    AppLocalizations.of(context).openRaisingSystem,
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
              const SizedBox(height: 24),
              if (!signedIn) ...[
                FilledButton.icon(
                  onPressed: () => _showLogin(context),
                  icon: const Icon(Icons.login_rounded),
                  label: Text(AppLocalizations.of(context).signInAccount),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _showRegister(context),
                  icon: const Icon(Icons.person_add_alt_1_rounded),
                  label: Text(AppLocalizations.of(context).registerAccount),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// 设置页修改 Token 后：校验已在设置页完成，这里保存并刷新会话。
  /// 空字符串表示清除令牌并退出登录。
  Future<void> _applyToken(String token) async {
    final trimmed = token.trim();
    if (trimmed.isEmpty) {
      await widget.onLogout();
      if (mounted) setState(() => _avatarUrl = null);
      return;
    }
    try {
      final current = await widget.api.currentUser(trimmed);
      final result = <String, dynamic>{
        'token': trimmed,
        ...current,
      };
      if (result['user'] == null) {
        result['user'] = current['user'] ?? current;
      }
      await widget.onLogin(result);
      final avatar = _pickAvatar(result);
      if (mounted) setState(() => _avatarUrl = avatar);
    } on ApiException {
      rethrow;
    }
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
              token: widget.token,
              api: widget.api,
              onTokenChanged: _applyToken,
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
        SnackBar(content: Text(AppLocalizations.of(context).signInSuccess)),
      );
    }
    await _loadAvatar();
  }


  Future<void> _showRegister(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _RegisterDialog(api: widget.api),
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).registerSuccess)),
      );
      await _showLogin(context);
    }
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

  Future<void> _openTokenLogin() async {
    if (_loading) return;
    final token = await showDialog<String>(
      context: context,
      builder: (_) => const _TokenLoginDialog(),
    );
    if (token == null || token.isEmpty || !mounted) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final current = await widget.api.currentUser(token);
      // 构造成与密码登录相近的结构，供 onLogin / 头像解析使用
      final result = <String, dynamic>{
        'token': token,
        ...current,
      };
      if (result['user'] == null) {
        result['user'] = current['user'] ?? current;
      }
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
      AppLocalizations.of(context).signInToChengeWorld,
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
                labelText: AppLocalizations.of(context).username,
                prefixIcon: const Icon(Icons.person_outline_rounded),
              ),
              validator:
                  (value) =>
                      value == null || value.trim().isEmpty
                          ? AppLocalizations.of(context).enterUsername
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
                labelText: AppLocalizations.of(context).password,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                suffixIcon: IconButton(
                  tooltip: _obscurePassword
                      ? AppLocalizations.of(context).showPassword
                      : AppLocalizations.of(context).hidePassword,
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
                          ? AppLocalizations.of(context).enterPassword
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
        child: Text(AppLocalizations.of(context).cancel),
      ),
      TextButton(
        onPressed: _loading ? null : _openTokenLogin,
        child: Text(AppLocalizations.of(context).signInWithToken),
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
          _loading ? AppLocalizations.of(context).signingIn : AppLocalizations.of(context).signIn,
        ),
      ),
    ],
  );
}

class _TokenLoginDialog extends StatefulWidget {
  const _TokenLoginDialog();

  @override
  State<_TokenLoginDialog> createState() => _TokenLoginDialogState();
}

class _TokenLoginDialogState extends State<_TokenLoginDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).signInWithToken,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 390,
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: _controller,
            autofocus: true,
            maxLines: 4,
            minLines: 2,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context).accessToken,
              hintText: AppLocalizations.of(context).pasteJwtToken,
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context).enterToken;
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        FilledButton(
          onPressed: _confirm,
          child: Text(AppLocalizations.of(context).confirmSignIn),
        ),
      ],
    );
  }
}


class _RegisterDialog extends StatefulWidget {
  const _RegisterDialog({required this.api});

  final ChengeApi api;

  @override
  State<_RegisterDialog> createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<_RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _nickname = TextEditingController();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  bool _sendingCode = false;
  int _countdown = 0;
  String? _error;

  @override
  void dispose() {
    _username.dispose();
    _nickname.dispose();
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).fillEmailFirst);
      return;
    }
    if (_sendingCode || _countdown > 0) return;
    setState(() {
      _sendingCode = true;
      _error = null;
    });
    try {
      await widget.api.sendEmailCode(email);
      if (!mounted) return;
      setState(() => _countdown = 60);
      // 简单倒计时
      Future.doWhile(() async {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (!mounted) return false;
        setState(() => _countdown = (_countdown - 1).clamp(0, 60));
        return _countdown > 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).emailCodeSent)),
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _sendingCode = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _loading) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await widget.api.register(
        username: _username.text.trim(),
        password: _password.text,
        email: _email.text.trim(),
        code: _code.text.trim(),
        nickname: _nickname.text.trim().isEmpty
            ? null
            : _nickname.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          Icons.person_add_alt_1_rounded,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(
        AppLocalizations.of(context).registerTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
      ),
      content: SizedBox(
        width: 390,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _username,
                  enabled: !_loading,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).username,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty)
                          ? AppLocalizations.of(context).enterUsername
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nickname,
                  enabled: !_loading,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).nicknameOptional,
                    prefixIcon: const Icon(Icons.badge_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  enabled: !_loading,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).email,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return AppLocalizations.of(context).enterEmail;
                    }
                    if (!v.contains('@')) {
                      return AppLocalizations.of(context).invalidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _code,
                        enabled: !_loading,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).emailCode,
                          prefixIcon: const Icon(Icons.pin_outlined),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? AppLocalizations.of(context).enterEmailCode
                                : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FilledButton.tonal(
                        onPressed: (_sendingCode || _countdown > 0 || _loading)
                            ? null
                            : _sendCode,
                        child: Text(
                          _countdown > 0
                              ? '${_countdown}s'
                              : (_sendingCode
                                  ? AppLocalizations.of(context).sendingCode
                                  : AppLocalizations.of(context).getEmailCode),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  enabled: !_loading,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).passwordMinSix,
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return AppLocalizations.of(context).enterPassword;
                    }
                    if (v.length < 6) {
                      return AppLocalizations.of(context).passwordTooShort;
                    }
                    return null;
                  },
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
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        FilledButton.icon(
          onPressed: _loading ? null : _submit,
          icon: _loading
              ? const SizedBox.square(
                  dimension: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.person_add_alt_1_rounded),
          label: Text(
            _loading
                ? AppLocalizations.of(context).registering
                : AppLocalizations.of(context).register,
          ),
        ),
      ],
    );
  }
}
