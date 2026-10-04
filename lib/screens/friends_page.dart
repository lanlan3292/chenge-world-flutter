import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/chat_conversation.dart';
import '../models/friend_user.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({
    super.key,
    required this.api,
    required this.token,
    required this.onOpenChat,
    required this.onLoginRequested,
    this.onOpenConversation,
    this.showAppBar = true,
  });

  final ChengeApi api;
  final String? token;
  final ValueChanged<int> onOpenChat;
  final ValueChanged<int>? onOpenConversation;
  final VoidCallback onLoginRequested;
  final bool showAppBar;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _searchController = TextEditingController();
  final _friends = <FriendUser>[];
  final _requests = <FriendUser>[];
  final _results = <FriendUser>[];
  final _groups = <ChatConversation>[];
  final _groupResults = <ChatConversation>[];
  final _busyIds = <int>{};
  final _online = <int, bool>{};
  String _section = 'friends';
  String _searchMode = 'user'; // user | group
  String _error = '';
  int _searchGeneration = 0;
  bool _loading = false;
  bool _searching = false;
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    _refreshLists();
  }

  @override
  void didUpdateWidget(covariant FriendsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _friends.clear();
      _requests.clear();
      _results.clear();
      _groups.clear();
      _groupResults.clear();
      _online.clear();
      _searched = false;
      if (widget.token != null) _refreshLists();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refreshLists() async {
    final token = widget.token;
    if (token == null || _loading) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    try {
      final data = await Future.wait([
        widget.api.friends(token),
        widget.api.friendRequests(token),
        widget.api.conversations(token),
      ]);
      if (!mounted) return;
      final conversations = data[2] as List<ChatConversation>;
      setState(() {
        _friends
          ..clear()
          ..addAll(data[0] as List<FriendUser>);
        _requests
          ..clear()
          ..addAll(data[1] as List<FriendUser>);
        _groups
          ..clear()
          ..addAll(conversations.where((c) => c.type == 'group'));
      });
      _refreshOnlineStatus();
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refreshOnlineStatus() async {
    final token = widget.token;
    if (token == null || _friends.isEmpty) return;
    final ids = _friends.map((f) => f.userId).toList();
    final results = await Future.wait(
      ids.map((id) async {
        try {
          return MapEntry(id, await widget.api.isUserOnline(id, token));
        } catch (_) {
          return MapEntry(id, false);
        }
      }),
    );
    if (!mounted) return;
    setState(() {
      for (final e in results) {
        _online[e.key] = e.value;
      }
    });
  }

  Future<void> _search() async {
    final keyword = _searchController.text.trim();
    if (keyword.isEmpty) {
      _showMessage(_searchMode == 'group' ? AppLocalizations.of(context).enterGroupNameKeyword : AppLocalizations.of(context).enterUserSearchHint);
      return;
    }
    final token = widget.token;
    if (token == null) return;
    final generation = ++_searchGeneration;
    setState(() {
      _searching = true;
      _searched = true;
      _error = '';
    });
    try {
      if (_searchMode == 'group') {
        final groups = await widget.api.searchGroups(keyword, token);
        if (!mounted || generation != _searchGeneration) return;
        setState(() {
          _groupResults
            ..clear()
            ..addAll(groups);
          _results.clear();
        });
      } else {
        final users = await widget.api.searchUsers(keyword, token);
        if (!mounted || generation != _searchGeneration) return;
        setState(() {
          _results
            ..clear()
            ..addAll(users);
          _groupResults.clear();
        });
      }
    } on ApiException catch (error) {
      if (mounted && generation == _searchGeneration) {
        setState(() => _error = error.message);
      }
    } finally {
      if (mounted && generation == _searchGeneration) {
        setState(() => _searching = false);
      }
    }
  }

  Future<void> _runAction(
    FriendUser user,
    Future<void> Function() action,
    String successMessage, {
    bool updateSearch = false,
  }) async {
    if (_busyIds.contains(user.userId)) return;
    setState(() => _busyIds.add(user.userId));
    try {
      await action();
      if (!mounted) return;
      _showMessage(successMessage);
      await _refreshLists();
      if (updateSearch && _searchController.text.trim().isNotEmpty) {
        await _search();
      }
    } on ApiException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } finally {
      if (mounted) setState(() => _busyIds.remove(user.userId));
    }
  }

  Future<void> _apply(FriendUser user) => _runAction(
    user,
    () => widget.api.applyFriend(user.userId, widget.token!),
    user.iReceived ? AppLocalizations.of(context).friendAddedBack : AppLocalizations.of(context).friendRequestSent,
    updateSearch: true,
  );

  Future<void> _remove(FriendUser user, {required bool reject}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(reject ? AppLocalizations.of(context).rejectFriendRequest : AppLocalizations.of(context).removeFriend),
            content: Text(
              reject
                  ? AppLocalizations.of(context).confirmRejectFriendRequest(user.displayName)
                  : AppLocalizations.of(context).confirmRemoveFriend(user.displayName),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(AppLocalizations.of(context).cancel),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context, true),
                child: Text(reject ? AppLocalizations.of(context).reject : AppLocalizations.of(context).remove),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    await _runAction(
      user,
      () => widget.api.removeFriend(user.userId, widget.token!),
      reject ? AppLocalizations.of(context).friendRequestRejected : AppLocalizations.of(context).friendRemoved,
      updateSearch: true,
    );
  }

  Future<void> _editRemark(FriendUser user) async {
    final remark = await showDialog<String>(
      context: context,
      builder: (dialogContext) => _EditRemarkDialog(
        initialRemark: user.remark ?? '',
      ),
    );
    if (remark == null || !mounted) return;
    await _runAction(
      user,
      () => widget.api.setFriendRemark(user.userId, remark, widget.token!),
      remark.isEmpty ? AppLocalizations.of(context).remarkCleared : AppLocalizations.of(context).remarkSaved,
    );
  }

  Future<void> _joinGroup(ChatConversation group) async {
    final token = widget.token;
    if (token == null || _busyIds.contains(group.id)) return;
    setState(() => _busyIds.add(group.id));
    try {
      await widget.api.joinGroup(group.id, token);
      if (!mounted) return;
      _showMessage(AppLocalizations.of(context).joinedGroup(group.name));
      setState(() => _groupResults.removeWhere((g) => g.id == group.id));
      await _refreshLists();
      widget.onOpenConversation?.call(group.id);
    } on ApiException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } finally {
      if (mounted) setState(() => _busyIds.remove(group.id));
    }
  }

  Future<void> _createGroup() async {
    final token = widget.token;
    if (token == null) return;

    final result = await showDialog<_CreateGroupResult>(
      context: context,
      builder: (dialogContext) => _CreateGroupDialog(friends: _friends),
    );
    if (result == null || !mounted) return;
    if (result.name.isEmpty) {
      _showMessage(AppLocalizations.of(context).enterGroupName, isError: true);
      return;
    }

    try {
      final conversation = await widget.api.createGroupChat(
        name: result.name,
        memberIds: result.memberIds,
        token: token,
      );
      if (!mounted) return;
      _showMessage(AppLocalizations.of(context).groupCreated(conversation.name));
      await _refreshLists();
      widget.onOpenConversation?.call(conversation.id);
    } on ApiException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    }
  }

  void _openFriendChat(FriendUser user) => widget.onOpenChat(user.userId);

  void _openGroupChat(ChatConversation group) {
    final open = widget.onOpenConversation;
    if (open != null) {
      open(group.id);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppTheme.coral : null,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar:
          widget.showAppBar
              ? AppBar(
                title: Text(
                  AppLocalizations.of(context).contacts,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                actions: [
                  if (widget.token != null)
                    IconButton(
                      tooltip: AppLocalizations.of(context).createGroupChat,
                      onPressed: _createGroup,
                      icon: const Icon(Icons.group_add_rounded),
                    ),
                  if (widget.token != null)
                    IconButton(
                      tooltip: AppLocalizations.of(context).refresh,
                      onPressed: _loading ? null : _refreshLists,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  const SizedBox(width: 8),
                ],
              )
              : null,
      body:
          widget.token == null
              ? _signedOut()
              : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: width >= 1000 ? 900 : 720,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (!widget.showAppBar)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _createGroup,
                              icon: const Icon(
                                Icons.group_add_rounded,
                                size: 18,
                              ),
                              label: Text(AppLocalizations.of(context).createGroupChat),
                            ),
                          ),
                        _sectionSelector(),
                        if (_section == 'search') ...[
                          const SizedBox(height: 14),
                          _searchField(),
                        ],
                        if (_error.isNotEmpty) _errorBanner(),
                        const SizedBox(height: 12),
                        Expanded(child: _content()),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Widget _signedOut() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.contacts_outlined, size: 56, color: AppTheme.leaf),
          const SizedBox(height: 14),
          Text(
            AppLocalizations.of(context).signInToManageContacts,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).contactsSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: widget.onLoginRequested,
            icon: const Icon(Icons.login_rounded),
            label: Text(AppLocalizations.of(context).goSignIn),
          ),
        ],
      ),
    ),
  );

  Widget _sectionSelector() => SegmentedButton<String>(
    showSelectedIcon: false,
    segments: [
      ButtonSegment(
        value: 'friends',
        label: Text(AppLocalizations.of(context).friendsTab(_friends.length)),
        icon: const Icon(Icons.people_outline_rounded),
      ),
      ButtonSegment(
        value: 'groups',
        label: Text(AppLocalizations.of(context).groupsTab(_groups.length)),
        icon: const Icon(Icons.groups_outlined),
      ),
      ButtonSegment(
        value: 'requests',
        label: Text(AppLocalizations.of(context).requestsTab(_requests.length)),
        icon: const Icon(Icons.person_add_alt_1_rounded),
      ),
      ButtonSegment(
        value: 'search',
        label: Text(AppLocalizations.of(context).search),
        icon: const Icon(Icons.search_rounded),
      ),
    ],
    selected: {_section},
    onSelectionChanged:
        (selection) => setState(() => _section = selection.first),
  );

  Widget _searchField() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SegmentedButton<String>(
        showSelectedIcon: false,
        segments:  [
          ButtonSegment(
            value: 'user',
            label: Text(AppLocalizations.of(context).searchUsers),
            icon: Icon(Icons.person_search_rounded),
          ),
          ButtonSegment(
            value: 'group',
            label: Text(AppLocalizations.of(context).searchGroups),
            icon: Icon(Icons.group_rounded),
          ),
        ],
        selected: {_searchMode},
        onSelectionChanged: (selection) {
          setState(() {
            _searchMode = selection.first;
            _searched = false;
            _results.clear();
            _groupResults.clear();
          });
        },
      ),
      const SizedBox(height: 10),
      TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: (_) => _search(),
        decoration: InputDecoration(
          hintText: _searchMode == 'group' ? AppLocalizations.of(context).groupNameKeyword : AppLocalizations.of(context).userSearchHint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            tooltip: _searchMode == 'group' ? AppLocalizations.of(context).searchGroupsTooltip : AppLocalizations.of(context).searchUsersTooltip,
            onPressed: _searching ? null : _search,
            icon:
                _searching
                    ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.arrow_forward_rounded),
          ),
        ),
      ),
    ],
  );

  Widget _errorBanner() => Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Material(
      color: const Color(0xFFFFE8E1),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.coral,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(_error, style: const TextStyle(color: AppTheme.ink)),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context).retry,
              visualDensity: VisualDensity.compact,
              onPressed: _section == 'search' ? _search : _refreshLists,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _content() {
    if (_section == 'search') {
      if (_searching && !_searched) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!_searched) {
        return _empty(
          _searchMode == 'group' ? AppLocalizations.of(context).searchPublicGroups : AppLocalizations.of(context).searchChengeUsers,
          _searchMode == 'group' ? AppLocalizations.of(context).searchPublicGroupsHint : AppLocalizations.of(context).searchUsersHint,
        );
      }
      if (_searchMode == 'group') {
        if (_searching && _groupResults.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_groupResults.isEmpty) return _empty(AppLocalizations.of(context).noMatchingGroups, AppLocalizations.of(context).tryOtherKeywords);
        return _groupList(_groupResults, searchable: true);
      }
      if (_searching && _results.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_results.isEmpty) return _empty(AppLocalizations.of(context).noMatchingPeople, AppLocalizations.of(context).tryOtherKeywords);
      return _userList(_results, kind: _FriendListKind.search);
    }

    if (_section == 'groups') {
      if (_loading && _groups.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (_groups.isEmpty) return _empty(AppLocalizations.of(context).noGroupsYet, AppLocalizations.of(context).noGroupsHint);
      return _groupList(_groups, searchable: false);
    }

    final users = _section == 'friends' ? _friends : _requests;
    if (_loading && users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (users.isEmpty) {
      return _section == 'friends'
          ? _empty(AppLocalizations.of(context).noFriendsYet, AppLocalizations.of(context).noFriendsHint)
          : _empty(AppLocalizations.of(context).noPendingRequests, AppLocalizations.of(context).noPendingRequestsHint);
    }
    return _userList(
      users,
      kind:
          _section == 'friends'
              ? _FriendListKind.friend
              : _FriendListKind.request,
    );
  }

  Widget _userList(List<FriendUser> users, {required _FriendListKind kind}) {
    final bottomClearance =
        MediaQuery.paddingOf(context).bottom + kBottomNavigationBarHeight + 12;
    return RefreshIndicator(
      onRefresh: _refreshLists,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: bottomClearance),
        itemCount: users.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _userTile(users[index], kind),
      ),
    );
  }

  Widget _groupList(
    List<ChatConversation> groups, {
    required bool searchable,
  }) {
    final bottomClearance =
        MediaQuery.paddingOf(context).bottom + kBottomNavigationBarHeight + 12;
    return RefreshIndicator(
      onRefresh: _refreshLists,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: bottomClearance),
        itemCount: groups.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder:
            (context, index) =>
                _groupTile(groups[index], searchable: searchable),
      ),
    );
  }

  Widget _userTile(FriendUser user, _FriendListKind kind) {
    final busy = _busyIds.contains(user.userId);
    final online = _online[user.userId] == true;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap:
            kind == _FriendListKind.friend ? () => _openFriendChat(user) : null,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    foregroundImage:
                        user.avatar == null ? null : NetworkImage(user.avatar!),
                    onForegroundImageError:
                        user.avatar == null ? null : (_, __) {},
                    child: Icon(
                      Icons.person_rounded,
                      color: Theme.of(context).colorScheme.onTertiaryContainer,
                    ),
                  ),
                  if (kind == _FriendListKind.friend)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color:
                              online
                                  ? const Color(0xFF2ECC71)
                                  : Theme.of(context).colorScheme.outline,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLow,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle(user, kind),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (busy)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                _actions(user, kind),
            ],
          ),
        ),
      ),
    );
  }

  Widget _groupTile(ChatConversation group, {required bool searchable}) {
    final busy = _busyIds.contains(group.id);
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: searchable ? null : () => _openGroupChat(group),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                foregroundImage:
                    group.avatar == null ? null : NetworkImage(group.avatar!),
                onForegroundImageError:
                    group.avatar == null ? null : (_, __) {},
                child: Icon(
                  Icons.groups_rounded,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      searchable ? AppLocalizations.of(context).groupTapToJoin : AppLocalizations.of(context).groupChat,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (busy)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 11),
                  child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else if (searchable)
                FilledButton.tonal(
                  onPressed: () => _joinGroup(group),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: Text(AppLocalizations.of(context).join),
                )
              else
                IconButton(
                  tooltip: AppLocalizations.of(context).enterGroup,
                  onPressed: () => _openGroupChat(group),
                  icon: const Icon(Icons.chat_bubble_outline_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _subtitle(FriendUser user, _FriendListKind kind) {
    if (kind == _FriendListKind.request) return AppLocalizations.of(context).requestAddYou(user.username);
    if (kind == _FriendListKind.friend) {
      final online = _online[user.userId] == true;
      final status = online ? AppLocalizations.of(context).online : AppLocalizations.of(context).offline;
      if (user.remark?.isNotEmpty == true) {
        return AppLocalizations.of(context).onlineWithRemark(status, user.remark ?? '', user.username);
      }
      return '$status · @${user.username}';
    }
    return '@${user.username}';
  }

  Widget _actions(FriendUser user, _FriendListKind kind) {
    if (kind == _FriendListKind.search) {
      if (user.mutual) return _statusPill(AppLocalizations.of(context).friend, AppTheme.leaf);
      if (user.iReceived) {
        return FilledButton.tonal(
          onPressed: () => _apply(user),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: Text(AppLocalizations.of(context).addBack),
        );
      }
      if (user.iSent) return _statusPill(AppLocalizations.of(context).requested, const Color(0xFF8A5A08));
      return FilledButton.tonal(
        onPressed: () => _apply(user),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: Text(AppLocalizations.of(context).add),
      );
    }
    if (kind == _FriendListKind.request) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            tooltip: AppLocalizations.of(context).acceptAndAddBack,
            onPressed: () => _apply(user),
            icon: const Icon(Icons.person_add_alt_1_rounded),
          ),
          IconButton(
            tooltip: AppLocalizations.of(context).rejectRequest,
            onPressed: () => _remove(user, reject: true),
            color: AppTheme.coral,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      );
    }
    return PopupMenuButton<String>(
      tooltip: AppLocalizations.of(context).friendActions,
      onSelected: (action) {
        if (action == 'chat') _openFriendChat(user);
        if (action == 'remark') _editRemark(user);
        if (action == 'remove') _remove(user, reject: false);
      },
      itemBuilder:
          (_) => [
            PopupMenuItem(value: 'chat', child: Text(AppLocalizations.of(context).sendMessageAction)),
            PopupMenuItem(
              value: 'remark',
              child: Text(user.remark?.isNotEmpty == true ? AppLocalizations.of(context).editRemark : AppLocalizations.of(context).setRemark),
            ),
            PopupMenuItem(value: 'remove', child: Text(AppLocalizations.of(context).removeFriendRelation)),
          ],
      child: const SizedBox.square(
        dimension: 42,
        child: Icon(Icons.more_horiz_rounded, color: Color(0xFF60736E)),
      ),
    );
  }

  Widget _statusPill(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
    ),
  );

  Widget _empty(String title, String subtitle) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      const SizedBox(height: 70),
      Center(
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: const Color(0xFFFFE8C5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.contacts_outlined,
                color: AppTheme.ink,
                size: 34,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

enum _FriendListKind { friend, request, search }


/// 修改备注弹窗：由 StatefulWidget 持有 TextEditingController，
/// 避免在 Dialog 路由退场动画期间 dispose controller 触发
/// `_dependents.isEmpty` assertion（Android 上常见）。
class _EditRemarkDialog extends StatefulWidget {
  const _EditRemarkDialog({required this.initialRemark});

  final String initialRemark;

  @override
  State<_EditRemarkDialog> createState() => _EditRemarkDialogState();
}

class _EditRemarkDialogState extends State<_EditRemarkDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialRemark);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_controller.text.trim());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).setFriendRemark),
      content: TextField(
        controller: _controller,
        autofocus: true,
        maxLength: 40,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: InputDecoration(
          labelText: AppLocalizations.of(context).remarkName,
          hintText: AppLocalizations.of(context).remarkHintClear,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(AppLocalizations.of(context).save),
        ),
      ],
    );
  }
}

