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

  /// Default brand seed (AppTheme.leaf).
  static const defaultSeed = Color(0xFF006B61);

  Color seedColor = defaultSeed;
  bool useDynamicColor = true;
  bool statusBarImmersive = true;
  bool navigationBarImmersive = true;
  /// Scroll down to hide the page top app bar (feed / shop). Default on.
  bool autoHideTopBar = true;
  /// Scroll down to hide the shell bottom navigation bar. Default on.
  bool autoHideBottomBar = true;

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
}
