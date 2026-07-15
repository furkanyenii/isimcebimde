import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';

/// Ara toplam → KDV → genel indirim → genel toplam. Hiçbir tutar burada
/// hesaplanmaz; hepsi [Offer]'ın kendi getter'larından okunur.
class OfferSummary extends StatelessWidget {
  const OfferSummary({required this.offer, super.key});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasGeneralDiscount = offer.generalDiscount.basisPoints > 0;

    return AppSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SummaryRow(
            label: l10n.subtotalLabel,
            amount: offer.subtotal,
            currency: offer.currency,
          ),
          _SummaryRow(
            label: l10n.vatTotalLabel,
            amount: offer.vatTotal,
            currency: offer.currency,
          ),
          if (hasGeneralDiscount)
            _SummaryRow(
              label:
                  '${l10n.generalDiscountLabel} (%${offer.generalDiscount.asPercent.toStringAsFixed(0)})',
              amount: offer.totalBeforeGeneralDiscount - offer.grandTotal,
              currency: offer.currency,
              isNegative: true,
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
            child: Divider(),
          ),
          _SummaryRow(
            label: l10n.grandTotalLabel,
            amount: offer.grandTotal,
            currency: offer.currency,
            emphasize: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.amount,
    required this.currency,
    this.isNegative = false,
    this.emphasize = false,
  });

  final String label;
  final Money amount;
  final Currency currency;
  final bool isNegative;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    // Genel toplam teklifin sonucudur: en büyük, en kontrastlı, aksan renginde.
    final labelStyle = emphasize
        ? context.textStyles.titleMedium
        : context.textStyles.bodyMedium;
    final amountStyle = emphasize
        ? context.textStyles.headlineSmall?.copyWith(
            color: context.colors.primary,
          )
        : context.textStyles.bodyMedium;
    final formatted = amount.format(
      locale: context.localeTag,
      symbol: currency.symbol,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(
            isNegative ? '-$formatted' : formatted,
            style: amountStyle?.tabular,
          ),
        ],
      ),
    );
  }
}
