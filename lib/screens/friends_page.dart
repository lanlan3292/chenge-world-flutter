import 'package:flutter/material.dart';

import '../l10n/app_localizations_text.dart';
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
      _showMessage(_searchMode == 'group' ? '请输入群名称关键词' : '请输入用户名、昵称或邮箱');
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
      if (mounted && generation == _searchGeneration)
        setState(() => _error = error.message);
    } finally {
      if (mounted && generation == _searchGeneration)
        setState(() => _searching = false);
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
      if (updateSearch && _searchController.text.trim().isNotEmpty)
        await _search();
    } on ApiException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } finally {
      if (mounted) setState(() => _busyIds.remove(user.userId));
    }
  }

  Future<void> _apply(FriendUser user) => _runAction(
    user,
    () => widget.api.applyFriend(user.userId, widget.token!),
    user.iReceived ? '已回加，现在你们是好友了' : '好友申请已发送',
    updateSearch: true,
  );

  Future<void> _remove(FriendUser user, {required bool reject}) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(reject ? '拒绝好友申请' : '解除好友'),
            content: Text(
              reject
                  ? '确定拒绝 ${user.displayName} 的好友申请？'
                  : '确定与 ${user.displayName} 解除好友关系？',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('取消'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(context, true),
                child: Text(reject ? '拒绝' : '解除'),
              ),
            ],
          ),
    );
    if (confirmed != true || !mounted) return;
    await _runAction(
      user,
      () => widget.api.removeFriend(user.userId, widget.token!),
      reject ? '已拒绝好友申请' : '已解除好友关系',
      updateSearch: true,
    );
  }

  Future<void> _editRemark(FriendUser user) async {
    final controller = TextEditingController(text: user.remark ?? '');
    final remark = await showDialog<String>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('设置好友备注'),
            content: TextField(
              controller: controller,
              autofocus: true,
              maxLength: 40,
              textInputAction: TextInputAction.done,
              onSubmitted:
                  (_) => Navigator.pop(context, controller.text.trim()),
              decoration: const InputDecoration(
                labelText: '备注名称',
                hintText: '留空以清除备注',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, controller.text.trim()),
                child: const Text('保存'),
              ),
            ],
          ),
    );
    controller.dispose();
    if (remark == null || !mounted) return;
    await _runAction(
      user,
      () => widget.api.setFriendRemark(user.userId, remark, widget.token!),
      remark.isEmpty ? '备注已清除' : '备注已保存',
    );
  }

  Future<void> _joinGroup(ChatConversation group) async {
    final token = widget.token;
    if (token == null || _busyIds.contains(group.id)) return;
    setState(() => _busyIds.add(group.id));
    try {
      await widget.api.joinGroup(group.id, token);
      if (!mounted) return;
      _showMessage('已加入「${group.name}」');
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
    final nameController = TextEditingController();
    final selected = <int>{};

    final created = await showDialog<bool>(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setLocal) => AlertDialog(
                  title: const Text('创建群聊'),
                  content: SizedBox(
                    width: 360,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          autofocus: true,
                          maxLength: 40,
                          decoration: const InputDecoration(
                            labelText: '群名称',
                            hintText: '给群聊起个名字',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '选择成员（可选）',
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child:
                              _friends.isEmpty
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Text(
                                      AppLocalizations.of(
                                        context,
                                      ).text('暂无好友可邀请'),
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  )
                                  : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _friends.length,
                                    itemBuilder: (context, index) {
                                      final user = _friends[index];
                                      final checked = selected.contains(
                                        user.userId,
                                      );
                                      return CheckboxListTile(
                                        dense: true,
                                        value: checked,
                                        title: Text(user.displayName),
                                        subtitle: Text(
                                          '@${user.username}',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        onChanged:
                                            (v) => setLocal(() {
                                              if (v == true) {
                                                selected.add(user.userId);
                                              } else {
                                                selected.remove(user.userId);
                                              }
                                            }),
                                      );
                                    },
                                  ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('取消'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('创建'),
                    ),
                  ],
                ),
          ),
    );

    final name = nameController.text.trim();
    nameController.dispose();
    if (created != true || !mounted) return;
    if (name.isEmpty) {
      _showMessage('请输入群名称', isError: true);
      return;
    }

    try {
      final conversation = await widget.api.createGroupChat(
        name: name,
        memberIds: selected.toList(),
        token: token,
      );
      if (!mounted) return;
      _showMessage('群聊「${conversation.name}」已创建');
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
                  AppLocalizations.of(context).text('通讯录'),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                actions: [
                  if (widget.token != null)
                    IconButton(
                      tooltip: '创建群聊',
                      onPressed: _createGroup,
                      icon: const Icon(Icons.group_add_rounded),
                    ),
                  if (widget.token != null)
                    IconButton(
                      tooltip: '刷新',
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
                              label: const Text('创建群聊'),
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
          const Text(
            '登录后管理通讯录',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            '搜索用户、加入群聊、处理好友申请',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: widget.onLoginRequested,
            icon: const Icon(Icons.login_rounded),
            label: const Text('前往登录'),
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
        label: Text('好友 ${_friends.length}'),
        icon: const Icon(Icons.people_outline_rounded),
      ),
      ButtonSegment(
        value: 'groups',
        label: Text('群聊 ${_groups.length}'),
        icon: const Icon(Icons.groups_outlined),
      ),
      ButtonSegment(
        value: 'requests',
        label: Text('申请 ${_requests.length}'),
        icon: const Icon(Icons.person_add_alt_1_rounded),
      ),
      const ButtonSegment(
        value: 'search',
        label: Text('搜索'),
        icon: Icon(Icons.search_rounded),
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
        segments: const [
          ButtonSegment(
            value: 'user',
            label: Text('搜用户'),
            icon: Icon(Icons.person_search_rounded),
          ),
          ButtonSegment(
            value: 'group',
            label: Text('搜群聊'),
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
          hintText: _searchMode == 'group' ? '群名称关键词' : '用户名、昵称或邮箱',
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: IconButton(
            tooltip: _searchMode == 'group' ? '搜索群聊' : '搜索用户',
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
              tooltip: '重试',
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
      if (_searching && !_searched)
        return const Center(child: CircularProgressIndicator());
      if (!_searched) {
        return _empty(
          _searchMode == 'group' ? '搜索公开群聊' : '搜索 ChengeWorld 用户',
          _searchMode == 'group' ? '输入群名称关键词，加入感兴趣的群' : '支持用户名、昵称或邮箱',
        );
      }
      if (_searchMode == 'group') {
        if (_searching && _groupResults.isEmpty)
          return const Center(child: CircularProgressIndicator());
        if (_groupResults.isEmpty) return _empty('没有找到匹配的群', '试试其他关键词');
        return _groupList(_groupResults, searchable: true);
      }
      if (_searching && _results.isEmpty)
        return const Center(child: CircularProgressIndicator());
      if (_results.isEmpty) return _empty('没有找到匹配的人', '试试其他关键词');
      return _userList(_results, kind: _FriendListKind.search);
    }

    if (_section == 'groups') {
      if (_loading && _groups.isEmpty)
        return const Center(child: CircularProgressIndicator());
      if (_groups.isEmpty) return _empty('还没有群聊', '创建群聊，或在搜索里加入公开群');
      return _groupList(_groups, searchable: false);
    }

    final users = _section == 'friends' ? _friends : _requests;
    if (_loading && users.isEmpty)
      return const Center(child: CircularProgressIndicator());
    if (users.isEmpty) {
      return _section == 'friends'
          ? _empty('还没有好友', '搜索用户名或昵称，认识新朋友')
          : _empty('没有待处理的申请', '新的好友申请会显示在这里');
    }
    return _userList(
      users,
      kind:
          _section == 'friends'
              ? _FriendListKind.friend
              : _FriendListKind.request,
    );
  }

  Widget _userList(List<FriendUser> users, {required _FriendListKind kind}) =>
      RefreshIndicator(
        onRefresh: _refreshLists,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => _userTile(users[index], kind),
        ),
      );

  Widget _groupList(
    List<ChatConversation> groups, {
    required bool searchable,
  }) => RefreshIndicator(
    onRefresh: _refreshLists,
    child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 12),
      itemCount: groups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder:
          (context, index) => _groupTile(groups[index], searchable: searchable),
    ),
  );

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
                      searchable ? '群聊 · 点击加入' : '群聊',
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
                  child: const Text('加入'),
                )
              else
                IconButton(
                  tooltip: '进入群聊',
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
    if (kind == _FriendListKind.request) return '@${user.username} · 申请添加你';
    if (kind == _FriendListKind.friend) {
      final online = _online[user.userId] == true;
      final status = online ? '在线' : '离线';
      if (user.remark?.isNotEmpty == true)
        return '$status · 备注：${user.remark} · @${user.username}';
      return '$status · @${user.username}';
    }
    return '@${user.username}';
  }

  Widget _actions(FriendUser user, _FriendListKind kind) {
    if (kind == _FriendListKind.search) {
      if (user.mutual) return _statusPill('好友', AppTheme.leaf);
      if (user.iReceived) {
        return FilledButton.tonal(
          onPressed: () => _apply(user),
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 40),
            padding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          child: const Text('回加'),
        );
      }
      if (user.iSent) return _statusPill('已申请', const Color(0xFF8A5A08));
      return FilledButton.tonal(
        onPressed: () => _apply(user),
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        child: const Text('添加'),
      );
    }
    if (kind == _FriendListKind.request) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton.filledTonal(
            tooltip: '回加并接受',
            onPressed: () => _apply(user),
            icon: const Icon(Icons.person_add_alt_1_rounded),
          ),
          IconButton(
            tooltip: '拒绝申请',
            onPressed: () => _remove(user, reject: true),
            color: AppTheme.coral,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      );
    }
    return PopupMenuButton<String>(
      tooltip: '好友操作',
      onSelected: (action) {
        if (action == 'chat') _openFriendChat(user);
        if (action == 'remark') _editRemark(user);
        if (action == 'remove') _remove(user, reject: false);
      },
      itemBuilder:
          (_) => [
            const PopupMenuItem(value: 'chat', child: Text('发消息')),
            PopupMenuItem(
              value: 'remark',
              child: Text(user.remark?.isNotEmpty == true ? '修改备注' : '设置备注'),
            ),
            const PopupMenuItem(value: 'remove', child: Text('解除好友关系')),
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
