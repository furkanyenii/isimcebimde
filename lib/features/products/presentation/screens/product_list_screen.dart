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

    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
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
                message: 'Ürünler yüklenemedi.',
                onRetry: () => ref.invalidate(productListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  // Arama sonucu boş olmakla, hiç ürün olmaması farklı şeylerdir.
                  return query.trim().isEmpty
                      ? AppEmptyView(
                          icon: Icons.inventory_2_outlined,
                          title: 'Henüz ürün yok',
                          description:
                              'Teklif hazırlayabilmek için önce ürünlerini ekle.',
                          actionLabel: 'Ürün ekle',
                          onAction: () => _openForm(context),
                        )
                      : const AppEmptyView(
                          icon: Icons.search_off,
                          title: 'Sonuç yok',
                          description: 'Farklı bir arama dene.',
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
        label: const Text('Yeni Ürün'),
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
        hintText: 'Ürün ara',
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
      subtitle: Text('KDV %${product.vatRate.asPercent.toStringAsFixed(0)}'),
      trailing: Text(
        product.price.format(),
        style: context.textStyles.titleMedium,
      ),
      onTap: onTap,
    );
  }
}
