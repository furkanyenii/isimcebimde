import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';

/// Veritabanına dokunan test düz `test()` içinde yazılır (CLAUDE.md: Test Rules).
void main() {
  late AppDatabase db;
  late SettingsRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = SettingsRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test(
    'yeni kurulumda varsayılan ayar okunur: sistem dili, sistem teması',
    () async {
      final settings = await repository.watch().first;

      expect(settings.language, AppLanguage.system);
      expect(settings.themeMode, AppThemeMode.system);
    },
  );

  test('kaydedilen dil ve tema geri okunur', () async {
    await repository.save(
      const AppSettings(
        language: AppLanguage.english,
        themeMode: AppThemeMode.dark,
      ),
    );

    final settings = await repository.watch().first;
    expect(settings.language, AppLanguage.english);
    expect(settings.themeMode, AppThemeMode.dark);
  });

  test('kaydetmek satırı çoğaltmaz, üzerine yazar', () async {
    await repository.save(const AppSettings(language: AppLanguage.turkish));
    await repository.save(const AppSettings(language: AppLanguage.english));

    expect(await db.select(db.settings).get(), hasLength(1));
    expect((await repository.watch().first).language, AppLanguage.english);
  });

  test('sistem diline dönüldüğünde dil kodu NULL olur', () async {
    await repository.save(const AppSettings(language: AppLanguage.turkish));
    await repository.save(const AppSettings());

    // "Seçim yok" ile "Türkçe seçildi" farklı durumlardır: birincisi cihaz
    // dilini takip eder, ikincisi etmez.
    final row = await db.select(db.settings).getSingle();
    expect(row.languageCode, isNull);
    expect((await repository.watch().first).language, AppLanguage.system);
  });

  test('firma bilgileri kaydedilir ve geri okunur', () async {
    await repository.save(
      const AppSettings(
        company: CompanyInfo(
          name: 'Yılmaz Hırdavat',
          phone: '0555 111 22 33',
          taxNumber: '1234567890',
          logoPath: '/documents/company_logo-1.png',
        ),
      ),
    );

    final company = (await repository.watch().first).company;
    expect(company.name, 'Yılmaz Hırdavat');
    expect(company.phone, '0555 111 22 33');
    expect(company.taxNumber, '1234567890');
    expect(company.logoPath, '/documents/company_logo-1.png');
    expect(company.hasLogo, isTrue);
  });

  test('boş firma alanı NULL olarak saklanır', () async {
    await repository.save(
      const AppSettings(
        company: CompanyInfo(name: 'Acme', phone: '   '),
      ),
    );

    // "Telefonu yok" tek bir şekilde temsil edilmeli ('' değil NULL).
    final row = await db.select(db.settings).getSingle();
    expect(row.companyPhone, isNull);
    expect(row.companyName, 'Acme');
  });

  test('firma bilgisi kaydetmek dil tercihini ezmez', () async {
    await repository.save(const AppSettings(language: AppLanguage.english));

    final current = await repository.watch().first;
    await repository.save(
      current.copyWith(company: const CompanyInfo(name: 'Acme')),
    );

    final updated = await repository.watch().first;
    expect(updated.language, AppLanguage.english);
    expect(updated.company.name, 'Acme');
  });

  test('ayar değişince stream yeni değeri yayar', () async {
    final emissions = <AppLanguage>[];
    final subscription = repository.watch().listen(
      (settings) => emissions.add(settings.language),
    );

    await pumpEventQueue();
    await repository.save(const AppSettings(language: AppLanguage.english));
    await pumpEventQueue();
    await subscription.cancel();

    expect(emissions, [AppLanguage.system, AppLanguage.english]);
  });
}
