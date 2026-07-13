import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_list_screen.dart';

/// Widget testi ekranı test eder, veritabanını değil.
/// Repository arayüzü sayesinde sahte bir uygulama takmak tek satırdır;
/// gerçek Drift entegrasyonu `product_repository_impl_test.dart` içinde sınanır.
class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this._controller);

  final StreamController<List<Product>> _controller;

  @override
  Stream<List<Product>> watchAll() => _controller.stream;

  @override
  Future<void> add(Product product) async {}
}

void main() {
  late StreamController<List<Product>> controller;

  setUp(() => controller = StreamController<List<Product>>.broadcast());
  tearDown(() => controller.close());

  // main.dart ile aynı retry politikası — test, üretimdeki davranışı sınamalı.
  Widget buildSubject() => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      productRepositoryProvider.overrideWithValue(
        _FakeProductRepository(controller),
      ),
    ],
    child: const MaterialApp(home: ProductListScreen()),
  );

  testWidgets('veri gelmeden önce loading gösterir', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(AppLoadingView), findsOneWidget);
  });

  testWidgets('ürün yokken empty state gösterir', (tester) async {
    await tester.pumpWidget(buildSubject());
    controller.add(const []);
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('Henüz ürün yok'), findsOneWidget);
  });

  testWidgets('ürünler gelince listelenir ve fiyat formatlanır', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      Product(id: 1, name: 'Vida M8', price: Money.fromLira(12, 50)),
    ]);
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsNothing);
    expect(find.text('Vida M8'), findsOneWidget);
    expect(find.textContaining('12,50'), findsOneWidget);
  });

  testWidgets('hata durumunda error state ve tekrar dene gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.addError(Exception('bozuk'));
    await tester.pumpAndSettle();

    // Retry açık olsaydı state `AsyncLoading(error:)` olarak kalır ve kullanıcı
    // hata yerine sonsuz spinner görürdü. Bu test o gerilemeyi yakalar.
    expect(find.byType(AppLoadingView), findsNothing);
    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text('Tekrar dene'), findsOneWidget);
  });
}
