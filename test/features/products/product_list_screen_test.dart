import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/domain/repositories/category_repository.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_list_screen.dart';

import '../../support/localized_app.dart';

/// Widget testi ekranı test eder, veritabanını değil.
/// Repository arayüzü sayesinde sahte bir uygulama takmak tek satırdır;
/// gerçek Drift entegrasyonu `product_repository_impl_test.dart` içinde sınanır.
class _FakeProductRepository implements ProductRepository {
  _FakeProductRepository(this._controller);

  final StreamController<List<Product>> _controller;

  @override
  Stream<List<Product>> watchAll({String? query, int? categoryId}) =>
      _controller.stream;

  @override
  Stream<Product?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Product product) async => 1;

  @override
  Future<void> update(Product product) async {}

  @override
  Future<void> delete(int id) async {}
}

/// Ürünler artık kategori altında gruplanır (`productGroups`), bu yüzden
/// kategori repository'si de sahte bir uygulamayla takılır.
class _FakeCategoryRepository implements CategoryRepository {
  @override
  Stream<List<Category>> watchAll() =>
      Stream.value(const [Category(id: 1, name: 'Genel')]);

  @override
  Future<int> create(String name) async => 1;

  @override
  Future<void> delete(int id) async {}
}

void main() {
  // Beklenen metinler ARB'den okunur (bkz. test/support/localized_app.dart).
  final tr = l10nFor(const Locale('tr'));

  late StreamController<List<Product>> controller;

  setUp(() => controller = StreamController<List<Product>>.broadcast());
  tearDown(() => controller.close());

  // main.dart ile aynı retry politikası — test, üretimdeki davranışı sınamalı.
  Widget buildSubject({Locale locale = const Locale('tr')}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      productRepositoryProvider.overrideWithValue(
        _FakeProductRepository(controller),
      ),
      categoryRepositoryProvider.overrideWithValue(_FakeCategoryRepository()),
    ],
    child: localizedApp(const ProductListScreen(), locale: locale),
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
    expect(find.text(tr.productsEmptyTitle), findsOneWidget);
  });

  testWidgets('ürünler gelince listelenir ve fiyat formatlanır', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      Product(
        id: 1,
        name: 'Vida M8',
        price: Money.fromLira(12, 50),
        categoryId: 1,
      ),
    ]);
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsNothing);
    expect(find.text('Vida M8'), findsOneWidget);
    expect(find.textContaining('12,50'), findsOneWidget);
  });

  testWidgets('İngilizce arayüzde fiyat nokta ile biçimlenir', (tester) async {
    await tester.pumpWidget(buildSubject(locale: const Locale('en')));
    controller.add([
      Product(
        id: 1,
        name: 'Screw M8',
        price: Money.fromLira(12, 50),
        categoryId: 1,
      ),
    ]);
    await tester.pumpAndSettle();

    // Para birimi dilden bağımsızdır: biçim değişir, ₺ kalır.
    expect(find.textContaining('12.50'), findsOneWidget);
    expect(find.textContaining('₺'), findsOneWidget);
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
    expect(find.text(tr.actionRetry), findsOneWidget);
  });
}
