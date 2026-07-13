import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Product>> watchAll() {
    final query = _db.select(_db.products)
      ..where((p) => p.isArchived.equals(false))
      ..orderBy([(p) => OrderingTerm.asc(p.name)]);

    return query
        .watch()
        .map((rows) => rows.map(_toDomain).toList())
        .handleError(
          (Object e) => throw DatabaseFailure('Ürünler okunamadı.', cause: e),
        );
  }

  @override
  Future<void> add(Product product) async {
    try {
      await _db
          .into(_db.products)
          .insert(
            ProductsCompanion.insert(
              name: product.name,
              priceMinor: product.price.minor,
              categoryId: product.categoryId,
              vatRateBasisPoints: Value(product.vatRate.basisPoints),
            ),
          );
    } on Object catch (e) {
      // Ham Drift hatası üst katmana çıkmaz (CLAUDE.md: Database Rules).
      throw DatabaseFailure('Ürün kaydedilemedi.', cause: e);
    }
  }

  Product _toDomain(ProductRow row) => Product(
    id: row.id,
    name: row.name,
    price: Money(row.priceMinor),
    categoryId: row.categoryId,
    vatRate: Percent.fromBasisPoints(row.vatRateBasisPoints),
    isArchived: row.isArchived,
  );
}
