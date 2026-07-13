import 'package:isimcebimde/features/products/domain/entities/product.dart';

/// Presentation katmanı yalnızca bu arayüzü görür.
/// Drift tipleri (`AppDatabase`, `ProductRow`) buranın dışına sızmaz —
/// ileride cloud sync eklendiğinde UI'da tek satır değişmemesini bu sağlar.
abstract interface class ProductRepository {
  /// Arşivlenmemiş ürünler. Veritabanı değiştikçe kendiliğinden yayın yapar.
  Stream<List<Product>> watchAll();

  Future<void> add(Product product);
}
