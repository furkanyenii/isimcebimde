import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Ürün tablosu.
///
/// Fiyat **kuruş cinsinden `int`** tutulur (CLAUDE.md: para asla `double` değildir).
/// Domain'e taşınırken `Money`'ye çevrilir.
@DataClassName('ProductRow')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get priceMinor => integer()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Uygulamanın tek veri kaynağı. Backend yok — bu dosyadaki her şema
/// değişikliği geri alınamaz kullanıcı verisine dokunur (CLAUDE.md: Database Rules).
@DriftDatabase(tables: [Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'isimcebimde'));

  /// Testlerde bellek içi veritabanı vermek için.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    beforeOpen: (details) async {
      // İleride teklif → teklif satırı ilişkisi buna dayanacak.
      // SQLite'ta varsayılan KAPALI olduğu için her açılışta açılmalı.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
