import 'package:flutter/material.dart';

import '../services/chenge_api.dart';

/// 服务端用户偏好：通知类型、免打扰、隐私。
class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({super.key, required this.api, required this.token});

  final ChengeApi api;
  final String token;

  @override
  State<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  static const _typeLabels = <String, String>{
    'friend': '好友',
    'message': '聊天消息',
    'like': '点赞',
    'comment': '评论',
    'mention': '@ 提及',
    'system': '系统',
  };

  Map<String, dynamic> _settings = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data = await widget.api.userSettings(widget.token);
      if (!mounted) return;
      setState(() {
        _settings = data;
        _loading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.message;
        _loading = false;
      });
    }
  }

  Map<String, dynamic> get _notify =>
      _settings['notify'] is Map ? Map<String, dynamic>.from(_settings['notify'] as Map) : {};

  Map<String, dynamic> get _types =>
      _notify['types'] is Map ? Map<String, dynamic>.from(_notify['types'] as Map) : {};

  Map<String, dynamic> get _dnd =>
      _notify['dnd'] is Map ? Map<String, dynamic>.from(_notify['dnd'] as Map) : {};

  Map<String, dynamic> get _privacy =>
      _settings['privacy'] is Map ? Map<String, dynamic>.from(_settings['privacy'] as Map) : {};

  Future<void> _save(Map<String, dynamic> next) async {
    final previous = _settings;
    setState(() => _settings = next);
    try {
      final saved = await widget.api.saveUserSettings(next, widget.token);
      if (!mounted) return;
      setState(() => _settings = saved.isEmpty ? next : saved);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _settings = previous);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  Future<void> _patchNotify(Map<String, dynamic> notify) =>
      _save({..._settings, 'notify': notify});

  Future<void> _setType(String key, bool value) {
    final types = {..._types, key: value};
    return _patchNotify({..._notify, 'types': types});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户设置', style: TextStyle(fontWeight: FontWeight.w800))),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('站内通知'),
                      subtitle: const Text('关闭后不再接收任何站内通知'),
                      value: _notify['site'] != false,
                      onChanged: (value) => _patchNotify({..._notify, 'site': value}),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: Text('通知类型', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    for (final entry in _typeLabels.entries)
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry.value),
                        value: _types[entry.key] != false,
                        onChanged: (value) => _setType(entry.key, value),
                      ),
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('免打扰'),
                      subtitle: Text('${_dnd['start'] ?? '23:00'} – ${_dnd['end'] ?? '07:00'}'),
                      value: _dnd['enabled'] == true,
                      onChanged: (value) => _patchNotify({
                        ..._notify,
                        'dnd': {..._dnd, 'enabled': value},
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 4),
                      child: Text('隐私', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('显示在线状态'),
                      value: _privacy['onlineVisible'] != false,
                      onChanged: (value) => _save({
                        ..._settings,
                        'privacy': {..._privacy, 'onlineVisible': value},
                      }),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('显示位置'),
                      value: _privacy['locationVisible'] != false,
                      onChanged: (value) => _save({
                        ..._settings,
                        'privacy': {..._privacy, 'locationVisible': value},
                      }),
                    ),
                  ],
                ),
    );
  }
}
