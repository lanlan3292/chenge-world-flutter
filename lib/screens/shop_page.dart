import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/shop_item.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';
import 'shop_detail_page.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    super.key,
    required this.api,
    required this.token,
    required this.userId,
    required this.onLoginRequested,
    this.autoHideTopBar = true,
    this.autoHideBottomBar = true,
    this.minColumns = 1,
    this.maxColumns = 3,
    this.onChromeVisibilityChanged,
  });

  final ChengeApi api;
  final String? token;
  final int? userId;
  final VoidCallback onLoginRequested;
  final bool autoHideTopBar;
  final bool autoHideBottomBar;

  /// Minimum grid column count (1–3).
  final int minColumns;

  /// Maximum grid column count (1–3). Always ≥ [minColumns].
  final int maxColumns;

  /// Called when scrolling should show/hide shell bottom nav.
  final ValueChanged<bool>? onChromeVisibilityChanged;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final _scrollController = ScrollController();
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
  bool _chromeVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    if (!widget.autoHideBottomBar && !_chromeVisible) {
      _setChromeVisible(true);
    }
    if (widget.autoHideBottomBar && !oldWidget.autoHideBottomBar) {
      // Always show chrome when returning to a layout that has a bottom bar.
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
    if (!widget.autoHideBottomBar && !widget.autoHideTopBar) return;
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

    if ((_chromeScrollAccum > 0 && delta < 0) ||
        (_chromeScrollAccum < 0 && delta > 0)) {
      _chromeScrollAccum = 0;
    }
    _chromeScrollAccum += delta;

    if (_chromeScrollAccum > _chromeScrollThreshold) {
      _chromeScrollAccum = 0;
      _setChromeVisible(false);
    } else if (_chromeScrollAccum < -_chromeScrollThreshold) {
      _chromeScrollAccum = 0;
      _setChromeVisible(true);
    }
  }

  void _setChromeVisible(bool visible) {
    if (_chromeVisible == visible) return;
    _chromeVisible = visible;
    // Do not setState: bottom padding stays fixed so the list does not reflow.
    // 顶栏隐藏也需要通知外壳，用于状态栏遮罩。
    if (widget.autoHideBottomBar || widget.autoHideTopBar) {
      widget.onChromeVisibilityChanged?.call(visible);
    }
  }

  Future<void> _loadItems({int page = 1}) async {
    final requestId = ++_itemRequestId;
    setState(() {
      _loading = true;
      _error = '';
      _items.clear();
      _page = 0;
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
      if (mounted && requestId == _itemRequestId) {
        setState(() => _error = error.message);
      }
    } finally {
      if (mounted && requestId == _itemRequestId) {
        setState(() => _loading = false);
      }
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
    _setChromeVisible(true);
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
    _setChromeVisible(true);
    final purchased = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder:
            (_) => ShopDetailPage(
              api: widget.api,
              item: item,
              token: widget.token,
              userId: widget.userId,
              onLoginRequested: widget.onLoginRequested,
            ),
      ),
    );
    if (purchased == true && mounted) {
      await _loadItems();
      if (widget.token != null) {
        _balance = await widget.api
            .shopBalance(widget.token!)
            .catchError((_) => _balance ?? 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final minCols = widget.minColumns.clamp(1, 3);
    final maxCols = widget.maxColumns.clamp(minCols, 3);
    final responsive =
        width >= 1180
            ? 3
            : width >= 760
            ? 2
            : 1;
    final columns = responsive.clamp(minCols, maxCols);
    final hideTop = widget.autoHideTopBar;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: RefreshIndicator(
            onRefresh:
                () => _view == 'mall' ? _loadItems() : _loadPrivate(_view),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  floating: hideTop,
                  snap: hideTop,
                  pinned: !hideTop,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  forceElevated: false,
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(60),
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
                        child: _viewSelector(),
                      ),
                    ),
                  ),
                  title: Text(
                    AppLocalizations.of(context).store,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  actions: [
                    if (_balance != null)
                      Center(
                        child: _coinPill('${_balance!.toStringAsFixed(2)} CC'),
                      ),
                    IconButton(
                      tooltip: AppLocalizations.of(context).refresh,
                      onPressed:
                          _loading
                              ? null
                              : () =>
                                  _view == 'mall'
                                      ? _loadItems()
                                      : _loadPrivate(_view),
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                    const SizedBox(width: 5),
                  ],
                ),
                if (_error.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    sliver: SliverToBoxAdapter(child: _errorBanner()),
                  ),
                ..._viewSlivers(columns),
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

  List<Widget> _viewSlivers(int columns) {
    if (_view == 'mall') {
      return [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
          sliver: SliverToBoxAdapter(child: _searchBar()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          sliver: SliverToBoxAdapter(child: _filters()),
        ),
        if (_loading && _items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error.isNotEmpty && _items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _empty(AppLocalizations.of(context).shopUnavailable, AppLocalizations.of(context).checkNetworkAndRetry),
          )
        else if (_items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: _empty(AppLocalizations.of(context).noProducts, AppLocalizations.of(context).tryOtherSearch),
          )
        else ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 11),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context).discoverItems,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalizations.of(context).itemCount(_total),
                    style: const TextStyle(color: Color(0xFF70817D)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            sliver: SliverGrid.builder(
              itemCount: _items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 278,
              ),
              itemBuilder: (context, index) => _itemCard(_items[index]),
            ),
          ),
          _pagination(),
        ],
      ];
    }

    if (widget.token == null) {
      return [
        SliverFillRemaining(hasScrollBody: false, child: _signedOutPrivate()),
      ];
    }
    if (_loadingPrivate && !_privateLoaded) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    final rows = _view == 'assets' ? _assets : _orders;
    if (rows.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _empty(
            _view == 'assets' ? AppLocalizations.of(context).noAssets : AppLocalizations.of(context).noOrders,
            AppLocalizations.of(context).purchasesShowHere,
          ),
        ),
      ];
    }
    return [
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index.isOdd) return const SizedBox(height: 8);
            final rowIndex = index ~/ 2;
            return _privateRow(rows[rowIndex], isAsset: _view == 'assets');
          }, childCount: rows.isEmpty ? 0 : rows.length * 2 - 1),
        ),
      ),
    ];
  }

  Widget _viewSelector() => SegmentedButton<String>(
    showSelectedIcon: false,
    segments: [
      ButtonSegment(
        value: 'mall',
        label: Text(AppLocalizations.of(context).shopNow),
        icon: const Icon(Icons.storefront_outlined),
      ),
      ButtonSegment(
        value: 'assets',
        label: Text(AppLocalizations.of(context).myAssets),
        icon: const Icon(Icons.inventory_2_outlined),
      ),
      ButtonSegment(
        value: 'orders',
        label: Text(AppLocalizations.of(context).orders),
        icon: const Icon(Icons.receipt_long_outlined),
      ),
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
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).searchProducts,
            prefixIcon: const Icon(Icons.search_rounded),
          ),
        ),
      ),
      const SizedBox(width: 8),
      IconButton.filledTonal(
        tooltip: AppLocalizations.of(context).searchProducts,
        onPressed: () => _loadItems(),
        icon: const Icon(Icons.arrow_forward_rounded),
      ),
      const SizedBox(width: 5),
      PopupMenuButton<String>(
        tooltip: AppLocalizations.of(context).sortProducts,
        initialValue: _sort,
        onSelected: (value) {
          setState(() => _sort = value);
          _loadItems();
        },
        itemBuilder:
            (context) => [
              PopupMenuItem(
                value: 'latest',
                child: Text(AppLocalizations.of(context).newestArrivals),
              ),
              PopupMenuItem(
                value: 'hot',
                child: Text(AppLocalizations.of(context).popularProducts),
              ),
              PopupMenuItem(
                value: 'price_asc',
                child: Text(AppLocalizations.of(context).priceLowToHigh),
              ),
              PopupMenuItem(
                value: 'price_desc',
                child: Text(AppLocalizations.of(context).priceHighToLow),
              ),
              PopupMenuItem(
                value: 'rating',
                child: Text(AppLocalizations.of(context).ratingFirst),
              ),
            ],
        child: const SizedBox.square(
          dimension: 44,
          child: Icon(Icons.sort_rounded),
        ),
      ),
    ],
  );

  Widget _filters() => SizedBox(
    height: 40,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        _typeChip('', AppLocalizations.of(context).all),
        _typeChip('file', AppLocalizations.of(context).files),
        _typeChip('emoji', AppLocalizations.of(context).emojiPacks),
        _typeChip('ui', AppLocalizations.of(context).components),
        _typeChip('app', AppLocalizations.of(context).applications),
        _typeChip('command', AppLocalizations.of(context).executables),
        _typeChip('classes', AppLocalizations.of(context).libraries),
        _typeChip('functions', AppLocalizations.of(context).functionLibraries),
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
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      item.summary ?? _typeLabel(context, item.type),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF70817D),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.sellerName ?? AppLocalizations.of(context).communityMerchant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF70817D),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        '${item.priceCoins.toStringAsFixed(2)} CC',
                        style: const TextStyle(
                          color: AppTheme.coral,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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
    final title = row['title']?.toString() ?? AppLocalizations.of(context).product;
    final cover = row['cover']?.toString();
    final price =
        row['price'] is num ? (row['price'] as num).toDouble() / 100 : 0.0;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap:
            isAsset && row['itemId'] is num
                ? () => _openItem(
                  ShopItem(
                    id: (row['itemId'] as num).toInt(),
                    title: title,
                    type: row['type']?.toString() ?? 'file',
                    price: (row['price'] as num?)?.toInt() ?? 0,
                    stock: 0,
                  ),
                )
                : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _image(cover, title),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      isAsset
                          ? AppLocalizations.of(context).holdingQuantityType(row['quantity'] ?? 0, _typeLabel(context, row['type']?.toString()))
                          : '${price.toStringAsFixed(2)} CC × ${row['quantity'] ?? 1} · ${_orderStatus(context, row['status']?.toString())}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF70817D),
                      ),
                    ),
                    if (!isAsset && row['createdAt'] != null)
                      Text(
                        row['createdAt'].toString().replaceFirst('T', ' '),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF83918D),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                isAsset
                    ? Icons.chevron_right_rounded
                    : Icons.receipt_long_outlined,
                color: const Color(0xFF81908A),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagination() {
    final totalPages = (_total + 11) ~/ 12;
    if (totalPages < 2) {
      return const SliverToBoxAdapter(child: SizedBox(height: 18));
    }
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              tooltip: AppLocalizations.of(context).previousPage,
              onPressed:
                  _loading || _page <= 1
                      ? null
                      : () => _loadItems(page: _page - 1),
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
                      : () => _loadItems(page: _page + 1),
              icon:
                  _loading
                      ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : const Icon(Icons.chevron_right_rounded),
            ),
          ],
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
        Text(AppLocalizations.of(context).noAssetsOrOrdersSignIn, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        FilledButton.icon(
          onPressed: widget.onLoginRequested,
          icon: const Icon(Icons.login_rounded),
          label: Text(AppLocalizations.of(context).goSignIn),
        ),
      ],
    ),
  );

  Widget _empty(String title, String subtitle) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.store_mall_directory_outlined,
          size: 48,
          color: AppTheme.leaf,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF70817D)),
        ),
        if (_view == 'mall' && _error.isNotEmpty) ...[
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _loadItems,
            icon: const Icon(Icons.refresh_rounded),
            label: Text(AppLocalizations.of(context).retry),
          ),
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
        child: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppTheme.coral,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(_error, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            IconButton(
              tooltip: AppLocalizations.of(context).retry,
              onPressed:
                  () => _view == 'mall' ? _loadItems() : _loadPrivate(_view),
              icon: const Icon(Icons.refresh_rounded),
            ),
          ],
        ),
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
      loadingBuilder:
          (context, child, progress) =>
              progress == null ? child : _imagePlaceholder(title),
    );
  }

  Widget _imagePlaceholder(String title) => Container(
    width: double.infinity,
    color: const Color(0xFFDDECE5),
    child: Center(
      child: Text(
        title.isEmpty ? AppLocalizations.of(context).productInitial : title.characters.first,
        style: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w900,
          color: AppTheme.ink,
        ),
      ),
    ),
  );

  Widget _coinPill(String label) => Container(
    margin: const EdgeInsets.only(right: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE8C5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppTheme.coral,
        fontWeight: FontWeight.w900,
        fontSize: 12,
      ),
    ),
  );

  static String _typeLabel(BuildContext context, [String? type]) {
    final l10n = AppLocalizations.of(context);
    return switch (type) {
      'emoji' => l10n.emojiPacks,
      'file' => l10n.files,
      'ui' => l10n.components,
      'app' => l10n.applications,
      'command' => l10n.executables,
      'classes' => l10n.libraries,
      'functions' => l10n.functionLibraries,
      _ => type ?? l10n.product,
    };
  }

  static String _orderStatus(BuildContext context, [String? status]) {
    final l10n = AppLocalizations.of(context);
    return switch (status) {
      'pending' => l10n.orderPending,
      'paid' => l10n.orderPaid,
      'refunded' => l10n.orderRefunded,
      _ => status ?? l10n.statusUnknown,
    };
  }
}
