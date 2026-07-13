import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';

/// Faz 0 doğrulama ekranı: DB → repository → provider → UI hattının çalıştığını
/// gösterir. Gerçek ürün yönetimi Faz 1'de bunun yerine gelecek.
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      body: products.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: 'Ürünler yüklenemedi.',
          onRetry: () => ref.invalidate(productListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return const AppEmptyView(
              icon: Icons.inventory_2_outlined,
              title: 'Henüz ürün yok',
              description: 'Teklif hazırlayabilmek için önce ürünlerini ekle.',
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) =>
                _ProductTile(product: items[index]),
          );
        },
      ),
      // Gerçek "Yeni Ürün" formu bu fazın (Phase 2) ilerleyen adımında gelir.
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: const Icon(Icons.inventory_2_outlined),
      title: Text(product.name),
      trailing: Text(
        product.price.format(),
        style: context.textStyles.titleMedium,
      ),
    );
  }
}
