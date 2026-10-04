import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/ai_session.dart';
import '../models/blog_post.dart';
import '../models/blog_category.dart';
import '../models/blog_comment.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';
import '../models/friend_user.dart';
import '../models/shop_item.dart';
import '../models/task_item.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.businessCode});

  final String message;
  final int? statusCode;
  final int? businessCode;

  @override
  String toString() => message;
}

class PostPage {
  const PostPage({required this.posts, required this.total, required this.pages});

  final List<BlogPost> posts;
  final int total;
  final int pages;
}

class ShopItemPage {
  const ShopItemPage({required this.items, required this.total});

  final List<ShopItem> items;
  final int total;
}

/// One SSE event from `/ai/agent/stream` (status / delta / done / error / …).
class AiStreamEvent {
  const AiStreamEvent({required this.type, this.data});

  final String type;
  final dynamic data;
}

/// Owned emoji asset for the picker (from shop assets / my items).
class EmojiAsset {
  const EmojiAsset({
    required this.itemId,
    this.key,
    this.url,
    this.fileId,
    this.title,
  });

  final int itemId;
  final String? key;
  final String? url;
  final int? fileId;
  final String? title;

  String get displayName => (title ?? key ?? '表情').trim();

  Map<String, dynamic> toSendJson() => {
        'itemId': itemId,
        if (key != null && key!.isNotEmpty) 'key': key,
        if (fileId != null) 'fileId': fileId,
        if (url != null && url!.isNotEmpty) 'url': url,
      };

  factory EmojiAsset.fromMap(Map<String, dynamic> json) {
    final itemId = _integer(json['itemId'] ?? json['id']);
    return EmojiAsset(
      itemId: itemId,
      key: _nullableText(json['key'] ?? json['content']),
      url: _nullableText(json['url'] ?? json['fileUrl'] ?? json['cover']),
      fileId: json['fileId'] == null ? null : _integer(json['fileId']),
      title: _nullableText(json['title'] ?? json['name']),
    );
  }

