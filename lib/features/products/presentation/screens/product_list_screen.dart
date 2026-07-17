import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_paging.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
import 'package:isimcebimde/core/widgets/app_paginated_list_view.dart';
import 'package:isimcebimde/core/widgets/app_search_field.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/product_grouping.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_form_screen.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(productSearchQueryProvider);
    final groups = ref.watch(productGroupsProvider(query: query));
    // Sayfalama ürün bazında olduğundan sayaç da tüm gruplardaki ürün toplamı.
    final productCount =
        groups.asData?.value.fold<int>(
          0,
          (sum, group) => sum + group.products.length,
        ) ??
        0;
    final hasPagination = productCount > AppPaging.pageSize;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleProducts)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: AppSearchField(
              hintText: l10n.productSearchHint,
              onChanged: (value) =>
                  ref.read(productSearchQueryProvider.notifier).update(value),
            ),
          ),
          Expanded(
            child: groups.when(
              loading: () => const AppLoadingView(),
              error: (error, _) => AppErrorView(
                message: l10n.productsLoadError,
                onRetry: () => ref.invalidate(allProductsProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  // Arama sonucu boş olmakla, hiç ürün olmaması farklı şeylerdir.
                  // Eylem butonu yok: yeni ürün zaten sağ alttaki FAB ile açılır.
                  return query.trim().isEmpty
                      ? AppEmptyView(
                          icon: Icons.inventory_2_outlined,
                          title: l10n.productsEmptyTitle,
                          description: l10n.productsEmptyDescription,
                        )
                      : AppEmptyView(
                          icon: Icons.search_off,
                          title: l10n.emptySearchTitle,
                          description: l10n.emptySearchDescription,
                        );
                }
                // Sayfalama ürün bazında (15 ürün/sayfa): gruplar düzleştirilip
                // dilimlenir, her sayfa kendi dilimini tekrar gruplar. Bir
                // kategori sayfa sınırında bölünürse başlığı iki sayfada görünür.
                return AppPaginatedListView<FlatProduct>(
                  items: flattenGroups(items),
                  pageBuilder: (context, pageItems) {
                    final pageGroups = regroupProducts(pageItems);
                    return ListView.builder(
                      // FAB son kartı örtmesin.
                      padding: const EdgeInsets.fromLTRB(
                        AppSizes.md,
                        0,
                        AppSizes.md,
                        AppSizes.xxl + AppSizes.lg,
                      ),
                      itemCount: pageGroups.length,
                      itemBuilder: (context, index) => _CategorySection(
                        group: pageGroups[index],
                        onProductTap: (product) =>
                            _openForm(context, product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Sayfalama çubuğu görünürken FAB'ı çubuk yüksekliği kadar kaldır.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: hasPagination ? AppPaging.barHeight : 0,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _openForm(context),
          icon: const Icon(Icons.add),
          label: Text(l10n.productNew),
        ),
      ),
    );
  }

  void _openForm(BuildContext context, {Product? product}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductFormScreen(product: product),
      ),
    );
  }
}

/// Bir kategori başlığı ve altındaki ürün kartları.
class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.group, required this.onProductTap});

  final ProductGroup group;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.xs,
            AppSizes.md,
            AppSizes.xs,
            AppSizes.sm,
          ),
          child: Text(
            group.categoryName,
            style: context.textStyles.titleSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        for (final product in group.products) ...[
          _ProductTile(product: product, onTap: () => onProductTap(product)),
          const SizedBox(height: AppSizes.sm),
        ],
      ],
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      icon: Icons.inventory_2_outlined,
      iconColor: AppColors.success,
      title: product.name,
      onTap: onTap,
      trailing: Text(
        context.formatMoney(product.price),
        style: context.textStyles.titleMedium?.tabular,
      ),
    );
  }
}
