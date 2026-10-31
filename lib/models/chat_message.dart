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
    this.reactions = const [],
    this.replyTo,
    this.recallDeadline,
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

  /// 表情回应（后端 `reactions`，已按 emoji/key 聚合）。
  final List<ChatReaction> reactions;

  /// 被引用的消息快照；后端只在同会话同频道时返回。
  final ChatQuote? replyTo;

  /// 撤回截止时间（后端 createdAt + 2 分钟）。
  final DateTime? recallDeadline;

  bool get isRecalled => type == 'recalled';

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
        reactions: ChatReaction.listFromJson(json['reactions']),
        replyTo: ChatQuote.tryParse(json['reply']),
        recallDeadline: _millis(json['recallDeadline']),
      );

  /// 撤回 / 回应等局部更新。
  ChatMessage copyWith({
    String? type,
    String? content,
    List<ChatReaction>? reactions,
  }) => ChatMessage(
    id: id,
    conversationId: conversationId,
    senderId: senderId,
    type: type ?? this.type,
    content: content ?? this.content,
    senderName: senderName,
    senderAvatar: senderAvatar,
    createdAt: createdAt,
    channelId: channelId,
    reactions: reactions ?? this.reactions,
    replyTo: replyTo,
    recallDeadline: recallDeadline,
  );

  static DateTime? _millis(Object? value) {
    if (value is! num) return null;
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
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

/// 被引用消息的快照（后端 message view 的 `reply`）。
class ChatQuote {
  const ChatQuote({
    required this.id,
    this.senderId = 0,
    this.senderName,
    this.type = 'text',
    this.content = '',
  });

  final int id;
  final int senderId;
  final String? senderName;
  final String type;
  final String content;

  String get preview {
    switch (type) {
      case 'emoji':
        return '[表情]';
      case 'image':
        return '[图片]';
      case 'post':
        return '[帖子]';
      case 'order':
        return '[订单]';
      case 'recalled':
        return '消息已撤回';
      case 'qq':
      case 'game':
        final text = ChatInteropContent.tryParse(content)?.displayText ?? '';
        return text.isEmpty ? '[跨平台消息]' : text;
      default:
        final text = content.replaceAll(RegExp(r'\s+'), ' ').trim();
        return text.length > 120 ? '${text.substring(0, 120)}…' : text;
    }
  }

  static ChatQuote? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final map = raw.cast<String, dynamic>();
    final id = map['id'] is num ? (map['id'] as num).toInt() : int.tryParse('${map['id']}');
    if (id == null || id <= 0) return null;
    return ChatQuote(
      id: id,
      senderId:
          map['senderId'] is num
              ? (map['senderId'] as num).toInt()
              : int.tryParse('${map['senderId']}') ?? 0,
      senderName: _nullableText(map['senderName']),
      type: (map['type'] ?? 'text').toString(),
      content: (map['content'] ?? '').toString(),
    );
  }

  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}

/// 表情回应用户。
class ChatReactionUser {
  const ChatReactionUser({this.userId = 0, this.name, this.avatar});

  final int userId;
  final String? name;
  final String? avatar;

  static ChatReactionUser? tryParse(Object? raw) {
    if (raw is! Map) return null;
    final map = raw.cast<String, dynamic>();
    return ChatReactionUser(
      userId:
          map['userId'] is num
              ? (map['userId'] as num).toInt()
              : int.tryParse('${map['userId']}') ?? 0,
      name: _nullableText(map['name']),
      avatar: _nullableText(map['avatar']),
    );
  }

  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}

/// 一条消息上的聚合回应：`{type:'emoji', emoji, users, count}`。
class ChatReaction {
  const ChatReaction({
    this.type = 'emoji',
    this.emoji,
    this.itemId,
    this.key,
    this.url,
    this.users = const [],
    this.count = 0,
  });

  final String type;
  final String? emoji;
  final int? itemId;
  final String? key;
  final String? url;
  final List<ChatReactionUser> users;
  final int count;

  bool get isEmoji => type == 'emoji' && (emoji ?? '').isNotEmpty;

  bool reactedBy(int userId) => users.any((user) => user.userId == userId);

  String get display => isEmoji ? emoji! : '🎨';

  static List<ChatReaction> listFromJson(Object? raw) {
    if (raw is! List) return const [];
    final result = <ChatReaction>[];
    for (final item in raw) {
      if (item is! Map) continue;
      final map = item.cast<String, dynamic>();
      final users = <ChatReactionUser>[];
      final rawUsers = map['users'];
      if (rawUsers is List) {
        for (final user in rawUsers) {
          final parsed = ChatReactionUser.tryParse(user);
          if (parsed != null) users.add(parsed);
        }
      }
      result.add(
        ChatReaction(
          type: (map['type'] ?? 'emoji').toString(),
          emoji: _nullableText(map['emoji']),
          itemId:
              map['itemId'] is num
                  ? (map['itemId'] as num).toInt()
                  : int.tryParse('${map['itemId']}'),
          key: _nullableText(map['key']),
          url: _nullableText(map['url'] ?? map['fileUrl'] ?? map['cover']),
          users: users,
          count:
              map['count'] is num
                  ? (map['count'] as num).toInt()
                  : users.length,
        ),
      );
    }
    return result;
  }

  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}