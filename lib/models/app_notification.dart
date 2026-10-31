/// 站内通知（`/home/notify/*`）。
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    this.actorId,
    this.title = '',
    this.body = '',
    this.targetType = '',
    this.targetId = '',
    this.readFlag = 0,
    this.createdAt,
    this.actorName,
    this.avatar,
  });

  final int id;
  final String type;
  final int? actorId;
  final String title;
  final String body;
  final String targetType;
  final String targetId;
  final int readFlag;
  final DateTime? createdAt;
  final String? actorName;
  final String? avatar;

  bool get isRead => readFlag == 1;

  /// 聊天目标可能是 `conversationId` 或 `conversationId:channelId`。
  int? get conversationId {
    if (targetType != 'conversation') return null;
    final head = targetId.split(':').first.trim();
    return int.tryParse(head);
  }

  int? get channelId {
    if (targetType != 'conversation') return null;
    final parts = targetId.split(':');
    if (parts.length < 2) return null;
    return int.tryParse(parts[1].trim());
  }

  AppNotification copyWith({int? readFlag}) => AppNotification(
    id: id,
    type: type,
    actorId: actorId,
    title: title,
    body: body,
    targetType: targetType,
    targetId: targetId,
    readFlag: readFlag ?? this.readFlag,
    createdAt: createdAt,
    actorName: actorName,
    avatar: avatar,
  );

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
    id: json['id'] is num ? (json['id'] as num).toInt() : 0,
    type: (json['type'] ?? '').toString(),
    actorId: json['actorId'] is num ? (json['actorId'] as num).toInt() : null,
    title: (json['title'] ?? '').toString(),
    body: (json['body'] ?? '').toString(),
    targetType: (json['targetType'] ?? '').toString(),
    targetId: (json['targetId'] ?? '').toString(),
    readFlag: json['readFlag'] is num ? (json['readFlag'] as num).toInt() : 0,
    createdAt: _date(json['createdAt']),
    actorName: json['actorName']?.toString(),
    avatar: json['avatar']?.toString(),
  );

  /// 处理 WebSocket `type=notify` 推送帧。
  factory AppNotification.fromSocket(Map<String, dynamic> json) => AppNotification(
    id: json['id'] is num ? (json['id'] as num).toInt() : 0,
    type: (json['ntype'] ?? json['type'] ?? '').toString(),
    actorId: json['actorId'] is num ? (json['actorId'] as num).toInt() : null,
    title: (json['title'] ?? '').toString(),
    body: (json['body'] ?? '').toString(),
    targetType: (json['targetType'] ?? '').toString(),
    targetId: (json['targetId'] ?? '').toString(),
    createdAt: _date(json['at']),
    avatar: json['avatar']?.toString(),
  );
}

/// 通知列表 + 未读统计（一次请求同时喂列表和角标）。
class AppNotificationFeed {
  const AppNotificationFeed({
    required this.items,
    required this.unread,
    this.unreadByType = const {},
  });

  final List<AppNotification> items;
  final int unread;
  final Map<String, int> unreadByType;

  factory AppNotificationFeed.fromJson(Map<String, dynamic> json) {
    final items = json['items'];
    final byType = json['unreadByType'];
    return AppNotificationFeed(
      items:
          (items is List ? items : const [])
              .whereType<Map<String, dynamic>>()
              .map(AppNotification.fromJson)
              .toList(),
      unread: json['unread'] is num ? (json['unread'] as num).toInt() : 0,
      unreadByType:
          byType is Map
              ? {
                for (final entry in byType.entries)
                  entry.key.toString(): entry.value is num
                      ? (entry.value as num).toInt()
                      : 0,
              }
              : const {},
    );
  }
}

/// 系统公告（`/home/announcements`）。
class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    this.content = '',
    this.version = 0,
    this.forceRead = false,
    this.expiresAt,
    this.publishedAt,
    this.readAt,
  });

  final int id;
  final String title;
  final String content;
  final int version;
  final bool forceRead;
  final DateTime? expiresAt;
  final DateTime? publishedAt;
  final DateTime? readAt;

  bool get isUnread => readAt == null;

  Announcement copyWith({DateTime? readAt}) => Announcement(
    id: id,
    title: title,
    content: content,
    version: version,
    forceRead: forceRead,
    expiresAt: expiresAt,
    publishedAt: publishedAt,
    readAt: readAt ?? this.readAt,
  );

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
    id: json['id'] is num ? (json['id'] as num).toInt() : 0,
    title: (json['title'] ?? '').toString(),
    content: (json['content'] ?? '').toString(),
    version: json['version'] is num ? (json['version'] as num).toInt() : 0,
    forceRead: json['force_read'] == true || json['force_read'] == 1,
    expiresAt: _date(json['expires_at']),
    publishedAt: _date(json['published_at']),
    readAt: _date(json['read_at']),
  );
}

DateTime? _date(Object? value) {
  if (value == null) return null;
  if (value is num) {
    return DateTime.fromMillisecondsSinceEpoch(value.toInt());
  }
  return DateTime.tryParse(value.toString());
}
