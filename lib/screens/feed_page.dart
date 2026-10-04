import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../l10n/app_localizations_text.dart';
import '../models/blog_post.dart';
import '../services/chenge_api.dart';
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
    this.maxColumns = 3,
    this.onChromeVisibilityChanged,
  });

  final ChengeApi api;
  final String? token;
  final bool autoHideTopBar;
  final bool autoHideBottomBar;

  /// Minimum grid column count (1–3).
  final int minColumns;

  /// Maximum grid column count (1–3). Always ≥ [minColumns].
  final int maxColumns;

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

  /// Minimum scroll distance before toggling chrome (avoids jank from rapid flips).
  static const double _chromeScrollThreshold = 28;

  double _lastScrollPixels = 0;
  double _chromeScrollAccum = 0;

  void _onScroll() {
    if (!widget.autoHideTopBar && !widget.autoHideBottomBar) return;
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final offset = position.pixels;

    if (offset <= 8) {
      _chromeScrollAccum = 0;
      _lastScrollPixels = offset;
      _setChromeVisible(true);
      return;
    }

    final delta = offset - _lastScrollPixels;
    _lastScrollPixels = offset;
    if (delta == 0) return;

    // Same direction as current intent: accumulate; reverse direction: reset and accumulate opposite.
    if ((_chromeScrollAccum > 0 && delta < 0) ||
        (_chromeScrollAccum < 0 && delta > 0)) {
      _chromeScrollAccum = 0;
    }
    _chromeScrollAccum += delta;

    if (_chromeScrollAccum > _chromeScrollThreshold) {
      // Scrolling down
      _chromeScrollAccum = 0;
      _setChromeVisible(false);
    } else if (_chromeScrollAccum < -_chromeScrollThreshold) {
      // Scrolling up
      _chromeScrollAccum = 0;
      _setChromeVisible(true);
    }
  }

  void _setChromeVisible(bool visible) {
    if (_chromeVisible == visible) return;
    _chromeVisible = visible;
    // Do not setState: bottom padding stays fixed so the list does not reflow.
    // Shell animates the bottom bar with a transform only.
    // 顶栏隐藏也需要通知外壳，用于状态栏遮罩。
    if (widget.autoHideBottomBar || widget.autoHideTopBar) {
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
      if (mounted && requestId == _requestId) {
        setState(() => _error = error.message);
      }
    } finally {
      if (mounted && requestId == _requestId) setState(() => _loading = false);
    }
  }

  void _openPost(BlogPost post) {
    _setChromeVisible(true);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) => PostDetailPage(
              api: widget.api,
              post: post,
              token: widget.token,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width >= 1200 ? 1120.0 : 920.0;
    final minCols = widget.minColumns.clamp(1, 3);
    final maxCols = widget.maxColumns.clamp(minCols, 3);
    // Breakpoints: narrow 1 / medium 2 / wide 3, then clamp to user range.
    final responsive =
        width >= 1120
            ? 3
            : width >= 760
            ? 2
            : 1;
    final columns = responsive.clamp(minCols, maxCols);
    final isWide = MediaQuery.sizeOf(context).width >= 760;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: RefreshIndicator(
            onRefresh: () => _loadPage(1),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: widget.autoHideTopBar,
                  snap: widget.autoHideTopBar,
                  pinned: !widget.autoHideTopBar,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ChengeWorld',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(
                              context,
                            ).text('ChengeWorld 社区广场'),
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      tooltip: AppLocalizations.of(context).text('刷新帖子'),
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
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                else if (_error.isNotEmpty && _posts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildError(),
                  )
                else if (_posts.isEmpty)
                  SliverFillRemaining(hasScrollBody: false, child: _EmptyFeed())
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    // 同行等高：每行高度取该行卡片内容最高者，水平对齐。
                    sliver: SliverAlignedGrid.count(
                      crossAxisCount: columns,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      itemCount: _posts.length,
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
                  // Only clear the system gesture inset (+ a small gap).
                  // Scaffold already reserves bottomNavigationBar layout space;
                  // stacking kBottomNavigationBarHeight here made the tail too tall.
                  child: SizedBox(
                    height: MediaQuery.paddingOf(context).bottom + 12,
                  ),
                ),
              ],
            ),
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
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).text('搜索帖子和话题'),
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
      ),
      const SizedBox(width: 10),
      IconButton.filledTonal(
        tooltip: AppLocalizations.of(context).text('搜索'),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).text('此刻在聊'),
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).text('看看社区里的新鲜讨论'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (_total > 0)
            Text(
              AppLocalizations.of(context).postCount(_total),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      const SizedBox(height: 16),
      SegmentedButton<String>(
        showSelectedIcon: false,
        segments: [
          ButtonSegment(
            value: 'latest',
            label: Text(AppLocalizations.of(context).text('最新')),
            icon: Icon(Icons.schedule_rounded),
          ),
          ButtonSegment(
            value: 'hot',
            label: Text(AppLocalizations.of(context).text('热门')),
            icon: Icon(Icons.local_fire_department_rounded),
          ),
          ButtonSegment(
            value: 'essence',
            label: Text(AppLocalizations.of(context).text('精华')),
            icon: Icon(Icons.auto_awesome_rounded),
          ),
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
              tooltip: AppLocalizations.of(context).text('上一页'),
              onPressed:
                  _loading || _page <= 1 ? null : () => _loadPage(_page - 1),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(
                AppLocalizations.of(context).pageCount(_page, totalPages),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            IconButton.filledTonal(
              tooltip: AppLocalizations.of(context).text('下一页'),
              onPressed:
                  _loading || _page >= totalPages
                      ? null
                      : () => _loadPage(_page + 1),
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
          Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            _error,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => _loadPage(1),
            child: Text(AppLocalizations.of(context).text('重试')),
          ),
        ],
      ),
    ),
  );
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 12),
          Text(
            AppLocalizations.of(context).text('暂时没有帖子'),
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).text('换个关键词或稍后再来看看'),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}
