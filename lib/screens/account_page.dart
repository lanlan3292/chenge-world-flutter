import 'package:flutter/material.dart';

import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
    required this.api,
    required this.token,
    required this.username,
    required this.onLogin,
    required this.onLogout,
  });

  final ChengeApi api;
  final String? token;
  final String? username;
  final Future<void> Function(Map<String, dynamic>) onLogin;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    final signedIn = token != null;
    return Scaffold(
      appBar: AppBar(title: const Text('账户', style: TextStyle(fontWeight: FontWeight.w800))),
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
              if (signedIn)
                OutlinedButton.icon(
                  onPressed: () async {
                    await onLogout();
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('已退出登录')));
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('退出登录'),
                )
              else
                FilledButton.icon(
                  onPressed: () => _showLogin(context),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('登录账户'),
                ),
              const SizedBox(height: 24),
              const Text('连接状态', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                leading: const Icon(Icons.dns_outlined, color: AppTheme.leaf),
                title: const Text('ChengeWorld 服务'),
                subtitle: const Text('8.138.13.61'),
                trailing: const Icon(Icons.circle, size: 10, color: AppTheme.leaf),
              ),
            ],
          ),
        ),
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