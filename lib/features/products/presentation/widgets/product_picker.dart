import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';

/// Teklife ürün eklerken seçim ekranı.
///
/// `CustomerPicker` ile aynı gerekçe: kendi yerel arama metnini tutar, ekranın
/// paylaşılan `productSearchQueryProvider`'ını kullanmaz.
Future<Product?> showProductPicker(BuildContext context) {
  return showModalBottomSheet<Product>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _ProductPickerSheet(),
  );
}

class _ProductPickerSheet extends ConsumerStatefulWidget {
  const _ProductPickerSheet();

  @override
  ConsumerState<_ProductPickerSheet> createState() =>
      _ProductPickerSheetState();
}

class _ProductPickerSheetState extends ConsumerState<_ProductPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final products = ref.watch(productListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.productSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.sm),
            Flexible(
              child: products.when(
                loading: () => const AppLoadingView(),
                error: (error, _) =>
                    AppErrorView(message: l10n.productsLoadError),
                data: (items) {
                  final query = _searchController.text;
                  final filtered = items
                      .where((p) => containsNormalized(p.name, query))
                      .toList();

                  if (filtered.isEmpty) {
                    return AppEmptyView(
                      icon: Icons.search_off,
                      title: l10n.emptySearchTitle,
                      description: l10n.emptySearchDescription,
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ListTile(
                        title: Text(product.name),
                        trailing: Text(context.formatMoney(product.price)),
                        onTap: () => Navigator.of(context).pop(product),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
