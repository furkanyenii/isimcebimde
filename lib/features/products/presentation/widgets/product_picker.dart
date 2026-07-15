import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_picker_sheet.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/product_grouping.dart';
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
    final query = _searchController.text.trim();
    // Ürünler ekranıyla aynı gruplama: kategori başlıkları altında listelenir,
    // arama hem ürün hem kategori adında yapılır.
    final groups = ref.watch(productGroupsProvider(query: query));

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
            onPressed: () => _createProduct(query),
            icon: const Icon(Icons.add),
            label: Text(l10n.productNew),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: groups.when(
              loading: () => const AppLoadingView(),
              error: (error, _) =>
                  AppErrorView(message: l10n.productsLoadError),
              data: (items) {
                if (items.isEmpty) {
                  return AppEmptyView(
                    icon: Icons.search_off,
                    title: l10n.emptySearchTitle,
                    description: query.isEmpty
                        ? l10n.productsEmptyDescription
                        : l10n.emptySearchDescription,
                  );
                }

                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => _CategorySection(
                    group: items[index],
                    onProductTap: (product) =>
                        Navigator.of(context).pop(product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Bir kategori başlığı ve altındaki ürün satırları (seçici için).
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.group, required this.onProductTap});

  final ProductGroup group;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Belirgin kategori bandı: dolu arka plan + ikon + kalın, harflerarası
        // açık büyük başlık; ürün satırlarından net biçimde ayrışsın.
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(
            AppSizes.xs,
            AppSizes.md,
            AppSizes.xs,
            AppSizes.sm,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.sm,
            vertical: AppSizes.xs,
          ),
          decoration: BoxDecoration(
            color: context.colors.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: Row(
            children: [
              Icon(
                Icons.folder_outlined,
                size: AppSizes.iconSm,
                color: context.colors.onPrimaryContainer,
              ),
              const SizedBox(width: AppSizes.xs),
              Expanded(
                child: Text(
                  group.categoryName.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: context.colors.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        for (final product in group.products)
          ListTile(
            title: Text(product.name),
            trailing: Text(context.formatMoney(product.price)),
            onTap: () => onProductTap(product),
          ),
      ],
    );
  }
}
