import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/quotes/data/repositories/template_repository_impl.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';

/// Veritabanına dokunan test düz `test()` içinde yazılır (CLAUDE.md: Test Rules).
void main() {
  late AppDatabase db;
  late TemplateRepositoryImpl repository;
  late int categoryId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = TemplateRepositoryImpl(db);

    categoryId = await db
        .into(db.categories)
        .insert(CategoriesCompanion.insert(name: 'Hırdavat'));
  });

  tearDown(() => db.close());

  OfferItem sampleItem({int? productId}) => OfferItem(
    productId: productId,
    productName: 'Vida M8',
    unitPrice: Money.fromLira(12, 50),
    quantity: 100,
    vatRate: Percent.of(20),
  );

  Template sampleTemplate({
    String name = 'Standart Hırdavat',
    List<OfferItem>? items,
  }) => Template(name: name, items: items ?? [sampleItem()]);

  test('şablon oluşturulur ve satırlarıyla birlikte okunur', () async {
    final id = await repository.create(sampleTemplate());

    final template = await repository.watchById(id).first;
    expect(template, isNotNull);
    expect(template!.name, 'Standart Hırdavat');
    expect(template.items, hasLength(1));
    expect(template.items.single.productName, 'Vida M8');
    expect(template.items.single.quantity, 100);
    expect(template.items.single.unitPrice, Money.fromLira(12, 50));
  });

  test('isimsiz şablon oluşturulamaz', () async {
    final template = Template(name: '', items: [sampleItem()]);

    expect(() => repository.create(template), throwsA(isA<EmptyNameFailure>()));
  });

  test('ürünsüz şablon oluşturulamaz', () async {
    final template = sampleTemplate(items: []);

    expect(
      () => repository.create(template),
      throwsA(isA<EmptyTemplateFailure>()),
    );
  });

  test('aynı isimde ikinci şablon oluşturulamaz', () async {
    await repository.create(sampleTemplate());

    expect(
      () => repository.create(sampleTemplate()),
      throwsA(isA<DuplicateTemplateNameFailure>()),
    );
  });

  test('kaydedilmemiş şablon güncellenemez', () async {
    expect(
      () => repository.update(sampleTemplate()),
      throwsA(isA<UnsavedEntityFailure>()),
    );
  });

  test('güncelleme satırları tamamen değiştirir (diff\'lemez)', () async {
    final id = await repository.create(sampleTemplate());
    final saved = await repository.watchById(id).first;

    final updated = saved!.copyWith(
      items: [sampleItem().copyWith(productName: 'Somun', quantity: 5)],
    );
    await repository.update(updated);

    final reloaded = await repository.watchById(id).first;
    expect(reloaded!.items, hasLength(1));
    expect(reloaded.items.single.productName, 'Somun');
    expect(reloaded.items.single.quantity, 5);
  });

  test('satır sırası korunur', () async {
    final id = await repository.create(
      sampleTemplate(
        items: [
          sampleItem().copyWith(productName: 'Vida'),
          sampleItem().copyWith(productName: 'Somun'),
          sampleItem().copyWith(productName: 'Rondela'),
        ],
      ),
    );

    final template = await repository.watchById(id).first;
    expect(template!.items.map((i) => i.productName), [
      'Vida',
      'Somun',
      'Rondela',
    ]);
  });

  test('şablon silinince satırları da silinir', () async {
    final id = await repository.create(sampleTemplate());
    await repository.delete(id);

    expect(await db.select(db.templateItems).get(), isEmpty);
    expect(await repository.watchById(id).first, isNull);
  });

  test('liste oluşturulma sırasına göre (en yeni önce) gelir', () async {
    await repository.create(sampleTemplate(name: 'Birinci'));
    await repository.create(sampleTemplate(name: 'İkinci'));

    final templates = await repository.watchAll().first;
    expect(templates, hasLength(2));
  });

  test('ürün silinse bile satırın adı/fiyatı snapshot olarak kalır', () async {
    final productId = await db
        .into(db.products)
        .insert(
          ProductsCompanion.insert(
            name: 'Vida M8',
            priceMinor: 1250,
            categoryId: categoryId,
          ),
        );
    final id = await repository.create(
      sampleTemplate(items: [sampleItem(productId: productId)]),
    );

    await (db.delete(db.products)..where((p) => p.id.equals(productId))).go();

    final template = await repository.watchById(id).first;
    expect(template!.items.single.productId, isNull);
    expect(template.items.single.productName, 'Vida M8');
    expect(template.items.single.unitPrice, Money.fromLira(12, 50));
  });
}
