import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  Widget buildSubject() => const MaterialApp(home: DashboardScreen());

  testWidgets('dört modül kartı da gösterilir', (tester) async {
    await tester.pumpWidget(buildSubject());

    expect(find.text('Teklifler'), findsOneWidget);
    expect(find.text('Ürünler'), findsOneWidget);
    expect(find.text('Müşteriler'), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
  });

  testWidgets('hazır olmayan modüller "Yakında" olarak işaretlenir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject());

    // Teklifler (Phase 5) ve Ayarlar (Phase 4) henüz yazılmadı;
    // Ürünler ve Müşteriler hazır.
    expect(find.text('Yakında'), findsNWidgets(2));
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
