import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';

/// Material 3 tema. Renkler tek bir tohum renkten üretilir; widget'lar
/// doğrudan renk sabiti kullanmaz (CLAUDE.md: UI Rules).
abstract final class AppTheme {
  /// Kurumsal, sakin bir mavi — saha kullanımında okunabilirliği yüksek.
  static const Color _seed = Color(0xFF1B6C4F);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.minTapTarget),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
    );
  }
}
