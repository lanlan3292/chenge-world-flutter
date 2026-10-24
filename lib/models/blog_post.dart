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
    this.images = const [],
    this.media = const [],
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
  final List<String> images;
  final List<String> media;

  factory BlogPost.fromJson(Map<String, dynamic> json) {
    final content = _text(json['content']);
    final summary = _text(json['summary']);
    final tags = json['tags'];
    final images = json['images'];
    final media = json['media'];

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
      liked: _asBool(json['liked']),
      tags: tags is List ? tags.map((tag) => _text(tag)).where((tag) => tag.isNotEmpty).toList() : const [],
      images: images is List
          ? images.map((item) => _text(item)).where((item) => item.isNotEmpty).toList()
          : const [],
      media: _stringList(media),
    );
  }


  /// Image that represents this post in lists and detail headers.
  ///
  /// Prefers the explicit cover, then uploaded images, and finally the first
  /// image embedded in the markdown/HTML body — older posts often have no
  /// cover but do have images inline, which used to render as an empty card.
  String? get displayCoverImage {
    final cover = coverImage?.trim();
    if (cover != null && cover.isNotEmpty) return cover;
    for (final image in images) {
      final trimmed = image.trim();
      if (trimmed.isNotEmpty) return trimmed;
    }
    return firstInlineImage;
  }

  /// First image target embedded in [content] (markdown `![]()` or HTML `img`).
  String? get firstInlineImage {
    if (content.isEmpty) return null;
    final markdown = RegExp(
      r'!\[[^\]]*\]\(\s*<?([^)\s>]+)',
    ).firstMatch(content);
    final fromMarkdown = _cleanImageUrl(markdown?.group(1));
    if (fromMarkdown != null) return fromMarkdown;
    final html = RegExp(
      r'''<img[^>]+src\s*=\s*["']([^"']+)["']''',
      caseSensitive: false,
    ).firstMatch(content);
    return _cleanImageUrl(html?.group(1));
  }

  static String? _cleanImageUrl(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    if (trimmed.isEmpty || trimmed.startsWith('data:')) return null;
    return trimmed;
  }

  static bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text == 'true' || text == '1' || text == 'yes';
  }

  BlogPost copyWith({
    int? id,
    String? title,
    String? summary,
    String? content,
    String? authorName,
    DateTime? createdAt,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    String? coverImage,
    String? authorAvatar,
    String? categoryName,
    bool? liked,
    List<String>? tags,
    List<String>? images,
    List<String>? media,
  }) {
    return BlogPost(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      coverImage: coverImage ?? this.coverImage,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      categoryName: categoryName ?? this.categoryName,
      liked: liked ?? this.liked,
      tags: tags ?? this.tags,
      images: images ?? this.images,
      media: media ?? this.media,
    );
  }

  static List<String> _stringList(Object? value) {
    if (value is List) {
      return value.map((item) => _text(item)).where((item) => item.isNotEmpty).toList();
    }
    if (value is String && value.trim().isNotEmpty) {
      // Backend may store newline-joined media.
      return value
          .split(RegExp(r'[\n,]'))
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }
    return const [];
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