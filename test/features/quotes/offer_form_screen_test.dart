import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/domain/repositories/category_repository.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/quantity_field.dart';

import '../../support/localized_app.dart';

class _FakeCustomerRepository implements CustomerRepository {
  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) =>
      Stream.value(const [
        Customer(id: 1, type: CustomerType.individual, name: 'Ahmet Yılmaz'),
        Customer(id: 2, type: CustomerType.company, name: 'Yılmaz İnşaat'),
      ]);

  @override
  Stream<Customer?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Customer customer) async => 3;

  @override
  Future<void> update(Customer customer) async {}

  @override
  Future<void> delete(int id) async {}
}

class _FakeProductRepository implements ProductRepository {
  @override
  Stream<List<Product>> watchAll({String? query, int? categoryId}) =>
      Stream.value([
        Product(
          id: 1,
          name: 'Vida M8',
          price: Money.fromLira(12, 50),
          categoryId: 1,
        ),
      ]);

  @override
  Stream<Product?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Product product) async => 1;

  @override
  Future<void> update(Product product) async {}

  @override
  Future<void> delete(int id) async {}
}

/// Ürün seçici artık ürünleri kategori altında gruplar (`productGroups`),
/// bu yüzden kategori repository'si de sahte bir uygulamayla takılır.
class _FakeCategoryRepository implements CategoryRepository {
  @override
  Stream<List<Category>> watchAll() =>
      Stream.value(const [Category(id: 1, name: 'Genel')]);

  @override
  Future<int> create(String name) async => 1;

  @override
  Future<void> delete(int id) async {}
}

class _FakeOfferRepository implements OfferRepository {
  final List<Offer> created = [];
  final List<Offer> updated = [];
  final List<int> deleted = [];
  Failure? failure;

  @override
  Future<int> create(Offer offer) async {
    if (failure != null) throw failure!;
    created.add(offer);
    return 1;
  }

  @override
  Future<void> update(Offer offer) async {
    if (failure != null) throw failure!;
    updated.add(offer);
  }

  @override
  Future<void> delete(int id) async {
    if (failure != null) throw failure!;
    deleted.add(id);
  }

  @override
  Stream<List<Offer>> watchAll() => const Stream.empty();

  @override
  Stream<Offer?> watchById(int id) => const Stream.empty();
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late _FakeOfferRepository offers;

  setUp(() {
    offers = _FakeOfferRepository();
  });

  // Form uzun (müşteri, para birimi, satırlar, indirim, not, özet); varsayılan
  // test yüzeyi hepsini sığdırmaz. Kaydırma mekaniğiyle uğraşmak yerine
  // yüzeyi forma yetecek kadar büyütüyoruz — CustomerPicker/ProductPicker'ın
  // açtığı bottom sheet'ler de bu büyük yüzeyde sorunsuz çalışır.
  Future<void> pumpTallSurface(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(widget);
  }

