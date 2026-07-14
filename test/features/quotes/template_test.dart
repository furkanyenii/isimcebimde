import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';

void main() {
  group('Template — varsayılanlar', () {
    test('para birimi Türk Lirası, genel indirim sıfırdır', () {
      const template = Template(name: 'Standart');

      expect(template.currency, Currency.turkishLira);
      expect(template.generalDiscount, Percent.zero);
      expect(template.items, isEmpty);
    });
  });

  group('Template — copyWith', () {
    test('null geçilen alanı korur, verilen alanı değiştirir', () {
      const template = Template(name: 'Standart', notes: 'Not');
      final updated = template.copyWith(name: 'Yeni Ad');

      expect(updated.name, 'Yeni Ad');
      expect(updated.notes, 'Not'); // dokunulmadı
    });

    test('notes sentinel ile açıkça temizlenebilir', () {
      const template = Template(name: 'Standart', notes: 'Not');
      final updated = template.copyWith(notes: null);

      expect(updated.notes, isNull);
    });
  });

  group('Template — toDraftOffer', () {
    test('müşteri boş başlar, currency/indirim/not aynen taşınır', () {
      final template = Template(
        name: 'Standart Hırdavat',
        currency: Currency.usDollar,
        generalDiscount: Percent.of(10),
        notes: 'Standart teklif notu',
        items: [
          OfferItem(
            productName: 'Vida M8',
            unitPrice: Money.fromLira(12, 50),
            quantity: Quantity.of(100),
            vatRate: Percent.of(20),
          ),
        ],
      );

      final draft = template.toDraftOffer();

      expect(draft.customerId, isNull);
      expect(draft.customerName, isEmpty);
      expect(draft.currency, Currency.usDollar);
      expect(draft.generalDiscount, Percent.of(10));
      expect(draft.notes, 'Standart teklif notu');
      expect(draft.items, hasLength(1));
    });

    test('satırlar kaydedilmemiş (id null) yeni kopyalar olarak gelir', () {
      final template = Template(
        name: 'Standart',
        items: [
          OfferItem(
            id: 42, // şablon tablosundaki satır kimliği
            productName: 'Vida M8',
            unitPrice: Money.fromLira(12, 50),
            quantity: Quantity.of(1),
            vatRate: Percent.of(20),
          ),
        ],
      );

      final draftItem = template.toDraftOffer().items.single;

      // 42, TemplateItems tablosundaki bir satırın kimliğidir; taslak teklifte
      // bu satır henüz kaydedilmemiştir — id sızmamalı.
      expect(draftItem.id, isNull);
      expect(draftItem.productName, 'Vida M8');
      expect(draftItem.quantity, Quantity.of(1));
    });

    test('taslak tekliften hesaplanan toplam satırlarla tutarlıdır', () {
      final template = Template(
        name: 'Standart',
        items: [
          OfferItem(
            productName: 'Vida M8',
            unitPrice: Money.fromLira(100),
            quantity: Quantity.of(1),
            vatRate: Percent.of(20),
          ),
        ],
      );

      final draft = template.toDraftOffer();

      // 100 ₺ + %20 KDV = 120 ₺. Money hesabı OfferItem/Offer'da zaten test
      // edilmiştir (offer_calculations_test.dart); burada yalnızca doğru
      // taşındığı doğrulanır.
      expect(draft.grandTotal, Money.fromLira(120));
    });
  });
}
