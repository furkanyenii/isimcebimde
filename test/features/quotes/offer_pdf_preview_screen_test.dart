import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_pdf_preview_screen.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/repositories/settings_repository.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';

import '../../support/localized_app.dart';

/// Ekran testi veritabanını değil ekranı sınar; repository sahtelenir
/// (CLAUDE.md: Test Rules — settings_screen_test.dart ile aynı desen).
class _FakeSettingsRepository implements SettingsRepository {
  _FakeSettingsRepository(this._controller);

  final StreamController<AppSettings> _controller;

  @override
  Stream<AppSettings> watch() => _controller.stream;

  @override
  Future<void> save(AppSettings settings) async {}
}

void main() {
  final tr = l10nFor(const Locale('tr'));

  late StreamController<AppSettings> stream;
  late _FakeSettingsRepository repository;

  setUp(() {
    stream = StreamController<AppSettings>.broadcast();
    repository = _FakeSettingsRepository(stream);
  });
  tearDown(() => stream.close());

  Offer sampleOffer() => Offer(
    id: 7,
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

  Widget buildSubject() => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [settingsRepositoryProvider.overrideWithValue(repository)],
    child: localizedApp(OfferPdfPreviewScreen(offer: sampleOffer())),
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
    stream.add(const AppSettings(company: CompanyInfo(name: 'Test A.Ş.')));

    // `PdfPreview` PDF'i rasterize etmek için platform kanalı kullanır;
    // testte bu kanal yok. `pumpAndSettle` bu yüzden kullanılmaz — burada
    // sınanan şey render'ın rasterize sonucunu değil, ekranın kurulumunu
    // çökmeden tamamladığıdır.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text(tr.pdfPreviewTitle), findsOneWidget);
  });

  testWidgets('okuma hatasında hata ekranı gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());
    stream.addError(
      const DatabaseFailure(DataOperation.read, EntityKind.settings),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.text(tr.errorSettingsLoad), findsOneWidget);
  });
}
