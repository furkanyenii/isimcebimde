import 'package:flutter/material.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_item_row.dart';

/// Teklifin satır listesi + "Ürün ekle" butonu.
///
/// Business state (hangi satırın nasıl değiştiği) burada değil, çağıran
/// ekranda yaşar (CLAUDE.md: Riverpod Rules) — bu widget yalnızca listeyi
/// düzenleyip [onChanged] ile bütün listeyi geri verir.
class OfferItemsSection extends StatelessWidget {
  const OfferItemsSection({
    required this.items,
    required this.currency,
    required this.onChanged,
    required this.onAddPressed,
    required this.addLabel,
    super.key,
  });

  final List<OfferItem> items;
  final Currency currency;
  final ValueChanged<List<OfferItem>> onChanged;
  final VoidCallback onAddPressed;
  final String addLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final item in items)
          OfferItemRow(
            key: ValueKey(item.hashCode),
            item: item,
            currency: currency,
            onChanged: (updated) {
              final updatedItems = [...items];
              updatedItems[updatedItems.indexOf(item)] = updated;
              onChanged(updatedItems);
            },
            onRemove: () {
              final updatedItems = [...items]..remove(item);
              onChanged(updatedItems);
            },
          ),
        OutlinedButton.icon(
          onPressed: onAddPressed,
          icon: const Icon(Icons.add),
          label: Text(addLabel),
        ),
      ],
    );
  }
}
