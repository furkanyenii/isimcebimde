import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_pdf_preview_screen.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/repositories/settings_repository.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';
import 'package:printing/printing.dart';

import '../../support/localized_app.dart';

class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this._controller);

  final StreamController<AppSettings> _controller;

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<void> save(AppSettings settings) async {}
}

/// Bu testlerde yalnızca `watchById` kullanılır; diğer metodlar çağrılmaz.
class _FakeCustomerRepository implements CustomerRepository {
  _FakeCustomerRepository(this._controller);

  final StreamController<Customer?> _controller;

  @override
  Stream<Customer?> watchById(int id) => _controller.stream;

  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) =>
      const Stream.empty();

  @override
  Future<int> create(Customer customer) async => throw UnimplementedError();

  @override
  Future<void> update(Customer customer) async => throw UnimplementedError();

  @override
  Future<void> delete(int id) async => throw UnimplementedError();
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late StreamController<AppSettings> settingsStream;
  late _FakeSettingsRepository settingsRepository;
  late StreamController<Customer?> customerStream;
  late _FakeCustomerRepository customerRepository;

  setUp(() {
    settingsStream = StreamController<AppSettings>.broadcast();
    settingsRepository = _FakeSettingsRepository(settingsStream);
    customerStream = StreamController<Customer?>.broadcast();
    customerRepository = _FakeCustomerRepository(customerStream);
  });
  tearDown(() {
    settingsStream.close();
    customerStream.close();
  });

  Offer sampleOffer({int? customerId}) => Offer(
    id: 7,
    customerId: customerId,
    customerName: 'Ahmet Yılmaz',
    createdAt: DateTime(2026, 1, 10),
    items: [
      OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(12, 50),
        quantity: 10,
        vatRate: Percent.of(20),
      ),
    ],
  );

  Widget buildSubject({Offer? offer}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [
      settingsRepositoryProvider.overrideWithValue(settingsRepository),
      customerRepositoryProvider.overrideWithValue(customerRepository),
    ],
    child: localizedApp(OfferPdfPreviewScreen(offer: offer ?? sampleOffer())),
  );

  testWidgets('ayar okunana kadar loading gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.byType(AppLoadingView), findsOneWidget);
  });

  testWidgets('firma bilgisi geldiğinde çökmeden başlığıyla render olur', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    settingsStream.add(
      const AppSettings(company: CompanyInfo(name: 'Test A.Ş.')),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(tr.pdfPreviewTitle), findsOneWidget);
  });

  testWidgets('okuma hatasında hata ekranı gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());
    settingsStream.addError(
      const DatabaseFailure(DataOperation.read, EntityKind.settings),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);
  });

  testWidgets('müşterinin e-postası paylaşımda alıcı olarak önceden dolar', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(offer: sampleOffer(customerId: 1)));
    settingsStream.add(const AppSettings());
    customerStream.add(
      const Customer(
        id: 1,
        type: CustomerType.individual,
        name: 'Ahmet Yılmaz',
        email: 'ahmet@example.com',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final preview = tester.widget<PdfPreview>(find.byType(PdfPreview));
    expect(preview.shareActionExtraEmails, ['ahmet@example.com']);
    expect(preview.shareActionExtraSubject, 'TKL-2026-000007');
  });

  testWidgets('müşteri seçili değilken paylaşım alıcısız açılır (çökmez)', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(offer: sampleOffer()));
    settingsStream.add(const AppSettings());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final preview = tester.widget<PdfPreview>(find.byType(PdfPreview));
    expect(preview.shareActionExtraEmails, isNull);
  });
}
