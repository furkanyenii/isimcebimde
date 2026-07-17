import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_list_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_customer_filter_field.dart';

import '../../support/fake_template_repository.dart';
import '../../support/localized_app.dart';

/// Widget testi ekranı test eder, veritabanını değil (CLAUDE.md: Test Rules).
class _FakeOfferRepository implements OfferRepository {
  _FakeOfferRepository(this._controller);

  final StreamController<List<Offer>> _controller;

  @override
  Stream<List<Offer>> watchAll() => _controller.stream;

  @override
  Stream<Offer?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Offer offer) async => 1;

  @override
  Future<void> update(Offer offer) async {}

  @override
  Future<void> delete(int id) async {}
}

/// Müşteri filtresi bu ekranın parçası olduğundan, widget testi gerçek
/// veritabanını açmasın diye müşteri repository'si de sahtelenir.
class _FakeCustomerRepository implements CustomerRepository {
  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) =>
      Stream.value(const [
        Customer(id: 1, type: CustomerType.individual, name: 'Ahmet Yılmaz'),
        Customer(id: 2, type: CustomerType.company, name: 'Beta İnşaat'),
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

void main() {
  final tr = l10nFor(const Locale('tr'));

  late StreamController<List<Offer>> controller;

  setUp(() => controller = StreamController<List<Offer>>.broadcast());
  tearDown(() => controller.close());

  Widget buildSubject() => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      offerRepositoryProvider.overrideWithValue(
        _FakeOfferRepository(controller),
      ),
      customerRepositoryProvider.overrideWithValue(_FakeCustomerRepository()),
      // Şablonsuz: FAB doğrudan forma gitsin, bu ekranın testi şablon seçimine
      // bulaşmasın. O seçim offer_start_picker_test.dart'ta sınanır.
      templateRepositoryProvider.overrideWithValue(
        const FakeTemplateRepository(),
      ),
    ],
    child: localizedApp(const OfferListScreen()),
  );

  Offer offerFor({
    required int id,
    required int customerId,
    required String customerName,
  }) => Offer(
    id: id,
    customerId: customerId,
    customerName: customerName,
    items: [
      OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(10, 0),
        quantity: Quantity.of(1),
        vatRate: Percent.of(20),
      ),
    ],
  );

  testWidgets('veri gelmeden önce loading gösterir', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(AppLoadingView), findsOneWidget);
  });

  testWidgets('teklif yokken empty state ve yönlendirici eylem gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.add(const []);
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(tr.quotesEmptyTitle), findsOneWidget);

    await tester.tap(find.text(tr.quoteNew).last);
    await tester.pumpAndSettle();

    expect(find.byType(OfferFormScreen), findsOneWidget);
  });

  testWidgets('teklifler gelince müşteri adı ve genel toplam listelenir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      Offer(
        id: 1,
        customerId: 1,
        customerName: 'Yılmaz İnşaat',
        items: [
          OfferItem(
            productName: 'Vida M8',
            unitPrice: Money.fromLira(12, 50),
            quantity: Quantity.of(100),
            vatRate: Percent.of(20),
          ),
        ],
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsNothing);
    expect(find.text('Yılmaz İnşaat'), findsOneWidget);
    // 1250 ₺ (ara toplam) + %20 KDV = 1500 ₺.
    expect(find.textContaining('1.500,00'), findsOneWidget);
  });

  testWidgets('teklife dokununca düzenleme formu açılır', (tester) async {
    final offer = Offer(
      id: 1,
      customerId: 1,
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
    await tester.pumpWidget(buildSubject());
    controller.add([offer]);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Yılmaz İnşaat'));
    await tester.pumpAndSettle();

    expect(find.byType(OfferFormScreen), findsOneWidget);
    expect(find.text(tr.offerEdit), findsOneWidget);
  });

  testWidgets('hata durumunda error state ve tekrar dene gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.addError(Exception('bozuk'));
    await tester.pumpAndSettle();

    expect(find.byType(AppLoadingView), findsNothing);
    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text(tr.actionRetry), findsOneWidget);
  });

  testWidgets('hiç teklif yokken müşteri filtresi gösterilmez', (tester) async {
    await tester.pumpWidget(buildSubject());
    controller.add(const []);
    await tester.pumpAndSettle();

    // Filtresiz boş ekran: yalnızca yönlendirici empty state, filtre yok.
    expect(find.byType(OfferCustomerFilterField), findsNothing);
  });

  testWidgets('teklif varken müşteri filtresi gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      offerFor(id: 1, customerId: 1, customerName: 'Ahmet Yılmaz'),
    ]);
    await tester.pumpAndSettle();

    expect(find.byType(OfferCustomerFilterField), findsOneWidget);
  });

  testWidgets('filtre alanına dokununca aramalı müşteri sheet\'i açılır', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      offerFor(id: 1, customerId: 1, customerName: 'Ahmet Yılmaz'),
    ]);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OfferCustomerFilterField));
    await tester.pumpAndSettle();

    // Sheet: "Tüm müşteriler" (temizle) satırı + müşteri listesi görünür.
    expect(find.text(tr.quotesFilterAll), findsOneWidget);
    // Beta yalnızca sheet'te var (teklif kartı yok), bu yüzden tek eşleşme.
    expect(find.text('Beta İnşaat'), findsOneWidget);
  });

  testWidgets('müşteri seçilince liste o müşteriye daralır', (tester) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      offerFor(id: 1, customerId: 1, customerName: 'Ahmet Yılmaz'),
      offerFor(id: 2, customerId: 2, customerName: 'Beta İnşaat'),
    ]);
    await tester.pumpAndSettle();

    // Filtre yokken iki teklif de listelenir.
    expect(find.text('Ahmet Yılmaz'), findsOneWidget);
    expect(find.text('Beta İnşaat'), findsOneWidget);

    // Filtreyi 2. müşteriye (Beta) ayarla. Bottom sheet etkileşimini sürmek
    // yerine state→UI zincirini doğrudan provider üzerinden test ediyoruz;
    // filtre alanının varlığı ve sheet açılışı ayrı yerde kanıtlanıyor.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(OfferListScreen)),
    );
    container.read(offerCustomerFilterProvider.notifier).select(2);
    await tester.pump();
    await tester.pump();

    // Yalnızca seçilen müşterinin teklifi kalır: Ahmet'in kartı gider.
    expect(find.text('Ahmet Yılmaz'), findsNothing);
    expect(find.text('Beta İnşaat'), findsWidgets);
  });
}
