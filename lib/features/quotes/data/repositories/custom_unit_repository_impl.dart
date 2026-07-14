import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/custom_unit_repository.dart';

class CustomUnitRepositoryImpl implements CustomUnitRepository {
  const CustomUnitRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<String>> watchAll() {
    final statement = _db.select(_db.customUnits)
      ..orderBy([(u) => OrderingTerm.asc(u.createdAt)]);

    return statement
        .watch()
        .map((rows) => rows.map((row) => row.name).toList())
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.customUnit,
            cause: e,
          ),
        );
  }

  @override
  Future<void> add(String unit) async {
    final name = unit.trim();
    if (name.isEmpty) {
      throw const EmptyNameFailure(EntityKind.customUnit);
    }

    try {
      // Aynı birimi ikinci kez eklemek hata değil, sessizce yok sayılır:
      // kullanıcı "m2" yazıp listede zaten "m2" varsa uyarmanın bir faydası yok.
      await _db
          .into(_db.customUnits)
          .insert(
            CustomUnitsCompanion.insert(name: name),
            mode: InsertMode.insertOrIgnore,
          );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.create,
        EntityKind.customUnit,
        cause: e,
      );
    }
  }
}
