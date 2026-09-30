class ShopItem {
  const ShopItem({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    required this.stock,
    this.summary,
    this.detail,
    this.cover,
    this.fileUrl,
    this.content,
    this.sellerId,
    this.sellerName,
    this.soldCount = 0,
    this.rating = 0,
    this.ratingCount = 0,
    this.status = 'on',
  });

  final int id;
  final String title;
  final String type;
  final int price;
  final int stock;
  final String? summary;
  final String? detail;
  final String? cover;
  final String? fileUrl;
  final String? content;
  final int? sellerId;
  final String? sellerName;
  final int soldCount;
  final double rating;
  final int ratingCount;
  final String status;

  double get priceCoins => price / 100;

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
        id: _integer(json['id']),
        title: _text(json['title'], fallback: '未命名商品'),
        type: _text(json['type'], fallback: 'file'),
        price: _integer(json['price']),
        stock: _integer(json['stock']),
        summary: _nullableText(json['summary']),
        detail: _nullableText(json['detail']),
        cover: _nullableText(json['cover']),
        fileUrl: _nullableText(json['fileUrl']),
        content: _nullableText(json['content']),
        sellerId: json['sellerId'] == null ? null : _integer(json['sellerId']),
        sellerName: _nullableText(json['sellerName']),
        soldCount: _integer(json['soldCount']),
        rating: _number(json['rating']),
        ratingCount: _integer(json['ratingCount']),
        status: _text(json['status'], fallback: 'on'),
      );

  static int _integer(Object? value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static double _number(Object? value) => value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
  static String _text(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  static String? _nullableText(Object? value) {
    final text = _text(value);
    return text.isEmpty ? null : text;
  }
}