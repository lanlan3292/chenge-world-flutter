import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chenge_api.dart';

/// 全站未读通知角标：登录后每 60 秒轻量刷新一次（`GET /home/notify/unread`）。
///
/// Web 端只在启动/打开面板时刷新，这里补一个定时器让角标不至于长期过期；
/// 真正的实时推送走聊天 WebSocket 的 `type=notify` 帧（后续接）。
class NotificationBadge extends ChangeNotifier {
  NotificationBadge(this._api);

  ChengeApi _api;
  String? _token;
  int _unread = 0;
  Timer? _timer;

  int get unread => _unread;

  /// 绑定当前会话：token 变化时重置角标并重启轮询。
  void bind(ChengeApi api, String? token) {
    _api = api;
    if (token == _token) return;
    _token = token;
    _unread = 0;
    _timer?.cancel();
    _timer = null;
    notifyListeners();
    if (token == null) return;
    unawaited(refresh());
    _timer = Timer.periodic(
      const Duration(seconds: 60),
      (_) => unawaited(refresh()),
    );
  }

  Future<void> refresh() async {
    final token = _token;
    if (token == null) return;
    try {
      final unread = await _api.notificationUnread(token);
      if (unread == _unread) return;
      _unread = unread;
      notifyListeners();
    } on ApiException {
      // 角标刷新失败静默处理，下次轮询再试。
    }
  }

  /// 本地清零（已全部已读 / 清空通知后调用）。
  void clearLocal() {
    if (_unread == 0) return;
    _unread = 0;
    notifyListeners();
  }

  void setUnread(int value) {
    final next = value < 0 ? 0 : value;
    if (next == _unread) return;
    _unread = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
