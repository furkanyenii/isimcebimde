import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';
import 'package:isimcebimde/features/products/data/repositories/product_repository_impl.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
import 'package:isimcebimde/features/products/presentation/product_grouping.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_providers.g.dart';

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) =>
    ProductRepositoryImpl(ref.watch(appDatabaseProvider));

/// Ürün listesindeki arama metni. Boş string = filtre yok.
@riverpod
class ProductSearchQuery extends _$ProductSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// Tüm (arşivlenmemiş) ürünler, filtresiz. Gruplama ve arama presentation
/// katmanında yapılır (kategori adında da aranabilmesi için); DB değiştikçe
/// kendiliğinden yayın yapar.
@riverpod
Stream<List<Product>> allProducts(Ref ref) =>
    ref.watch(productRepositoryProvider).watchAll();

/// Ürünleri kategorileri altında gruplar ve [query] ile filtreler.
///
/// Hem ürün listesi ekranı (paylaşılan arama metniyle) hem teklif ürün seçici
/// bottom sheet'i (kendi yerel arama metniyle) aynı sağlayıcıyı kullanır;
/// bu yüzden [query] parametreyle geçilir. Ürün veya kategori değişince
/// kendiliğinden yeniden hesaplanır.
@riverpod
Future<List<ProductGroup>> productGroups(
  Ref ref, {
  required String query,
}) async {
  final products = await ref.watch(allProductsProvider.future);
  final categories = await ref.watch(categoryListProvider.future);
  return groupProducts(products, categories, query);
}
