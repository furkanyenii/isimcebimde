import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:meta/meta.dart';

/// Bir kategori ve o kategoriye ait (aramadan geçmiş) ürünler.
///
/// Ürün listesi ekranı ve teklif ürün seçici bottom sheet'i aynı gruplamayı
/// kullanır; mantık burada tek yerde tutulur (CLAUDE.md: kod tekrarından kaçın).
@immutable
class ProductGroup {
  const ProductGroup({
    required this.categoryId,
    required this.categoryName,
    required this.products,
  });

  final int categoryId;
  final String categoryName;
  final List<Product> products;
}

/// [products]'ı kategorilerine göre gruplar.
///
/// [query] hem ürün adında hem kategori adında aranır (Türkçe karakter
/// duyarsız — bkz. `core/utils/turkish_text.dart`). Kategori adı eşleşirse o
/// kategorinin **tüm** ürünleri görünür; böylece "hırdavat" araması o
/// kategorinin altındaki her ürünü getirir. Görünür ürünü kalmayan gruplar
/// atlanır. Gruplar kategori adına göre sıralanır; grup içindeki ürünlerin
/// (repository'den gelen ada göre sıralı) düzeni korunur.
List<ProductGroup> groupProducts(
  List<Product> products,
  List<Category> categories,
  String query,
) {
  final categoryById = {
    for (final category in categories)
      if (category.id != null) category.id!: category,
  };

  final grouped = <int, List<Product>>{};
  for (final product in products) {
    final categoryName = categoryById[product.categoryId]?.name ?? '';
    final matches =
        containsNormalized(product.name, query) ||
        containsNormalized(categoryName, query);
    if (!matches) continue;
    (grouped[product.categoryId] ??= <Product>[]).add(product);
  }

  final result =
      [
        for (final entry in grouped.entries)
          ProductGroup(
            categoryId: entry.key,
            categoryName: categoryById[entry.key]?.name ?? '',
            products: entry.value,
          ),
      ]..sort(
        (a, b) => normalizeForSearch(
          a.categoryName,
        ).compareTo(normalizeForSearch(b.categoryName)),
      );

  return result;
}
