import 'package:material_ui/material_ui.dart';

import '../services/chenge_api.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key, required this.api, required this.token, required this.userId});
  final ChengeApi api;
  final String token;
  final int userId;

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final Future<Map<String, dynamic>> _data = widget.api.currentUser(widget.token);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('用户资料')),
    body: FutureBuilder<Map<String, dynamic>>(
      future: _data,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (snapshot.hasError) return Center(child: Text('资料加载失败：${snapshot.error}'));
        final data = snapshot.data ?? const <String, dynamic>{};
        final profile = data['profiles'] is Map ? Map<String, dynamic>.from(data['profiles'] as Map) : const <String, dynamic>{};
        final name = (profile['nickname'] ?? data['nickname'] ?? data['username'] ?? '用户').toString();
        final bio = (profile['bio'] ?? data['bio'] ?? '这个用户还没有填写个人简介').toString();
        return ListView(padding: const EdgeInsets.all(24), children: [
          CircleAvatar(radius: 42, child: Text(name.characters.first)),
          const SizedBox(height: 14),
          Center(child: Text(name, style: Theme.of(context).textTheme.headlineSmall)),
          Center(child: Text('用户 ID：${widget.userId}', style: Theme.of(context).textTheme.bodySmall)),
          const SizedBox(height: 24),
          Card(child: Padding(padding: const EdgeInsets.all(16), child: Text(bio, style: Theme.of(context).textTheme.bodyLarge))),
        ]);
      },
    ),
  );
}
