import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/chat_message.dart';

/// 聊天实时通道：`ws(s)://{host}/chat/ws?token=JWT`
///
/// 服务端在新消息入库后，向会话成员推送与 HTTP 消息结构一致的 JSON。
/// 客户端只订阅推送，发送仍走 HTTP `/chat/{id}/send`。
class ChatSocket {
  ChatSocket({required this.baseUrl});

  /// HTTP 根地址，如 `http://8.138.13.61`（无尾斜杠）
  final String baseUrl;

  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  Timer? _retryTimer;
  String? _token;
  bool _manualClose = false;

  final _messageController = StreamController<ChatMessage>.broadcast();
  final _rawController = StreamController<Map<String, dynamic>>.broadcast();
  final _connectionController = StreamController<bool>.broadcast();

  /// 解析后的新消息流（与 [ChatMessage.fromJson] 一致）
  Stream<ChatMessage> get messages => _messageController.stream;

  /// 原始 JSON（含会话更新等扩展字段时可自行处理）
  Stream<Map<String, dynamic>> get rawEvents => _rawController.stream;

  /// 连接状态：true = 已连接
  Stream<bool> get connectionState => _connectionController.stream;

  bool get isConnected =>
      _channel != null && _sub != null && !_manualClose;

  /// 建立或复用连接。token 变化时会先断开再连。
  void connect(String token) {
    final t = token.trim();
    if (t.isEmpty) return;
    if (_token == t && isConnected) return;
    _token = t;
    _manualClose = false;
    _open();
  }

  void disconnect() {
    _manualClose = true;
    _retryTimer?.cancel();
    _retryTimer = null;
    _teardown();
    _connectionController.add(false);
  }

  void _open() {
    _teardown();
    final token = _token;
    if (token == null || token.isEmpty || _manualClose) return;

    final http = Uri.parse(baseUrl);
    final scheme = http.scheme == 'https' ? 'wss' : 'ws';
    final host = http.hasPort ? '${http.host}:${http.port}' : http.host;
    final uri = Uri.parse(
      '$scheme://$host/chat/ws?token=${Uri.encodeComponent(token)}',
    );

    try {
      final channel = WebSocketChannel.connect(uri);
      _channel = channel;
      _sub = channel.stream.listen(
        _onData,
        onError: (_) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
        cancelOnError: false,
      );
      _connectionController.add(true);
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onData(dynamic data) {
    if (data is! String) return;
    try {
      final decoded = jsonDecode(data);
      if (decoded is! Map<String, dynamic>) return;
      _rawController.add(decoded);
      // 有 id + conversationId 的视为聊天消息
      if (decoded['id'] != null && decoded['conversationId'] != null) {
        _messageController.add(ChatMessage.fromJson(decoded));
      }
    } on FormatException {
      // ignore non-json
    }
  }

  void _scheduleReconnect() {
    _connectionController.add(false);
    _teardown();
    if (_manualClose || _token == null) return;
    _retryTimer?.cancel();
    _retryTimer = Timer(const Duration(seconds: 4), _open);
  }

  void _teardown() {
    _sub?.cancel();
    _sub = null;
    try {
      _channel?.sink.close();
    } catch (_) {}
    _channel = null;
  }

  /// 释放流（应用退出时调用）
  void dispose() {
    disconnect();
    _messageController.close();
    _rawController.close();
    _connectionController.close();
  }
}
