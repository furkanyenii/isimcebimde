import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/core/widgets/app_picker_sheet.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_form_screen.dart';

/// Teklife ürün eklerken seçim ekranı.
///
/// `CustomerPicker` ile aynı gerekçe: kendi yerel arama metnini tutar, ekranın
/// paylaşılan `productSearchQueryProvider`'ını kullanmaz.
Future<Product?> showProductPicker(BuildContext context) {
  return showAppPickerSheet<Product>(
    context: context,
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

  /// Aranan ürün yoksa akış kesilmez: kullanıcı ürünü buradan oluşturur ve
  /// oluşturulan ürün doğrudan teklife seçili olarak döner — teklif ekranına
  /// elleri boş dönüp "önce ürünü ekle" demek zorunda kalmaz.
  Future<void> _createProduct(String name) async {
    final created = await Navigator.of(context).push<Product>(
      MaterialPageRoute(
        builder: (context) => ProductFormScreen(initialName: name),
      ),
    );

    if (created == null || !mounted) return;
    Navigator.of(context).pop(created);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final products = ref.watch(productListProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        children: [
          // autofocus yok: sheet klavyesiz açılır, kullanıcı önce listeyi görür.
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.productSearchHint,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.sm),
          // Aranan ürün listede yoksa akış kesilmez: her zaman görünür bu buton
          // ile ürün buradan oluşturulur ve doğrudan teklife eklenir.
          OutlinedButton.icon(
            onPressed: () => _createProduct(_searchController.text.trim()),
            icon: const Icon(Icons.add),
            label: Text(l10n.productNew),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: products.when(
              loading: () => const AppLoadingView(),
              error: (error, _) =>
                  AppErrorView(message: l10n.productsLoadError),
              data: (items) {
                final query = _searchController.text.trim();
                final filtered = items
                    .where((p) => containsNormalized(p.name, query))
                    .toList();

                if (filtered.isEmpty) {
                  return AppEmptyView(
                    icon: Icons.search_off,
                    title: l10n.emptySearchTitle,
                    description: query.isEmpty
                        ? l10n.productsEmptyDescription
                        : l10n.emptySearchDescription,
                  );
                }

                return ListView.builder(
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
    );
  }
}
