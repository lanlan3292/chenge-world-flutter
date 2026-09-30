class FriendUser {
  const FriendUser({
    required this.userId,
    required this.username,
    this.nickname,
    this.avatar,
    this.remark,
    this.mutual = false,
    this.iSent = false,
    this.iReceived = false,
  });

  final int userId;
  final String username;
  final String? nickname;
  final String? avatar;
  final String? remark;
  final bool mutual;
  final bool iSent;
  final bool iReceived;

  String get displayName => nickname?.trim().isNotEmpty == true ? nickname!.trim() : username;

  factory FriendUser.fromJson(Map<String, dynamic> json) {
    return FriendUser(
      userId: _integer(json['userId']),
      username: _text(json['username'], fallback: '用户'),
      nickname: _nullableText(json['nickname']),
      avatar: _nullableText(json['avatar']),
      remark: _nullableText(json['remark']),
      mutual: json['mutual'] == true,
      iSent: json['iSent'] == true,
      iReceived: json['iReceived'] == true,
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
}