/// Uygulama genelindeki tüm ölçüler. CLAUDE.md: magic number yasak.
abstract final class AppSizes {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  /// Erişilebilirlik: minimum dokunma hedefi (Material 3).
  static const double minTapTarget = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 20;

  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 64;

  /// Splash ekranındaki marka logosu.
  static const double logoSplash = 120;
}

/// Animasyon süreleri.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 400);

  /// Splash logosunun tek bir "kalp atışı" (büyü-küçül) döngü süresi.
  /// 5 döngü × 500ms = splash ekranının toplam 2.5sn sürmesini sağlar.
  static const Duration heartbeat = Duration(milliseconds: 500);
}
