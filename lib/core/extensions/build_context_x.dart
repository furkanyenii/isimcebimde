import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// Tekrar eden `Theme.of(context)` erişimlerini kısaltır.
/// CLAUDE.md: widget içinde doğrudan renk sabiti kullanılmaz, buradan geçilir.
extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;

  /// Kullanıcıya görünen her metin buradan gelir; hardcoded string yasak
  /// (CLAUDE.md: Coding Standards). `nullable-getter: false` olduğu için
  /// null kontrolü gerekmez.
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// Tablet/yatay ayrımı için tek eşik. Ekranlarda elle genişlik karşılaştırma yapma.
  bool get isWide => MediaQuery.sizeOf(this).width >= 600;

  /// `intl`'in beklediği biçimde aktif locale (`tr`, `en`).
  String get localeTag => Localizations.localeOf(this).toLanguageTag();

  /// Tutarı aktif dile göre biçimler (TR `12,50 ₺`, EN `₺12.50`).
  /// Para birimi dilden bağımsızdır; locale yalnızca biçimi belirler.
  String formatMoney(Money amount) => amount.format(locale: localeTag);

  /// Ondalık ayracı (TR `,`, EN `.`). Para girişi bunu kullanır.
  String get decimalSeparator =>
      NumberFormat.decimalPattern(localeTag).symbols.DECIMAL_SEP;
}
