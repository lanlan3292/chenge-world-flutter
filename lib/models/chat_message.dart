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
  });

  final int id;
  final int conversationId;
  final int senderId;
  final String type;
  final String content;
  final String? senderName;
  final String? senderAvatar;
  final DateTime? createdAt;

  EmojiMessageContent? get emoji => type == 'emoji' ? EmojiMessageContent.tryParse(content) : null;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: _integer(json['id']),
        conversationId: _integer(json['conversationId']),
        senderId: _integer(json['senderId']),
        type: _text(json['type'], fallback: 'text'),
        content: _text(json['content']),
        senderName: _nullableText(json['senderName']),
        senderAvatar: _nullableText(json['senderAvatar']),
        createdAt: DateTime.tryParse(_text(json['createdAt'])),
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