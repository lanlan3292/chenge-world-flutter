import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/shop_item.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
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
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final _searchController = TextEditingController();
  final _items = <ShopItem>[];
  final _assets = <Map<String, dynamic>>[];
  final _orders = <Map<String, dynamic>>[];
  String _view = 'mall';
  String _sort = 'latest';
  String _type = '';
  String _error = '';
  int _page = 0;
  int _total = 0;
  int _itemRequestId = 0;
  double? _balance;
  bool _loading = false;
  bool _loadingPrivate = false;
  bool _privateLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void didUpdateWidget(covariant ShopPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.token != widget.token) {
      _privateLoaded = false;
      _balance = null;
      _assets.clear();
      _orders.clear();
      if (widget.token != null && _view != 'mall') _loadPrivate(_view);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems({int page = 1, bool append = false}) async {
    if (append && _loading) return;
    final requestId = ++_itemRequestId;
    setState(() {
      _loading = true;
      _error = '';
      if (!append) {
        _items.clear();
        _page = 0;
      }
    });
    try {
      final result = await widget.api.shopItems(
        page: page,
        sort: _sort,
        type: _type,
        keyword: _searchController.text,
      );
      if (!mounted) return;
      if (requestId != _itemRequestId) return;
      setState(() {
        _items.addAll(result.items);
        _total = result.total;
        _page = page;
      });
    } on ApiException catch (error) {
      if (mounted && requestId == _itemRequestId) setState(() => _error = error.message);
    } finally {
      if (mounted && requestId == _itemRequestId) setState(() => _loading = false);
    }
  }

  Future<void> _loadPrivate(String view) async {
    final token = widget.token;
    if (token == null) return;
    setState(() {
      _loadingPrivate = true;
      _error = '';
    });
    try {
      if (view == 'assets') {
        final assets = await widget.api.shopAssets(token);
        if (mounted && _view == view) {
          setState(() {
            _assets
              ..clear()
              ..addAll(assets);
            _privateLoaded = true;
          });
        }
      } else {
        final orders = await widget.api.shopOrders(token);
        if (mounted && _view == view) {
          setState(() {
            _orders
              ..clear()
              ..addAll(orders);
            _privateLoaded = true;
          });
        }
      }
      _balance ??= await widget.api.shopBalance(token);
    } on ApiException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _loadingPrivate = false);
    }
  }

  Future<void> _chooseView(String view) async {
    setState(() {
      _view = view;
      _error = '';
    });
    if (view != 'mall') {
      if (widget.token == null) return;
      _privateLoaded = false;
      await _loadPrivate(view);
    }
  }

  Future<void> _openItem(ShopItem item) async {
    final purchased = await Navigator.of(context).push<bool>(MaterialPageRoute<bool>(
      builder: (_) => ShopDetailPage(
        api: widget.api,
        item: item,
        token: widget.token,
        userId: widget.userId,
        onLoginRequested: widget.onLoginRequested,
      ),
    ));
    if (purchased == true && mounted) {
      await _loadItems();
      if (widget.token != null) {
        _balance = await widget.api.shopBalance(widget.token!).catchError((_) => _balance ?? 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width >= 1180 ? 3 : width >= 760 ? 2 : 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('商城', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          if (_balance != null)
            Center(child: _coinPill('${_balance!.toStringAsFixed(2)} CC')),
          IconButton(tooltip: '刷新', onPressed: _loading ? null : () => _view == 'mall' ? _loadItems() : _loadPrivate(_view), icon: const Icon(Icons.refresh_rounded)),
          const SizedBox(width: 5),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _viewSelector(),
                if (_view == 'mall') ...[
                  const SizedBox(height: 14),
                  _searchBar(),
                  const SizedBox(height: 10),
                  _filters(),
                  const SizedBox(height: 10),
                ],
                if (_error.isNotEmpty) _errorBanner(),
                Expanded(child: _viewBody(columns)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _viewSelector() => SegmentedButton<String>(
        showSelectedIcon: false,
        segments: const [
          ButtonSegment(value: 'mall', label: Text('逛商城'), icon: Icon(Icons.storefront_outlined)),
          ButtonSegment(value: 'assets', label: Text('我的资产'), icon: Icon(Icons.inventory_2_outlined)),
          ButtonSegment(value: 'orders', label: Text('订单'), icon: Icon(Icons.receipt_long_outlined)),
        ],
        selected: {_view},
        onSelectionChanged: (selection) => _chooseView(selection.first),
      );

  Widget _searchBar() => Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _loadItems(),
              decoration: const InputDecoration(hintText: '搜索商品', prefixIcon: Icon(Icons.search_rounded)),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filledTonal(tooltip: '搜索商品', onPressed: () => _loadItems(), icon: const Icon(Icons.arrow_forward_rounded)),
          const SizedBox(width: 5),
          PopupMenuButton<String>(
            tooltip: '排序商品',
            initialValue: _sort,
            onSelected: (value) {
              setState(() => _sort = value);
              _loadItems();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'latest', child: Text('最新上架')),
              PopupMenuItem(value: 'hot', child: Text('热门商品')),
              PopupMenuItem(value: 'price_asc', child: Text('价格从低到高')),
              PopupMenuItem(value: 'price_desc', child: Text('价格从高到低')),
              PopupMenuItem(value: 'rating', child: Text('评分优先')),
            ],
            child: const SizedBox.square(dimension: 44, child: Icon(Icons.sort_rounded)),
          ),
        ],
      );

  Widget _filters() => SizedBox(
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _typeChip('', '全部'),
            _typeChip('file', '文件'),
            _typeChip('emoji', '表情包'),
            _typeChip('ui', '组件'),
            _typeChip('app', '应用'),
            _typeChip('command', '可执行'),
            _typeChip('classes', '类库'),
            _typeChip('functions', '函数库'),
          ],
        ),
      );

  Widget _typeChip(String value, String label) => Padding(
        padding: const EdgeInsets.only(right: 7),
        child: ChoiceChip(
          label: Text(label),
          selected: _type == value,
          onSelected: (_) {
            setState(() => _type = value);
            _loadItems();
          },
          visualDensity: VisualDensity.compact,
        ),
      );

  Widget _viewBody(int columns) {
    if (_view == 'mall') {
      if (_loading && _items.isEmpty) return const Center(child: CircularProgressIndicator());
      if (_error.isNotEmpty && _items.isEmpty) return _empty('商城暂时不可用', '检查网络后重试');
      if (_items.isEmpty) return _empty('暂时没有商品', '试试其他关键词或分类');
      return RefreshIndicator(
        onRefresh: _loadItems,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: Row(
                  children: [
                    const Text('发现好物', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                    const Spacer(),
                    Text('$_total 件商品', style: const TextStyle(color: Color(0xFF70817D))),
                  ],
                ),
              ),
            ),
            SliverGrid.builder(
              itemCount: _items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 278,
              ),
              itemBuilder: (context, index) => _itemCard(_items[index]),
            ),
            _pagination(),
          ],
        ),
      );
    }
    if (widget.token == null) return _signedOutPrivate();
    if (_loadingPrivate && !_privateLoaded) return const Center(child: CircularProgressIndicator());
    final rows = _view == 'assets' ? _assets : _orders;
    if (rows.isEmpty) return _empty(_view == 'assets' ? '还没有资产' : '还没有订单', '在商城购买的内容会显示在这里');
    return RefreshIndicator(
      onRefresh: () => _loadPrivate(_view),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 12, bottom: 20),
        itemCount: rows.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _privateRow(rows[index], isAsset: _view == 'assets'),
      ),
    );
  }

  Widget _itemCard(ShopItem item) => Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _openItem(item),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: _image(item.cover, item.title)),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 10, 13, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                      const SizedBox(height: 4),
                      Expanded(child: Text(item.summary ?? _typeLabel(item.type), maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF70817D), fontSize: 12, height: 1.35))),
                      Row(
                        children: [
                          Expanded(child: Text(item.sellerName ?? '社区商家', maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFF70817D), fontSize: 11))),
                          Text('${item.priceCoins.toStringAsFixed(2)} CC',
                            style: const TextStyle(color: AppTheme.coral, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _privateRow(Map<String, dynamic> row, {required bool isAsset}) {
    final title = row['title']?.toString() ?? '商品';
    final cover = row['cover']?.toString();
    final price = row['price'] is num ? (row['price'] as num).toDouble() / 100 : 0.0;
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isAsset && row['itemId'] is num
            ? () => _openItem(ShopItem(id: (row['itemId'] as num).toInt(), title: title, type: row['type']?.toString() ?? 'file', price: (row['price'] as num?)?.toInt() ?? 0, stock: 0))
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(width: 70, height: 70, child: ClipRRect(borderRadius: BorderRadius.circular(6), child: _image(cover, title))),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(isAsset
                        ? '持有 ${row['quantity'] ?? 0} 件 · ${_typeLabel(row['type']?.toString() ?? '')}'
                        : '${price.toStringAsFixed(2)} CC × ${row['quantity'] ?? 1} · ${_orderStatus(row['status']?.toString())}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF70817D))),
                    if (!isAsset && row['createdAt'] != null)
                      Text(row['createdAt'].toString().replaceFirst('T', ' '), style: const TextStyle(fontSize: 11, color: Color(0xFF83918D))),
                  ],
                ),
              ),
              Icon(isAsset ? Icons.chevron_right_rounded : Icons.receipt_long_outlined, color: const Color(0xFF81908A)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagination() {
    final hasMore = _page * 12 < _total;
    if (!hasMore && !_loading) return const SliverPadding(padding: EdgeInsets.all(16), sliver: SliverToBoxAdapter(child: Center(child: Text('已显示全部商品', style: TextStyle(color: Color(0xFF70817D))))));
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: OutlinedButton.icon(
            onPressed: _loading ? null : () => _loadItems(page: _page + 1, append: true),
            icon: _loading ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.expand_more_rounded),
            label: Text(_loading ? '正在加载' : '加载更多'),
          ),
        ),
      ),
    );
  }

  Widget _signedOutPrivate() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline_rounded, size: 44, color: AppTheme.leaf),
            const SizedBox(height: 10),
            const Text('登录后查看资产与订单', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            FilledButton.icon(onPressed: widget.onLoginRequested, icon: const Icon(Icons.login_rounded), label: const Text('前往登录')),
          ],
        ),
      );

  Widget _empty(String title, String subtitle) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.store_mall_directory_outlined, size: 48, color: AppTheme.leaf),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 5),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF70817D))),
            if (_view == 'mall' && _error.isNotEmpty) ...[
              const SizedBox(height: 14),
              OutlinedButton.icon(onPressed: _loadItems, icon: const Icon(Icons.refresh_rounded), label: const Text('重试')),
            ],
          ],
        ),
      );

  Widget _errorBanner() => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Material(
          color: const Color(0xFFFFE8E1),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: AppTheme.coral, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(_error, maxLines: 2, overflow: TextOverflow.ellipsis)),
              IconButton(tooltip: '重试', onPressed: () => _view == 'mall' ? _loadItems() : _loadPrivate(_view), icon: const Icon(Icons.refresh_rounded)),
            ]),
          ),
        ),
      );

  Widget _image(String? url, String title) {
    if (url == null || url.isEmpty) return _imagePlaceholder(title);
    return Image.network(
      url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _imagePlaceholder(title),
      loadingBuilder: (context, child, progress) => progress == null ? child : _imagePlaceholder(title),
    );
  }

  Widget _imagePlaceholder(String title) => Container(
        width: double.infinity,
        color: const Color(0xFFDDECE5),
        child: Center(
          child: Text(title.isEmpty ? '商' : title.characters.first,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: AppTheme.ink)),
        ),
      );

  Widget _coinPill(String value) => Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: const Color(0xFFFFE8C5), borderRadius: BorderRadius.circular(20)),
        child: Text(value, style: const TextStyle(color: AppTheme.ink, fontWeight: FontWeight.w800, fontSize: 12)),
      );

  static String _typeLabel(String? type) => switch (type) {
        'emoji' => '表情包',
        'file' => '文件',
        'ui' => '组件',
        'app' => '应用',
        'command' => '可执行',
        'classes' => '类库',
        'functions' => '函数库',
        _ => type ?? '商品',
      };

  static String _orderStatus(String? status) => switch (status) {
        'paid' => '已支付',
        'refunded' => '已退款',
        _ => status ?? '状态未知',
      };
}

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({
    super.key,
    required this.api,
    required this.item,
    required this.token,
    required this.userId,
    required this.onLoginRequested,
  });

  final ChengeApi api;
  final ShopItem item;
  final String? token;
  final int? userId;
  final VoidCallback onLoginRequested;

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
  late Future<ShopItem> _detail;
  double? _balance;
  bool _owned = false;
  bool _checkingOwned = false;
  bool _buying = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _detail = widget.api.shopItem(widget.item.id, token: widget.token);
    _loadPrivateState();
  }

  Future<void> _loadPrivateState() async {
    final token = widget.token;
    if (token == null) return;
    setState(() => _checkingOwned = true);
    try {
      final results = await Future.wait([
        widget.api.shopBalance(token),
        widget.api.shopAssets(token),
      ]);
      if (!mounted) return;
      final assets = results[1] as List<Map<String, dynamic>>;
      setState(() {
        _balance = results[0] as double;
        _owned = assets.any((asset) => '${asset['itemId']}' == '${widget.item.id}' && (asset['quantity'] as num? ?? 0) > 0);
      });
    } on ApiException {
      // Public item detail remains available if private account data cannot load.
    } finally {
      if (mounted) setState(() => _checkingOwned = false);
    }
  }

  Future<void> _buy(ShopItem item) async {
    final token = widget.token;
    if (token == null) {
      Navigator.pop(context);
      widget.onLoginRequested();
      return;
    }
    var routeClosed = false;
    setState(() => _buying = true);
    try {
      await widget.api.buyShopItem(item.id, _quantity, token);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('购买成功，已加入资产清单')));
      setState(() => _buying = false);
      Navigator.pop(context, true);
      routeClosed = true;
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message), backgroundColor: AppTheme.coral));
      }
    } finally {
      if (mounted && !routeClosed) setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(tooltip: '返回商城', onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
          title: const Text('商品详情', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        body: FutureBuilder<ShopItem>(
          future: _detail,
          builder: (context, snapshot) {
            final item = snapshot.data ?? widget.item;
            if (snapshot.hasError && snapshot.data == null) return Center(child: Text('${snapshot.error}'));
            return _detailBody(item);
          },
        ),
      );

  Widget _detailBody(ShopItem item) {
    final isSeller = widget.userId != null && widget.userId == item.sellerId;
    final canBuy = item.status == 'on' && item.stock > 0 && !isSeller;
    final width = MediaQuery.sizeOf(context).width;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width >= 900 ? 860 : 680),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(height: width >= 900 ? 330 : 240, child: _detailImage(item)),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: Text(item.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, height: 1.15))),
                _coinTag('${item.priceCoins.toStringAsFixed(2)} CC'),
              ],
            ),
            if (item.summary?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(item.summary!, style: const TextStyle(color: Color(0xFF687A74), height: 1.5)),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _stat(Icons.inventory_2_outlined, '库存 ${item.stock}'),
                _stat(Icons.shopping_bag_outlined, '已售 ${item.soldCount}'),
                _stat(Icons.star_outline_rounded, '${item.rating.toStringAsFixed(1)} · ${item.ratingCount} 评价'),
                _stat(Icons.category_outlined, _typeLabel(item.type)),
              ],
            ),
            const SizedBox(height: 14),
            if (item.sellerName != null) _sellerRow(item),
            if (_balance != null) ...[
              const SizedBox(height: 12),
              Text('我的余额 ${_balance!.toStringAsFixed(2)} CC', style: const TextStyle(color: Color(0xFF70817D))),
            ],
            if (item.detail?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 22),
              const Text('商品详情', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              MarkdownBody(data: item.detail!, selectable: true),
            ],
            if ((_owned || isSeller) && item.fileUrl?.isNotEmpty == true) ...[
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => launchUrl(Uri.parse(item.fileUrl!), mode: LaunchMode.externalApplication),
                icon: const Icon(Icons.open_in_new_rounded),
                label: const Text('打开下载链接'),
              ),
            ],
            if (item.content?.trim().isNotEmpty == true && (_owned || isSeller)) ...[
              const SizedBox(height: 18),
              const Text('商品内容', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 7),
              SelectableText(item.content!, style: const TextStyle(height: 1.5)),
            ] else if (item.type != 'emoji' && item.type != 'ui' && item.content?.isNotEmpty == true) ...[
              const SizedBox(height: 18),
              const Text('购买后可查看完整商品内容', style: TextStyle(color: Color(0xFF70817D))),
            ],
            if (_checkingOwned) const LinearProgressIndicator(),
            if (_owned) ...[
              const SizedBox(height: 18),
              const Row(children: [Icon(Icons.verified_rounded, color: AppTheme.leaf, size: 18), SizedBox(width: 7), Text('已拥有', style: TextStyle(color: AppTheme.leaf, fontWeight: FontWeight.w700))]),
            ],
            const SizedBox(height: 22),
            Row(
              children: [
                IconButton.outlined(tooltip: '减少数量', onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null, icon: const Icon(Icons.remove_rounded)),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 15), child: Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.w800))),
                IconButton.outlined(tooltip: '增加数量', onPressed: _quantity < item.stock ? () => setState(() => _quantity++) : null, icon: const Icon(Icons.add_rounded)),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _buying || !canBuy ? null : () => _buy(item),
                    icon: _buying ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.shopping_bag_outlined),
                    label: Text(isSeller ? '这是你的商品' : item.stock < 1 ? '暂时售罄' : item.status != 'on' ? '已下架' : '立即购买 · ${(item.priceCoins * _quantity).toStringAsFixed(2)} CC'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailImage(ShopItem item) {
    final cover = item.cover;
    if (cover == null || cover.isEmpty) {
      return Container(color: const Color(0xFFDDECE5), child: Center(child: Text(item.title.characters.first,
        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: AppTheme.ink))));
    }
    return Image.network(cover, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(
      color: const Color(0xFFDDECE5), child: Center(child: Text(item.title.characters.first,
        style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: AppTheme.ink))),
    ));
  }

  Widget _sellerRow(ShopItem item) => Row(
        children: [
          const CircleAvatar(radius: 15, backgroundColor: Color(0xFFFFE8C5), child: Icon(Icons.storefront_rounded, size: 16, color: AppTheme.ink)),
          const SizedBox(width: 8),
          Text(item.sellerName!, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      );

  Widget _coinTag(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(color: const Color(0xFFFFE8C5), borderRadius: BorderRadius.circular(20)),
        child: Text(label, style: const TextStyle(color: AppTheme.coral, fontWeight: FontWeight.w900)),
      );

  Widget _stat(IconData icon, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 16, color: const Color(0xFF70817D)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF70817D))),
      ]);

  static String _typeLabel(String? type) => switch (type) {
        'emoji' => '表情包',
        'file' => '文件',
        'ui' => '组件',
        'app' => '应用',
        'command' => '可执行',
        'classes' => '类库',
        'functions' => '函数库',
        _ => type ?? '商品',
      };
}