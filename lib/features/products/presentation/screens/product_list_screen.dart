import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
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
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleProducts)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: _SearchField(),
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
                return ListView.builder(
                  // FAB son kartı örtmesin.
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.md,
                    0,
                    AppSizes.md,
                    AppSizes.xxl + AppSizes.lg,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) => _CategorySection(
                    group: items[index],
                    onProductTap: (product) =>
                        _openForm(context, product: product),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.productNew),
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

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: context.l10n.productSearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(productSearchQueryProvider.notifier).update('');
                  setState(() {});
                },
              ),
      ),
      onChanged: (value) {
        ref.read(productSearchQueryProvider.notifier).update(value);
        setState(() {}); // yalnızca temizle butonunun görünürlüğü için
      },
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
