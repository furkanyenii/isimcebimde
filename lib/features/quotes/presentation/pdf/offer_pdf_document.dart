import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/unit_label.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/domain/entities/preparer_info.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';
import 'package:pdf/widgets.dart' as pw;

/// [offer] ve [company]'den PDF byte'ları üretir.
///
/// Saf bir dönüşüm fonksiyonudur: veritabanına/dosya sistemine yazmaz,
/// yalnızca [Uint8List] döner — çağıran taraf (önizleme/paylaşım ekranı)
/// bununla ne yapacağına karar verir.
///
/// Varsayılan Helvetica Türkçe karakterleri (ç, ğ, ı, ö, ş, ü) basamadığı
/// için gömülü Noto Sans fontu kullanılır (`assets/fonts/`).
Future<Uint8List> buildOfferPdfBytes({
  required Offer offer,
  required CompanyInfo company,
  required AppLocalizations l10n,
  required String localeName,
  PreparerInfo preparer = const PreparerInfo(),
}) async {
  final regularFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'),
  );
  final boldFont = pw.Font.ttf(
    await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'),
  );

  final logoImage = company.logoPath == null
      ? null
      : pw.MemoryImage(await File(company.logoPath!).readAsBytes());

  final doc = pw.Document(
    theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
  );

  doc.addPage(
    pw.MultiPage(
      margin: const pw.EdgeInsets.all(32),
      // Şirket başlığı (logo, ad, adres, vergi) yalnızca ilk sayfada. Çok
      // sayfalı tekliflerde her sayfada tekrarlanması alanı boşa harcıyordu.
      header: (context) => context.pageNumber == 1
          ? _Header(
              company: company,
              logoImage: logoImage,
              offer: offer,
              l10n: l10n,
              localeName: localeName,
            )
          : pw.SizedBox(),
      // Teklifi hazırlayan kişi başlıksız, yalnızca son sayfanın altında.
      // Hiçbir alanı doldurulmadıysa alt bilgi hiç çizilmez.
      footer: preparer.isEmpty
          ? null
          : (context) => context.pageNumber == context.pagesCount
                ? _PreparerFooter(preparer: preparer)
                : pw.SizedBox(),
      build: (context) => [
        pw.SizedBox(height: 16),
        _CustomerSection(offer: offer, l10n: l10n),
        pw.SizedBox(height: 16),
        _ItemsTable(offer: offer, l10n: l10n, localeName: localeName),
        pw.SizedBox(height: 12),
        _TotalsSection(offer: offer, l10n: l10n, localeName: localeName),
        if (offer.notes != null && offer.notes!.trim().isNotEmpty) ...[
          pw.SizedBox(height: 16),
          _NotesSection(notes: offer.notes!, l10n: l10n),
        ],
      ],
    ),
  );

  return doc.save();
}

class _Header extends pw.StatelessWidget {
  _Header({
    required this.company,
    required this.logoImage,
    required this.offer,
    required this.l10n,
    required this.localeName,
  });

  final CompanyInfo company;
  final pw.MemoryImage? logoImage;
  final Offer offer;
  final AppLocalizations l10n;
  final String localeName;

  @override
  pw.Widget build(pw.Context context) {
    // Logo şirket adının üstünde, solda; sağ üstte yalnızca tarih. Teklif
    // numarası basılmaz — kullanıcı için bir anlam taşımıyordu, dosya adında
    // ve paylaşım konusunda hâlâ var.
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (logoImage != null) ...[
                    pw.Image(logoImage!, height: 56),
                    pw.SizedBox(height: 8),
                  ],
                  _CompanyInfoBlock(company: company),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Text(
              '${l10n.quoteDateLabel}: '
              '${_formatDate(offer.createdAt, localeName)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Divider(thickness: 1),
      ],
    );
  }

  static String _formatDate(DateTime date, String localeName) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return localeName.startsWith('en')
        ? '$month/$day/${date.year}'
        : '$day.$month.${date.year}';
  }
}

/// Teklifi hazırlayan kişi. Başlık yok: bilgiler kendini anlatır.
class _PreparerFooter extends pw.StatelessWidget {
  _PreparerFooter({required this.preparer});

  final PreparerInfo preparer;

