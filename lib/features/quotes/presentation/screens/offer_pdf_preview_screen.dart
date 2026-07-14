import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/presentation/pdf/offer_pdf_document.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';
import 'package:printing/printing.dart';

/// Kaydedilmiş bir teklifin PDF önizlemesi. [printing] paketinin
/// `PdfPreview` widget'ı yazdırma/paylaşım ikonlarını hazır getirir; bu
/// ekran yalnızca doğru içeriği üretmekten sorumludur (Faz 8'de özel
/// çoklu-kanal paylaşım akışı bunun üzerine kurulacak).
class OfferPdfPreviewScreen extends ConsumerWidget {
  const OfferPdfPreviewScreen({required this.offer, super.key});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);

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
            l10n: l10n,
            localeName: context.localeTag,
          ),
          pdfFileName: '${offer.quoteNumber}.pdf',
        ),
      ),
    );
  }
}
