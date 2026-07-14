import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';

/// Miktar kesirli olabilir (12,5 m²) ama para asla `double` değildir: çarpım
/// `Money.scaleBy` üzerinden yapılır ve yuvarlama tek bir yerde olur.
void main() {
  group('Quantity', () {
    test('ondalık değer binde bir olarak tutulur', () {
      expect(Quantity.of(12.5).thousandths, 12500);
      expect(Quantity.of(3).thousandths, 3000);
      expect(Quantity.one.thousandths, 1000);
    });

    test('üçten fazla ondalık basamak yuvarlanır', () {
      expect(Quantity.of(1.23456).thousandths, 1235);
    });

    test('tam sayı miktar ondalıksız biçimlenir', () {
      expect(Quantity.of(3).format(locale: 'tr'), '3');
      expect(Quantity.of(12.5).format(locale: 'tr'), '12,500');
      expect(Quantity.of(12.5).format(locale: 'en'), '12.500');
    });

    test('eşitlik değere göredir', () {
      expect(Quantity.of(2.5), const Quantity.fromThousandths(2500));
      expect(Quantity.of(2.5) == Quantity.of(2.6), isFalse);
    });
  });

  group('OfferItem — kesirli miktar', () {
    test('12,5 m² × 100 ₺ = 1250 ₺ (kuruş kaybı yok)', () {
      final item = OfferItem(
        productName: 'Seramik',
        unitPrice: Money.fromLira(100),
        quantity: Quantity.of(12.5),
        unit: 'm²',
      );

      expect(item.lineSubtotal, Money.fromLira(1250));
    });

    test('kesirli miktar + iskonto + KDV satır bazında hesaplanır', () {
      // 2,5 × 33,33 ₺ = 83,325 → 83,33 ₺ (ticari yuvarlama), %10 iskonto →
      // 74,997 → 75,00 ₺ ; %20 KDV → 15,00 ₺ ; toplam 90,00 ₺
      final item = OfferItem(
        productName: 'Kablo',
        unitPrice: Money.fromLira(33, 33),
        quantity: Quantity.of(2.5),
        unit: 'm',
        discount: Percent.of(10),
        vatRate: Percent.of(20),
      );

      expect(item.lineSubtotal, Money.fromLira(75));
      expect(item.lineVat, Money.fromLira(15));
      expect(item.lineTotal, Money.fromLira(90));
    });

    test('KDV varsayılanı %20, satırda değiştirilebilir', () {
      final item = OfferItem(
        productName: 'Vida',
        unitPrice: Money.fromLira(100),
        quantity: Quantity.one,
      );

      expect(item.vatRate, Percent.of(20));
      expect(item.copyWith(vatRate: Percent.of(1)).lineVat, Money.fromLira(1));
    });

    test('birim varsayılanı adet, hesaba girmez', () {
      final item = OfferItem(
        productName: 'Vida',
        unitPrice: Money.fromLira(10),
        quantity: Quantity.of(2),
      );

      expect(item.unit, 'adet');
      expect(item.copyWith(unit: 'kutu').lineTotal, item.lineTotal);
    });
  });
}
