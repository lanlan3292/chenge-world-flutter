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
    this.status = statusPublished,
    this.reviewNote,
  });

  /// Review pipeline reported by the API since the `published` rollout.
  static const String statusPublished = 'published';
  static const String statusReviewing = 'reviewing';
  static const String statusRejected = 'rejected';
  static const String statusDeleted = 'deleted';

  /// Legacy status used before the review pipeline; still means "buyable".
  static const String statusLegacyOn = 'on';

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

  /// Moderation feedback, only set when the reviewer rejected the item.
  final String? reviewNote;

  double get priceCoins => price / 100;

  /// `true` while the item is visible to everyone (or served by an older API).
  bool get isPublished => status == statusPublished || status == statusLegacyOn;

  bool get isUnderReview => status == statusReviewing;

  bool get isRejected => status == statusRejected;

  bool get isSoldOut => stock <= 0;

  /// A published item with stock left is the only thing a buyer can purchase.
  bool get isPurchasable => isPublished && !isSoldOut;

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
        status: _text(json['status'], fallback: statusPublished),
        reviewNote: _nullableText(json['reviewNote']),
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