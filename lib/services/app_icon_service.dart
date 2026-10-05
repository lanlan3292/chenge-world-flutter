import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to switch Android app icons via Activity Alias.
/// Only works on Android. On other platforms this is a no-op.
class AppIconService {
  static const _channel = MethodChannel('com.chenge.world/app_icon');
  static const _prefKey = 'app_icon_name';

  /// Available icon options.
  static const String defaultIcon = 'default';
  static const String ninaIcon = 'nina';

  static const List<String> availableIcons = [defaultIcon, ninaIcon];

  /// Display labels for UI.
  static String labelOf(String iconName) {
    switch (iconName) {
      case ninaIcon:
        return 'Nina';
      default:
        return '默认 / Default';
    }
  }

  /// Persist and apply the selected icon.
  static Future<void> setIcon(String iconName) async {
    if (!availableIcons.contains(iconName)) {
      iconName = defaultIcon;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, iconName);

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        await _channel.invokeMethod('setAppIcon', {'iconName': iconName});
      } on PlatformException catch (e) {
        debugPrint('Failed to set app icon: ${e.message}');
      }
    }
  }

  /// Load the currently selected icon name from prefs (and optionally sync with system).
  static Future<String> getIcon() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_prefKey) ?? defaultIcon;

    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        final current = await _channel.invokeMethod<String>('getCurrentAppIcon');
        if (current != null && availableIcons.contains(current) && current != stored) {
          // Prefer system state if different
          await prefs.setString(_prefKey, current);
          return current;
        }
      } on PlatformException catch (e) {
        debugPrint('Failed to get current app icon: ${e.message}');
      }
    }
    return stored;
  }
}