class _CreateGroupResult {
  const _CreateGroupResult({required this.name, required this.memberIds});

  final String name;
  final List<int> memberIds;
}

/// 创建群聊弹窗：controller 与选中状态由本 State 持有，
/// 确保 Dialog 关闭动画期间依赖关系正确清理。
class _CreateGroupDialog extends StatefulWidget {
  const _CreateGroupDialog({required this.friends});

  final List<FriendUser> friends;

  @override
  State<_CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<_CreateGroupDialog> {
  late final TextEditingController _nameController;
  final Set<int> _selected = <int>{};

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _cancel() => Navigator.of(context).pop();

  void _confirm() {
    Navigator.of(context).pop(
      _CreateGroupResult(
        name: _nameController.text.trim(),
        memberIds: _selected.toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(AppLocalizations.of(context).createGroupChat),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              maxLength: 40,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).groupName,
                hintText: AppLocalizations.of(context).groupNameHint,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context).selectMembersOptional,
                style: TextStyle(
                  fontSize: 13,
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: widget.friends.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        AppLocalizations.of(context).noFriendsToInvite,
                        style: TextStyle(color: scheme.onSurfaceVariant),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.friends.length,
                      itemBuilder: (context, index) {
                        final user = widget.friends[index];
                        final checked = _selected.contains(user.userId);
                        return CheckboxListTile(
                          dense: true,
                          value: checked,
                          title: Text(user.displayName),
                          subtitle: Text(
                            '@${user.username}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          onChanged: (v) {
                            setState(() {
                              if (v == true) {
                                _selected.add(user.userId);
                              } else {
                                _selected.remove(user.userId);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: Text(AppLocalizations.of(context).cancel),
        ),
        FilledButton(
          onPressed: _confirm,
          child: Text(AppLocalizations.of(context).create),
        ),
      ],
    );
  }
}
