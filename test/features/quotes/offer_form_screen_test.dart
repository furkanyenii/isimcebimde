import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
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
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/template_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
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

class _FakeOfferRepository implements OfferRepository {
  final List<Offer> created = [];
  final List<Offer> updated = [];
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
  Future<void> delete(int id) async {}

  @override
  Stream<List<Offer>> watchAll() => const Stream.empty();

  @override
  Stream<Offer?> watchById(int id) => const Stream.empty();
}

class _FakeTemplateRepository implements TemplateRepository {
  _FakeTemplateRepository([this._initial = const []]);

  final List<Template> _initial;
  final List<Template> created = [];

  @override
  Future<int> create(Template template) async {
    created.add(template);
    return 1;
  }

  @override
  Future<void> update(Template template) async {}

  @override
  Future<void> delete(int id) async {}

  @override
  Stream<List<Template>> watchAll() => Stream.value(_initial);

  @override
  Stream<Template?> watchById(int id) => const Stream.empty();
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late _FakeOfferRepository offers;
  late _FakeTemplateRepository templates;

  setUp(() {
    offers = _FakeOfferRepository();
    templates = _FakeTemplateRepository();
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
      templateRepositoryProvider.overrideWithValue(templates),
      customerRepositoryProvider.overrideWithValue(_FakeCustomerRepository()),
      productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
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

  testWidgets('teklif şablon olarak kaydedilir', (tester) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await addProduct(tester, 'Vida M8');

    await tester.tap(find.byTooltip(tr.templateSaveAsTooltip));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, tr.templateNameLabel),
      'Standart Hırdavat',
    );
    await tester.tap(find.text(tr.actionAdd));
    await tester.pumpAndSettle();

    expect(templates.created, hasLength(1));
    final saved = templates.created.single;
    expect(saved.name, 'Standart Hırdavat');
    expect(saved.items.single.productName, 'Vida M8');
  });

  testWidgets(
    'şablondan oluşturunca satırlar/para birimi/indirim gelir, müşteriye dokunulmaz',
    (tester) async {
      templates = _FakeTemplateRepository([
        Template(
          id: 1,
          name: 'Standart Hırdavat',
          currency: Currency.usDollar,
          generalDiscount: Percent.of(10),
          items: [
            OfferItem(
              productName: 'Rondela',
              unitPrice: Money.fromLira(2),
              quantity: Quantity.of(50),
              vatRate: Percent.of(20),
            ),
          ],
        ),
      ]);

      await pumpTallSurface(tester, buildSubject());
      await tester.pumpAndSettle();

      await selectCustomer(tester, 'Ahmet Yılmaz');

      await tester.tap(find.byTooltip(tr.templateUseTooltip));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Standart Hırdavat'));
      await tester.pumpAndSettle();

      expect(find.text('Rondela'), findsOneWidget);
      expect(find.text('Ahmet Yılmaz'), findsOneWidget); // müşteri korunur

      await tester.tap(find.text(tr.actionSave));
      await tester.pumpAndSettle();

      final saved = offers.created.single;
      expect(saved.customerId, 1);
      expect(saved.currency, Currency.usDollar);
      expect(saved.generalDiscount, Percent.of(10));
      expect(saved.items.single.productName, 'Rondela');
    },
  );

  testWidgets('yeni teklif olmayan (düzenleme) ekranda şablon butonu yoktur', (
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

    expect(find.byTooltip(tr.templateUseTooltip), findsNothing);
    // Ürün zaten var; "şablon olarak kaydet" düzenlemede de görünür.
    expect(find.byTooltip(tr.templateSaveAsTooltip), findsOneWidget);
  });
}
