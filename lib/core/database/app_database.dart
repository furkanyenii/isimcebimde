import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Varsayılan kategorinin adı. Migration sırasında kategorisiz kalan ürünler
/// buraya bağlanır — kategori zorunlu olduğu için hiçbir ürün boşta kalamaz.
const String kDefaultCategoryName = 'Genel';

/// Ürün kategorileri.
@DataClassName('CategoryRow')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100).unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Ürün tablosu.
///
/// Fiyat **kuruş cinsinden `int`** tutulur (CLAUDE.md: para asla `double` değildir).
/// KDV oranı baz puan olarak tutulur (2000 = %20) ve ürünün *varsayılanıdır*;
/// teklif satırına kopyalanır ve orada değiştirilebilir.
@DataClassName('ProductRow')
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  IntColumn get priceMinor => integer()();
  IntColumn get vatRateBasisPoints =>
      integer().withDefault(const Constant(2000))();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.restrict)();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Uygulamanın tek veri kaynağı. Backend yok — bu dosyadaki her şema
/// değişikliği geri alınamaz kullanıcı verisine dokunur (CLAUDE.md: Database Rules).
@DriftDatabase(tables: [Products, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'isimcebimde'));

  /// Testlerde bellek içi veritabanı vermek için.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Yeni kurulumda da en az bir kategori bulunmalı: kategori zorunlu.
      await into(
        categories,
      ).insert(CategoriesCompanion.insert(name: kDefaultCategoryName));
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await _migrateV1ToV2(m);
      }
    },
    beforeOpen: (details) async {
      // Teklif → teklif satırı ilişkisi buna dayanacak.
      // SQLite'ta varsayılan KAPALI olduğu için her açılışta açılmalı.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// v1 → v2: kategori sistemi ve ürün KDV oranı.
  ///
  /// Kategori **zorunlu** olduğu için `category_id` doğrudan NOT NULL olarak
  /// eklenemez: mevcut ürünlerin değeri olmaz ve migration veri kaybıyla patlar.
  /// Bu yüzden sıra şudur — önce varsayılan kategori yaratılır, sütun eklenir,
  /// mevcut ürünler ona bağlanır (backfill), NOT NULL kısıtı en sona bırakılır.
  Future<void> _migrateV1ToV2(Migrator m) async {
    await m.createTable(categories);
    await m.addColumn(products, products.vatRateBasisPoints);

    final defaultCategoryId = await into(categories).insert(
      CategoriesCompanion.insert(name: kDefaultCategoryName),
      mode: InsertMode.insertOrIgnore,
    );

    // Sütun geçici olarak nullable eklenir; Drift'in kendi addColumn'ı NOT NULL
    // bir sütunu default'suz ekleyemeyeceği için ham SQL kullanılır.
    await customStatement(
      'ALTER TABLE products ADD COLUMN category_id INTEGER '
      'REFERENCES categories (id) ON DELETE RESTRICT',
    );
    await customStatement(
      'UPDATE products SET category_id = ? WHERE category_id IS NULL',
      [defaultCategoryId],
    );

    // NOT NULL kısıtını uygulamak için tabloyu yeniden yaz. Bu, backfill
    // tamamlandıktan SONRA yapılır — aksi halde mevcut satırlar kaybolurdu.
    await m.alterTable(TableMigration(products));
  }
}
