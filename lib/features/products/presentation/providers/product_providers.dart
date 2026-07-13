import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/products/data/repositories/product_repository_impl.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';
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

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
/// Arama metni değişince sorgu da kendiliğinden yeniden kurulur.
@riverpod
Stream<List<Product>> productList(Ref ref) {
  final query = ref.watch(productSearchQueryProvider);
  return ref.watch(productRepositoryProvider).watchAll(query: query);
}
