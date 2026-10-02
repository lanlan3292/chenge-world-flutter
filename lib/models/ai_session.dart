class AiSession {
  const AiSession({
    required this.sessionId,
    required this.name,
    this.id,
    this.userId,
    this.scene,
    this.createTime,
  });

  final int? id;
  final String sessionId;
  final String name;
  final int? userId;
  final String? scene;
  final DateTime? createTime;

  factory AiSession.fromJson(Map<String, dynamic> json) {
    final sessionId = _text(json['sessionId']).isNotEmpty
        ? _text(json['sessionId'])
        : _text(json['session_id']);
    return AiSession(
      id: _nullableInt(json['id']),
      sessionId: sessionId,
      name: _text(json['name'], fallback: '新对话'),
      userId: _nullableInt(json['userId'] ?? json['user_id']),
      scene: _nullableText(json['scene']),
      createTime: DateTime.tryParse(
        _text(json['createTime'] ?? json['created_at'] ?? json['createdAt']),
      ),
    );
  }

  static int? _nullableInt(Object? value) {
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }

  static String _text(Object? value, {String fallback = ''}) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? fallback : text;
  }

  static String? _nullableText(Object? value) {
    final text = _text(value);
    return text.isEmpty ? null : text;
  }
}

/// One bubble in the AI thread (history + live stream).
class AiChatBubble {
  AiChatBubble({
    required this.role,
    required this.content,
    this.status,
    this.streaming = false,
  });

  /// user | assistant | system | tool
  final String role;
  String content;
  String? status;
  bool streaming;

  factory AiChatBubble.fromHistory(dynamic raw) {
    if (raw is Map) {
      final map = Map<String, dynamic>.from(raw);
      final role = _roleOf(map);
      final content = _contentOf(map);
      return AiChatBubble(role: role, content: content);
    }
    return AiChatBubble(role: 'assistant', content: '$raw');
  }

  static String _roleOf(Map<String, dynamic> map) {
    final role = (map['role'] ?? map['type'] ?? map['sender'] ?? 'assistant').toString().toLowerCase();
    if (role.contains('human') || role == 'user' || role == 'human') return 'user';
    if (role.contains('system')) return 'system';
    if (role.contains('tool')) return 'tool';
    return 'assistant';
  }

  static String _contentOf(Map<String, dynamic> map) {
    final content = map['content'] ?? map['text'] ?? map['message'] ?? map['user_input'];
    if (content is String) return content;
    if (content is List) {
      final parts = <String>[];
      for (final item in content) {
        if (item is String) {
          parts.add(item);
        } else if (item is Map && item['text'] != null) {
          parts.add('${item['text']}');
        } else if (item is Map && item['content'] != null) {
          parts.add('${item['content']}');
        }
      }
      return parts.join('\n');
    }
    if (content != null) return content.toString();
    return '';
  }
}
