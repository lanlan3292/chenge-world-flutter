class BlogTag {
  const BlogTag({
    required this.id,
    required this.name,
    this.postCount = 0,
  });

  final int id;
  final String name;
  final int postCount;

  factory BlogTag.fromJson(Map<String, dynamic> json) {
    return BlogTag(
      id: _integer(json['id']),
      name: _text(json['name'] ?? json['tagName']),
      postCount: _integer(json['postCount'] ?? json['count'] ?? json['useCount']),
    );
  }

  static int _integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? '' : text;
  }
}
