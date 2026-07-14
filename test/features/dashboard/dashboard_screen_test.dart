import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/features/dashboard/presentation/screens/dashboard_screen.dart';

import '../../support/localized_app.dart';

void main() {
  // Beklenen metinler ARB'den okunur (bkz. test/support/localized_app.dart).
  final tr = l10nFor(const Locale('tr'));

  Widget buildSubject() => localizedApp(const DashboardScreen());

  testWidgets('dört modül kartı da gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text(tr.moduleQuotes), findsOneWidget);
    expect(find.text(tr.moduleProducts), findsOneWidget);
    expect(find.text(tr.moduleCustomers), findsOneWidget);
    expect(find.text(tr.moduleSettings), findsOneWidget);
  });

  testWidgets('hazır olmayan modüller "Yakında" olarak işaretlenir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    // Yalnızca Teklifler (Phase 5) henüz yazılmadı;
    // Ürünler, Müşteriler ve Ayarlar hazır.
    expect(find.text(tr.comingSoon), findsOneWidget);
  });

  testWidgets('teklif modülü hazır olmadığı için Yeni Teklif butonu pasiftir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('dar ekranda 2, geniş ekranda 4 sütun gösterir', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(buildSubject());
    expect(
      tester.widget<GridView>(find.byType(GridView)).gridDelegate,
      isA<SliverGridDelegateWithFixedCrossAxisCount>().having(
        (d) => d.crossAxisCount,
        'crossAxisCount',
        2,
      ),
    );

    tester.view.physicalSize = const Size(900, 800);
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(
      tester.widget<GridView>(find.byType(GridView)).gridDelegate,
      isA<SliverGridDelegateWithFixedCrossAxisCount>().having(
        (d) => d.crossAxisCount,
        'crossAxisCount',
        4,
      ),
    );
  });
}
