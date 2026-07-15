import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/domain/repositories/category_repository.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/template_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/template_form_screen.dart';

import '../../support/localized_app.dart';

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

class _FakeTemplateRepository implements TemplateRepository {
  final List<Template> created = [];
  final List<Template> updated = [];
  final List<int> deleted = [];
  Failure? failure;

  @override
  Future<int> create(Template template) async {
    if (failure != null) throw failure!;
    created.add(template);
    return 1;
  }

  @override
  Future<void> update(Template template) async {
    if (failure != null) throw failure!;
    updated.add(template);
  }

  @override
  Future<void> delete(int id) async {
    if (failure != null) throw failure!;
    deleted.add(id);
  }

  @override
  Stream<List<Template>> watchAll() => const Stream.empty();

  @override
  Stream<Template?> watchById(int id) => const Stream.empty();
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late _FakeTemplateRepository templates;

  setUp(() => templates = _FakeTemplateRepository());

  // Form uzun (ad, para birimi, satırlar, indirim, not, özet); varsayılan test
  // yüzeyi hepsini sığdırmaz (bkz. offer_form_screen_test.dart — aynı gerekçe).
  Future<void> pumpTallSurface(WidgetTester tester, Widget widget) async {
    tester.view.physicalSize = const Size(1200, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(widget);
  }

  Widget buildSubject({Template? template}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      templateRepositoryProvider.overrideWithValue(templates),
      productRepositoryProvider.overrideWithValue(_FakeProductRepository()),
      categoryRepositoryProvider.overrideWithValue(_FakeCategoryRepository()),
    ],
    child: localizedApp(TemplateFormScreen(template: template)),
  );

  Future<void> addProduct(WidgetTester tester, String name) async {
    await tester.tap(find.text(tr.productAdd));
    await tester.pumpAndSettle();
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  testWidgets('ad girilmeden ve ürün eklenmeden Kaydet pasiftir', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('ad girilir, ürün eklenir, kaydet aktif olur ve kaydeder', (
    tester,
  ) async {
    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, tr.templateNameLabel),
      'Standart Hırdavat',
    );
    await addProduct(tester, 'Vida M8');
    await tester.pumpAndSettle();

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNotNull);

    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(templates.created, hasLength(1));
    final saved = templates.created.single;
    expect(saved.name, 'Standart Hırdavat');
    expect(saved.items.single.productName, 'Vida M8');
  });

  testWidgets('mevcut şablon düzenlenirken değerler forma yüklenir', (
    tester,
  ) async {
    final existing = Template(
      id: 7,
      name: 'Standart Hırdavat',
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

    await pumpTallSurface(tester, buildSubject(template: existing));
    await tester.pumpAndSettle();

    expect(find.text(tr.templateEdit), findsOneWidget);
    expect(find.text('Standart Hırdavat'), findsOneWidget);
    expect(find.text('Vida M8'), findsOneWidget);
  });

  testWidgets('düzenlenen şablonu kaydetmek update çağırır, create değil', (
    tester,
  ) async {
    final existing = Template(
      id: 7,
      name: 'Standart Hırdavat',
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

    await pumpTallSurface(tester, buildSubject(template: existing));
    await tester.pumpAndSettle();

    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(templates.created, isEmpty);
    expect(templates.updated, hasLength(1));
    expect(templates.updated.single.id, 7);
  });

  testWidgets('silme onay ister; onaylanınca şablon silinir', (tester) async {
    final existing = Template(
      id: 7,
      name: 'Standart Hırdavat',
      items: [
        OfferItem(
          productName: 'Vida M8',
          unitPrice: Money.fromLira(12, 50),
          quantity: Quantity.of(1),
          vatRate: Percent.of(20),
        ),
      ],
    );

    await pumpTallSurface(tester, buildSubject(template: existing));
    await tester.pumpAndSettle();

    // AppBar'daki silme aksiyonu: satır silme butonuyla aynı ikonu/tooltip'i
    // paylaşıyor (OfferItemRow), bu yüzden AppBar'a scope'lanır.
    await tester.tap(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.byIcon(Icons.delete_outline),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('geri alınamaz'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, tr.actionDelete));
    await tester.pumpAndSettle();

    expect(templates.deleted, [7]);
  });

  testWidgets('kayıt hatası kullanıcıya gösterilir', (tester) async {
    templates.failure = const DuplicateTemplateNameFailure('Standart');

    await pumpTallSurface(tester, buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, tr.templateNameLabel),
      'Standart',
    );
    await addProduct(tester, 'Vida M8');

    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    expect(find.text(tr.errorTemplateDuplicate('Standart')), findsOneWidget);
  });
}
