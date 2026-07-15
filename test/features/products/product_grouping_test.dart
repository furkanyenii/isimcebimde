import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/product_grouping.dart';

/// Saf fonksiyon: veritabanına dokunmaz, düz `test()` yeterlidir.
void main() {
  const categories = [
    Category(id: 1, name: 'Hırdavat'),
    Category(id: 2, name: 'Boya'),
  ];

  Product product(String name, int categoryId) => Product(
    id: name.hashCode,
    name: name,
    price: Money.fromLira(10, 0),
    categoryId: categoryId,
  );

  final products = [
    product('Vida M8', 1),
    product('Somun', 1),
    product('Beyaz Boya', 2),
  ];

  test(
    'ürünler kategorilerine göre gruplanır, kategori adına göre sıralanır',
    () {
      final groups = groupProducts(products, categories, '');

      expect(groups.map((g) => g.categoryName), ['Boya', 'Hırdavat']);
      expect(
        groups.firstWhere((g) => g.categoryId == 1).products.map((p) => p.name),
        ['Vida M8', 'Somun'],
      );
    },
  );

  test('ürün adında arama yalnızca eşleşen ürünü getirir', () {
    final groups = groupProducts(products, categories, 'vida');

    expect(groups, hasLength(1));
    expect(groups.single.categoryName, 'Hırdavat');
    expect(groups.single.products.map((p) => p.name), ['Vida M8']);
  });

  test('kategori adında arama o kategorinin tüm ürünlerini getirir', () {
    final groups = groupProducts(products, categories, 'hirdavat');

    expect(groups, hasLength(1));
    expect(groups.single.products.map((p) => p.name), ['Vida M8', 'Somun']);
  });

  test('Türkçe karakter duyarsız arama (şapkasız yazım de bulur)', () {
    final groups = groupProducts(products, categories, 'hirdavat');
    final groupsWithDiacritics = groupProducts(
      products,
      categories,
      'hırdavat',
    );

    expect(groups.single.products, hasLength(2));
    expect(groupsWithDiacritics.single.products, hasLength(2));
  });

  test('eşleşme yoksa boş liste döner', () {
    expect(groupProducts(products, categories, 'yok-böyle-şey'), isEmpty);
  });

  test('görünür ürünü olmayan grup atlanır', () {
    final groups = groupProducts(products, categories, 'boya');

    expect(groups, hasLength(1));
    expect(groups.single.categoryName, 'Boya');
  });
}
