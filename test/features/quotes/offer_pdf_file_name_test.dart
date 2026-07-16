import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/pdf/offer_pdf_file_name.dart';

Offer _offer({int? id}) => Offer(
  id: id,
  customerId: 1,
  customerName: 'Yılmaz İnşaat',
  createdAt: DateTime(2026, 7, 10),
  items: [
    OfferItem(
      productName: 'Vida M8',
      unitPrice: Money.fromLira(12, 50),
      quantity: Quantity.of(1),
      vatRate: Percent.of(20),
    ),
  ],
);

void main() {
  final sharedAt = DateTime(2026, 7, 16);

  test(
    'kaydedilmiş teklif: numara korunur, sonuna paylaşım tarihi eklenir',
    () {
      final name = offerPdfFileName(
        _offer(id: 1),
        draftLabel: 'Teklif-Taslak',
        sharedAt: sharedAt,
      );

      expect(name, 'TKL-2026-000001-16072026.pdf');
    },
  );

  test('kaydedilmemiş teklif taslak etiketiyle adlandırılır', () {
    final name = offerPdfFileName(
      _offer(),
      draftLabel: 'Teklif-Taslak',
      sharedAt: sharedAt,
    );

    expect(name, 'Teklif-Taslak-16072026.pdf');
  });

  test('tarih teklifin oluşturulma günü değil, paylaşıldığı gündür', () {
    // Teklif 10 Temmuz'da oluşturuldu; 16 Temmuz'da paylaşılıyor.
    final name = offerPdfFileName(
      _offer(id: 1),
      draftLabel: 'Teklif-Taslak',
      sharedAt: sharedAt,
    );

    expect(name, contains('16072026'));
    expect(name, isNot(contains('10072026')));
  });

  test('aynı gün paylaşılan iki teklif farklı dosya adı alır', () {
    // Dosya adı yalnızca tarihten oluşsaydı ikisi çakışır, biri diğerinin
    // üstüne yazardı.
    final first = offerPdfFileName(
      _offer(id: 1),
      draftLabel: 'Teklif-Taslak',
      sharedAt: sharedAt,
    );
    final second = offerPdfFileName(
      _offer(id: 2),
      draftLabel: 'Teklif-Taslak',
      sharedAt: sharedAt,
    );

    expect(first, isNot(second));
  });

  test('günün ve ayın tek haneli olduğu tarihler başına sıfır alır', () {
    final name = offerPdfFileName(
      _offer(id: 1),
      draftLabel: 'Teklif-Taslak',
      sharedAt: DateTime(2026, 1, 5),
    );

    expect(name, 'TKL-2026-000001-05012026.pdf');
  });
}
