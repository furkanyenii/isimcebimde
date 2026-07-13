import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/money_field.dart';

void main() {
  group('MoneyInputFormatter — metin ↔ kuruş', () {
    test('rakamlar doğrudan kuruş olarak okunur', () {
      expect(MoneyInputFormatter.parseMinor('1'), 1);
      expect(MoneyInputFormatter.parseMinor('12'), 12);
      expect(MoneyInputFormatter.parseMinor('1250'), 1250);
    });

    test('rakam dışı karakterler yok sayılır', () {
      expect(MoneyInputFormatter.parseMinor('12,50'), 1250);
      expect(MoneyInputFormatter.parseMinor('1.250,00 ₺'), 125000);
      expect(MoneyInputFormatter.parseMinor(''), 0);
      expect(MoneyInputFormatter.parseMinor('abc'), 0);
    });

    test('kuruş 12,50 biçiminde gösterilir', () {
      expect(MoneyInputFormatter.formatMinor(0), '0,00');
      expect(MoneyInputFormatter.formatMinor(5), '0,05');
      expect(MoneyInputFormatter.formatMinor(1250), '12,50');
      expect(MoneyInputFormatter.formatMinor(125000), '1250,00');
    });

    test('gidiş-dönüş kayıpsızdır (kuruş → metin → kuruş)', () {
      for (final minor in [0, 1, 9, 99, 100, 1250, 999999]) {
        final text = MoneyInputFormatter.formatMinor(minor);
        expect(MoneyInputFormatter.parseMinor(text), minor, reason: text);
      }
    });

    test('formatEditUpdate sağdan sola doldurur', () {
      final formatter = MoneyInputFormatter();
      TextEditingValue apply(String text) => formatter.formatEditUpdate(
        TextEditingValue.empty,
        TextEditingValue(text: text),
      );

      expect(apply('1').text, '0,01');
      expect(apply('12').text, '0,12');
      expect(apply('125').text, '1,25');
      expect(apply('1250').text, '12,50');
    });

    test('imleç her zaman metnin sonundadır', () {
      final result = MoneyInputFormatter().formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '1250'),
      );

      expect(result.selection.baseOffset, result.text.length);
    });
  });

  group('MoneyField — widget', () {
    Future<void> pumpField(
      WidgetTester tester, {
      required Money initialValue,
      required ValueChanged<Money> onChanged,
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoneyField(initialValue: initialValue, onChanged: onChanged),
          ),
        ),
      );
    }

    testWidgets('başlangıç değeri biçimlenmiş gösterilir', (tester) async {
      await pumpField(
        tester,
        initialValue: Money.fromLira(12, 50),
        onChanged: (_) {},
      );

      expect(find.text('12,50'), findsOneWidget);
    });

    testWidgets('kullanıcı rakam yazınca Money üretilir', (tester) async {
      Money? captured;
      await pumpField(
        tester,
        initialValue: Money.zero,
        onChanged: (value) => captured = value,
      );

      await tester.enterText(find.byType(TextFormField), '1250');
      await tester.pump();

      // 12,50 ₺ = 1250 kuruş. Arada hiçbir noktada double'a düşülmez.
      expect(captured, Money.fromLira(12, 50));
      expect(captured!.minor, 1250);
      expect(find.text('12,50'), findsOneWidget);
    });

    testWidgets('kuruş hassasiyeti korunur (0,01)', (tester) async {
      Money? captured;
      await pumpField(
        tester,
        initialValue: Money.zero,
        onChanged: (value) => captured = value,
      );

      await tester.enterText(find.byType(TextFormField), '1');
      await tester.pump();

      expect(captured!.minor, 1);
      expect(find.text('0,01'), findsOneWidget);
    });

    testWidgets('harf girişi tutarı bozmaz', (tester) async {
      Money? captured;
      await pumpField(
        tester,
        initialValue: Money.zero,
        onChanged: (value) => captured = value,
      );

      await tester.enterText(find.byType(TextFormField), 'ab12cd');
      await tester.pump();

      expect(captured!.minor, 12);
    });
  });
}
