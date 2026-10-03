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
    Brightness brightness = Brightness.light,
    bool statusBarImmersive = true,
    bool navigationBarImmersive = true,
    /// 非 null 时写入状态栏颜色（用于顶栏可隐藏时的半透明遮罩）。
    Color? statusBarMaskColor,
  }) {
    final ColorScheme scheme;
    if (dynamicScheme != null) {
      scheme = dynamicScheme.harmonized();
    } else {
      scheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
        primary: seedColor,
        secondary: coral,
        tertiary: citrus,
      );
    }

    final primary = scheme.primary;
    final isDark = brightness == Brightness.dark;
    final background = scheme.surface;
    final Color resolvedStatusBarColor;
    if (!statusBarImmersive) {
      resolvedStatusBarColor = background;
    } else if (statusBarMaskColor != null) {
      resolvedStatusBarColor = statusBarMaskColor;
    } else {
      resolvedStatusBarColor = Colors.transparent;
    }
    final systemBarStyle = SystemUiOverlayStyle(
      statusBarColor: resolvedStatusBarColor,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor:
          navigationBarImmersive ? Colors.transparent : scheme.surface,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: !navigationBarImmersive,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: statusBarImmersive ? Colors.transparent : background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: systemBarStyle,
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLow,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor:
            navigationBarImmersive
                ? scheme.surface.withValues(alpha: 0.92)
                : scheme.surface,
        indicatorColor: scheme.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        elevation: navigationBarImmersive ? 0 : null,
        surfaceTintColor: scheme.surfaceTint,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: background,
        indicatorColor: scheme.secondaryContainer,
        selectedIconTheme: IconThemeData(color: scheme.onSecondaryContainer),
        selectedLabelTextStyle: TextStyle(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        surfaceTintColor: scheme.surfaceTint,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        surfaceTintColor: scheme.surfaceTint,
        modalBackgroundColor: scheme.surfaceContainerLow,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surfaceContainer,
        surfaceTintColor: scheme.surfaceTint,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Legacy static light theme for tests / fallback.
  static final light = build();
}
