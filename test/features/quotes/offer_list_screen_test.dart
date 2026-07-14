import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_list_screen.dart';

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
    child: localizedApp(const OfferListScreen()),
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
            quantity: 100,
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
          quantity: 1,
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
}
