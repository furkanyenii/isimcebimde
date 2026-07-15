import 'package:flutter/material.dart';

/// Tipografi ölçeği. Tek font ailesi (Inter), sıkı harf aralığı, net ağırlık
/// basamakları — Material'ın varsayılan Roboto ölçeği "demo" gibi duruyordu.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  static TextTheme textTheme(Color onSurface, Color muted) {
    TextStyle style(
      double size,
      FontWeight weight, {
      double spacing = 0,
      double height = 1.3,
      Color? color,
    }) => TextStyle(
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
      color: color ?? onSurface,
    );

    return TextTheme(
      displaySmall: style(34, FontWeight.w700, spacing: -0.8, height: 1.15),
      headlineMedium: style(28, FontWeight.w700, spacing: -0.6, height: 1.2),
      headlineSmall: style(24, FontWeight.w600, spacing: -0.4, height: 1.2),
      titleLarge: style(20, FontWeight.w600, spacing: -0.2),
      titleMedium: style(16, FontWeight.w600, spacing: -0.1),
      titleSmall: style(14, FontWeight.w600),
      bodyLarge: style(16, FontWeight.w400, height: 1.45),
      bodyMedium: style(14, FontWeight.w400, height: 1.45, color: muted),
      bodySmall: style(12, FontWeight.w400, height: 1.4, color: muted),
      labelLarge: style(14, FontWeight.w600, spacing: 0.1),
      labelMedium: style(12, FontWeight.w500, spacing: 0.4, color: muted),
      labelSmall: style(11, FontWeight.w600, spacing: 0.8, color: muted),
    );
  }
}

extension AppTextStyleX on TextStyle {
  /// Rakamları sabit genişlikte basar. Orantılı rakamlarla "1" ile "8" farklı
  /// genişlikte basılır ve liste içindeki tutar kolonu kayar; para ve miktar
  /// gösteren her metin bu stili kullanır.
  TextStyle get tabular =>
      copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
