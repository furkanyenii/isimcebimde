import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:isimcebimde/features/settings/data/services/file_logo_storage.dart';
import 'package:isimcebimde/features/settings/data/services/image_picker_logo_picker.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/repositories/logo_picker.dart';
import 'package:isimcebimde/features/settings/domain/repositories/logo_storage.dart';
import 'package:isimcebimde/features/settings/domain/repositories/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_providers.g.dart';

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(appDatabaseProvider));

/// Arayüz tipiyle döner: testte sahte depolama tek satırla takılır.
@Riverpod(keepAlive: true)
LogoStorage logoStorage(Ref ref) => const FileLogoStorage();

/// Galeri açmak platform kanalı gerektirir; testte sahtelenebilmesi için
/// arayüz üzerinden sağlanır.
@Riverpod(keepAlive: true)
LogoPicker logoPicker(Ref ref) => const ImagePickerLogoPicker();

/// Uygulama ayarları. `App` bunu dinler: dil veya tema değişince tüm arayüz
/// kendiliğinden yeniden kurulur — manuel `invalidate` gerekmez.
///
/// `keepAlive`: uygulama ömrü boyunca dinlenir; kök widget'ın altında yaşar.
@Riverpod(keepAlive: true)
Stream<AppSettings> settings(Ref ref) =>
    ref.watch(settingsRepositoryProvider).watch();

/// Dil ve tema tercihini kaydeder.
@riverpod
class SettingsController extends _$SettingsController {
  @override
  FutureOr<void> build() {}

  Future<void> setLanguage(AppLanguage language) =>
      _update((current) => current.copyWith(language: language));

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update((current) => current.copyWith(themeMode: mode));

  Future<void> saveCompany(CompanyInfo company) =>
      _update((current) => current.copyWith(company: company));

  /// Seçilen görseli kalıcı konuma kopyalar ve yolunu kaydeder. Eski logo
  /// dosyası silinir — cihazda çöp dosya bırakmayız.
  Future<void> setLogo(String pickedPath) async {
    final storage = ref.read(logoStorageProvider);
    final previous = (await ref.read(settingsProvider.future)).company.logoPath;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final stored = await storage.save(pickedPath);
      await _save(
        (current) => current.copyWith(
          company: current.company.copyWith(logoPath: stored),
        ),
      );
      if (previous != null) await storage.delete(previous);
    });
  }

  Future<void> removeLogo() async {
    final storage = ref.read(logoStorageProvider);
    final previous = (await ref.read(settingsProvider.future)).company.logoPath;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _save(
        (current) => current.copyWith(company: current.company.withoutLogo()),
      );
      if (previous != null) await storage.delete(previous);
    });
  }

  Future<void> _update(AppSettings Function(AppSettings current) change) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _save(change));
  }

  /// Mevcut ayarın üzerine yazar: tek alanı değiştiren bir kaydetme, diğer
  /// alanları varsayılana döndürmemelidir.
  Future<void> _save(AppSettings Function(AppSettings current) change) async {
    final current = await ref.read(settingsProvider.future);
    await ref.read(settingsRepositoryProvider).save(change(current));
  }
}
