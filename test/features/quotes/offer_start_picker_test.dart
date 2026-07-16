import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_list_screen.dart';

import '../../support/fake_template_repository.dart';
import '../../support/localized_app.dart';

/// Şablondan teklife geçiş akışı, gerçek giriş noktasından (teklif listesinin
/// FAB'ı) sınanır: `openNewOfferFlow` ayrı bir ekran değil, o dokunuşun
/// davranışıdır.

class _FakeOfferRepository implements OfferRepository {
  @override
  Stream<List<Offer>> watchAll() => Stream.value(const []);

  @override
  Stream<Offer?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Offer offer) async => 1;

  @override
  Future<void> update(Offer offer) async {}

  @override
  Future<void> delete(int id) async {}
}

class _FakeCustomerRepository implements CustomerRepository {
  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) =>
      Stream.value(const [
        Customer(id: 1, type: CustomerType.individual, name: 'Ahmet Yılmaz'),
      ]);

  @override
  Stream<Customer?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Customer customer) async => 1;

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

class _FakeCategoryRepository implements CategoryRepository {
  @override
  Stream<List<Category>> watchAll() =>
      Stream.value(const [Category(id: 1, name: 'Genel')]);

  @override
  Future<int> create(String name) async => 1;

  @override
  Future<void> delete(int id) async {}
}

Template _template(String name) => Template(
  id: 1,
  name: name,
  items: [
    OfferItem(
      productName: 'Vida M8',
      unitPrice: Money.fromLira(12, 50),
      quantity: Quantity.of(100),
      vatRate: Percent.of(20),
    ),
  ],
);

void main() {
  final tr = l10nFor(const Locale('tr'));

  // Sheet ve teklif formu birlikte varsayılan test yüzeyine sığmaz
  // (OfferFormScreenTest ile aynı gerekçe).
  Future<void> pumpTallSurface(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(widget);
  }

  Widget buildSubject({
    List<Template> templates = const [],
    bool templatesFail = false,
  }) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      templateRepositoryProvider.overrideWithValue(
        FakeTemplateRepository(templates: templates, fails: templatesFail),
      ),
      offerRepositoryProvider.overrideWithValue(_FakeOfferRepository()),
      customerRepositoryProvider.overrideWithValue(_FakeCustomerRepository()),
      productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      categoryRepositoryProvider.overrideWithValue(_FakeCategoryRepository()),
    ],
    child: localizedApp(const OfferListScreen()),
  );

  Future<void> tapNewOffer(WidgetTester tester) async {
    await tester.tap(find.text(tr.quoteNew).last);
    await tester.pumpAndSettle();
  }

  /// Sheet açık mı? Kart başlığı ("Yeni teklif") teklif formunun AppBar
  /// başlığından ("Yeni Teklif") yalnızca bir harfin büyüklüğüyle ayrılıyor;
  /// sheet'in varlığı bu farka bel bağlamasın diye benzersiz olan alt satırdan
  /// okunur.
  final startSheet = find.text(tr.offerStartBlankSubtitle);

  testWidgets('şablon yokken seçim sorulmaz, doğrudan boş form açılır', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await tapNewOffer(tester);

    expect(startSheet, findsNothing);
    expect(find.byType(OfferFormScreen), findsOneWidget);
  });

  testWidgets('şablon varken boş teklif ve şablonlar seçenek olarak sunulur', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject(templates: [_template('Ofis')]));
    await tester.pumpAndSettle();

    await tapNewOffer(tester);

    expect(find.byType(OfferFormScreen), findsNothing);
    expect(startSheet, findsOneWidget);
    expect(find.text('Ofis'), findsOneWidget);
    expect(find.text(tr.quoteItemCount(1)), findsOneWidget);
  });

  testWidgets('şablon seçilince form onun satırlarıyla dolu açılır', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject(templates: [_template('Ofis')]));
    await tester.pumpAndSettle();

    await tapNewOffer(tester);
    await tester.tap(find.text('Ofis'));
    await tester.pumpAndSettle();

    expect(find.byType(OfferFormScreen), findsOneWidget);
    expect(find.text('Vida M8'), findsOneWidget);
    // Taslak kaydedilmemiştir (id == null): düzenleme değil, yeni tekliftir.
    expect(find.text(tr.quoteNew), findsOneWidget);
    expect(find.text(tr.offerEdit), findsNothing);
  });

  testWidgets('boş teklif seçilince form satırsız açılır', (tester) async {
    await pumpTallSurface(tester, buildSubject(templates: [_template('Ofis')]));
    await tester.pumpAndSettle();

    await tapNewOffer(tester);
    await tester.tap(startSheet);
    await tester.pumpAndSettle();

    expect(find.byType(OfferFormScreen), findsOneWidget);
    expect(find.text('Vida M8'), findsNothing);
  });

  testWidgets('sheet kapatılırsa form açılmaz', (tester) async {
    await pumpTallSurface(tester, buildSubject(templates: [_template('Ofis')]));
    await tester.pumpAndSettle();

    await tapNewOffer(tester);
    // Sheet dışına dokunmak akışı iptal eder.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(find.byType(OfferFormScreen), findsNothing);
    expect(startSheet, findsNothing);
  });

  testWidgets('şablonlar okunamazsa teklif akışı durmaz, boş form açılır', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject(templatesFail: true));
    await tester.pumpAndSettle();

    await tapNewOffer(tester);

    expect(find.byType(OfferFormScreen), findsOneWidget);
  });
}
