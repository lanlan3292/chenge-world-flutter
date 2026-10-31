import 'dart:convert';

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.type,
    required this.content,
    this.senderName,
    this.senderAvatar,
    this.createdAt,
    this.channelId,
  });

  final int id;
  final int conversationId;
  final int senderId;
  final String type;
  final String content;
  final String? senderName;
  final String? senderAvatar;
  final DateTime? createdAt;

  /// 群聊频道 ID；私聊为 null。
  final int? channelId;

  EmojiMessageContent? get emoji => type == 'emoji' ? EmojiMessageContent.tryParse(content) : null;

  /// 图片消息（后端 type='image'，content 为 {url, fileId, alt}）。
  ChatImageContent? get image => type == 'image' ? ChatImageContent.tryParse(content) : null;

  /// 跨平台互通消息（后端 type='qq' / 'game'）。
  ChatInteropContent? get interop =>
      type == 'qq' || type == 'game' ? ChatInteropContent.tryParse(content) : null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: _integer(json['id']),
        conversationId: _integer(json['conversationId']),
        senderId: _integer(json['senderId']),
        type: _text(json['type'], fallback: 'text'),
        content: _text(json['content']),
        senderName: _nullableText(json['senderName']),
        senderAvatar: _nullableText(json['senderAvatar']),
        createdAt: DateTime.tryParse(_text(json['createdAt'])),
        channelId: json['channelId'] == null ? null : _integer(json['channelId']),
      );

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

class EmojiMessageContent {
  const EmojiMessageContent({this.itemId, this.key, this.fileId, this.url});

  final int? itemId;
  final String? key;
  final int? fileId;
  final String? url;

  static EmojiMessageContent? tryParse(String content) {
    try {
      final json = jsonDecode(content);
      if (json is! Map<String, dynamic>) return null;
      return EmojiMessageContent(
        itemId: _integer(json['itemId']),
        key: _nullableText(json['key']),
        fileId: _integer(json['fileId']),
        url: _nullableText(json['url']),
      );
    } on FormatException {
      return null;
    }
  }

  static int? _integer(Object? value) => value is num ? value.toInt() : int.tryParse('$value');
  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}
/// 图片消息内容：`{"url": "...", "fileId": 1, "alt": "..."}`。
/// 旧消息可能只有 fileId，需要再用 /file-module/files/info/{id} 换 url。
class ChatImageContent {
  const ChatImageContent({this.url, this.fileId, this.alt});

  final String? url;
  final int? fileId;
  final String? alt;

  static ChatImageContent? tryParse(String content) {
    final raw = content.trim();
    if (raw.isEmpty) return null;
    if (raw.startsWith('http') || raw.startsWith('/')) {
      return ChatImageContent(url: raw);
    }
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      return ChatImageContent(
        url: _nullableText(json['url'] ?? json['src']),
        fileId: _integer(json['fileId'] ?? json['file_id']),
        alt: _nullableText(json['alt']),
      );
    } on FormatException {
      return null;
    }
  }

  static int? _integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value');
  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}

/// 跨平台互通消息内容（QQ 群 / 游戏频道同步过来的消息）。
class ChatInteropContent {
  const ChatInteropContent({
    this.message = '',
    this.groupName,
    this.nickname,
    this.role,
    this.gameId,
    this.country,
    this.server,
    this.coordinates = const {},
    this.images = const [],
  });

  final String message;
  final String? groupName;
  final String? nickname;
  final String? role;
  final String? gameId;
  final String? country;
  final String? server;
  final Map<String, String> coordinates;
  final List<String> images;

  /// 去掉 message 里的 Markdown 图片语法（图片单独渲染）。
  String get displayText => message
      .replaceAll(RegExp(r'!\[[^\]]*\]\(<?[^)>]*>?\)'), '')
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim();

  /// 弹窗里展示的来源细节。
  List<String> get details => [
    if (gameId != null) 'Game ID: $gameId',
    if (nickname != null) nickname!,
    if (groupName != null) groupName!,
    if (role != null) role!,
    if (country != null) country!,
    if (server != null) server!,
    if (coordinates.isNotEmpty)
      coordinates.entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => '${entry.key.toUpperCase()} ${entry.value}')
          .join(' · '),
  ];

  static ChatInteropContent? tryParse(String content) {
    try {
      final json = jsonDecode(content);
      if (json is! Map<String, dynamic>) return null;
      final images = <String>[];
      final rawImages = json['images'];
      if (rawImages is List) {
        for (final item in rawImages) {
          final url = item?.toString().trim() ?? '';
          if (url.startsWith('http')) images.add(url);
        }
      }
      final coordinates = <String, String>{};
      final rawCoordinates = json['coordinates'];
      if (rawCoordinates is Map) {
        rawCoordinates.forEach((key, value) {
          if (value == null) return;
          coordinates['$key'] = '$value';
        });
      }
      return ChatInteropContent(
        message: (json['message'] ?? json['gameMessage'] ?? '').toString(),
        groupName: _nullableText(json['groupName']),
        nickname: _nullableText(json['nickname']),
        role: _nullableText(json['role']),
        gameId: _nullableText(json['gameId']),
        country: _nullableText(json['country']),
        server: _nullableText(json['server']),
        coordinates: coordinates,
        images: images,
      );
    } on FormatException {
      return null;
    }
  }

  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}