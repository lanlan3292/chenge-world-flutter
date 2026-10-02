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
  static const _shopMinColumnsKey = 'layout_shop_min_columns';
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
  /// Minimum grid columns on the shop page (1–3). Default 1.
  int shopMinColumns = 1;
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
    feedMinColumns = (prefs.getInt(_feedMinColumnsKey) ?? 1).clamp(1, 3);
    shopMinColumns = (prefs.getInt(_shopMinColumnsKey) ?? 1).clamp(1, 3);
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
    feedMinColumns = value.clamp(1, 3);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_feedMinColumnsKey, feedMinColumns);
  }

  Future<void> setShopMinColumns(int value) async {
    shopMinColumns = value.clamp(1, 3);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_shopMinColumnsKey, shopMinColumns);
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
