import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/domain/repositories/category_repository.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_form_screen.dart';

class _FakeProductRepository implements ProductRepository {
  final List<Product> created = [];
  final List<Product> updated = [];
  final List<int> deleted = [];
  Failure? failure;

  @override
  Future<int> create(Product product) async {
    if (failure != null) throw failure!;
    created.add(product);
    return 1;
  }

  @override
  Future<void> update(Product product) async {
    if (failure != null) throw failure!;
    updated.add(product);
  }

  @override
  Future<void> delete(int id) async {
    if (failure != null) throw failure!;
    deleted.add(id);
  }

  @override
  Stream<List<Product>> watchAll({String? query, int? categoryId}) =>
      const Stream.empty();

  @override
  Stream<Product?> watchById(int id) => const Stream.empty();
}

class _FakeCategoryRepository implements CategoryRepository {
  @override
  Stream<List<Category>> watchAll() => Stream.value(const [
    Category(id: 1, name: 'Genel'),
    Category(id: 2, name: 'Hırdavat'),
  ]);

  @override
  Future<int> create(String name) async => 3;

  @override
  Future<void> delete(int id) async {}
}

void main() {
  late _FakeProductRepository products;

  setUp(() => products = _FakeProductRepository());

  Widget buildSubject({Product? product}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      productRepositoryProvider.overrideWithValue(products),
      categoryRepositoryProvider.overrideWithValue(_FakeCategoryRepository()),
    ],
    child: MaterialApp(home: ProductFormScreen(product: product)),
  );

  group('yeni ürün', () {
    testWidgets('boş ad reddedilir, kayıt yapılmaz', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Ürün adı boş olamaz'), findsOneWidget);
      expect(products.created, isEmpty);
    });

    testWidgets('sıfır fiyat reddedilir', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Vida');
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Fiyat sıfırdan büyük olmalı'), findsOneWidget);
      expect(products.created, isEmpty);
    });

    testWidgets('geçerli form ürünü kuruş olarak kaydeder', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Vida M8');
      await tester.enterText(fields.at(1), '1250'); // 12,50 ₺
      await tester.pumpAndSettle();

      // Kategori seç.
      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hırdavat').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(products.created, hasLength(1));
      final saved = products.created.single;
      expect(saved.name, 'Vida M8');
      expect(saved.price.minor, 1250);
      expect(saved.categoryId, 2);
      expect(saved.vatRate, Percent.of(20)); // varsayılan
      expect(saved.id, isNull);
    });
  });

  group('düzenleme', () {
    final existing = Product(
      id: 7,
      name: 'Somun',
      price: Money.fromLira(3, 25),
      categoryId: 1,
      vatRate: Percent.of(10),
    );

    testWidgets('mevcut değerler forma yüklenir', (tester) async {
      await tester.pumpWidget(buildSubject(product: existing));
      await tester.pumpAndSettle();

      expect(find.text('Somun'), findsOneWidget);
      expect(find.text('3,25'), findsOneWidget);
      expect(find.text('Ürünü Düzenle'), findsOneWidget);
    });

    testWidgets('kaydetmek update çağırır, create değil', (tester) async {
      await tester.pumpWidget(buildSubject(product: existing));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Somun M8');
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(products.created, isEmpty);
      expect(products.updated, hasLength(1));
      expect(products.updated.single.id, 7);
      expect(products.updated.single.name, 'Somun M8');
    });

    testWidgets('silme onay ister; vazgeçilirse silinmez', (tester) async {
      await tester.pumpWidget(buildSubject(product: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.textContaining('geri alınamaz'), findsOneWidget);

      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();

      expect(products.deleted, isEmpty);
    });

    testWidgets('onaylanınca ürün silinir', (tester) async {
      await tester.pumpWidget(buildSubject(product: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Sil'));
      await tester.pumpAndSettle();

      expect(products.deleted, [7]);
    });
  });

  group('hata', () {
    testWidgets('kayıt hatası kullanıcıya gösterilir', (tester) async {
      products.failure = const DatabaseFailure('Ürün kaydedilemedi.');

      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Vida');
      await tester.enterText(fields.at(1), '100');
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Genel').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Ürün kaydedilemedi.'), findsOneWidget);
    });
  });
}
