import 'package:flutter/material.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';

/// Domain ↔ Flutter eşlemesi. `domain` katmanı `package:flutter` göremez
/// (CLAUDE.md: bağımlılık yönü), bu yüzden dönüşüm presentation sınırında yapılır.
extension AppThemeModeX on AppThemeMode {
  ThemeMode get asThemeMode => switch (this) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}

extension AppLanguageX on AppLanguage {
  /// `null` → cihazın dili kullanılır (`MaterialApp.locale` verilmez).
  Locale? get asLocale {
    final code = languageCode;
    return code == null ? null : Locale(code);
  }
}
