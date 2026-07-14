import 'package:flutter/material.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// Widget testleri için lokalizasyon delegate'leri kurulmuş `MaterialApp`.
///
/// Delegate'ler olmadan `context.l10n` çalışmaz — üretimde `App` bunları
/// kuruyor, test de aynısını kurmalı. Aksi halde test, üretimde olmayan bir
/// ortamı doğrular (CLAUDE.md: Test Rules).
///
/// [locale] ile testi belirli bir dilde koşturabilirsin; varsayılan Türkçe.
/// İngilizce ekran testleri bu parametreyle yazılır.
Widget localizedApp(Widget home, {Locale locale = const Locale('tr')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}

/// Router ile kurulan testler için aynısı ([localizedApp]'in `MaterialApp.router`
/// karşılığı). Yönlendirmeyi sınayan testler gerçek router'la kurulur.
Widget localizedRouterApp(
  RouterConfig<Object> routerConfig, {
  Locale locale = const Locale('tr'),
}) {
  return MaterialApp.router(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    routerConfig: routerConfig,
  );
}

/// Testin beklediği metni, ekranın kullandığı **aynı** kaynaktan okur.
///
/// Beklentiyi `'Ürün kaydedilemedi.'` diye elle yazmak, çeviri değiştiğinde
/// testi kırar ve asıl davranışı değil metni test eder. Bunun yerine test de
/// ARB'den okur: böylece test "doğru mesaj gösterildi mi?"yi doğrular,
/// "metin şu harflerden mi oluşuyor?"u değil.
AppLocalizations l10nFor(Locale locale) => lookupAppLocalizations(locale);
