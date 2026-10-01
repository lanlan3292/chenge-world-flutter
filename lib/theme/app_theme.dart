import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract final class AppTheme {
  static const ink = Color(0xFF173C3A);
  static const leaf = Color(0xFF006B61);
  static const coral = Color(0xFFD45743);
  static const citrus = Color(0xFFF0B73F);
  static const mist = Color(0xFFF3F7F3);

  /// Preset seed colors available in appearance settings.
  static const presetSeeds = <Color>[
    leaf,
    Color(0xFF1565C0), // blue
    Color(0xFF6A1B9A), // purple
    Color(0xFFC62828), // red
    Color(0xFFEF6C00), // orange
    Color(0xFF2E7D32), // green
    Color(0xFF00838F), // teal
    Color(0xFFAD1457), // pink
  ];

  static ThemeData build({
    ColorScheme? dynamicScheme,
    Color seedColor = leaf,
    bool statusBarImmersive = true,
    bool navigationBarImmersive = true,
  }) {
    final ColorScheme scheme;
    if (dynamicScheme != null) {
      scheme = dynamicScheme.harmonized();
    } else {
      scheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
        primary: seedColor,
        secondary: coral,
        tertiary: citrus,
        surface: Colors.white,
      );
    }

    final primary = scheme.primary;
    final surfaceTint = scheme.surfaceContainerHighest.withValues(alpha: 0.0);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: mist,
      appBarTheme: AppBarTheme(
        backgroundColor: statusBarImmersive ? Colors.transparent : mist,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: statusBarImmersive ? Colors.transparent : mist,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor:
              navigationBarImmersive ? Colors.transparent : Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: !navigationBarImmersive,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDCE6E1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navigationBarImmersive
            ? Colors.white.withValues(alpha: 0.92)
            : Colors.white,
        indicatorColor: primary.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: navigationBarImmersive ? 0 : null,
        surfaceTintColor: surfaceTint,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: mist,
        indicatorColor: primary.withValues(alpha: 0.12),
        selectedIconTheme: IconThemeData(color: primary),
        selectedLabelTextStyle:
            const TextStyle(color: ink, fontWeight: FontWeight.w700),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Legacy static light theme for tests / fallback.
  static final light = build();
}
