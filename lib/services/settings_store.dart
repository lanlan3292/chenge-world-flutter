import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persisted appearance and system UI preferences.
class SettingsStore {
  SettingsStore();

  static const _seedKey = 'appearance_seed_color';
  static const _dynamicKey = 'appearance_use_dynamic_color';
  static const _statusImmersiveKey = 'appearance_status_bar_immersive';
  static const _navImmersiveKey = 'appearance_nav_bar_immersive';
  static const _autoHideTopKey = 'appearance_auto_hide_top_bar';
  static const _autoHideBottomKey = 'appearance_auto_hide_bottom_bar';
  static const _predictiveBackKey = 'appearance_predictive_back';
  static const _feedMinColumnsKey = 'layout_feed_min_columns';
  static const _feedMaxColumnsKey = 'layout_feed_max_columns';
  static const _shopMinColumnsKey = 'layout_shop_min_columns';
  static const _shopMaxColumnsKey = 'layout_shop_max_columns';
  static const _chatShowSelfAvatarKey = 'chat_show_self_avatar';
  static const _chatShowPeerAvatarKey = 'chat_show_peer_avatar';

  /// Default brand seed (AppTheme.leaf).
  static const defaultSeed = Color(0xFF006B61);

  Color seedColor = defaultSeed;
  bool useDynamicColor = true;
  bool statusBarImmersive = true;
  bool navigationBarImmersive = true;
  /// Scroll down to hide the page top app bar (feed / shop). Default on.
  bool autoHideTopBar = true;
  /// Scroll down to hide the shell bottom navigation bar. Default on.
  /// Not applied when the shell uses a side NavigationRail (wide layout).
  bool autoHideBottomBar = true;
  /// Android predictive back page transitions. Default off.
  bool predictiveBack = false;
  /// Minimum grid columns on the feed page (1–3). Default 1.
  int feedMinColumns = 1;
  /// Maximum grid columns on the feed page (1–3). Default 3. Always ≥ min.
  int feedMaxColumns = 3;
  /// Minimum grid columns on the shop page (1–3). Default 1.
  int shopMinColumns = 1;
  /// Maximum grid columns on the shop page (1–3). Default 3. Always ≥ min.
  int shopMaxColumns = 3;
  /// Show own avatar on the right of sent bubbles. Default off.
  bool chatShowSelfAvatar = false;
  /// Show peer avatar on the left in private (single) chats. Default off.
  /// Group chats always show other members' avatars.
  bool chatShowPeerAvatar = false;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final seedValue = prefs.getInt(_seedKey);
    if (seedValue != null) {
      seedColor = Color(seedValue);
    }
    useDynamicColor = prefs.getBool(_dynamicKey) ?? true;
    statusBarImmersive = prefs.getBool(_statusImmersiveKey) ?? true;
    navigationBarImmersive = prefs.getBool(_navImmersiveKey) ?? true;
    autoHideTopBar = prefs.getBool(_autoHideTopKey) ?? true;
    autoHideBottomBar = prefs.getBool(_autoHideBottomKey) ?? true;
    predictiveBack = prefs.getBool(_predictiveBackKey) ?? false;

    var feedMin = (prefs.getInt(_feedMinColumnsKey) ?? 1).clamp(1, 3);
    var feedMax = (prefs.getInt(_feedMaxColumnsKey) ?? 3).clamp(1, 3);
    if (feedMin > feedMax) feedMin = feedMax;
    feedMinColumns = feedMin;
    feedMaxColumns = feedMax;

    var shopMin = (prefs.getInt(_shopMinColumnsKey) ?? 1).clamp(1, 3);
    var shopMax = (prefs.getInt(_shopMaxColumnsKey) ?? 3).clamp(1, 3);
    if (shopMin > shopMax) shopMin = shopMax;
    shopMinColumns = shopMin;
    shopMaxColumns = shopMax;

    chatShowSelfAvatar = prefs.getBool(_chatShowSelfAvatarKey) ?? false;
    chatShowPeerAvatar = prefs.getBool(_chatShowPeerAvatarKey) ?? false;
  }

  Future<void> setSeedColor(Color color) async {
    seedColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_seedKey, color.toARGB32());
  }

  Future<void> setUseDynamicColor(bool value) async {
    useDynamicColor = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dynamicKey, value);
  }

  Future<void> setStatusBarImmersive(bool value) async {
    statusBarImmersive = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_statusImmersiveKey, value);
  }

  Future<void> setNavigationBarImmersive(bool value) async {
    navigationBarImmersive = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_navImmersiveKey, value);
  }

  Future<void> setAutoHideTopBar(bool value) async {
    autoHideTopBar = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoHideTopKey, value);
  }

  Future<void> setAutoHideBottomBar(bool value) async {
    autoHideBottomBar = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoHideBottomKey, value);
  }

  Future<void> setPredictiveBack(bool value) async {
    predictiveBack = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_predictiveBackKey, value);
  }

  Future<void> setFeedMinColumns(int value) async {
    feedMinColumns = value.clamp(1, feedMaxColumns);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_feedMinColumnsKey, feedMinColumns);
  }

  Future<void> setFeedMaxColumns(int value) async {
    feedMaxColumns = value.clamp(feedMinColumns, 3);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_feedMaxColumnsKey, feedMaxColumns);
  }

  /// Set feed min/max together (ensures min ≤ max). Prefer this from the range slider.
  Future<void> setFeedColumnRange(int min, int max) async {
    final lo = min.clamp(1, 3);
    final hi = max.clamp(1, 3);
    feedMinColumns = lo <= hi ? lo : hi;
    feedMaxColumns = lo <= hi ? hi : lo;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_feedMinColumnsKey, feedMinColumns);
    await prefs.setInt(_feedMaxColumnsKey, feedMaxColumns);
  }

  Future<void> setShopMinColumns(int value) async {
    shopMinColumns = value.clamp(1, shopMaxColumns);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shopMinColumnsKey, shopMinColumns);
  }

  Future<void> setShopMaxColumns(int value) async {
    shopMaxColumns = value.clamp(shopMinColumns, 3);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shopMaxColumnsKey, shopMaxColumns);
  }

  /// Set shop min/max together (ensures min ≤ max). Prefer this from the range slider.
  Future<void> setShopColumnRange(int min, int max) async {
    final lo = min.clamp(1, 3);
    final hi = max.clamp(1, 3);
    shopMinColumns = lo <= hi ? lo : hi;
    shopMaxColumns = lo <= hi ? hi : lo;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shopMinColumnsKey, shopMinColumns);
    await prefs.setInt(_shopMaxColumnsKey, shopMaxColumns);
  }

  Future<void> setChatShowSelfAvatar(bool value) async {
    chatShowSelfAvatar = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chatShowSelfAvatarKey, value);
  }

  Future<void> setChatShowPeerAvatar(bool value) async {
    chatShowPeerAvatar = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_chatShowPeerAvatarKey, value);
  }
}
