import 'package:chenge_world_app/l10n/generated/app_localizations.dart';
import 'package:chenge_world_app/services/settings_store.dart';
import 'package:chenge_world_app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppLocalizations', () {
    test('supports the requested locale variants', () {
      expect(
        AppLocalizations.supportedLocales,
        containsAll(const [
          Locale('zh', 'CN'),
          Locale('zh', 'TW'),
          Locale('en', 'US'),
        ]),
      );
    });

    test(
      'translates common feed labels into Traditional Chinese and English',
      () async {
        final taiwanese = await AppLocalizations.delegate.load(
          const Locale('zh', 'TW'),
        );
        final english = await AppLocalizations.delegate.load(
          const Locale('en', 'US'),
        );
        expect(taiwanese.popular, '熱門');
        expect(english.popular, 'Popular');
      },
    );
  });

  test('builds Material 3 themes with matching light and dark surfaces', () {
    final light = AppTheme.build(brightness: Brightness.light);
    final dark = AppTheme.build(brightness: Brightness.dark);

    expect(light.useMaterial3, isTrue);
    expect(dark.useMaterial3, isTrue);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
    expect(dark.scaffoldBackgroundColor, dark.colorScheme.surface);
    expect(dark.cardTheme.color, dark.colorScheme.surfaceContainerLow);
  });

  test('persists theme mode and locale selection', () async {
    SharedPreferences.setMockInitialValues({});
    final settings = SettingsStore();
    await settings.setThemeMode(ThemeMode.dark);
    await settings.setLocaleCode('zh_TW');

    final restored = SettingsStore();
    await restored.load();
    expect(restored.themeMode, ThemeMode.dark);
    expect(restored.localeCode, 'zh_TW');
  });
}
