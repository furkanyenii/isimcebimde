import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';

/// Ayarlar tek satırlık bir kayıttır: "yoksa oluştur" işi repository'nin içinde
/// kalır, çağıran id ile uğraşmaz.
abstract interface class SettingsRepository {
  /// Ayarlar değiştiğinde (dil, tema) yayın yapar; UI kendiliğinden güncellenir.
  Stream<AppSettings> watch();

  Future<void> save(AppSettings settings);
}
