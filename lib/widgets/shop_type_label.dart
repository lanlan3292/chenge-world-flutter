import 'package:flutter/widgets.dart';

import '../l10n/generated/app_localizations.dart';

/// 商店商品类型的本地化名称。
///
/// 与后端 `ItemServiceImpl` 的可用类型保持一致：
/// ui / command / apppack / classes / functions / 3d / animation / archive /
/// music / mp2 / liba2 / emoji / skill / nurture / nurture_ticket。
String shopTypeLabel(BuildContext context, String? type) {
  final l10n = AppLocalizations.of(context);
  return switch (type) {
    'emoji' => l10n.emojiPacks,
    'file' => l10n.files,
    'ui' => l10n.components,
    'app' => l10n.applications,
    'apppack' => l10n.shopTypeAppPack,
    'command' => l10n.executables,
    'classes' => l10n.libraries,
    'functions' => l10n.functionLibraries,
    '3d' => l10n.shopType3d,
    'animation' => l10n.shopTypeAnimation,
    'archive' => l10n.shopTypeArchive,
    'music' => l10n.shopTypeMusic,
    'mp2' => l10n.shopTypeMp2,
    'liba2' => l10n.shopTypeLiba2,
    'skill' => l10n.shopTypeSkill,
    'nurture' => l10n.shopTypeNurture,
    'nurture_ticket' => l10n.shopTypeNurtureTicket,
    _ => type ?? l10n.product,
  };
}
