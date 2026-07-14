import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
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

void main() {
  // Beklenen metinler ARB'den okunur (bkz. test/support/localized_app.dart).
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

  testWidgets('teklifler gelince adet ve toplam tutar özetlenir', (
    tester,
  ) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    controller.add([
      Offer(
        id: 1,
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

    expect(find.text('1'), findsOneWidget); // teklif adedi
    // 1250 ₺ (ara toplam) + %20 KDV = 1500 ₺. Sembolsüz biçimlenir: toplam
    // farklı para birimlerindeki teklifleri kapsayabilir.
    expect(find.textContaining('1.500,00'), findsOneWidget);
  });

  testWidgets('Yeni Teklif butonu teklif formunu açar', (tester) async {
    useTallSurface(tester);
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text(tr.quoteNew), findsOneWidget); // AppBar başlığı
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