  Widget buildSubject({Offer? offer}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      offerRepositoryProvider.overrideWithValue(offers),
      customerRepositoryProvider.overrideWithValue(_FakeCustomerRepository()),
      productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      categoryRepositoryProvider.overrideWithValue(_FakeCategoryRepository()),
    ],
    child: localizedApp(OfferFormScreen(offer: offer)),
  );

  Future<void> selectCustomer(WidgetTester tester, String name) async {
    await tester.tap(find.text(tr.customerFieldLabel));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  Future<void> addProduct(WidgetTester tester, String name) async {
    await tester.tap(find.text(tr.productAdd));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  testWidgets('müşteri seçilmeden ve ürün eklenmeden Kaydet pasiftir', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets(
    'müşteri seçilir, ürün eklenir, kaydet aktif olur ve kuruş olarak kaydeder',
    (tester) async {
      await pumpTallSurface(tester, buildSubject());
      await tester.pumpAndSettle();

      await selectCustomer(tester, 'Ahmet Yılmaz');
      await addProduct(tester, 'Vida M8');

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNotNull);

      await tester.tap(find.text(tr.actionSave));
      await tester.pumpAndSettle();

      expect(offers.created, hasLength(1));
      final saved = offers.created.single;
      expect(saved.customerId, 1);
      expect(saved.customerName, 'Ahmet Yılmaz');
      expect(saved.items.single.productName, 'Vida M8');
      expect(saved.items.single.unitPrice.minor, 1250);
      expect(saved.items.single.quantity, Quantity.of(1));
    },
  );

  testWidgets('miktar yazarken satır state\'i (ve odak) korunur', (
    tester,
  ) async {
    // Regresyon: satır anahtarı `item.hashCode`'dan türetiliyordu; her rakamda
    // anahtar değişince Flutter satırı yeni sanıp state'ini atıyor, klavye
    // her basamakta kapanıyordu. Aynı satır = aynı state olmalı.
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await selectCustomer(tester, 'Ahmet Yılmaz');
    await addProduct(tester, 'Vida M8');

    final quantityField = find.widgetWithText(TextFormField, tr.quantityLabel);
    final stateBefore = tester.state(find.byType(QuantityField));

    await tester.enterText(quantityField, '1');
    await tester.pump();
    await tester.enterText(quantityField, '12');
    await tester.pump();

    expect(
      tester.state(find.byType(QuantityField)),
      same(stateBefore),
      reason: 'Satır state\'i her tuş vuruşunda yeniden kurulmamalı',
    );

    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();
    expect(offers.created.single.items.single.quantity, Quantity.of(12));
  });

  testWidgets('ürün eklenince ara toplam ve genel toplam güncellenir', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await addProduct(tester, 'Vida M8');

    // 12,50 ₺ x 1 = 12,50 ₺ ara toplam, %20 KDV ile 15,00 ₺ genel toplam.
    expect(find.textContaining('12,50'), findsWidgets);
    expect(find.textContaining('15,00'), findsWidgets);
  });

  testWidgets('mevcut teklif düzenlenirken değerler forma yüklenir', (
    tester,
  ) async {
    final existing = Offer(
      id: 7,
      customerId: 2,
      customerName: 'Yılmaz İnşaat',
      currency: Currency.usDollar,
      items: [
        OfferItem(
          productId: 1,
          productName: 'Vida M8',
          unitPrice: Money.fromLira(12, 50),
          quantity: Quantity.of(10),
          vatRate: Percent.of(20),
        ),
      ],
    );

    await pumpTallSurface(tester, buildSubject(offer: existing));
    await tester.pumpAndSettle();

    expect(find.text(tr.offerEdit), findsOneWidget);
    expect(find.text('Yılmaz İnşaat'), findsOneWidget);
    expect(find.text('Vida M8'), findsOneWidget);
  });

  testWidgets('düzenlenen teklifi kaydetmek update çağırır, create değil', (
    tester,
  ) async {
    final existing = Offer(
      id: 7,
      customerId: 2,
      customerName: 'Yılmaz İnşaat',
      items: [
        OfferItem(
          productId: 1,
          productName: 'Vida M8',
          unitPrice: Money.fromLira(12, 50),
          quantity: Quantity.of(10),
          vatRate: Percent.of(20),
        ),
      ],
    );

    await pumpTallSurface(tester, buildSubject(offer: existing));
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(offers.created, isEmpty);
    expect(offers.updated, hasLength(1));
    expect(offers.updated.single.id, 7);
  });

  testWidgets('yeni teklifte silme butonu görünmez', (tester) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete_outline), findsNothing);
  });

  testWidgets('düzenlenen teklif onaylanınca silinir', (tester) async {
    final existing = Offer(
      id: 7,
      customerId: 2,
      customerName: 'Yılmaz İnşaat',
      items: [
        OfferItem(
          productName: 'Vida M8',
          unitPrice: Money.fromLira(12, 50),
          quantity: Quantity.of(1),
          vatRate: Percent.of(20),
        ),
      ],
    );

    await pumpTallSurface(tester, buildSubject(offer: existing));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.delete_outline),
      ),
    );
    await tester.pumpAndSettle();

    // Onay dialogu çıkar; onaylanınca repository.delete çağrılır.
    expect(find.text(tr.quoteDelete), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, tr.actionDelete));
    await tester.pumpAndSettle();

    expect(offers.deleted, [7]);
  });

  testWidgets('silme onaylanmazsa teklif silinmez', (tester) async {
    final existing = Offer(
      id: 7,
      customerId: 2,
      customerName: 'Yılmaz İnşaat',
      items: [
        OfferItem(
          productName: 'Vida M8',
          unitPrice: Money.fromLira(12, 50),
          quantity: Quantity.of(1),
          vatRate: Percent.of(20),
        ),
      ],
    );

    await pumpTallSurface(tester, buildSubject(offer: existing));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.delete_outline),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, tr.actionCancel));
    await tester.pumpAndSettle();

    expect(offers.deleted, isEmpty);
  });

  testWidgets('kayıt hatası kullanıcıya gösterilir', (tester) async {
    offers.failure = const CustomerRequiredFailure();

    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await selectCustomer(tester, 'Ahmet Yılmaz');
    await addProduct(tester, 'Vida M8');

    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(find.text(tr.errorOfferCustomerRequired), findsOneWidget);
  });

  testWidgets('PDF butonu satır eklenince görünür, kaydetmek gerekmez', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    // Yeni (kaydedilmemiş) teklif: satır yokken PDF üretmek anlamsız.
    expect(find.text(tr.pdfAction), findsNothing);

    await addProduct(tester, 'Vida M8');

    // Kaydetmeden, sadece satır eklenerek PDF butonu erişilebilir olur.
    expect(find.text(tr.pdfAction), findsOneWidget);
  });
}
