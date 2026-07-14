import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<AppSettings> watch() {
    final query = _db.select(_db.settings)
      ..where((s) => s.id.equals(kSettingsRowId));

    return query
        .watchSingleOrNull()
        .map((row) {
          // Satır migration/onCreate'te yaratılır. Yine de yoksa (elle silinmiş bir
          // veritabanı) ayarsız kalmak yerine varsayılana düşülür — dil tercihi
          // kaybolabilir, uygulama açılmamazlık edemez.
          if (row == null) return const AppSettings();
          return _toDomain(row);
        })
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.settings,
            cause: e,
          ),
        );
  }

  @override
  Future<void> save(AppSettings settings) async {
    try {
      await _db
          .into(_db.settings)
          .insertOnConflictUpdate(
            SettingsCompanion.insert(
              id: const Value(kSettingsRowId),
              languageCode: Value(settings.language.languageCode),
              themeMode: Value(settings.themeMode.wireName),
              companyName: Value(_nullIfBlank(settings.company.name)),
              companyLogoPath: Value(_nullIfBlank(settings.company.logoPath)),
              companyPhone: Value(_nullIfBlank(settings.company.phone)),
              companyEmail: Value(_nullIfBlank(settings.company.email)),
              companyWebsite: Value(_nullIfBlank(settings.company.website)),
              companyAddress: Value(_nullIfBlank(settings.company.address)),
              companyTaxOffice: Value(_nullIfBlank(settings.company.taxOffice)),
              companyTaxNumber: Value(_nullIfBlank(settings.company.taxNumber)),
            ),
          );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.update,
        EntityKind.settings,
        cause: e,
      );
    }
  }

  AppSettings _toDomain(SettingsRow row) => AppSettings(
    language: AppLanguage.fromCode(row.languageCode),
    themeMode: AppThemeMode.fromWireName(row.themeMode),
    company: CompanyInfo(
      name: row.companyName,
      logoPath: row.companyLogoPath,
      phone: row.companyPhone,
      email: row.companyEmail,
      website: row.companyWebsite,
      address: row.companyAddress,
      taxOffice: row.companyTaxOffice,
      taxNumber: row.companyTaxNumber,
    ),
  );

  /// Boş metin "bilgi yok" demektir; iki ayrı temsili (`''` ve `null`) olmasın.
  static String? _nullIfBlank(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
