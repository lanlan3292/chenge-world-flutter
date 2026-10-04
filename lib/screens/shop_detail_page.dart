import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/shop_item.dart';
import '../services/chenge_api.dart';
import '../theme/app_theme.dart';

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
        _owned = assets.any(
          (asset) =>
              '${asset['itemId']}' == '${widget.item.id}' &&
              (asset['quantity'] as num? ?? 0) > 0,
        );
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('购买成功，已加入资产清单')));
      setState(() => _buying = false);
      Navigator.pop(context, true);
      routeClosed = true;
    } on ApiException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: AppTheme.coral,
          ),
        );
      }
    } finally {
      if (mounted && !routeClosed) setState(() => _buying = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: '返回商城',
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: Text(
        AppLocalizations.of(context).productDetails,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    body: FutureBuilder<ShopItem>(
      future: _detail,
      builder: (context, snapshot) {
        final item = snapshot.data ?? widget.item;
        if (snapshot.hasError && snapshot.data == null) {
          return Center(child: Text('${snapshot.error}'));
        }
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
              child: SizedBox(
                height: width >= 900 ? 330 : 240,
                child: _detailImage(item),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      height: 1.15,
                    ),
                  ),
                ),
                _coinTag('${item.priceCoins.toStringAsFixed(2)} CC'),
              ],
            ),
            if (item.summary?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                item.summary!,
                style: const TextStyle(color: Color(0xFF687A74), height: 1.5),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _stat(Icons.inventory_2_outlined, '库存 ${item.stock}'),
                _stat(Icons.shopping_bag_outlined, '已售 ${item.soldCount}'),
                _stat(
                  Icons.star_outline_rounded,
                  '${item.rating.toStringAsFixed(1)} · ${item.ratingCount} 评价',
                ),
                _stat(Icons.category_outlined, _typeLabel(item.type)),
              ],
            ),
            if (item.sellerName != null) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: Color(0xFFFFE8C5),
                    child: Icon(
                      Icons.storefront_rounded,
                      size: 16,
                      color: AppTheme.ink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item.sellerName!,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
            if (item.detail?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 20),
              const Text(
                '商品介绍',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              MarkdownBody(data: item.detail!, selectable: true),
            ],
            if (item.content?.trim().isNotEmpty == true &&
                (_owned || isSeller)) ...[
              const SizedBox(height: 20),
              const Text(
                '已购内容',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              SelectableText(
                item.content!,
                style: const TextStyle(height: 1.5),
              ),
            ] else if (item.type != 'emoji' &&
                item.type != 'ui' &&
                item.content?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                '购买后可查看完整内容',
                style: TextStyle(color: Color(0xFF70817D), fontSize: 13),
              ),
            ],
            if (item.fileUrl != null && (_owned || isSeller)) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed:
                    () => launchUrl(
                      Uri.parse(item.fileUrl!),
                      mode: LaunchMode.externalApplication,
                    ),
                icon: const Icon(Icons.download_rounded),
                label: const Text('打开/下载文件'),
              ),
            ],
            const SizedBox(height: 22),
            if (_balance != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  '余额 ${_balance!.toStringAsFixed(2)} CC',
                  style: const TextStyle(color: Color(0xFF70817D)),
                ),
              ),
            if (canBuy) ...[
              Row(
                children: [
                  IconButton.filledTonal(
                    onPressed:
                        _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                    icon: const Icon(Icons.remove_rounded),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '$_quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed:
                        _quantity < item.stock
                            ? () => setState(() => _quantity++)
                            : null,
                    icon: const Icon(Icons.add_rounded),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed:
                        _buying || _checkingOwned ? null : () => _buy(item),
                    icon:
                        _buying
                            ? SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                            : const Icon(Icons.shopping_bag_outlined),
                    label: Text(_buying ? '购买中…' : '购买'),
                  ),
                ],
              ),
            ] else if (isSeller)
              const Text(
                '这是你上架的商品',
                style: TextStyle(color: Color(0xFF70817D)),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailImage(ShopItem item) {
    final cover = item.cover;
    if (cover == null || cover.isEmpty) {
      return Container(
        color: const Color(0xFFDDECE5),
        child: Center(
          child: Text(
            item.title.isEmpty ? '商' : item.title.characters.first,
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w900,
              color: AppTheme.ink,
            ),
          ),
        ),
      );
    }
    return Image.network(
      cover,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder:
          (_, __, ___) => Container(
            color: const Color(0xFFDDECE5),
            child: Center(
              child: Text(
                item.title.isEmpty ? '商' : item.title.characters.first,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.ink,
                ),
              ),
            ),
          ),
    );
  }

  Widget _coinTag(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
    decoration: BoxDecoration(
      color: const Color(0xFFFFE8C5),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppTheme.coral,
        fontWeight: FontWeight.w900,
      ),
    ),
  );

  Widget _stat(IconData icon, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: const Color(0xFF70817D)),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(fontSize: 12, color: Color(0xFF70817D)),
      ),
    ],
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
}
