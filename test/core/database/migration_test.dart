import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';

import '../../drift_schemas/schema.dart';
import '../../drift_schemas/schema_v1.dart' as v1;
import '../../drift_schemas/schema_v2.dart' as v2;
import '../../drift_schemas/schema_v3.dart' as v3;
import '../../drift_schemas/schema_v4.dart' as v4;

/// Kullanıcının cihazındaki veri geri getirilemez: backend yok, sunucuda yedek yok.
/// Bu yüzden migration'lar **testsiz merge edilmez** (CLAUDE.md: Database Rules).
///
/// Bu testler şema doğruluğunu değil, asıl olarak **veri kaybı olmadığını** kanıtlar.
void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('v1 → v2 sonrası şema beklenen hale gelir', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 2);
  });

  test(
    'v1\'deki ürünler v2\'ye kayıpsız taşınır ve Genel kategorisine bağlanır',
    () async {
      // 1) v1 şemasıyla bir veritabanı kur ve içine gerçek ürün yaz.
      final schema = await verifier.schemaAt(1);
      final oldDb = v1.DatabaseAtV1(schema.newConnection());

      // v1 yardımcısı companion üretmez; eski veriyi ham SQL ile yazıyoruz.
      await oldDb.customStatement(
        'INSERT INTO products (name, price_minor) VALUES (?, ?)',
        ['Vida M8', 1250],
      );
      await oldDb.customStatement(
        'INSERT INTO products (name, price_minor) VALUES (?, ?)',
        ['Somun', 300],
      );
      await oldDb.close();

      // 2) Gerçek uygulama koduyla v2'ye yükselt.
      final db = AppDatabase.forTesting(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, 2);

      // 3) Ürünler duruyor mu?
      final products = await db.select(db.products).get();
      expect(products, hasLength(2));
      expect(
        products.map((p) => p.name),
        containsAll(<String>['Vida M8', 'Somun']),
      );

      // Fiyatlar (kuruş) bozulmamalı.
      final vida = products.firstWhere((p) => p.name == 'Vida M8');
      expect(vida.priceMinor, 1250);

      // 4) Kategori zorunlu: hiçbir ürün boşta kalmamalı, hepsi "Genel"e bağlı.
      final categories = await db.select(db.categories).get();
      final general = categories.singleWhere(
        (c) => c.name == kDefaultCategoryName,
      );
      expect(
        products.every((p) => p.categoryId == general.id),
        isTrue,
        reason: 'Migration sonrası kategorisiz ürün kalmamalı',
      );

      // 5) KDV oranı varsayılanı uygulanmalı (%20).
      expect(products.every((p) => p.vatRateBasisPoints == 2000), isTrue);
    },
  );

  test('v2 → v3 sonrası şema beklenen hale gelir', () async {
    final connection = await verifier.startAt(2);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 3);
  });

  test('v1 → v3 tek seferde yükseltilebilir (sürüm atlanmaz)', () async {
    // Uygulamayı uzun süre güncellemeyen kullanıcı doğrudan v1'den v3'e atlar.
    // Migration adımlarının sırayla çalıştığının kanıtı budur.
    final connection = await verifier.startAt(1);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 3);
  });

  test('v2\'deki ürün ve kategoriler v3\'e kayıpsız taşınır', () async {
    // v2 → v3 yalnızca yeni tablo ekler; mevcut veriye dokunmamalı.
    final schema = await verifier.schemaAt(2);
    final oldDb = v2.DatabaseAtV2(schema.newConnection());

    await oldDb.customStatement(
      'INSERT INTO categories (id, name) VALUES (1, ?)',
      ['Genel'],
    );
    await oldDb.customStatement(
      'INSERT INTO products (name, price_minor, category_id, vat_rate_basis_points) '
      'VALUES (?, ?, 1, 1000)',
      ['Vida M8', 1250],
    );
    await oldDb.close();

    final db = AppDatabase.forTesting(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 3);

    final products = await db.select(db.products).get();
    expect(products, hasLength(1));
    expect(products.single.name, 'Vida M8');
    expect(products.single.priceMinor, 1250);
    expect(products.single.categoryId, 1);
    // Ürüne özel KDV oranı varsayılana ezilmemeli.
    expect(products.single.vatRateBasisPoints, 1000);

    // Yeni tablo boş ama kullanılabilir olmalı.
    expect(await db.select(db.customers).get(), isEmpty);
  });

  test('v3\'teki müşteri ve ürünler v5\'e kayıpsız taşınır', () async {
    // v3'te ayarlar tablosu hiç yoktu; tablo güncel tanımıyla yaratılır ve
    // mevcut veriye dokunulmaz.
    final schema = await verifier.schemaAt(3);
    final oldDb = v3.DatabaseAtV3(schema.newConnection());

    await oldDb.customStatement(
      'INSERT INTO categories (id, name) VALUES (1, ?)',
      ['Genel'],
    );
    await oldDb.customStatement(
      'INSERT INTO products (name, price_minor, category_id) VALUES (?, ?, 1)',
      ['Vida M8', 1250],
    );
    await oldDb.customStatement(
      'INSERT INTO customers (type, name) VALUES (?, ?)',
      ['company', 'Yılmaz İnşaat'],
    );
    await oldDb.close();

    final db = AppDatabase.forTesting(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 5);

    expect(await db.select(db.products).get(), hasLength(1));
    expect(await db.select(db.customers).get(), hasLength(1));

    // Ayar satırı migration'da yaratılır: okuma yolu "satır yok" durumunu
    // hiç görmemeli. Varsayılan = sistem dili, sistem teması.
    final settings = await db.select(db.settings).getSingle();
    expect(settings.id, kSettingsRowId);
    expect(settings.languageCode, isNull);
    expect(settings.themeMode, 'system');
  });

  test('v4 → v5 sonrası şema beklenen hale gelir', () async {
    final connection = await verifier.startAt(4);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 5);
  });

  test('v1 → v5 tek seferde yükseltilebilir (sürüm atlanmaz)', () async {
    final connection = await verifier.startAt(1);
    final db = AppDatabase.forTesting(connection);
    addTearDown(db.close);

    await verifier.migrateAndValidate(db, 5);
  });

  test('v4\'teki dil ve tema tercihi v5\'e kayıpsız taşınır', () async {
    // v4 → v5 yalnızca nullable sütun ekler; kullanıcının tercihi korunmalı.
    final schema = await verifier.schemaAt(4);
    final oldDb = v4.DatabaseAtV4(schema.newConnection());

    await oldDb.customStatement(
      'INSERT INTO settings (id, language_code, theme_mode) VALUES (1, ?, ?)',
      ['en', 'dark'],
    );
    await oldDb.close();

    final db = AppDatabase.forTesting(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, 5);

    final row = await db.select(db.settings).getSingle();
    expect(row.languageCode, 'en');
    expect(row.themeMode, 'dark');
    // Yeni alanlar boş gelir; firma bilgisi girilmemiş demektir.
    expect(row.companyName, isNull);
    expect(row.companyLogoPath, isNull);
  });

  test('ayarlar tek satırdır (CHECK id = 1)', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // İkinci bir ayar satırı, "hangisi geçerli?" sorusunu doğurur; veritabanı
    // seviyesinde engellenir.
    await expectLater(
      db.customStatement('INSERT INTO settings (id) VALUES (2)'),
      throwsA(isA<Exception>()),
    );

    expect(await db.select(db.settings).get(), hasLength(1));
  });

  test('geçersiz dil ve tema değeri veritabanına giremez (CHECK)', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    await expectLater(
      db.customStatement('UPDATE settings SET language_code = ?', ['de']),
      throwsA(isA<Exception>()),
    );
    await expectLater(
      db.customStatement('UPDATE settings SET theme_mode = ?', ['sepia']),
      throwsA(isA<Exception>()),
    );
  });

  test('müşteri tipi veritabanı seviyesinde kısıtlanır (CHECK)', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Repository'de bir hata olsa bile tabloya çöp tip giremez.
    await expectLater(
      db.customStatement('INSERT INTO customers (type, name) VALUES (?, ?)', [
        'kurumsal', // geçerli değerler: 'individual' | 'company'
        'Yılmaz İnşaat',
      ]),
      throwsA(isA<Exception>()),
    );

    await db.customStatement(
      'INSERT INTO customers (type, name) VALUES (?, ?)',
      ['company', 'Yılmaz İnşaat'],
    );
    expect(await db.select(db.customers).get(), hasLength(1));
  });

  test('yeni kurulumda (onCreate) varsayılan kategori hazır gelir', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    final categories = await db.select(db.categories).get();

    expect(categories, hasLength(1));
    expect(categories.single.name, kDefaultCategoryName);
  });

  test('kategori zorunlu: kategorisiz ürün eklenemez', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);

    // Var olmayan kategoriye bağlamak foreign key ihlalidir.
    await expectLater(
      db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(
              name: 'Hayalet',
              priceMinor: 100,
              categoryId: 9999,
            ),
          ),
      throwsA(isA<Exception>()),
    );
  });
}
