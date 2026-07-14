import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';

/// Material 3 tema. Renkler tek bir tohum renkten üretilir; widget'lar
/// doğrudan renk sabiti kullanmaz (CLAUDE.md: UI Rules).
abstract final class AppTheme {
  /// Marka logosundaki (quotra_logo.png) aksan rengi — canlı indigo-mavi.
  static const Color _seed = Color(0xFF5865ED);

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: brightness,
    );

    final buttonShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
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
          shape: buttonShape,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.minTapTarget),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(AppSizes.minTapTarget),
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(AppSizes.minTapTarget, AppSizes.minTapTarget),
          shape: buttonShape,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusLg),
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
