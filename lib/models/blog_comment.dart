class BlogComment {
  const BlogComment({
    required this.id,
    required this.blogId,
    required this.userId,
    required this.content,
    required this.likeCount,
    required this.createdAt,
    this.authorName,
    this.authorAvatar,
    this.parentId = 0,
    this.replyToName,
    this.children = const [],
  });

  final int id;
  final int blogId;
  final int userId;
  final String content;
  final int likeCount;
  final DateTime? createdAt;
  final String? authorName;
  final String? authorAvatar;
  final int parentId;
  final String? replyToName;
  final List<BlogComment> children;

  factory BlogComment.fromJson(Map<String, dynamic> json) {
    final children = json['children'];
    return BlogComment(
      id: _integer(json['id']),
      blogId: _integer(json['blogId']),
      userId: _integer(json['userId']),
      content: _text(json['content']),
      likeCount: _integer(json['likeCount']),
      createdAt: DateTime.tryParse(_text(json['createdAt'])),
      authorName: _nullableText(json['authorName']),
      authorAvatar: _nullableText(json['authorAvatar']),
      parentId: _integer(json['parentId']),
      replyToName: _nullableText(json['replyToName']),
      children: children is List
          ? children.whereType<Map<String, dynamic>>().map(BlogComment.fromJson).toList()
          : const [],
    );
  }

  static int _integer(Object? value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static String _text(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  static String? _nullableText(Object? value) {
    final text = _text(value);
    return text.isEmpty ? null : text;
  }
}