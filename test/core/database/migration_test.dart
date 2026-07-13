import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';

import '../../drift_schemas/schema.dart';
import '../../drift_schemas/schema_v1.dart' as v1;

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
