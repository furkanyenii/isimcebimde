import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/presentation/pdf/offer_pdf_document.dart';
import 'package:isimcebimde/features/quotes/presentation/pdf/offer_pdf_file_name.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';
import 'package:printing/printing.dart';

/// Kaydedilmiş bir teklifin PDF önizlemesi. [printing] paketinin
/// `PdfPreview` widget'ı yazdırma/paylaşım ikonlarını hazır getirir; bu
/// ekran yalnızca doğru içeriği üretmekten ve paylaşımı (konu/metin/alıcı)
/// zenginleştirmekten sorumludur. WhatsApp ve Mail için ayrı bir buton
/// yoktur: sistem paylaşım ekranı ikisini de native olarak destekler
/// (Faz 8 kararı — bkz. docs/ROADMAP.md).
class OfferPdfPreviewScreen extends ConsumerStatefulWidget {
  const OfferPdfPreviewScreen({required this.offer, super.key});

  final Offer offer;

  @override
  ConsumerState<OfferPdfPreviewScreen> createState() =>
      _OfferPdfPreviewScreenState();
}

class _OfferPdfPreviewScreenState extends ConsumerState<OfferPdfPreviewScreen> {
  /// Paylaşım anı ekran açılırken bir kez sabitlenir.
  ///
  /// StatefulWidget'ın gerekçesi bu: hem belgenin üstündeki tarih hem dosya
  /// adı bu değerden üretiliyor ve **aynı** olmak zorunda. `DateTime.now()`
  /// her build'de yeniden okunsaydı — `PdfPreview` içeriği kağıt boyutu
  /// değiştikçe yeniden üretir — gece yarısını geçen bir paylaşımda belge ile
  /// dosya adı farklı güne düşerdi.
  late final DateTime _documentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final offer = widget.offer;
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);

    // Müşterinin e-postası yalnızca bir zenginleştirmedir: yüklenirken veya
    // müşteri bulunamadığında (silinmiş/seçilmemiş) ekranı bloklamaz,
    // paylaşım alıcısız açılır (CLAUDE.md: müşteri serbestçe silinebilir).
    final customerId = offer.customerId;
    final customerEmail = customerId == null
        ? null
        : ref.watch(customerByIdProvider(customerId)).value?.email;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.pdfPreviewTitle)),
      body: settings.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: l10n.errorSettingsLoad,
          onRetry: () => ref.invalidate(settingsProvider),
        ),
        data: (appSettings) => PdfPreview(
          build: (format) => buildOfferPdfBytes(
            offer: offer,
            company: appSettings.company,
            preparer: appSettings.preparer,
            l10n: l10n,
            localeName: context.localeTag,
            documentDate: _documentDate,
          ),
          pdfFileName: offerPdfFileName(
            offer,
            draftLabel: l10n.quoteDraftLabel,
            sharedAt: _documentDate,
          ),
          shareActionExtraSubject:
              offer.quoteNumberOrNull ?? l10n.quoteDraftLabel,
          shareActionExtraBody: l10n.shareEmailBody(offer.customerName),
          shareActionExtraEmails: customerEmail == null
              ? null
              : [customerEmail],
        ),
      ),
    );
  }
}
