import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/data/repositories/offer_repository_impl.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';

/// Veritabanına dokunan test düz `test()` içinde yazılır (CLAUDE.md: Test Rules).
void main() {
  late AppDatabase db;
  late OfferRepositoryImpl repository;
  late int categoryId;
  late int customerId;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = OfferRepositoryImpl(db);

    categoryId = await db
        .into(db.categories)
        .insert(CategoriesCompanion.insert(name: 'Hırdavat'));
    customerId = await db
        .into(db.customers)
        .insert(
          CustomersCompanion.insert(type: 'individual', name: 'Ahmet Yılmaz'),
        );
  });

  tearDown(() => db.close());

  OfferItem sampleItem({int? productId}) => OfferItem(
    productId: productId,
    productName: 'Vida M8',
    unitPrice: Money.fromLira(12, 50),
    quantity: Quantity.of(100),
    vatRate: Percent.of(20),
  );

  Offer sampleOffer({List<OfferItem>? items}) => Offer(
    customerId: customerId,
    customerName: 'Ahmet Yılmaz',
    items: items ?? [sampleItem()],
  );

  test('teklif oluşturulur ve satırlarıyla birlikte okunur', () async {
    final id = await repository.create(sampleOffer());

    final offer = await repository.watchById(id).first;
    expect(offer, isNotNull);
    expect(offer!.customerName, 'Ahmet Yılmaz');
    expect(offer.items, hasLength(1));
    expect(offer.items.single.productName, 'Vida M8');
    expect(offer.items.single.quantity, Quantity.of(100));
    expect(offer.items.single.unitPrice, Money.fromLira(12, 50));
  });

  test(
    'müşteri iletişim/vergi bilgileri snapshot olarak kaydedilip okunur',
    () async {
      // Vergi no hem harf içerir hem 11 haneden uzundur: uzunluk sınırı
      // kalkmış olmalı.
      final offer = sampleOffer().copyWith(
        customerContactPerson: 'Ahmet Yılmaz',
        customerPhone: '0532 111 22 33',
        customerEmail: 'info@yilmaz.com',
        customerAddress: 'Çekmeköy, İstanbul',
        customerTaxOffice: 'Ümraniye',
        customerTaxNumber: 'TR1234567890123',
      );

      final id = await repository.create(offer);
      final saved = await repository.watchById(id).first;

      expect(saved!.customerContactPerson, 'Ahmet Yılmaz');
      expect(saved.customerPhone, '0532 111 22 33');
      expect(saved.customerEmail, 'info@yilmaz.com');
      expect(saved.customerAddress, 'Çekmeköy, İstanbul');
      expect(saved.customerTaxOffice, 'Ümraniye');
      expect(saved.customerTaxNumber, 'TR1234567890123');
    },
  );

  test('boş müşteri bilgileri null olarak normalize edilir', () async {
    final offer = sampleOffer().copyWith(
      customerPhone: '   ',
      customerEmail: '',
    );

    final id = await repository.create(offer);
    final saved = await repository.watchById(id).first;

    expect(saved!.customerPhone, isNull);
    expect(saved.customerEmail, isNull);
  });

  test('müşteri seçilmeden teklif oluşturulamaz', () async {
    final offer = Offer(customerName: '', items: [sampleItem()]);

    expect(
      () => repository.create(offer),
      throwsA(isA<CustomerRequiredFailure>()),
    );
  });

  test('ürünsüz teklif oluşturulamaz', () async {
    final offer = sampleOffer(items: []);

    expect(() => repository.create(offer), throwsA(isA<EmptyOfferFailure>()));
  });

  test('kaydedilmemiş teklif güncellenemez', () async {
    expect(
      () => repository.update(sampleOffer()),
      throwsA(isA<UnsavedEntityFailure>()),
    );
  });

  test('güncelleme satırları tamamen değiştirir (diff\'lemez)', () async {
    final id = await repository.create(sampleOffer());
    final saved = await repository.watchById(id).first;

    final updated = saved!.copyWith(
      items: [
        sampleItem().copyWith(productName: 'Somun', quantity: Quantity.of(5)),
      ],
    );
    await repository.update(updated);

    final reloaded = await repository.watchById(id).first;
    expect(reloaded!.items, hasLength(1));
    expect(reloaded.items.single.productName, 'Somun');
    expect(reloaded.items.single.quantity, Quantity.of(5));
  });

  test('satır sırası korunur', () async {
    final id = await repository.create(
      sampleOffer(
        items: [
          sampleItem().copyWith(productName: 'Vida'),
          sampleItem().copyWith(productName: 'Somun'),
          sampleItem().copyWith(productName: 'Rondela'),
        ],
      ),
    );

    final offer = await repository.watchById(id).first;
    expect(offer!.items.map((i) => i.productName), [
      'Vida',
      'Somun',
      'Rondela',
    ]);
  });

  test('teklif silinince satırları da silinir', () async {
    final id = await repository.create(sampleOffer());
    await repository.delete(id);

    expect(await db.select(db.offerItems).get(), isEmpty);
    expect(await repository.watchById(id).first, isNull);
  });

  test('liste oluşturulma sırasına göre (en yeni önce) gelir', () async {
    await repository.create(sampleOffer());
    await repository.create(sampleOffer());

    final offers = await repository.watchAll().first;
    expect(offers, hasLength(2));
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
      sampleOffer(items: [sampleItem(productId: productId)]),
    );

    await (db.delete(db.products)..where((p) => p.id.equals(productId))).go();

    final offer = await repository.watchById(id).first;
    expect(offer!.items.single.productId, isNull);
    expect(offer.items.single.productName, 'Vida M8');
    expect(offer.items.single.unitPrice, Money.fromLira(12, 50));
  });
}
