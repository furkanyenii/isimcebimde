import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:isimcebimde/features/products/presentation/screens/product_form_screen.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);
    final query = ref.watch(productSearchQueryProvider);
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
            child: products.when(
              loading: () => const AppLoadingView(),
              error: (error, _) => AppErrorView(
                message: l10n.productsLoadError,
                onRetry: () => ref.invalidate(productListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  // Arama sonucu boş olmakla, hiç ürün olmaması farklı şeylerdir.
                  return query.trim().isEmpty
                      ? AppEmptyView(
                          icon: Icons.inventory_2_outlined,
                          title: l10n.productsEmptyTitle,
                          description: l10n.productsEmptyDescription,
                          actionLabel: l10n.productAdd,
                          onAction: () => _openForm(context),
                        )
                      : AppEmptyView(
                          icon: Icons.search_off,
                          title: l10n.emptySearchTitle,
                          description: l10n.emptySearchDescription,
                        );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => _ProductTile(
                    product: items[index],
                    onTap: () => _openForm(context, product: items[index]),
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

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: const Icon(Icons.inventory_2_outlined),
      title: Text(product.name),
      subtitle: Text(
        context.l10n.vatRateShort(product.vatRate.asPercent.toStringAsFixed(0)),
      ),
      trailing: Text(
        context.formatMoney(product.price),
        style: context.textStyles.titleMedium,
      ),
      onTap: onTap,
    );
  }
}
