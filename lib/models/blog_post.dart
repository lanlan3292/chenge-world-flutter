class BlogPost {
  const BlogPost({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.authorName,
    required this.createdAt,
    required this.viewCount,
    required this.likeCount,
    required this.commentCount,
    this.coverImage,
    this.authorAvatar,
    this.categoryName,
    this.liked = false,
    this.tags = const [],
  });

  final int id;
  final String title;
  final String summary;
  final String content;
  final String authorName;
  final DateTime? createdAt;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final String? coverImage;
  final String? authorAvatar;
  final String? categoryName;
  final bool liked;
  final List<String> tags;

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    final content = _text(json['content']);
    final summary = _text(json['summary']);
    final tags = json['tags'];

    return BlogPost(
      id: _integer(json['id']),
      title: _text(json['title'], fallback: '未命名帖子'),
      summary: summary.isNotEmpty ? summary : _plainText(content),
      content: content,
      authorName: _text(json['authorName'], fallback: 'Chenge 用户'),
      createdAt: DateTime.tryParse(_text(json['createdAt'])),
      viewCount: _integer(json['viewCount']),
      likeCount: _integer(json['likeCount']),
      commentCount: _integer(json['commentCount']),
      coverImage: _nullableText(json['coverImage']),
      authorAvatar: _nullableText(json['authorAvatar']),
      categoryName: _nullableText(json['categoryName']),
      liked: json['liked'] == true,
      tags: tags is List ? tags.map((tag) => _text(tag)).where((tag) => tag.isNotEmpty).toList() : const [],
    );
  }

  static int _integer(Object? value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static String _text(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  static String? _nullableText(Object? value) {
    final text = _text(value);
    return text.isEmpty ? null : text;
  }

  static String _plainText(String markdown) => markdown
      .replaceAll(RegExp(r'!\[[^\]]*\]\([^)]*\)'), '')
      .replaceAllMapped(RegExp(r'\[([^\]]+)\]\([^)]*\)'), (match) => match.group(1) ?? '')
      .replaceAll(RegExp(r'[#>*_`~]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}