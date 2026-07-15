import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/pdf/offer_pdf_document.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';

import '../../support/localized_app.dart';

/// Bu bir görsel regresyon testi değildir; yalnızca fonksiyonun hatasız,
/// boş olmayan ve gerçekten bir PDF olan byte'lar ürettiğini doğrular
/// (font yükleme, logo okuma, l10n erişimi hatasız çalışıyor mu).
void main() {
  Offer sampleOffer() => Offer(
    id: 42,
    customerName: 'Yılmaz İnşaat',
    customerContactPerson: 'Ahmet Yılmaz',
    createdAt: DateTime(2026, 3, 5),
    notes: 'Teslimat Çekmeköy şubesine yapılacaktır.',
    items: [
      OfferItem(
        productName: 'Çelik Vida M8',
        unitPrice: Money.fromLira(12, 50),
        quantity: Quantity.of(100),
        vatRate: Percent.of(20),
        discount: Percent.of(10),
      ),
    ],
  );

  testWidgets('geçerli, boş olmayan bir PDF üretir', (tester) async {
    final bytes = await buildOfferPdfBytes(
      offer: sampleOffer(),
      company: const CompanyInfo(name: 'Şahin Yapı Malzemeleri'),
      l10n: l10nFor(const Locale('tr')),
      localeName: 'tr',
    );

    expect(bytes, isNotEmpty);
    // PDF dosyaları her zaman "%PDF-" imzasıyla başlar.
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  testWidgets('müşterinin tüm iletişim/vergi bilgileriyle PDF üretir', (
    tester,
  ) async {
    // Yeni müşteri snapshot alanları (adres, telefon, e-posta, vergi) dolu
    // olduğunda da PDF hatasız üretilmeli.
    final offer = sampleOffer().copyWith(
      customerPhone: '0532 111 22 33',
      customerEmail: 'info@yilmaz.com',
      customerAddress: 'Çekmeköy, İstanbul',
      customerTaxOffice: 'Ümraniye',
      customerTaxNumber: 'TR1234567890',
    );

    final bytes = await buildOfferPdfBytes(
      offer: offer,
      company: const CompanyInfo(name: 'Şahin Yapı Malzemeleri'),
      l10n: l10nFor(const Locale('tr')),
      localeName: 'tr',
    );

    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });

  testWidgets('firma bilgisi boşken de (opsiyonel alanlar) üretir', (
    tester,
  ) async {
    final bytes = await buildOfferPdfBytes(
      offer: sampleOffer(),
      company: const CompanyInfo(),
      l10n: l10nFor(const Locale('en')),
      localeName: 'en',
    );

    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
  });
}
