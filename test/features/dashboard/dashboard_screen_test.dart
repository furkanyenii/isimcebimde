import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';

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

class _FakeCustomerRepository implements CustomerRepository {
  _FakeCustomerRepository(this._controller);

  final StreamController<List<Customer>> _controller;

  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) =>
      _controller.stream;

  @override
  Stream<Customer?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Customer customer) async => 1;

  @override
  Future<void> update(Customer customer) async {}

  @override
  Future<void> delete(int id) async {}
}

void main() {
  // Beklenen metinler ARB'den okunur (bkz. test/support/localized_app.dart).
  final tr = l10nFor(const Locale('tr'));

  late StreamController<List<Offer>> controller;
  late StreamController<List<Customer>> customerController;

  setUp(() {
    controller = StreamController<List<Offer>>.broadcast();
    customerController = StreamController<List<Customer>>.broadcast();
  });
  tearDown(() {
    controller.close();
    customerController.close();
  });

  Widget buildSubject() => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      offerRepositoryProvider.overrideWithValue(
        _FakeOfferRepository(controller),
      ),
      customerRepositoryProvider.overrideWithValue(
        _FakeCustomerRepository(customerController),
      ),
    ],
    child: localizedApp(const DashboardScreen()),
  );

  /// Dört modül satırı bir ekrana sığmıyor; testler tam boy bir telefon
  /// yüzeyinde koşar, aksi halde alttaki satır hiç build edilmez.
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('dört modül satırı da gösterilir', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text(tr.moduleQuotes), findsOneWidget);
    expect(find.text(tr.moduleProducts), findsOneWidget);
    expect(find.text(tr.moduleCustomers), findsOneWidget);
    expect(find.text(tr.moduleSettings), findsOneWidget);
  });

  testWidgets('teklif yüklenmeden özet rakamları yerine "—" gösterilir', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    // Özet, ekranın birincil içeriği değil: veri yokken modüller yine çalışır,
    // spinner veya hata ekranı gösterilmez.
    expect(find.text('—'), findsNWidgets(2));
    expect(find.text(tr.moduleQuotes), findsOneWidget);
  });

  testWidgets('teklif ve müşteri sayıları özetlenir', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    controller.add([
      Offer(id: 1, customerName: 'Yılmaz İnşaat'),
      Offer(id: 2, customerName: 'Acme Ltd.'),
    ]);
    customerController.add(const [
      Customer(id: 1, name: 'Yılmaz İnşaat', type: CustomerType.company),
    ]);
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget); // teklif adedi
    expect(find.text('1'), findsOneWidget); // müşteri adedi
  });

  testWidgets('teklif sayısına dokununca yeni teklif formu açılır', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    controller.add([Offer(id: 1, customerName: 'Yılmaz İnşaat')]);
    customerController.add(const []);
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.dashboardStatQuotes));
    await tester.pumpAndSettle();

    expect(find.text(tr.quoteNew), findsOneWidget); // AppBar başlığı
  });

  testWidgets('müşteri sayısına dokununca yeni müşteri formu açılır', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    controller.add(const []);
    customerController.add(const []);
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.dashboardStatCustomers));
    await tester.pumpAndSettle();

    expect(find.text(tr.customerNew), findsOneWidget); // AppBar başlığı
  });

  testWidgets('geniş ekranda içerik sınırlı genişlikte ortalanır', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(
      tester.getSize(find.byType(ListView)).width,
      AppSizes.maxContentWidth,
    );
  });
}
