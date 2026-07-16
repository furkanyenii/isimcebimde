import 'package:flutter/material.dart';

/// Marka paleti.
///
/// `ColorScheme.fromSeed` bilinçli olarak kullanılmıyor: tohum algoritması
/// yüzeyleri tek tonun pastel türevlerine çeviriyor ve aradığımız "koyu,
/// katmanlı, yüksek kontrastlı finans aracı" karakterini üretmiyor. Renkler
/// burada elle tanımlanır; widget'lar yine de bu sınıfı değil,
/// `context.colors` üzerinden [ColorScheme]'i okur (CLAUDE.md: UI Rules).
///
/// Tek istisna [accentGradient]: gradyan [ColorScheme]'de temsil edilemiyor,
/// bu yüzden marka başlığı ve birincil eylem için buradan okunur.
abstract final class AppColors {
  // --- Marka aksanı (logodaki indigo-mavi, koyu zeminde parlayacak şekilde) ---
  static const Color accent = Color(0xFF6C7BFF);
  static const Color accentBright = Color(0xFF8B9BFF);
  static const Color accentDeep = Color(0xFF4B57D6);

  /// Marka başlığı ve birincil eylem yüzeyi.
  static const List<Color> accentGradient = [
    Color(0xFF5865ED),
    Color(0xFF8B5CF6),
  ];

  // --- Koyu tema: derin lacivert zemin, üstünde yükselen katmanlar ---
  static const Color darkBackground = Color(0xFF0B0E1A);
  static const Color darkSurface = Color(0xFF11162A);
  static const Color darkSurfaceHigh = Color(0xFF1A2038);
  static const Color darkSurfaceHighest = Color(0xFF242C48);
  static const Color darkBorder = Color(0xFF2C3454);
  static const Color darkOnSurface = Color(0xFFEDEFF7);
  static const Color darkOnSurfaceMuted = Color(0xFF97A0BF);

  // --- Açık tema: sahada güneş altında okunabilirlik birinci öncelik ---
  static const Color lightBackground = Color(0xFFF6F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceHigh = Color(0xFFF0F2F9);
  static const Color lightSurfaceHighest = Color(0xFFE6E9F4);
  static const Color lightBorder = Color(0xFFDCE0EC);
  static const Color lightOnSurface = Color(0xFF12162A);
  static const Color lightOnSurfaceMuted = Color(0xFF5B6480);

  // --- Durum renkleri (teklif durumu, tutar yönü, uyarılar) ---
  static const Color success = Color(0xFF2FBF71);
  static const Color warning = Color(0xFFF5A524);
  static const Color danger = Color(0xFFE5484D);

  /// Nötr vurgu. Modül listesinde şablonların kimliği: aksan (indigo) ile
  /// [success] (yeşil) arasında durduğu için ikisinden de net ayrışan bir ton
  /// gerekiyor — mor ya da teal komşularına karışırdı.
  static const Color info = Color(0xFF06B6D4);
}
