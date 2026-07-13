import 'package:flutter/material.dart';

/// Tekrar eden `Theme.of(context)` erişimlerini kısaltır.
/// CLAUDE.md: widget içinde doğrudan renk sabiti kullanılmaz, buradan geçilir.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Tablet/yatay ayrımı için tek eşik. Ekranlarda elle genişlik karşılaştırma yapma.
  bool get isWide => MediaQuery.sizeOf(this).width >= 600;
}
