import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/template_repository.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/template_form_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/template_list_screen.dart';

import '../../support/localized_app.dart';

/// Widget testi ekranı test eder, veritabanını değil (CLAUDE.md: Test Rules).
class _FakeTemplateRepository implements TemplateRepository {
  _FakeTemplateRepository(this._controller);

  final StreamController<List<Template>> _controller;

  @override
  Stream<List<Template>> watchAll() => _controller.stream;

  @override
  Stream<Template?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Template template) async => 1;

  @override
  Future<void> update(Template template) async {}

  @override
  Future<void> delete(int id) async {}
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late StreamController<List<Template>> controller;

  setUp(() => controller = StreamController<List<Template>>.broadcast());
  tearDown(() => controller.close());

  Widget buildSubject() => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      templateRepositoryProvider.overrideWithValue(
        _FakeTemplateRepository(controller),
      ),
    ],
    child: localizedApp(const TemplateListScreen()),
  );

  testWidgets('veri gelmeden önce loading gösterir', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(AppLoadingView), findsOneWidget);
  });

  testWidgets('şablon yokken empty state ve yönlendirici eylem gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    controller.add(const []);
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text(tr.templatesEmptyTitle), findsOneWidget);

    await tester.tap(find.text(tr.templateNew).last);
    await tester.pumpAndSettle();

    expect(find.byType(TemplateFormScreen), findsOneWidget);
  });

  testWidgets('şablonlar gelince ad ve ürün sayısı listelenir', (tester) async {
    await tester.pumpWidget(buildSubject());
    controller.add([
      Template(
        id: 1,
        name: 'Standart Hırdavat',
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
    expect(find.text('Standart Hırdavat'), findsOneWidget);
    expect(find.text('1 ürün'), findsOneWidget);
  });

  testWidgets('şablona dokununca düzenleme formu açılır', (tester) async {
    final template = Template(
      id: 1,
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
    await tester.pumpWidget(buildSubject());
    controller.add([template]);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Standart Hırdavat'));
    await tester.pumpAndSettle();

    expect(find.byType(TemplateFormScreen), findsOneWidget);
    expect(find.text(tr.templateEdit), findsOneWidget);
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
