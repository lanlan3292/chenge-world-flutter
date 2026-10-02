import 'package:flutter/material.dart';

import '../services/chenge_api.dart';
import 'ai_agent_page.dart';
import 'chat_page.dart';
import 'friends_page.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({
    super.key,
    required this.api,
    required this.token,
    required this.userId,
    required this.onLoginRequested,
  });

  final ChengeApi api;
  final String? token;
  final int? userId;
  final VoidCallback onLoginRequested;

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  /// 0 = 聊天（默认）, 1 = 好友, 2 = AI
  int _section = 0;
  int? _pendingPeerId;
  int _launchNonce = 0;
  /// 窄屏下进入会话线程时隐藏社交顶栏与分段，实现全屏聊天。
  bool _chatThreadOpen = false;

  void _openChat(int peerId) {
    _pendingPeerId = peerId;
    setState(() {
      _section = 0;
      _launchNonce++;
    });
  }

  void _onChatMobileThreadChanged(bool open) {
    if (_chatThreadOpen == open) return;
    setState(() => _chatThreadOpen = open);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 760;
    final hideChrome = !wide && _section == 0 && _chatThreadOpen;

    return Scaffold(
      appBar: hideChrome
          ? null
          : AppBar(title: const Text('社交', style: TextStyle(fontWeight: FontWeight.w800))),
      body: Column(
        children: [
          if (!hideChrome)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 0, label: Text('聊天'), icon: Icon(Icons.chat_bubble_outline_rounded)),
                  ButtonSegment(value: 1, label: Text('好友'), icon: Icon(Icons.people_outline_rounded)),
                  ButtonSegment(value: 2, label: Text('AI'), icon: Icon(Icons.smart_toy_outlined)),
                ],
                selected: {_section},
                onSelectionChanged: (selection) {
                  setState(() {
                    _section = selection.first;
                    if (_section != 0) _chatThreadOpen = false;
                  });
                },
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _section,
              children: [
                ChatPage(
                  key: const ValueKey('social-chat'),
                  api: widget.api,
                  token: widget.token,
                  userId: widget.userId,
                  launchPeerId: _pendingPeerId,
                  launchNonce: _launchNonce,
                  onOpenFriends: () => setState(() {
                    _section = 1;
                    _chatThreadOpen = false;
                  }),
                  onLoginRequested: widget.onLoginRequested,
                  showAppBar: false,
                  onMobileThreadChanged: _onChatMobileThreadChanged,
                ),
                FriendsPage(
                  api: widget.api,
                  token: widget.token,
                  onOpenChat: _openChat,
                  onLoginRequested: widget.onLoginRequested,
                  showAppBar: false,
                ),
                AiAgentPage(
                  key: const ValueKey('social-ai'),
                  api: widget.api,
                  token: widget.token,
                  onLoginRequested: widget.onLoginRequested,
                  showAppBar: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
