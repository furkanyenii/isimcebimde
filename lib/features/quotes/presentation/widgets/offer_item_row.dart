import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/money_field.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/percent_field.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/quantity_field.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/unit_field.dart';

/// Tek bir teklif satırı: ürün adı, miktar + birim, birim fiyat, iskonto, KDV
/// ve hesaplanan satır toplamı. Toplam bu widget'ta **tekrar hesaplanmaz** —
/// [OfferItem.lineTotal] tek doğruluk kaynağıdır.
///
/// KDV satırda girilir: aynı ürün farklı teklifte farklı oranla satılabilir.
class OfferItemRow extends StatelessWidget {
  const OfferItemRow({
    required this.item,
    required this.currency,
    required this.customUnits,
    required this.onChanged,
    required this.onUnitCreated,
    required this.onRemove,
    super.key,
  });

  final OfferItem item;
  final Currency currency;
  final List<String> customUnits;
  final ValueChanged<OfferItem> onChanged;
  final ValueChanged<String> onUnitCreated;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.productName,
                    style: context.textStyles.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.actionDelete,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: QuantityField(
                    initialValue: item.quantity,
                    onChanged: (quantity) =>
                        onChanged(item.copyWith(quantity: quantity)),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: UnitField(
                    value: item.unit,
                    customUnits: customUnits,
                    onChanged: (unit) => onChanged(item.copyWith(unit: unit)),
                    onUnitCreated: onUnitCreated,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            MoneyField(
              initialValue: item.unitPrice,
              onChanged: (price) => onChanged(item.copyWith(unitPrice: price)),
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: PercentField(
                    initialValue: item.discount,
                    label: l10n.discountLabel,
                    onChanged: (discount) =>
                        onChanged(item.copyWith(discount: discount)),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: PercentField(
                    initialValue: item.vatRate,
                    label: l10n.vatRateLabel,
                    onChanged: (vatRate) =>
                        onChanged(item.copyWith(vatRate: vatRate)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                item.lineTotal.format(
                  locale: context.localeTag,
                  symbol: currency.symbol,
                ),
                style: context.textStyles.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
