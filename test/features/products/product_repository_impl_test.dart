import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/products/data/repositories/product_repository_impl.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';

/// Entegrasyon testi: gerçek (bellek içi) Drift → repository → domain.
///
/// `testWidgets` DEĞİL, düz `test` kullanılır: `testWidgets` sahte bir async
/// zamanında çalışır ve Drift'in gerçek I/O'su o zamanda ilerlemez (asılı timer).
/// Veritabanına dokunan testler her zaman düz `test` içinde yazılır.
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

  test('boş veritabanı boş liste yayınlar', () async {
    expect(await repository.watchAll().first, isEmpty);
  });

  test('eklenen ürün domain entity olarak geri okunur', () async {
    await repository.add(
      Product(
        id: null,
        name: 'Vida M8',
        price: Money.fromLira(12, 50),
        categoryId: categoryId,
      ),
    );

    final products = await repository.watchAll().first;

    expect(products, hasLength(1));
    expect(products.single.name, 'Vida M8');
    // Fiyat kuruş olarak saklanır, Money olarak döner.
    expect(products.single.price, Money.fromLira(12, 50));
    expect(products.single.price.minor, 1250);
    expect(products.single.id, isNotNull);
  });

  test('stream reaktiftir: yeni kayıt mevcut dinleyiciye yayınlanır', () async {
    final emissions = <List<Product>>[];
    final subscription = repository.watchAll().listen(emissions.add);

    await pumpEventQueue();
    await repository.add(
      Product(
        id: null,
        name: 'Somun',
        price: Money.fromLira(3),
        categoryId: categoryId,
      ),
    );
    await pumpEventQueue();

    await subscription.cancel();

    expect(emissions.first, isEmpty);
    expect(emissions.last.single.name, 'Somun');
  });

  test('arşivlenmiş ürün listede görünmez', () async {
    await repository.add(
      Product(
        id: null,
        name: 'Eski Ürün',
        price: Money.fromLira(1),
        categoryId: categoryId,
      ),
    );
    await db.customStatement('UPDATE products SET is_archived = 1');

    expect(await repository.watchAll().first, isEmpty);
  });

  test('ürünler isme göre sıralı gelir', () async {
    await repository.add(
      Product(
        id: null,
        name: 'Zımba',
        price: Money.fromLira(1),
        categoryId: categoryId,
      ),
    );
    await repository.add(
      Product(
        id: null,
        name: 'Anahtar',
        price: Money.fromLira(2),
        categoryId: categoryId,
      ),
    );

    final names = (await repository.watchAll().first)
        .map((p) => p.name)
        .toList();

    expect(names, ['Anahtar', 'Zımba']);
  });
}
