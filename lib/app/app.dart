import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/theme/app_theme.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/presentation/app_settings_x.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ayarlar okunana kadar varsayılan (sistem dili + sistem teması) kullanılır:
    // uygulama kabuğu her koşulda kurulmalı, ayar için spinner gösterilmez.
    // Ayar geldiğinde dil ve tema kendiliğinden uygulanır.
    final settings = ref.watch(settingsProvider).value ?? const AppSettings();

    return MaterialApp.router(
      title: 'Quotra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode.asThemeMode,
      routerConfig: appRouter,

      // `locale` null ise cihazın dili kullanılır, desteklenmiyorsa listedeki
      // ilkine (Türkçe) düşülür. Kullanıcı Ayarlar'dan dil seçtiyse o kazanır.
      locale: settings.language.asLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
