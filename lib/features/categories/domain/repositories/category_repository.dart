import 'package:isimcebimde/features/categories/domain/entities/category.dart';

abstract interface class CategoryRepository {
  /// Kategoriler ada göre sıralı. Veritabanı değiştikçe kendiliğinden yayın yapar.
  Stream<List<Category>> watchAll();

  /// Yeni kategori oluşturur ve id'sini döner.
  /// Aynı isim varsa [DuplicateCategoryFailure] fırlatır.
  Future<int> create(String name);

  /// Kategoriyi siler.
  /// Kategoriye bağlı ürün varsa [CategoryInUseFailure] fırlatır — ürünler
  /// sahipsiz kalamaz, çünkü kategori zorunludur.
  Future<void> delete(int id);
}
