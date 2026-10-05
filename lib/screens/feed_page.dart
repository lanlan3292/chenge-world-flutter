import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/blog_post.dart';
import '../services/chenge_api.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';
import 'create_post_page.dart';

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

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
  bool _fabExpanded = true;

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
    // After wide→narrow, force shell chrome visible.
    // Must notify even when local state is already true (shell may still be hidden).
    if (widget.autoHideBottomBar && !oldWidget.autoHideBottomBar) {
      if (!_chromeVisible) {
        _setChromeVisible(true);
      } else {
        widget.onChromeVisibilityChanged?.call(true);
      }
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
  if (!_scrollController.hasClients) return;

  final offset = _scrollController.position.pixels;

  // Material 3 FAB:
  // 顶部：展开
  // 离开顶部：收起
  final fabExpanded = offset <= 8;

  if (_fabExpanded != fabExpanded) {
    setState(() {
      _fabExpanded = fabExpanded;
    });
  }

  // AppBar / BottomBar 的自动隐藏逻辑
  if (!widget.autoHideTopBar && !widget.autoHideBottomBar) return;

  if (offset <= 8) {
    _chromeScrollAccum = 0;
    _lastScrollPixels = offset;
    _setChromeVisible(true);
    return;
  }

  final delta = offset - _lastScrollPixels;
  _lastScrollPixels = offset;

  if (delta == 0) return;

  // Same direction as current intent: accumulate;
  // reverse direction: reset and accumulate opposite.
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
    setState(() => _chromeVisible = visible);
    // Shell animates the bottom bar with a transform only.
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

  Future<void> _openPost(BlogPost post) async {
    _setChromeVisible(true);
    final updated = await Navigator.of(context).push<BlogPost>(
      MaterialPageRoute<BlogPost>(
        builder:
            (_) => PostDetailPage(
              api: widget.api,
              post: post,
              token: widget.token,
            ),
      ),
    );
    if (!mounted || updated == null) return;
    final index = _posts.indexWhere((item) => item.id == updated.id);
    if (index < 0) return;
    setState(() {
      _posts[index] = _posts[index].copyWith(
        liked: updated.liked,
        likeCount: updated.likeCount,
        commentCount: updated.commentCount,
      );
    });
  }

  Future<void> _openCreatePost() async {
    final token = widget.token;
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).signInToCreatePost),
          ),
        );
      return;
    }
    _setChromeVisible(true);
    final createdId = await Navigator.of(context).push<int>(
      MaterialPageRoute<int>(
        builder: (_) => CreatePostPage(api: widget.api, token: token),
      ),
    );
    if (!mounted) return;
    if (createdId != null) {
      await _loadPage(1);
    }
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
      // FAB must not ride the IME; shell already keeps the bottom bar fixed.
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          widget.token != null && widget.token!.isNotEmpty
              ? _CreatePostFab(
                onPressed: _openCreatePost,
                // Wide layout has no shell bottom bar — never reserve nav height.
                dockedToBottomBar:
                    MediaQuery.sizeOf(context).width < 760 &&
                    (!widget.autoHideBottomBar || _chromeVisible),
                expanded: _fabExpanded
              )
              : null,
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
                            AppLocalizations.of(context).communityTitle,
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
                      tooltip: AppLocalizations.of(context).refreshPosts,
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
                      itemBuilder:
                          (context, index) => PostCard(
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
            hintText: AppLocalizations.of(context).searchPostsAndTopics,
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
      ),
      const SizedBox(width: 10),
      IconButton.filledTonal(
        tooltip: AppLocalizations.of(context).search,
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
                  AppLocalizations.of(context).rightNow,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context).freshDiscussions,
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
            label: Text(AppLocalizations.of(context).latest),
            icon: Icon(Icons.schedule_rounded),
          ),
          ButtonSegment(
            value: 'hot',
            label: Text(AppLocalizations.of(context).popular),
            icon: Icon(Icons.local_fire_department_rounded),
          ),
          ButtonSegment(
            value: 'essence',
            label: Text(AppLocalizations.of(context).featured),
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
              tooltip: AppLocalizations.of(context).previousPage,
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
              tooltip: AppLocalizations.of(context).nextPage,
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
            child: Text(AppLocalizations.of(context).retry),
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
            AppLocalizations.of(context).noPosts,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
          ),
          SizedBox(height: 6),
          Text(
            AppLocalizations.of(context).noPostsHint,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    ),
  );
}

class _CreatePostFab extends StatelessWidget {
  const _CreatePostFab({
    required this.onPressed,
    required this.dockedToBottomBar,
    required this.expanded,
  });

  final VoidCallback onPressed;
  final bool dockedToBottomBar;
  final bool expanded;

  /// M3 [NavigationBar] material height (destinations row), excluding system inset.
  static const double _shellNavBarHeight = 80;

