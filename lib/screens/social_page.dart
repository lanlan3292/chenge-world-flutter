import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../services/chenge_api.dart';
import '../services/settings_store.dart';
import 'ai_agent_page.dart';
import 'chat_page.dart';
import 'friends_page.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({
    super.key,
    required this.api,
    required this.token,
    required this.userId,
    required this.settings,
    required this.onLoginRequested,
    this.isActive = true,
  });

  final ChengeApi api;
  final String? token;
  final int? userId;
  final SettingsStore settings;
  final VoidCallback onLoginRequested;
  final bool isActive;

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  /// 0 = 聊天（默认）, 1 = 通讯录, 2 = AI
  int _section = 0;
  int? _pendingPeerId;
  int? _pendingConversationId;
  int _launchNonce = 0;

  void _openChat(int peerId) {
    _pendingPeerId = peerId;
    _pendingConversationId = null;
    setState(() {
      _section = 0;
      _launchNonce++;
    });
  }

  void _openConversation(int conversationId) {
    _pendingPeerId = null;
    _pendingConversationId = conversationId;
    setState(() {
      _section = 0;
      _launchNonce++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).social,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(AppLocalizations.of(context).chat),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(AppLocalizations.of(context).contacts),
                  icon: const Icon(Icons.contacts_outlined),
                ),
                ButtonSegment(
                  value: 2,
                  label: Text('AI'),
                  icon: const Icon(Icons.smart_toy_outlined),
                ),
              ],
              selected: {_section},
              onSelectionChanged:
                  (selection) => setState(() => _section = selection.first),
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
                  settings: widget.settings,
                  isActive: widget.isActive && _section == 0,
                  launchPeerId: _pendingPeerId,
                  launchConversationId: _pendingConversationId,
                  launchNonce: _launchNonce,
                  onOpenFriends: () => setState(() => _section = 1),
                  onLoginRequested: widget.onLoginRequested,
                  showAppBar: false,
                ),
                FriendsPage(
                  api: widget.api,
                  token: widget.token,
                  onOpenChat: _openChat,
                  onOpenConversation: _openConversation,
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
