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

/// Kategori bilgisini yanında taşıyan tek ürün. Sayfalama ürün bazında (15
/// ürün/sayfa) yapılırken kullanılır: gruplar düzleştirilip dilimlenir, sonra
/// dilim tekrar gruplanır. Bir kategori sayfa sınırında bölünürse başlığı
/// sonraki sayfada yeniden görünür — beklenen davranıştır.
@immutable
class FlatProduct {
  const FlatProduct({
    required this.categoryId,
    required this.categoryName,
    required this.product,
  });

  final int categoryId;
  final String categoryName;
  final Product product;
}

/// [groups]'ı, grup ve ürün sırasını koruyarak düz bir [FlatProduct] listesine
/// çevirir. [regroupProducts] bunun tersidir.
List<FlatProduct> flattenGroups(List<ProductGroup> groups) => [
  for (final group in groups)
    for (final product in group.products)
      FlatProduct(
        categoryId: group.categoryId,
        categoryName: group.categoryName,
        product: product,
      ),
];

/// Ardışık aynı kategorideki [flat] ürünleri tekrar [ProductGroup]'lara toplar.
/// Sıra korunduğundan bir sayfa dilimi tek geçişte gruplanabilir.
List<ProductGroup> regroupProducts(List<FlatProduct> flat) {
  final result = <ProductGroup>[];
  for (final item in flat) {
    if (result.isNotEmpty && result.last.categoryId == item.categoryId) {
      result.last.products.add(item.product);
    } else {
      result.add(
        ProductGroup(
          categoryId: item.categoryId,
          categoryName: item.categoryName,
          products: [item.product],
        ),
      );
    }
  }
  return result;
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
