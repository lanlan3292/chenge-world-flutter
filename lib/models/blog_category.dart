class BlogCategory {
  const BlogCategory({
    required this.id,
    required this.name,
    this.description,
    this.iconUrl,
    this.postCount = 0,
    this.isPublic = true,
  });

  final int id;
  final String name;
  final String? description;
  final String? iconUrl;
  final int postCount;
  final bool isPublic;

  factory BlogCategory.fromJson(Map<String, dynamic> json) {
    return BlogCategory(
      id: _integer(json['id']),
      name: _text(json['name'], fallback: 'Category'),
      description: _nullableText(json['description']),
      iconUrl: _nullableText(json['iconUrl']),
      postCount: _integer(json['postCount']),
      isPublic: json['isPublic'] == null ? true : _asBool(json['isPublic']),
    );
  }

  static int _integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static String _text(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  static String? _nullableText(Object? value) {
    final text = _text(value);
    return text.isEmpty ? null : text;
  }

  static bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text == 'true' || text == '1' || text == 'yes';
  }
}