  static int _integer(Object? value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;
  static String? _nullableText(Object? value) {
    final text = value?.toString().trim() ?? '';
    return text.isEmpty || text == 'null' ? null : text;
  }
}

class ChengeApi {
  ChengeApi({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = (baseUrl ?? const String.fromEnvironment(
          'CHENGE_API_BASE_URL',
          defaultValue: 'http://8.138.13.61',
        )).replaceFirst(RegExp(r'/+$'), '');

  final http.Client _client;
  final String _baseUrl;
  /// Session-local post like flags (detail API may omit liked for guests/filters).
  final Map<int, bool> _likedPostCache = {};
  static const _timeout = Duration(seconds: 25);
  static const _streamTimeout = Duration(minutes: 3);

  /// 当前 API 根地址（无尾部斜杠），用于拼前端 / Web 页面。
  String get baseUrl => _baseUrl;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final data = await _request(
      'POST',
      '/home/login',
      body: {'username': username, 'password': password},
    );
    if (data is! Map<String, dynamic> || data['token'] is! String) {
      throw const ApiException('登录响应缺少 token');
    }
    return data;
  }

  /// 发送邮箱验证码：GET /home/sendemailcode?email=
  Future<void> sendEmailCode(String email) async {
    await _request(
      'GET',
      '/home/sendemailcode',
      query: {'email': email.trim()},
    );
  }

  /// 注册：POST /home/register
  /// 必填 username / password / email / code；可选 nickname、avatar、gender、birthday、roleCode
  Future<void> register({
    required String username,
    required String password,
    required String email,
    required String code,
    String? nickname,
    String? avatar,
    int gender = 0,
    String? birthday,
    String roleCode = '1',
  }) async {
    final body = <String, dynamic>{
      'username': username.trim(),
      'password': password,
      'email': email.trim(),
      'code': code.trim(),
      'gender': gender,
      'roleCode': roleCode,
      'nickname': (nickname == null || nickname.trim().isEmpty)
          ? username.trim()
          : nickname.trim(),
    };
    if (avatar != null && avatar.trim().isNotEmpty) {
      body['avatar'] = avatar.trim();
    }
    if (birthday != null && birthday.trim().isNotEmpty) {
      body['birthday'] = birthday.trim();
    }
    await _request('POST', '/home/register', body: body);
  }

  Future<PostPage> listPosts({
    required int page,
    required String sort,
    String keyword = '',
    String? token,
  }) async {
    final query = <String, String>{
      'pageNum': '$page',
      'pageSize': '12',
      'sort': sort,
    };
    if (keyword.trim().isNotEmpty) query['keyword'] = keyword.trim();

    final data = await _request('GET', '/blog/post/list', query: query, token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('帖子列表格式不正确');
    final records = data['records'];
    return PostPage(
      posts: records is List
          ? records.whereType<Map<String, dynamic>>().map(BlogPost.fromJson).toList()
          : const [],
      total: _integer(data['total']),
      pages: _integer(data['pages']),
    );
  }

  Future<Map<String, dynamic>> currentUser(String token) async {
    final data = await _request('GET', '/home/me', token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('用户信息格式不正确');
    return data;
  }

  Future<void> logout(String token) async {
    await _request('POST', '/home/logout', token: token);
  }

  Future<BlogPost> postDetail(int id, {String? token}) async {
    final data = await _request('GET', '/blog/post/$id', token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('帖子内容格式不正确');
    return BlogPost.fromJson(data);
  }

  Future<List<BlogComment>> postComments(int blogId) async {
    final data = await _request('GET', '/blog/comment/list', query: {'blogId': '$blogId'});
    if (data is! List) throw const ApiException('评论列表格式不正确');
    return data.whereType<Map<String, dynamic>>().map(BlogComment.fromJson).toList();
  }

  Future<int> addPostComment({
    required int blogId,
    required String content,
    required String token,
    int parentId = 0,
  }) async {
    final data = await _request(
      'POST',
      '/blog/comment',
      body: {'blogId': blogId, 'content': content, 'parentId': parentId},
      token: token,
    );
    return _integer(data);
  }

  Future<bool> togglePostLike(int blogId, String token) async {
    final data = await _request(
      'POST',
      '/blog/like/toggle',
      query: {'targetType': 'POST', 'targetId': '$blogId'},
      token: token,
    );
    if (data is! Map<String, dynamic>) {
      throw const ApiException('Invalid like response');
    }
    final liked = data['liked'];
    bool? resolved;
    if (liked is bool) {
      resolved = liked;
    } else if (liked is num) {
      resolved = liked != 0;
    } else {
      final text = liked?.toString().trim().toLowerCase() ?? '';
      if (text == 'true' || text == '1') resolved = true;
      if (text == 'false' || text == '0') resolved = false;
    }
    if (resolved == null) throw const ApiException('Invalid like response');
    _likedPostCache[blogId] = resolved;
    return resolved;
  }

  bool? cachedPostLiked(int blogId) => _likedPostCache[blogId];

  void rememberPostLiked(int blogId, bool liked) {
    _likedPostCache[blogId] = liked;
  }

  Future<List<BlogCategory>> listCategories({String? token, bool onlyPublic = true}) async {
    final data = await _request(
      'GET',
      '/blog/category/list',
      query: {'onlyPublic': onlyPublic ? 'true' : 'false'},
      token: token,
    );
    if (data is! List) throw const ApiException('Invalid category list');
    return data
        .whereType<Map<String, dynamic>>()
        .map(BlogCategory.fromJson)
        .toList();
  }

  /// Upload a file to the file module. Returns the public URL.
  Future<String> uploadFile({
    required List<int> bytes,
    required String filename,
    required String token,
    String businessType = 'post_image',
    String? businessId,
  }) async {
    final uri = Uri.parse('$_baseUrl/file-module/files/upload').replace(
      queryParameters: {
        'businessType': businessType,
        if (businessId != null && businessId.isNotEmpty) 'businessId': businessId,
      },
    );
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: filename),
    );
    late http.StreamedResponse streamed;
    try {
      streamed = await _client.send(request).timeout(_timeout);
    } on Exception catch (error) {
      throw ApiException('Upload failed: $error');
    }
    final response = await http.Response.fromStream(streamed);
    final decoded = utf8.decode(response.bodyBytes, allowMalformed: true);
    dynamic payload;
    try {
      payload = jsonDecode(decoded);
    } on FormatException {
      throw const ApiException('Invalid upload response');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = payload is Map ? payload['msg'] : null;
      throw ApiException(
        message?.toString() ?? 'Upload failed (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }
    if (payload is! Map<String, dynamic> || payload['code'] != 200) {
      throw ApiException(payload is Map ? (payload['msg']?.toString() ?? 'Upload failed') : 'Upload failed');
    }
    final data = payload['data'];
    if (data is Map && data['url'] != null) {
      final url = data['url'].toString().trim();
      if (url.isNotEmpty) return _resolveMediaUrl(url);
    }
    throw const ApiException('Upload response missing url');
  }

  Future<int> publishPost({
    required String token,
    required int categoryId,
    required String title,
    required String content,
    String? coverImage,
    String? summary,
    List<String>? images,
    List<String>? tags,
    String contentType = 'md',
  }) async {
    final body = <String, dynamic>{
      'categoryId': categoryId,
      'title': title,
      'content': content,
      'contentType': contentType,
      if (coverImage != null && coverImage.isNotEmpty) 'coverImage': coverImage,
      if (summary != null && summary.isNotEmpty) 'summary': summary,
      if (images != null && images.isNotEmpty) 'images': images,
      if (tags != null && tags.isNotEmpty) 'tags': tags,
    };
    final data = await _request('POST', '/blog/post/publish', body: body, token: token);
    return _integer(data);
  }

  /// Resolve relative file paths to absolute URLs under the API base.
  String resolveMediaUrl(String url) => _resolveMediaUrl(url);

  String _resolveMediaUrl(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    if (trimmed.startsWith('/')) {
      return '$_baseUrl$trimmed';
    }
    return '$_baseUrl/$trimmed';
  }

  Future<List<FriendUser>> friends(String token) => _friendList('/friend/list', token: token);

  Future<List<FriendUser>> friendRequests(String token) => _friendList('/friend/requests', token: token);

  Future<List<FriendUser>> searchUsers(String keyword, String token) => _friendList(
        '/friend/search',
        query: {'keyword': keyword.trim()},
        token: token,
      );

  Future<void> applyFriend(int friendId, String token) async {
    await _request('POST', '/friend/apply', query: {'friendId': '$friendId'}, token: token);
  }

  Future<void> removeFriend(int friendId, String token) async {
    await _request('DELETE', '/friend/$friendId', token: token);
  }

  Future<void> setFriendRemark(int friendId, String remark, String token) async {
    final query = <String, String>{'friendId': '$friendId'};
    if (remark.trim().isNotEmpty) query['remark'] = remark.trim();
    await _request('POST', '/friend/remark', query: query, token: token);
  }

  /// Whether the given user is currently online.
  Future<bool> isUserOnline(int userId, String token) async {
    try {
      final data = await _request('GET', '/home/online/$userId', token: token);
      if (data is bool) return data;
      if (data is Map) return data['online'] == true || data['v'] == true;
      return data == true || data == 1 || '$data' == 'true';
    } on ApiException {
      return false;
    }
  }

  Future<List<FriendUser>> _friendList(
    String path, {
    Map<String, String>? query,
    required String token,
  }) async {
    final data = await _request('GET', path, query: query, token: token);
    if (data is! List) throw const ApiException('联系人列表格式不正确');
    return data.whereType<Map<String, dynamic>>().map(FriendUser.fromJson).toList();
  }

  Future<List<ChatConversation>> conversations(String token) async {
    final data = await _request('GET', '/chat/conversations', token: token);
    if (data is! List) throw const ApiException('会话列表格式不正确');
    return data.whereType<Map<String, dynamic>>().map(ChatConversation.fromJson).toList();
  }

  Future<ChatConversation> openSingleChat(int peerId, String token) async {
    final data = await _request('POST', '/chat/single', query: {'peerId': '$peerId'}, token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('会话信息格式不正确');
    return ChatConversation.fromJson(data, fallbackPeerId: peerId);
  }

  Future<ChatConversation> createGroupChat({
    required String name,
    required List<int> memberIds,
    required String token,
  }) async {
    final data = await _request(
      'POST',
      '/chat/group',
      body: {'name': name.trim(), 'memberIds': memberIds},
      token: token,
    );
    if (data is! Map<String, dynamic>) throw const ApiException('创建群聊响应格式不正确');
    return ChatConversation.fromJson(data);
  }

  Future<List<ChatConversation>> searchGroups(String keyword, String token) async {
    final data = await _request(
      'GET',
      '/chat/search',
      query: {'keyword': keyword.trim()},
      token: token,
    );
    if (data is! List) throw const ApiException('群聊搜索结果格式不正确');
    return data.whereType<Map<String, dynamic>>().map(ChatConversation.fromJson).toList();
  }

  Future<void> joinGroup(int conversationId, String token) async {
    await _request('POST', '/chat/$conversationId/join', token: token);
  }

  Future<List<ChatMessage>> chatMessages(int conversationId, String token, {int? beforeId, int size = 30}) async {
    final query = <String, String>{'size': '$size'};
    if (beforeId != null) query['beforeId'] = '$beforeId';
    final data = await _request('GET', '/chat/$conversationId/messages', query: query, token: token);
    if (data is! List) throw const ApiException('消息列表格式不正确');
    return data.whereType<Map<String, dynamic>>().map(ChatMessage.fromJson).toList();
  }

  Future<ChatMessage> sendChatMessage(
    int conversationId,
    String content,
    String token, {
    String type = 'text',
  }) async {
    final data = await _request(
      'POST',
      '/chat/$conversationId/send',
      body: {
        'type': type,
        'content': content,
        'clientMsgId': 'android-${DateTime.now().microsecondsSinceEpoch}',
      },
      token: token,
    );
    if (data is! Map<String, dynamic>) throw const ApiException('发送消息响应格式不正确');
    return ChatMessage.fromJson(data);
  }

  Future<void> markChatRead(int conversationId, String token, {int? messageId}) async {
    await _request(
      'POST',
      '/chat/$conversationId/read',
      body: messageId == null ? const {} : {'messageId': messageId},
      token: token,
    );
  }

  /// Load owned emoji packs from shop assets + my items (type == emoji).
  Future<List<EmojiAsset>> myEmojiAssets(String token) async {
    final byId = <String, EmojiAsset>{};

    void addEmoji(Map<String, dynamic> raw, {int? itemId}) {
      final asset = EmojiAsset.fromMap({
        ...raw,
        if (itemId != null) 'itemId': itemId,
      });
      final key = asset.key?.trim();
      final url = asset.url?.trim();
      if (asset.itemId <= 0 ||
          key == null ||
          key.isEmpty ||
          key.length > 32 ||
          asset.fileId == null ||
          asset.fileId! <= 0 ||
          url == null ||
          !_isValidEmojiUrl(url)) {
        return;
      }

      final identity = '${asset.itemId}:${asset.fileId}';
      byId.putIfAbsent(identity, () => asset);
    }

    void absorb(Map<String, dynamic> raw) {
      final type = (raw['type'] ?? raw['itemType'] ?? '').toString().toLowerCase();
      if (type.isNotEmpty && type != 'emoji') return;

      final itemId = _integer(raw['itemId'] ?? raw['id']);
      if (itemId <= 0) return;

      final content = raw['content'];
      if (content is String && content.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(content);
          if (decoded is List) {
            for (final entry in decoded.whereType<Map<String, dynamic>>()) {
              addEmoji({
                ...entry,
                'itemId': itemId,
                if (raw['title'] != null) 'title': raw['title'],
              });
            }
            return;
          }
          if (decoded is Map<String, dynamic>) {
            addEmoji({
              ...decoded,
              'itemId': itemId,
              if (raw['title'] != null) 'title': raw['title'],
            });
            return;
          }
        } on FormatException {
          // Fall through for legacy responses that expose a single emoji directly.
        }
      }

      addEmoji(raw, itemId: itemId);
    }

    try {
      final assets = await shopAssets(token);
      for (final row in assets) {
        absorb(row);
      }
    } on ApiException {
      // optional source
    }

    try {
      var page = 1;
      var total = 1 << 30;
      final collected = <Map<String, dynamic>>[];
      while (collected.length < total && page <= 10) {
        final data = await _request(
          'GET',
          '/shop/my/items',
          query: {'pageNum': '$page', 'pageSize': '60'},
          token: token,
        );
        if (data is! Map<String, dynamic>) break;
        total = _integer(data['total']);
        final records = data['records'];
        if (records is! List || records.isEmpty) break;
        for (final row in records.whereType<Map<String, dynamic>>()) {
          collected.add(row);
          absorb({...row, if (row['itemId'] == null) 'itemId': row['id']});
        }
        if (records.length < 60) break;
        page++;
      }
    } on ApiException {
      // optional source
    }

    // If type filter was too strict (assets without type), keep all that look like emoji urls.
    if (byId.isEmpty) {
      try {
        for (final row in await shopAssets(token)) {
          absorb(row);
        }
      } on ApiException {
        // ignore
      }
    }

    return byId.values.toList();
  }

  Future<ShopItemPage> shopItems({
    int page = 1,
    int pageSize = 12,
    String sort = 'latest',
    String type = '',
    String keyword = '',
  }) async {
    final query = <String, String>{'pageNum': '$page', 'pageSize': '$pageSize', 'sort': sort};
    if (type.isNotEmpty) query['type'] = type;
    if (keyword.trim().isNotEmpty) query['keyword'] = keyword.trim();
    final data = await _request('GET', '/shop/items', query: query);
    if (data is! Map<String, dynamic> || data['records'] is! List) throw const ApiException('商品列表格式不正确');
    return ShopItemPage(
      items: (data['records'] as List).whereType<Map<String, dynamic>>().map(ShopItem.fromJson).toList(),
      total: _integer(data['total']),
    );
  }

  Future<ShopItem> shopItem(int id, {String? token}) async {
    final data = await _request('GET', '/shop/item/$id', token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('商品详情格式不正确');
    return ShopItem.fromJson(data);
  }

  Future<double> shopBalance(String token) async {
    final data = await _request('GET', '/shop/wallet', token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('钱包信息格式不正确');
    final coins = data['coins'];
    return coins is num ? coins.toDouble() : 0;
  }

  Future<Map<String, dynamic>> buyShopItem(int itemId, int quantity, String token) async {
    final data = await _request(
      'POST',
      '/shop/buy',
      body: {'itemId': itemId, 'quantity': quantity},
      token: token,
    );
    if (data is! Map<String, dynamic>) throw const ApiException('购买响应格式不正确');
    return data;
  }

  Future<List<Map<String, dynamic>>> shopAssets(String token) => _mapList('/shop/assets', token);

  Future<List<Map<String, dynamic>>> shopOrders(String token) => _mapList('/shop/orders', token);

  Future<List<TaskItem>> tasks({String? token}) async {
    final data = await _request('GET', '/task/list', token: token);
    if (data is! List) throw const ApiException('任务列表格式不正确');
    return data.whereType<Map<String, dynamic>>().map(TaskItem.fromJson).toList();
  }

  Future<Map<String, dynamic>> claimTask(String code, String token) async {
    final data = await _request('POST', '/task/claim', body: {'code': code}, token: token);
    if (data is! Map<String, dynamic>) throw const ApiException('任务领取响应格式不正确');
    return data;
  }

  // ——— AI Agent / chatSession ———

  Future<List<AiSession>> aiSessions(String token) async {
    final data = await _request('GET', '/chatSession/list/my', token: token);
    if (data is! List) throw const ApiException('AI 会话列表格式不正确');
    return data.whereType<Map<String, dynamic>>().map(AiSession.fromJson).toList();
  }

  Future<AiSession> createAiSession(String token, {String name = '新对话'}) async {
    final data = await _request(
      'POST',
      '/chatSession/create',
      body: {'name': name},
      token: token,
    );
    if (data is! Map<String, dynamic>) throw const ApiException('创建 AI 会话响应格式不正确');
    return AiSession.fromJson(data);
  }

  Future<void> deleteAiSession(String sessionId, String token) async {
    await _request('DELETE', '/chatSession/delete/$sessionId', token: token);
  }

  Future<void> renameAiSession(String sessionId, String name, String token) async {
    await _request(
      'POST',
      '/chatSession/rename',
      body: {'sessionId': sessionId, 'name': name},
      token: token,
    );
  }

  Future<List<dynamic>> aiChatHistory(String sessionId, String token) async {
    final data = await _request(
      'POST',
      '/chatSession/getchat',
      body: {'sessionId': sessionId},
      token: token,
    );
    if (data is! List) throw const ApiException('AI 聊天历史格式不正确');
    return data;
  }

  /// Stream AI agent reply via SSE (`event: status|delta|done|error|…`).
  Stream<AiStreamEvent> streamAiAgent({
    required String token,
    required String sessionId,
    required String userInput,
    String? turnId,
  }) async* {
    final uri = Uri.parse('$_baseUrl/ai/agent/stream');
    final request = http.Request('POST', uri)
      ..headers.addAll({
        'Accept': 'text/event-stream',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $token',
      })
      ..body = jsonEncode({
        'session_id': sessionId,
        'user_input': userInput,
        if (turnId != null && turnId.isNotEmpty) 'turn_id': turnId,
      });

    late http.StreamedResponse response;
    try {
      response = await _client.send(request).timeout(_streamTimeout);
    } on Exception catch (error) {
      throw ApiException('连接 AI 服务失败：$error');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final body = await response.stream.bytesToString();
      throw ApiException('AI 流式请求失败（${response.statusCode}）$body', statusCode: response.statusCode);
    }

    var buffer = '';
    String? eventType;
    final dataLines = <String>[];

    await for (final chunk in response.stream.transform(utf8.decoder).timeout(_streamTimeout)) {
      buffer += chunk;
      while (true) {
        final sep = buffer.indexOf('\n');
        if (sep < 0) break;
        var line = buffer.substring(0, sep);
        buffer = buffer.substring(sep + 1);
        if (line.endsWith('\r')) line = line.substring(0, line.length - 1);

        if (line.isEmpty) {
          if (eventType != null || dataLines.isNotEmpty) {
            final raw = dataLines.join('\n');
            dynamic parsed = raw;
            if (raw.isNotEmpty) {
              try {
                parsed = jsonDecode(raw);
              } on FormatException {
                parsed = raw;
              }
            }
            yield AiStreamEvent(type: eventType ?? 'message', data: parsed);
            if ((eventType ?? '') == 'done' || (eventType ?? '') == 'error') return;
          }
          eventType = null;
          dataLines.clear();
          continue;
        }

        if (line.startsWith('event:')) {
          eventType = line.substring(6).trim();
        } else if (line.startsWith('data:')) {
          dataLines.add(line.substring(5).trimLeft());
        }
        // ignore id: / retry:
      }
    }

    // flush trailing event without blank line
    if (eventType != null || dataLines.isNotEmpty) {
      final raw = dataLines.join('\n');
      dynamic parsed = raw;
      if (raw.isNotEmpty) {
        try {
          parsed = jsonDecode(raw);
        } on FormatException {
          parsed = raw;
        }
      }
      yield AiStreamEvent(type: eventType ?? 'message', data: parsed);
    }
  }

  Future<List<Map<String, dynamic>>> _mapList(String path, String token) async {
    final data = await _request('GET', path, token: token);
    if (data is! List) throw const ApiException('列表格式不正确');
    return data.whereType<Map<String, dynamic>>().toList();
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
    String? token,
  }) async {
    final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: query);
    final headers = <String, String>{'Accept': 'application/json'};
    if (body != null) headers['Content-Type'] = 'application/json; charset=utf-8';
    if (token != null && token.isNotEmpty) headers['Authorization'] = 'Bearer $token';

    late http.Response response;
    try {
      final request = http.Request(method, uri)..headers.addAll(headers);
      if (body != null) request.body = jsonEncode(body);
      final streamed = await _client.send(request).timeout(_timeout);
      response = await http.Response.fromStream(streamed);
    } on Exception catch (error) {
      throw ApiException('连接服务失败：$error');
    }

    final decoded = utf8.decode(response.bodyBytes, allowMalformed: true);
    dynamic payload;
    try {
      payload = jsonDecode(decoded);
    } on FormatException {
      throw const ApiException('服务返回了无法识别的数据');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = payload is Map ? payload['msg'] : null;
      throw ApiException(message?.toString() ?? '请求失败（${response.statusCode}）', statusCode: response.statusCode);
    }
    if (payload is! Map<String, dynamic>) throw const ApiException('服务响应格式不正确');
    if (payload['code'] != 200) {
      throw ApiException(
        payload['msg']?.toString() ?? '请求失败',
        businessCode: _integer(payload['code']),
      );
    }
    return payload['data'];
  }

  static int _integer(Object? value) => value is num ? value.toInt() : int.tryParse('$value') ?? 0;

  static bool _isValidEmojiUrl(String url) {
    const localPrefix = '/file-module/files/local/';
    if (url.startsWith(localPrefix)) {
      return !url.contains(r'\') && url.substring(localPrefix.length).trim().isNotEmpty;
    }
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}

class SessionStore {
  const SessionStore();

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'chenge_access_token';

  Future<String?> readToken() => _storage.read(key: _tokenKey);

  Future<void> saveToken(String token) => _storage.write(key: _tokenKey, value: token);

  Future<void> clearToken() => _storage.delete(key: _tokenKey);
}
