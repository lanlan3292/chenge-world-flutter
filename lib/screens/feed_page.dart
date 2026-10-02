import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../models/blog_post.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({
    super.key,
    required this.api,
    required this.token,
    this.autoHideTopBar = true,
    this.autoHideBottomBar = true,
    this.minColumns = 1,
    this.onChromeVisibilityChanged,
  });

  final ChengeApi api;
  final String? token;
  final bool autoHideTopBar;
  final bool autoHideBottomBar;
  /// Minimum grid column count (1–3); responsive layout may use more.
  final int minColumns;
  /// Called when scrolling should show/hide shell chrome (bottom nav, etc.).
  final ValueChanged<bool>? onChromeVisibilityChanged;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  final _posts = <BlogPost>[];
  String _sort = 'latest';
  String _error = '';
  int _page = 0;
  int _total = 0;
  int _requestId = 0;
  bool _loading = false;
  bool _chromeVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPage(1);
  }

  @override
  void didUpdateWidget(covariant FeedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) _loadPage(1);
    if (!widget.autoHideBottomBar && !_chromeVisible) {
      _setChromeVisible(true);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    widget.onChromeVisibilityChanged?.call(true);
    super.dispose();
  }

  void _onScroll() {
    if (!widget.autoHideTopBar && !widget.autoHideBottomBar) return;
    if (!_scrollController.hasClients) return;
    if (_scrollController.offset <= 8) {
      _setChromeVisible(true);
      return;
    }
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      _setChromeVisible(false);
    } else if (direction == ScrollDirection.forward) {
      _setChromeVisible(true);
    }
  }

  void _setChromeVisible(bool visible) {
    if (_chromeVisible == visible) return;
    setState(() => _chromeVisible = visible);
    if (widget.autoHideBottomBar) {
      widget.onChromeVisibilityChanged?.call(visible);
    }
  }

  Future<void> _loadPage(int page) async {
    final requestId = ++_requestId;
    setState(() {
      _loading = true;
      _error = '';
      _posts.clear();
      _page = 0;
    });
    try {
      final result = await widget.api.listPosts(
        page: page,
        sort: _sort,
        keyword: _searchController.text,
        token: widget.token,
      );
      if (!mounted) return;
      if (requestId != _requestId) return;
      setState(() {
        _posts.addAll(result.posts);
        _total = result.total;
        _page = page;
      });
    } on ApiException catch (error) {
      if (mounted && requestId == _requestId) setState(() => _error = error.message);
    } finally {
      if (mounted && requestId == _requestId) setState(() => _loading = false);
    }
  }

  void _openPost(BlogPost post) {
    _setChromeVisible(true);
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => PostDetailPage(api: widget.api, post: post, token: widget.token),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width >= 1200 ? 1120.0 : 920.0;
    final responsive = width >= 1120 ? 2 : 1;
    final columns = responsive < widget.minColumns ? widget.minColumns.clamp(1, 3) : responsive;
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                floating: widget.autoHideTopBar,
                snap: widget.autoHideTopBar,
                pinned: !widget.autoHideTopBar,
                backgroundColor: AppTheme.mist,
                surfaceTintColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                forceElevated: false,
                titleSpacing: 20,
                title: Row(
                  children: [
                    if (!isWide) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 38,
                          height: 38,
                          cacheWidth: 114,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 11),
                    ],
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ChengeWorld', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        Text('社区广场', style: TextStyle(fontSize: 11, color: Color(0xFF70817D))),
                      ],
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    tooltip: '刷新帖子',
                    onPressed: _loading ? null : () => _loadPage(1),
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
                sliver: SliverToBoxAdapter(child: _buildSearch()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                sliver: SliverToBoxAdapter(child: _buildFeedHeader()),
              ),
              if (_loading && _posts.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error.isNotEmpty && _posts.isEmpty)
                SliverFillRemaining(hasScrollBody: false, child: _buildError())
              else if (_posts.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: _EmptyFeed())
              else ...[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid.builder(
                    itemCount: _posts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: columns == 1 ? 328 : 370,
                    ),
                    itemBuilder: (context, index) => PostCard(
                      post: _posts[index],
                      featured: index == 0 && _page == 1,
                      onTap: () => _openPost(_posts[index]),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildPagination()),
              ],
              SliverToBoxAdapter(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeInOutCubic,
                  height: 24 +
                      MediaQuery.paddingOf(context).bottom +
                      (widget.autoHideBottomBar
                          ? (_chromeVisible ? kBottomNavigationBarHeight + 12 : 0)
                          : kBottomNavigationBarHeight + 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() => Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _loadPage(1),
              decoration: const InputDecoration(
                hintText: '搜索帖子和话题',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filledTonal(
            tooltip: '搜索',
            onPressed: () => _loadPage(1),
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      );

  Widget _buildFeedHeader() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('此刻在聊', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, height: 1.1)),
                    SizedBox(height: 4),
                    Text('看看社区里的新鲜讨论', style: TextStyle(color: Color(0xFF70817D))),
                  ],
                ),
              ),
              if (_total > 0) Text('$_total 篇', style: const TextStyle(color: Color(0xFF70817D))),
            ],
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 'latest', label: Text('最新'), icon: Icon(Icons.schedule_rounded)),
              ButtonSegment(value: 'hot', label: Text('热门'), icon: Icon(Icons.local_fire_department_rounded)),
              ButtonSegment(value: 'essence', label: Text('精华'), icon: Icon(Icons.auto_awesome_rounded)),
            ],
            selected: {_sort},
            onSelectionChanged: (selection) {
              setState(() => _sort = selection.first);
              _loadPage(1);
            },
          ),
        ],
      );

  Widget _buildPagination() {
    final totalPages = (_total + 11) ~/ 12;
    if (totalPages < 2) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              tooltip: '上一页',
              onPressed: _loading || _page <= 1 ? null : () => _loadPage(_page - 1),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text('第 $_page / $totalPages 页', style: const TextStyle(fontWeight: FontWeight.w700)),
            ),
            IconButton.filledTonal(
              tooltip: '下一页',
              onPressed: _loading || _page >= totalPages ? null : () => _loadPage(_page + 1),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48, color: Color(0xFF70817D)),
              const SizedBox(height: 12),
              Text(_error, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF70817D))),
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: () => _loadPage(1), child: const Text('重试')),
            ],
          ),
        ),
      );
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.forum_outlined, size: 48, color: Color(0xFF70817D)),
              SizedBox(height: 12),
              Text('暂时没有帖子', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              SizedBox(height: 6),
              Text('换个关键词或稍后再来看看', style: TextStyle(color: Color(0xFF70817D))),
            ],
          ),
        ),
      );
}
