import 'package:isimcebimde/features/products/domain/entities/product.dart';

/// Presentation katmanı yalnızca bu arayüzü görür.
/// Drift tipleri (`AppDatabase`, `ProductRow`) buranın dışına sızmaz —
/// ileride cloud sync eklendiğinde UI'da tek satır değişmemesini bu sağlar.
abstract interface class ProductRepository {
  /// Arşivlenmemiş ürünler, ada göre sıralı.
  ///
  /// [query] verilirse ada göre filtreler (büyük/küçük harf duyarsız).
  /// [categoryId] verilirse yalnızca o kategoriyi getirir.
  Stream<List<Product>> watchAll({String? query, int? categoryId});

  Stream<Product?> watchById(int id);

  /// Yeni ürün oluşturur ve id'sini döner.
  Future<int> create(Product product);

  /// Var olan ürünü günceller. [Product.id] null olamaz.
  Future<void> update(Product product);

  /// Ürünü kalıcı olarak siler.
  ///
  /// Geçmiş teklifler bozulmaz: teklif satırı ürünün ad ve fiyat *snapshot*'ını
  /// tutar, ürüne canlı referans vermez (CLAUDE.md: Database Rules).
  Future<void> delete(int id);
}
