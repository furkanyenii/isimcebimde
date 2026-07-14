import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/money_field.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/percent_field.dart';

/// Tek bir teklif satırı: ürün adı, miktar, birim fiyat, satır iskontosu ve
/// hesaplanan satır toplamı. Toplam bu widget'ta **tekrar hesaplanmaz** —
/// [OfferItem.lineTotal] tek doğruluk kaynağıdır.
class OfferItemRow extends StatefulWidget {
  const OfferItemRow({
    required this.item,
    required this.currency,
    required this.onChanged,
    required this.onRemove,
    super.key,
  });

  final OfferItem item;
  final Currency currency;
  final ValueChanged<OfferItem> onChanged;
  final VoidCallback onRemove;

  @override
  State<OfferItemRow> createState() => _OfferItemRowState();
}

class _OfferItemRowState extends State<OfferItemRow> {
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

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
                    widget.item.productName,
                    style: context.textStyles.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.actionDelete,
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(labelText: l10n.quantityLabel),
                    onChanged: (text) {
                      final quantity = int.tryParse(text) ?? 0;
                      if (quantity > 0) {
                        widget.onChanged(
                          widget.item.copyWith(quantity: quantity),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  flex: 2,
                  child: MoneyField(
                    initialValue: widget.item.unitPrice,
                    onChanged: (price) => widget.onChanged(
                      widget.item.copyWith(unitPrice: price),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: PercentField(
                    initialValue: widget.item.discount,
                    label: l10n.discountLabel,
                    onChanged: (discount) => widget.onChanged(
                      widget.item.copyWith(discount: discount),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.item.lineTotal.format(
                        locale: context.localeTag,
                        symbol: widget.currency.symbol,
                      ),
                      style: context.textStyles.titleMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
