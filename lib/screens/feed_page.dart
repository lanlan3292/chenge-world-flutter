import 'package:flutter/material.dart';

import '../models/blog_post.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import '../widgets/post_card.dart';
import 'post_detail_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.api, required this.token});

  final ChengeApi api;
  final String? token;

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

  @override
  void initState() {
    super.initState();
    _loadPage(1);
  }

  @override
  void didUpdateWidget(covariant FeedPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) _loadPage(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPage(int page, {bool append = false}) async {
    if (append && _loading) return;
    final requestId = ++_requestId;
    setState(() {
      _loading = true;
      _error = '';
      if (!append) {
        _posts.clear();
        _page = 0;
      }
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
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => PostDetailPage(api: widget.api, post: post, token: widget.token),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width >= 1200 ? 1120.0 : 920.0;
    final columns = width >= 1120 ? 2 : 1;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.leaf,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.forum_rounded, color: Colors.white, size: 21),
            ),
            const SizedBox(width: 11),
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
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
              const SliverToBoxAdapter(child: SizedBox(height: 30)),
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
    if (_page * 12 >= _total && !_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 25),
        child: Center(child: Text('已经看到这里了', style: TextStyle(color: Color(0xFF70817D)))),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: FilledButton.tonalIcon(
          onPressed: _loading ? null : () => _loadPage(_page + 1, append: true),
          icon: _loading
              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.expand_more_rounded),
          label: Text(_loading ? '正在加载' : '加载更多'),
        ),
      ),
    );
  }

  Widget _buildError() => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 42, color: AppTheme.coral),
              const SizedBox(height: 12),
              Text(_error, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => _loadPage(1),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('重试'),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(color: const Color(0xFFFFE8C5), borderRadius: BorderRadius.circular(28)),
              child: const Icon(Icons.forum_outlined, size: 38, color: AppTheme.ink),
            ),
            const SizedBox(height: 16),
            const Text('这里暂时很安静', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            const Text('换个关键词试试', style: TextStyle(color: Color(0xFF70817D))),
          ],
        ),
      );
}