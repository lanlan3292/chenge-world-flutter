import 'package:flutter/material.dart';

import '../services/chenge_api.dart';
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
  int _section = 0;
  int? _pendingPeerId;
  int _launchNonce = 0;

  void _openChat(int peerId) {
    _pendingPeerId = peerId;
    setState(() {
      _section = 1;
      _launchNonce++;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('社交', style: TextStyle(fontWeight: FontWeight.w800))),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SegmentedButton<int>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 0, label: Text('好友'), icon: Icon(Icons.people_outline_rounded)),
                  ButtonSegment(value: 1, label: Text('聊天'), icon: Icon(Icons.chat_bubble_outline_rounded)),
                ],
                selected: {_section},
                onSelectionChanged: (selection) => setState(() => _section = selection.first),
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: _section,
                children: [
                  FriendsPage(
                    api: widget.api,
                    token: widget.token,
                    onOpenChat: _openChat,
                    onLoginRequested: widget.onLoginRequested,
                    showAppBar: false,
                  ),
                  ChatPage(
                    key: const ValueKey('social-chat'),
                    api: widget.api,
                    token: widget.token,
                    userId: widget.userId,
                    launchPeerId: _pendingPeerId,
                    launchNonce: _launchNonce,
                    onOpenFriends: () => setState(() => _section = 0),
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