  @override
  pw.Widget build(pw.Context context) {
    final parts = [
      ?preparer.fullName,
      ?preparer.title,
      ?preparer.phone,
      ?preparer.email,
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(thickness: 0.5),
        pw.Text(parts.join(' · '), style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }
}

class _CompanyInfoBlock extends pw.StatelessWidget {
  _CompanyInfoBlock({required this.company});

  final CompanyInfo company;

  @override
  pw.Widget build(pw.Context context) {
    final lines = <String>[
      if (company.phone != null) company.phone!,
      if (company.email != null) company.email!,
      if (company.website != null) company.website!,
      if (company.address != null) company.address!,
      if (company.taxOffice != null && company.taxNumber != null)
        '${company.taxOffice} - ${company.taxNumber}'
      else if (company.taxOffice != null)
        company.taxOffice!
      else if (company.taxNumber != null)
        company.taxNumber!,
    ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          company.name ?? '',
          style: const pw.TextStyle(
            fontSize: 16,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 4),
        for (final line in lines)
          pw.Text(line, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }
}

class _CustomerSection extends pw.StatelessWidget {
  _CustomerSection({required this.offer, required this.l10n});

  final Offer offer;
  final AppLocalizations l10n;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.customerFieldLabel,
          style: const pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(offer.customerName, style: const pw.TextStyle(fontSize: 11)),
        if (offer.customerContactPerson != null &&
            offer.customerContactPerson!.trim().isNotEmpty)
          pw.Text(
            '${l10n.contactPersonLabel}: ${offer.customerContactPerson}',
            style: const pw.TextStyle(fontSize: 9),
          ),
      ],
    );
  }
}

class _ItemsTable extends pw.StatelessWidget {
  _ItemsTable({
    required this.offer,
    required this.l10n,
    required this.localeName,
  });

  final Offer offer;
  final AppLocalizations l10n;
  final String localeName;

  @override
  pw.Widget build(pw.Context context) {
    return pw.TableHelper.fromTextArray(
      headerStyle: const pw.TextStyle(
        fontSize: 9,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignments: const {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
      headers: [
        l10n.productNameLabel,
        l10n.quantityLabel,
        l10n.priceLabel,
        l10n.discountLabel,
        l10n.vatRateLabel,
        l10n.lineTotalLabel,
      ],
      data: offer.items.map((item) => _row(item)).toList(),
    );
  }

  List<String> _row(OfferItem item) => [
    item.productName,
    // Birim miktarın yanında yazılır: "12,5 m²". Ayrı bir sütun tabloyu
    // dar sayfada sıkıştırırdı.
    '${item.quantity.format(locale: localeName)} ${unitLabel(l10n, item.unit)}',
    item.unitPrice.format(locale: localeName, symbol: offer.currency.symbol),
    '%${item.discount.asPercent.toStringAsFixed(0)}',
    '%${item.vatRate.asPercent.toStringAsFixed(0)}',
    item.lineTotal.format(locale: localeName, symbol: offer.currency.symbol),
  ];
}

class _TotalsSection extends pw.StatelessWidget {
  _TotalsSection({
    required this.offer,
    required this.l10n,
    required this.localeName,
  });

  final Offer offer;
  final AppLocalizations l10n;
  final String localeName;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.SizedBox(
          width: 220,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              _totalLine(l10n.subtotalLabel, offer.subtotal),
              _totalLine(l10n.vatTotalLabel, offer.vatTotal),
              if (offer.generalDiscount.basisPoints != 0)
                _totalLine(
                  '${l10n.generalDiscountLabel} '
                  '(%${offer.generalDiscount.asPercent.toStringAsFixed(0)})',
                  offer.totalBeforeGeneralDiscount - offer.grandTotal,
                ),
              pw.Divider(thickness: 0.5),
              _totalLine(
                l10n.grandTotalLabel,
                offer.grandTotal,
                emphasize: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _totalLine(String label, Money amount, {bool emphasize = false}) {
    final formatted = amount.format(
      locale: localeName,
      symbol: offer.currency.symbol,
    );

    final style = pw.TextStyle(
      fontSize: emphasize ? 11 : 9,
      fontWeight: emphasize ? pw.FontWeight.bold : pw.FontWeight.normal,
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: style),
          pw.SizedBox(width: 12),
          pw.Text(formatted, style: style),
        ],
      ),
    );
  }
}

class _NotesSection extends pw.StatelessWidget {
  _NotesSection({required this.notes, required this.l10n});

  final String notes;
  final AppLocalizations l10n;

  @override
  pw.Widget build(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l10n.notesLabel,
          style: const pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 2),
        pw.Text(notes, style: const pw.TextStyle(fontSize: 9)),
      ],
    );
  }
}
