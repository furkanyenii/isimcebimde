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

/// Müşteriler.
///
/// Bireysel ve kurumsal müşteri **tek tabloda** tutulur; iki tabloya bölmek
/// teklif tarafında polimorfik foreign key'e yol açardı. Alanların çoğu ortaktır,
/// tipe özel olanlar (yetkili kişi, vergi dairesi) yalnızca kurumsalda doldurulur.
///
/// [type] enum *index'i* değil, metin olarak saklanır: enum sırasını değiştiren
/// bir refactor, index saklansaydı tüm müşterileri sessizce yanlış tipe çevirirdi.
/// Geçerli değerler `CustomerType.wireName` ile aynıdır ve CHECK kısıtıyla
/// veritabanı seviyesinde garanti altına alınır — repository'de bir hata olsa
/// bile tabloya çöp değer giremez.
///
/// Boş alanlar `''` değil `NULL` tutulur; repository sınırında normalize edilir.
@DataClassName('CustomerRow')
@TableIndex(name: 'idx_customers_name', columns: {#name})
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text().withLength(min: 1, max: 20)();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get contactPerson => text().withLength(max: 200).nullable()();
  TextColumn get phone => text().withLength(max: 32).nullable()();
  TextColumn get email => text().withLength(max: 200).nullable()();
  TextColumn get address => text().withLength(max: 500).nullable()();
  TextColumn get taxOffice => text().withLength(max: 100).nullable()();
  TextColumn get taxNumber => text().withLength(max: 11).nullable()();
  TextColumn get notes => text().withLength(max: 1000).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    // Değerler CustomerType.wireName ile eşleşmek zorundadır.
    "CHECK (type IN ('individual', 'company'))",
  ];
}

/// Uygulamanın tek veri kaynağı. Backend yok — bu dosyadaki her şema
/// değişikliği geri alınamaz kullanıcı verisine dokunur (CLAUDE.md: Database Rules).
@DriftDatabase(tables: [Products, Categories, Customers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'isimcebimde'));

  /// Testlerde bellek içi veritabanı vermek için.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

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
      // Adımlar sırayla çalışır; sürüm atlanamaz (CLAUDE.md: Migration stratejisi).
      if (from < 2) {
        await _migrateV1ToV2(m);
      }
      if (from < 3) {
        // v2 → v3: müşteri modülü. Yalnızca yeni tablo — mevcut veriye dokunulmaz.
        await m.createTable(customers);
        await m.createIndex(idxCustomersName);
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
