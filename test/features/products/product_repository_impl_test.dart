import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/products/data/repositories/product_repository_impl.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';

/// Entegrasyon testi: gerçek (bellek içi) Drift → repository → domain.
///
/// `testWidgets` DEĞİL, düz `test` kullanılır: `testWidgets` sahte bir async
/// zamanında çalışır ve Drift'in gerçek I/O'su o zamanda ilerlemez (asılı timer).
void main() {
  late AppDatabase db;
  late ProductRepositoryImpl repository;
  late int categoryId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = ProductRepositoryImpl(db);
    // Kategori zorunlu; onCreate varsayılan "Genel" kategorisini kurar.
    categoryId = (await db.select(db.categories).getSingle()).id;
  });

  tearDown(() => db.close());

  Product product(String name, Money price) =>
      Product(id: null, name: name, price: price, categoryId: categoryId);

  group('create / okuma', () {
    test('boş veritabanı boş liste yayınlar', () async {
      expect(await repository.watchAll().first, isEmpty);
    });

    test('eklenen ürün domain entity olarak geri okunur', () async {
      await repository.create(product('Vida M8', Money.fromLira(12, 50)));

      final products = await repository.watchAll().first;

      expect(products, hasLength(1));
      expect(products.single.name, 'Vida M8');
      // Fiyat kuruş olarak saklanır, Money olarak döner.
      expect(products.single.price, Money.fromLira(12, 50));
      expect(products.single.price.minor, 1250);
      expect(products.single.categoryId, categoryId);
      // Varsayılan KDV %20.
      expect(products.single.vatRate, Percent.of(20));
    });

    test('KDV oranı üründe saklanır', () async {
      await repository.create(
        Product(
          id: null,
          name: 'Ekmek',
          price: Money.fromLira(10),
          categoryId: categoryId,
          vatRate: Percent.of(1),
        ),
      );

      final products = await repository.watchAll().first;
      expect(products.single.vatRate, Percent.of(1));
    });

    test('ürün adının baştaki/sondaki boşlukları temizlenir', () async {
      await repository.create(product('  Vida  ', Money.fromLira(1)));

      expect((await repository.watchAll().first).single.name, 'Vida');
    });

    test('stream reaktiftir: yeni kayıt dinleyiciye yayınlanır', () async {
      final emissions = <List<Product>>[];
      final subscription = repository.watchAll().listen(emissions.add);

      await pumpEventQueue();
      await repository.create(product('Somun', Money.fromLira(3)));
      await pumpEventQueue();

      await subscription.cancel();

      expect(emissions.first, isEmpty);
      expect(emissions.last.single.name, 'Somun');
    });

    test('ürünler isme göre sıralı gelir', () async {
      await repository.create(product('Zımba', Money.fromLira(1)));
      await repository.create(product('Anahtar', Money.fromLira(2)));

      final names = (await repository.watchAll().first)
          .map((p) => p.name)
          .toList();

      expect(names, ['Anahtar', 'Zımba']);
    });

    test('watchById tek ürünü izler, yoksa null döner', () async {
      final id = await repository.create(product('Vida', Money.fromLira(1)));

      expect((await repository.watchById(id).first)?.name, 'Vida');
      expect(await repository.watchById(9999).first, isNull);
    });
  });

  group('doğrulama', () {
    test('boş isim reddedilir', () {
      expect(
        () => repository.create(product('   ', Money.fromLira(1))),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('negatif fiyat reddedilir', () {
      expect(
        () => repository.create(product('Vida', const Money(-1))),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('kaydedilmemiş ürün güncellenemez', () {
      expect(
        () => repository.update(product('Vida', Money.fromLira(1))),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('update', () {
    test('ürün güncellenir', () async {
      final id = await repository.create(product('Vida', Money.fromLira(1)));

      await repository.update(
        Product(
          id: id,
          name: 'Vida M8',
          price: Money.fromLira(15, 75),
          categoryId: categoryId,
          vatRate: Percent.of(10),
        ),
      );

      final updated = await repository.watchById(id).first;
      expect(updated!.name, 'Vida M8');
      expect(updated.price, Money.fromLira(15, 75));
      expect(updated.vatRate, Percent.of(10));
    });
  });

  group('delete', () {
    test('ürün kalıcı olarak silinir', () async {
      final id = await repository.create(product('Vida', Money.fromLira(1)));

      await repository.delete(id);

      expect(await repository.watchAll().first, isEmpty);
      expect(await repository.watchById(id).first, isNull);
    });
  });

  group('arama', () {
    setUp(() async {
      await repository.create(product('Vida M8', Money.fromLira(1)));
      await repository.create(product('Somun M8', Money.fromLira(2)));
      await repository.create(product('Çekiç', Money.fromLira(3)));
    });

    test('ada göre filtreler', () async {
      final results = await repository.watchAll(query: 'vida').first;
      expect(results.map((p) => p.name), ['Vida M8']);
    });

    test('kısmi eşleşme bulur', () async {
      final results = await repository.watchAll(query: 'M8').first;
      expect(results.map((p) => p.name), ['Somun M8', 'Vida M8']);
    });

    test('boş arama tüm ürünleri getirir', () async {
      expect(await repository.watchAll(query: '   ').first, hasLength(3));
    });

    // SQLite'ın lower()'ı yalnızca ASCII çalışır; bu testler Türkçe
    // karakterlerde aramanın bozulmadığını garanti eder.
    test('Türkçe karakterlerde büyük/küçük harf duyarsızdır', () async {
      expect(await repository.watchAll(query: 'çekiç').first, hasLength(1));
      expect(await repository.watchAll(query: 'ÇEKİÇ').first, hasLength(1));
      expect(await repository.watchAll(query: 'Çekiç').first, hasLength(1));
    });

    test('noktalı/noktasız i ayrımı aramayı bozmaz', () async {
      await repository.create(product('Kılavuz', Money.fromLira(4)));

      expect(await repository.watchAll(query: 'kilavuz').first, hasLength(1));
      expect(await repository.watchAll(query: 'KILAVUZ').first, hasLength(1));
    });

    test('eşleşme yoksa boş liste döner', () async {
      expect(await repository.watchAll(query: 'yok').first, isEmpty);
    });
  });

  group('kategori filtresi', () {
    test('yalnızca seçilen kategorinin ürünlerini getirir', () async {
      final otherCategoryId = await db
          .into(db.categories)
          .insert(CategoriesCompanion.insert(name: 'Hırdavat'));

      await repository.create(product('Genel Ürün', Money.fromLira(1)));
      await repository.create(
        Product(
          id: null,
          name: 'Hırdavat Ürünü',
          price: Money.fromLira(2),
          categoryId: otherCategoryId,
        ),
      );

      final results = await repository
          .watchAll(categoryId: otherCategoryId)
          .first;

      expect(results.map((p) => p.name), ['Hırdavat Ürünü']);
    });
  });
}
