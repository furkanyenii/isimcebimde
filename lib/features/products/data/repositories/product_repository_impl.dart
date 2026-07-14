import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Product>> watchAll({String? query, int? categoryId}) {
    final statement = _db.select(_db.products)
      ..where((p) => p.isArchived.equals(false))
      ..orderBy([(p) => OrderingTerm.asc(p.name)]);

    if (categoryId != null) {
      statement.where((p) => p.categoryId.equals(categoryId));
    }

    final search = query ?? '';

    return statement
        .watch()
        .map((rows) => rows.map(_toDomain).toList())
        .map(
          // Arama SQL'de değil Dart'ta filtrelenir; gerekçe: core/utils/turkish_text.dart
          (products) => products
              .where((p) => containsNormalized(p.name, search))
              .toList(),
        )
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.product,
            cause: e,
          ),
        );
  }

  @override
  Stream<Product?> watchById(int id) {
    final statement = _db.select(_db.products)..where((p) => p.id.equals(id));

    return statement.watchSingleOrNull().map(
      (row) => row == null ? null : _toDomain(row),
    );
  }

  @override
  Future<int> create(Product product) async {
    _validate(product);
    try {
      return await _db
          .into(_db.products)
          .insert(
            ProductsCompanion.insert(
              name: product.name.trim(),
              priceMinor: product.price.minor,
              categoryId: product.categoryId,
              vatRateBasisPoints: Value(product.vatRate.basisPoints),
            ),
          );
    } on Object catch (e) {
      // Ham Drift hatası üst katmana çıkmaz (CLAUDE.md: Database Rules).
      throw DatabaseFailure(DataOperation.create, EntityKind.product, cause: e);
    }
  }

  @override
  Future<void> update(Product product) async {
    final id = product.id;
    if (id == null) {
      throw const UnsavedEntityFailure(EntityKind.product);
    }
    _validate(product);

    try {
      await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
        ProductsCompanion(
          name: Value(product.name.trim()),
          priceMinor: Value(product.price.minor),
          categoryId: Value(product.categoryId),
          vatRateBasisPoints: Value(product.vatRate.basisPoints),
        ),
      );
    } on Object catch (e) {
      throw DatabaseFailure(DataOperation.update, EntityKind.product, cause: e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await (_db.delete(_db.products)..where((p) => p.id.equals(id))).go();
    } on Object catch (e) {
      throw DatabaseFailure(DataOperation.delete, EntityKind.product, cause: e);
    }
  }

  /// İş kuralları domain sınırında zorunlu kılınır; UI'ın doğrulama yapması
  /// yeterli değildir (repository başka yerden de çağrılabilir).
  void _validate(Product product) {
    if (product.name.trim().isEmpty) {
      throw const EmptyNameFailure(EntityKind.product);
    }
    if (product.price.isNegative) {
      throw const NegativePriceFailure();
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
