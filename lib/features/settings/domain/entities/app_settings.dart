import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/entities/preparer_info.dart';

/// Kullanıcının seçtiği arayüz dili.
///
/// [system] "cihazın dilini kullan" demektir ve varsayılandır: kullanıcı bir
/// tercih belirtmediyse telefonunun dili doğru tahmindir.
enum AppLanguage {
  system(null),
  turkish('tr'),
  english('en');

  const AppLanguage(this.languageCode);

  /// Veritabanında saklanan değer. [system] için `NULL` — "seçim yapılmadı"
  /// ile "Türkçe seçildi" aynı şey değildir; ikincisi cihaz dili değişse bile
  /// Türkçe kalmalıdır.
  final String? languageCode;

  static AppLanguage fromCode(String? code) {
    if (code == null) return AppLanguage.system;
    for (final language in values) {
      if (language.languageCode == code) return language;
    }
    // CHECK kısıtı bunu engeller; yine de bozuk veriyi gizlemek yerine göster.
    throw ArgumentError.value(code, 'code', 'Bilinmeyen dil kodu');
  }
}

/// Tema tercihi. Flutter'ın `ThemeMode`'unun domain karşılığı — `domain`
/// katmanı `package:flutter` import edemez (CLAUDE.md: bağımlılık yönü).
enum AppThemeMode {
  system('system'),
  light('light'),
  dark('dark');

  const AppThemeMode(this.wireName);

  final String wireName;

  static AppThemeMode fromWireName(String value) {
    for (final mode in values) {
      if (mode.wireName == value) return mode;
    }
    throw ArgumentError.value(value, 'value', 'Bilinmeyen tema modu');
  }
}

/// Uygulama ayarları. Tek satırlık bir kayıttır.
class AppSettings {
  const AppSettings({
    this.language = AppLanguage.system,
    this.themeMode = AppThemeMode.system,
    this.company = const CompanyInfo(),
    this.preparer = const PreparerInfo(),
  });

  final AppLanguage language;
  final AppThemeMode themeMode;
  final CompanyInfo company;

  /// Teklifi hazırlayan kişi. Cihaz başına tek kişi varsayılır; teklif başına
  /// farklı hazırlayan gerekirse bu alan tekliflere taşınır.
  final PreparerInfo preparer;

  AppSettings copyWith({
    AppLanguage? language,
    AppThemeMode? themeMode,
    CompanyInfo? company,
    PreparerInfo? preparer,
  }) => AppSettings(
    language: language ?? this.language,
    themeMode: themeMode ?? this.themeMode,
    company: company ?? this.company,
    preparer: preparer ?? this.preparer,
  );

  @override
  bool operator ==(Object other) =>
      other is AppSettings &&
      other.language == language &&
      other.themeMode == themeMode &&
      other.company == company &&
      other.preparer == preparer;

  @override
  int get hashCode => Object.hash(language, themeMode, company, preparer);
}
