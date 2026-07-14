import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';

/// Para/KDV/indirim hesapları — CLAUDE.md: "özellikle para/KDV" domain birim
/// testleri zorunludur. Bu testler ekran testlerinden bağımsız olarak,
/// hesabın kendisinin doğru olduğunu kanıtlar.
void main() {
  group('OfferItem — satır hesabı', () {
    test('iskonto yokken satır toplamı miktar x birim fiyat + KDV', () {
      final item = OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(12, 50),
        quantity: 100,
        vatRate: Percent.of(20),
      );

      expect(item.lineSubtotal, Money.fromLira(1250)); // 12,50 x 100
      expect(item.lineVat, Money.fromLira(250)); // %20 KDV
      expect(item.lineTotal, Money.fromLira(1500));
    });

    test('satır iskontosu KDV\'den önce, ara toplama uygulanır', () {
      final item = OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(100),
        quantity: 1,
        vatRate: Percent.of(20),
        discount: Percent.of(10),
      );

      // 100 ₺ - %10 iskonto = 90 ₺; %20 KDV = 18 ₺; toplam 108 ₺.
      expect(item.lineSubtotal, Money.fromLira(90));
      expect(item.lineVat, Money.fromLira(18));
      expect(item.lineTotal, Money.fromLira(108));
    });

    test('KDV oranı sıfır olabilir (istisna ürünler)', () {
      final item = OfferItem(
        productName: 'Kitap',
        unitPrice: Money.fromLira(50),
        quantity: 2,
        vatRate: Percent.zero,
      );

      expect(item.lineSubtotal, Money.fromLira(100));
      expect(item.lineVat, Money.zero);
      expect(item.lineTotal, Money.fromLira(100));
    });

    test('kuruş hassasiyeti korunur (yuvarlama satır bazında)', () {
      final item = OfferItem(
        productName: 'Kablo (metre)',
        unitPrice: Money.fromLira(0, 33), // 0,33 ₺
        quantity: 3,
        vatRate: Percent.of(20),
      );

      expect(item.lineSubtotal, Money.fromLira(0, 99));
      expect(item.lineVat.minor, 20); // 99 kuruşun %20'si, yuvarlanmış
    });
  });

  group('Offer — teklif toplamları', () {
    Offer offerWith(
      List<OfferItem> items, {
      Percent generalDiscount = Percent.zero,
    }) => Offer(
      customerId: 1,
      customerName: 'Ahmet Yılmaz',
      generalDiscount: generalDiscount,
      items: items,
    );

    test('tek satırlı teklifte toplamlar satırla birebir eşleşir', () {
      final item = OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(12, 50),
        quantity: 100,
        vatRate: Percent.of(20),
      );
      final offer = offerWith([item]);

      expect(offer.subtotal, item.lineSubtotal);
      expect(offer.vatTotal, item.lineVat);
      expect(offer.totalBeforeGeneralDiscount, item.lineTotal);
      expect(offer.grandTotal, item.lineTotal); // genel indirim yok
    });

    test('çok satırlı teklifte toplamlar satır bazında toplanır', () {
      final vida = OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(12, 50),
        quantity: 100, // 1250 ₺ + %20 KDV = 1500 ₺
        vatRate: Percent.of(20),
      );
      final somun = OfferItem(
        productName: 'Somun',
        unitPrice: Money.fromLira(3),
        quantity: 50, // 150 ₺ + %10 KDV = 165 ₺
        vatRate: Percent.of(10),
      );
      final offer = offerWith([vida, somun]);

      expect(offer.subtotal, Money.fromLira(1400)); // 1250 + 150
      expect(offer.vatTotal, Money.fromLira(265)); // 250 + 15
      expect(offer.totalBeforeGeneralDiscount, Money.fromLira(1665));
    });

    test('genel indirim KDV dahil toplama, KDV\'den SONRA uygulanır', () {
      final item = OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(100),
        quantity: 1,
        vatRate: Percent.of(20), // 100 ₺ + 20 ₺ KDV = 120 ₺
      );
      final offer = offerWith([item], generalDiscount: Percent.of(10));

      // Bu "toplamdan geriye hesaplama" değildir: satır değerleri
      // (subtotal=100, vat=20) hiç değişmez, yalnızca ödenecek son tutar
      // ileri yönde %10 indirilir: 120 ₺ - %10 = 108 ₺.
      expect(offer.subtotal, Money.fromLira(100));
      expect(offer.vatTotal, Money.fromLira(20));
      expect(offer.totalBeforeGeneralDiscount, Money.fromLira(120));
      expect(offer.grandTotal, Money.fromLira(108));
    });

    test('boş teklifin toplamları sıfırdır', () {
      final offer = offerWith(const []);

      expect(offer.subtotal, Money.zero);
      expect(offer.vatTotal, Money.zero);
      expect(offer.grandTotal, Money.zero);
    });

    test('varsayılan para birimi Türk Lirası\'dır', () {
      expect(offerWith(const []).currency, Currency.turkishLira);
    });
  });

  group('Offer/OfferItem — copyWith', () {
    test('copyWith null geçilen alanı korur, verilen alanı değiştirir', () {
      final offer = Offer(customerName: 'Ahmet Yılmaz', customerId: 1);
      final updated = offer.copyWith(customerName: 'Mehmet Demir');

      expect(updated.customerName, 'Mehmet Demir');
      expect(updated.customerId, 1); // dokunulmadı
    });

    test('customerContactPerson sentinel ile açıkça temizlenebilir', () {
      final offer = Offer(
        customerName: 'Yılmaz İnşaat',
        customerContactPerson: 'Ahmet Yılmaz',
      );

      // Müşteri değişince yeni müşterinin yetkilisi olmayabilir; bu durumda
      // alan açıkça null'a set edilebilmeli (Customer.copyWith'teki sentinel
      // deseniyle aynı gerekçe).
      final updated = offer.copyWith(customerContactPerson: null);
      expect(updated.customerContactPerson, isNull);
    });

    test('OfferItem.copyWith ile miktar/iskonto bağımsız güncellenebilir', () {
      final item = OfferItem(
        productName: 'Vida M8',
        unitPrice: Money.fromLira(12, 50),
        quantity: 1,
        vatRate: Percent.of(20),
      );

      final updated = item.copyWith(quantity: 5, discount: Percent.of(10));
      expect(updated.quantity, 5);
      expect(updated.discount, Percent.of(10));
      expect(updated.unitPrice, item.unitPrice); // dokunulmadı
    });
  });

  group('Offer — quoteNumber', () {
    test('id ve oluşturulma yılından türetilir, 6 haneye doldurulur', () {
      final offer = Offer(
        id: 42,
        customerName: 'Ahmet Yılmaz',
        createdAt: DateTime(2026),
      );

      expect(offer.quoteNumber, 'TKL-2026-000042');
    });

    test('kaydedilmemiş teklifte (id null) hata fırlatır', () {
      final offer = Offer(customerName: 'Ahmet Yılmaz');

      expect(() => offer.quoteNumber, throwsStateError);
    });
  });
}
