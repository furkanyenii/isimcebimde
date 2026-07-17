import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/domain/repositories/category_repository.dart';
import 'package:sqlite3/common.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  const CategoryRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Category>> watchAll() {
    final query = _db.select(_db.categories)
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Stream<Set<int>> watchUsedCategoryIds() {
    // Ürün tablosunda geçen distinct kategori id'leri. Tam ürün listesini
    // taşımaya gerek yok; yalnızca "bu kategori kullanılıyor mu" bilgisi lazım.
    final query = _db.selectOnly(_db.products, distinct: true)
      ..addColumns([_db.products.categoryId]);

    return query.watch().map(
      (rows) => rows.map((row) => row.read(_db.products.categoryId)!).toSet(),
    );
  }

  @override
  Future<int> create(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw const EmptyNameFailure(EntityKind.category);
    }

    try {
      return await _db
          .into(_db.categories)
          .insert(CategoriesCompanion.insert(name: trimmed));
    } on SqliteException catch (e) {
      // Benzersizlik kısıtı veritabanı seviyesinde; yarış durumunda da tutar.
      if (e.extendedResultCode == _uniqueConstraintCode) {
        throw DuplicateCategoryFailure(trimmed, cause: e);
      }
      throw DatabaseFailure(
        DataOperation.create,
        EntityKind.category,
        cause: e,
      );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.create,
        EntityKind.category,
        cause: e,
      );
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
    } on SqliteException catch (e) {
      // FK kısıtı (ON DELETE RESTRICT): kategoriye bağlı ürün var.
      //
      // Genişletilmiş hata kodu SQLite sürümüne/tablonun nasıl yeniden
      // yazıldığına göre değişebiliyor (787 yerine 1811 de görüldü), bu yüzden
      // sihirli sayıya değil, birincil kısıt koduna ve mesaja bakılır.
      if (_isForeignKeyViolation(e)) {
        throw CategoryInUseFailure(cause: e);
      }
      throw DatabaseFailure(
        DataOperation.delete,
        EntityKind.category,
        cause: e,
      );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.delete,
        EntityKind.category,
        cause: e,
      );
    }
  }

  /// SQLITE_CONSTRAINT_UNIQUE
  static const int _uniqueConstraintCode = 2067;

  /// SQLITE_CONSTRAINT
  static const int _constraintCode = 19;

  static bool _isForeignKeyViolation(SqliteException e) =>
      e.resultCode == _constraintCode &&
      e.message.toUpperCase().contains('FOREIGN KEY');

  Category _toDomain(CategoryRow row) => Category(id: row.id, name: row.name);
}
