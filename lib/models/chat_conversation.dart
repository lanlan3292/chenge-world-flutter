import 'chat_message.dart';

class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.type,
    required this.name,
    required this.unread,
    this.peerId,
    this.avatar,
    this.updatedAt,
    this.lastMessage,
  });

  final int id;
  final String type;
  final String name;
  final int unread;
  final int? peerId;
  final String? avatar;
  final DateTime? updatedAt;
  final ChatMessage? lastMessage;

  factory ChatConversation.fromJson(Map<String, dynamic> json, {int? fallbackPeerId}) {
    final lastMessage = json['lastMessage'];
    return ChatConversation(
      id: _integer(json['id']),
      type: _text(json['type'], fallback: 'single'),
      name: _text(json['name'], fallback: fallbackPeerId == null ? '新会话' : '用户$fallbackPeerId'),
      unread: _integer(json['unread']),
      peerId: _integer(json['peerId']) == 0 ? fallbackPeerId : _integer(json['peerId']),
      avatar: _nullableText(json['avatar']),
      updatedAt: DateTime.tryParse(_text(json['updatedAt'])),
      lastMessage: lastMessage is Map<String, dynamic> ? ChatMessage.fromJson(lastMessage) : null,
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