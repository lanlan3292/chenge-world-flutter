/// 群聊频道（后端 chat_channel 表 + `GET /chat/groups/{id}` 的 canSend）。
class ChatChannel {
  const ChatChannel({
    required this.id,
    required this.name,
    this.type = 'text',
    this.topic = '',
    this.position = 0,
    this.unread = 0,
    this.canSend = false,
  });

  final int id;
  final String name;

  /// text = 普通文字频道；announcement = 公告频道。
  final String type;
  final String topic;
  final int position;
  final int unread;
  final bool canSend;

  bool get isAnnouncement => type == 'announcement';

  factory ChatChannel.fromJson(Map<String, dynamic> json) => ChatChannel(
        id: _integer(json['id']),
        name: _text(json['name'], fallback: '频道'),
        type: _text(json['type'], fallback: 'text'),
        topic: _text(json['topic']),
        position: _integer(json['position']),
        unread: _integer(json['unread']),
        canSend: _asBool(json['canSend']),
      );

  /// 从群总览响应中解析可见频道列表。
  static List<ChatChannel> listFromOverview(Map<String, dynamic> overview) {
    final channels = overview['channels'];
    if (channels is! List) return const [];
    return channels
        .whereType<Map<String, dynamic>>()
        .map(ChatChannel.fromJson)
        .where((channel) => channel.id > 0)
        .toList();
  }

  static int _integer(Object? value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static String _text(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  static bool _asBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    final text = value?.toString().trim().toLowerCase() ?? '';
    return text == 'true' || text == '1';
  }
}