  /// Bottom offset so the FAB clears the shell bottom bar / screen edge.
  ///
  /// Platform differences matter:
  /// - Android edge-to-edge: system gesture inset + nav bar stack; needs more clearance.
  /// - Desktop (Windows/macOS/Linux): no gesture inset overlap; nav height alone is enough.
  /// - Always use [MediaQueryData.viewPadding] (not padding) so the IME cannot lift the FAB.
  static double _bottomInset(BuildContext context, {required bool docked}) {
    final mq = MediaQuery.of(context);
    // Ignore keyboard / viewInsets entirely.
    final systemBottom = mq.viewPadding.bottom;
    final platform = Theme.of(context).platform;

    if (!docked) {
      // Bar hidden or wide layout: rest near the physical bottom.
      switch (platform) {
        case TargetPlatform.windows:
        case TargetPlatform.linux:
        case TargetPlatform.macOS:
          return 12;
        default:
          return systemBottom + 12;
      }
    }

    switch (platform) {
      case TargetPlatform.android:
        // Gesture/nav inset + NavigationBar; extra gap avoids occlusion on tall safe areas.
        return systemBottom + _shellNavBarHeight + 20;
      case TargetPlatform.iOS:
        return systemBottom + _shellNavBarHeight + 12;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        // Desktop client area already excludes OS taskbar; only clear the in-app nav.
        return _shellNavBarHeight + 4;
      default:
        return systemBottom + _shellNavBarHeight + 12;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = _bottomInset(context, docked: dockedToBottomBar);
    final mq = MediaQuery.of(context);
    // Strip viewInsets so any ancestor keyboard inset cannot nudge the FAB.
    return MediaQuery(
      data: mq.copyWith(viewInsets: EdgeInsets.zero),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(bottom: bottom),
        child: _AnimatedExtendedFab(
          onPressed: onPressed,
          expanded: expanded,
          icon: const Icon(Icons.edit_rounded),
          label: AppLocalizations.of(context).createPost,
        ),
      ),
    );
  }
}

class _AnimatedExtendedFab extends StatefulWidget {
  const _AnimatedExtendedFab({
    required this.onPressed,
    required this.expanded,
    required this.icon,
    required this.label,
  });

  final VoidCallback onPressed;
  final bool expanded;
  final Widget icon;
  final String label;

  @override
  State<_AnimatedExtendedFab> createState() => _AnimatedExtendedFabState();
}

class _AnimatedExtendedFabState extends State<_AnimatedExtendedFab>
    with SingleTickerProviderStateMixin {
  static const _collapsedWidth = 56.0;
  static const _height = 56.0;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: const Duration(milliseconds: 180),
      value: widget.expanded ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedExtendedFab oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.expanded == widget.expanded) {
      return;
    }

    if (widget.expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fabTheme = FloatingActionButtonTheme.of(context);
    final colors = theme.colorScheme;

    final iconSize = fabTheme.iconSize ?? 24.0;

    final textStyle =
        fabTheme.extendedTextStyle ??
        theme.textTheme.labelLarge!;

    final expandedWidth = _expandedWidth(
      context,
      textStyle,
      iconSize,
    );

    final backgroundColor =
        fabTheme.backgroundColor ?? colors.primaryContainer;

    final foregroundColor =
        fabTheme.foregroundColor ?? colors.onPrimaryContainer;

    final shape =
        fabTheme.shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final progress = Curves.easeInOutCubic.transform(
          _controller.value,
        );

        final width = lerpDouble(
          _collapsedWidth,
          expandedWidth,
          progress,
        )!;

        // collapsed: icon 居中
        // expanded: icon 左侧 16dp
        final iconStart = lerpDouble(
          (_collapsedWidth - iconSize) / 2,
          16,
          progress,
        )!;

        return SizedBox(
          width: width,
          height: _height,
          child: RawMaterialButton(
            onPressed: widget.onPressed,
            elevation: fabTheme.elevation ?? 6,
            focusElevation: fabTheme.focusElevation ?? 6,
            hoverElevation: fabTheme.hoverElevation ?? 8,
            highlightElevation: fabTheme.highlightElevation ?? 6,
            disabledElevation: fabTheme.disabledElevation ?? 6,
            fillColor: backgroundColor,
            focusColor:
                fabTheme.focusColor ??
                colors.onPrimaryContainer.withValues(alpha: 0.10),
            hoverColor:
                fabTheme.hoverColor ??
                colors.onPrimaryContainer.withValues(alpha: 0.08),
            splashColor:
                fabTheme.splashColor ??
                colors.onPrimaryContainer.withValues(alpha: 0.10),
            shape: shape,
            clipBehavior: Clip.antiAlias,
            materialTapTargetSize: theme.materialTapTargetSize,
            child: SizedBox(
              width: width,
              height: _height,
              child: Stack(
                children: [
                  // 唯一的 icon
                  PositionedDirectional(
                    start: iconStart,
                    top: (_height - iconSize) / 2,
                    child: IconTheme.merge(
                      data: IconThemeData(
                        size: iconSize,
                        color: foregroundColor,
                      ),
                      child: widget.icon,
                    ),
                  ),

                  // 唯一的 label
                  PositionedDirectional(
                    start: 16 + iconSize + 8,
                    end: 20,
                    top: 0,
                    bottom: 0,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: progress,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: DefaultTextStyle(
                            style: textStyle.copyWith(
                              color: foregroundColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            child: Text(
                              widget.label,
                              softWrap: false,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _expandedWidth(
    BuildContext context,
    TextStyle textStyle,
    double iconSize,
  ) {
    final painter = TextPainter(
      text: TextSpan(
        text: widget.label,
        style: textStyle,
      ),
      textDirection: Directionality.of(context),
      maxLines: 1,
    )..layout();

    return math.max(
      _collapsedWidth,
      16 +
          iconSize +
          8 +
          painter.width +
          20,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
