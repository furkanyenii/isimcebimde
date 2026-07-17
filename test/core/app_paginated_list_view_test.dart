import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/widgets/app_paginated_list_view.dart';

import '../support/localized_app.dart';

void main() {
  Widget subject(List<int> items) => localizedApp(
    Scaffold(
      body: AppPaginatedListView<int>(
        items: items,
        pageBuilder: (context, pageItems) =>
            ListView(children: [for (final i in pageItems) Text('item $i')]),
      ),
    ),
  );

  testWidgets('15 veya daha az kayıtta sayfalama çubuğu gösterilmez', (
    tester,
  ) async {
    await tester.pumpWidget(subject(List.generate(15, (i) => i)));
    await tester.pumpAndSettle();

    expect(find.text('item 0'), findsOneWidget);
    expect(find.text('item 14'), findsOneWidget);
    // Sayfa "2" düğmesi yoksa çubuk da yok.
    expect(find.text('2'), findsNothing);
  });

  testWidgets('15 üstünde ilk sayfa ilk 15 kaydı ve çubuğu gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(subject(List.generate(20, (i) => i)));
    await tester.pumpAndSettle();

    expect(find.text('item 0'), findsOneWidget);
    expect(find.text('item 14'), findsOneWidget);
    // 16. kayıt ikinci sayfaya taşar.
    expect(find.text('item 15'), findsNothing);
    // Sayfalama çubuğu görünür.
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('sayfa numarasına dokununca o sayfanın kayıtları gelir', (
    tester,
  ) async {
    await tester.pumpWidget(subject(List.generate(20, (i) => i)));
    await tester.pumpAndSettle();

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    // İkinci sayfa 15..19 kayıtlarını gösterir.
    expect(find.text('item 15'), findsOneWidget);
    expect(find.text('item 19'), findsOneWidget);
    expect(find.text('item 0'), findsNothing);
  });
}
