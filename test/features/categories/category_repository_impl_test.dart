import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/categories/data/repositories/category_repository_impl.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/products/data/repositories/product_repository_impl.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';

void main() {
  late AppDatabase db;
  late CategoryRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CategoryRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('yeni kurulumda varsayılan "Genel" kategorisi vardır', () async {
    final categories = await repository.watchAll().first;

    expect(categories.map((c) => c.name), [kDefaultCategoryName]);
  });

  test('kategori oluşturulur ve liste kendiliğinden güncellenir', () async {
    final emissions = <List<Category>>[];
    final subscription = repository.watchAll().listen(emissions.add);

    await pumpEventQueue();
    await repository.create('Hırdavat');
    await pumpEventQueue();

    await subscription.cancel();

    expect(emissions.first.map((c) => c.name), [kDefaultCategoryName]);
    expect(emissions.last.map((c) => c.name), ['Genel', 'Hırdavat']);
  });

  test('kategoriler ada göre sıralı gelir', () async {
    await repository.create('Zımba');
    await repository.create('Ahşap');

    final names = (await repository.watchAll().first)
        .map((c) => c.name)
        .toList();

    expect(names, ['Ahşap', 'Genel', 'Zımba']);
  });

  test('kategori adı boş olamaz', () {
    expect(() => repository.create('   '), throwsA(isA<ValidationFailure>()));
  });

  test('adın boşlukları temizlenir', () async {
    await repository.create('  Hırdavat  ');

    final categories = await repository.watchAll().first;
    expect(categories.map((c) => c.name), contains('Hırdavat'));
  });

  test('aynı isimde ikinci kategori oluşturulamaz', () async {
    await repository.create('Hırdavat');

    expect(
      () => repository.create('Hırdavat'),
      throwsA(isA<DuplicateCategoryFailure>()),
    );
  });

  test('boş kategori silinebilir', () async {
    final id = await repository.create('Geçici');

    await repository.delete(id);

    final names = (await repository.watchAll().first).map((c) => c.name);
    expect(names, isNot(contains('Geçici')));
  });

  test('içinde ürün olan kategori silinemez', () async {
    final categoryId = await repository.create('Hırdavat');
    await ProductRepositoryImpl(db).create(
      Product(
        id: null,
        name: 'Vida',
        price: Money.fromLira(1),
        categoryId: categoryId,
      ),
    );

    // Ürünler sahipsiz kalamaz: kategori zorunlu, FK RESTRICT.
    await expectLater(
      repository.delete(categoryId),
      throwsA(isA<CategoryInUseFailure>()),
    );

    // Kategori hâlâ duruyor olmalı.
    final names = (await repository.watchAll().first).map((c) => c.name);
    expect(names, contains('Hırdavat'));
  });
}
