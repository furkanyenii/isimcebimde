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
///
/// [vatRateBasisPoints] **kullanılmıyor**: KDV artık ürünün değil teklif
/// satırının özelliğidir (bkz. [OfferItems.vatRateBasisPoints]). Sütun, şema
/// değişikliği yıkıcı olamayacağı için duruyor (CLAUDE.md: Migration stratejisi);
/// yeni kayıtlarda varsayılan değerini alır ve hiçbir yerde okunmaz.
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

  /// Vergi/kimlik no serbest metindir: rakam, harf (büyük/küçük) içerebilir ve
  /// uzunluğu ülkeye göre değişir (TCKN 11, vergi no 10, AB VAT farklı). Bu
  /// yüzden **uzunluk sınırı yoktur**; biçim kontrolü de yapılmaz.
  TextColumn get taxNumber => text().nullable()();
  TextColumn get notes => text().withLength(max: 1000).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    // Değerler CustomerType.wireName ile eşleşmek zorundadır.
    "CHECK (type IN ('individual', 'company'))",
  ];
}

/// Bir teklif ve başlık bilgileri. Satırları [OfferItems]'tadır.
///
/// Müşteri bilgileri ([customerName], [customerContactPerson], [customerPhone],
/// [customerEmail], [customerAddress], [customerTaxOffice], [customerTaxNumber])
/// müşteri seçildiği andaki **snapshot**'tır; [customerId] silinirse `NULL` olur
/// (`ON DELETE SET NULL`) ama teklif bundan etkilenmez (CLAUDE.md: Database
/// Rules — aynı gerekçe `Products`/`Customers` için de geçerli). PDF bu
/// alanlardan basar; müşteri sonradan değişse/silinse bile geçmiş teklif
/// çıktısı bozulmaz.
@DataClassName('OfferRow')
class Offers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get customerId => integer().nullable().references(
    Customers,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get customerName => text().withLength(min: 1, max: 200)();
  TextColumn get customerContactPerson =>
      text().withLength(max: 200).nullable()();
  TextColumn get customerPhone => text().withLength(max: 32).nullable()();
  TextColumn get customerEmail => text().withLength(max: 200).nullable()();
  TextColumn get customerAddress => text().withLength(max: 500).nullable()();
  TextColumn get customerTaxOffice => text().withLength(max: 100).nullable()();

  /// Vergi no serbest metindir (bkz. `Customers.taxNumber`): uzunluk sınırı yok.
  TextColumn get customerTaxNumber => text().nullable()();

  /// ISO 4217 kodu; yalnızca gösterim etiketi, çevrim yapılmaz (bkz. `Currency`).
  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('TRY'))();

  IntColumn get generalDiscountBasisPoints =>
      integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withLength(max: 1000).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    "CHECK (currency_code IN ('TRY', 'USD', 'EUR', 'GBP'))",
  ];
}

/// Bir teklifin satırları. [productName]/[unitPriceMinor] ürünün eklendiği
/// andaki **snapshot**'ıdır; ürün sonra değişse/silinse bile satır değişmez.
///
/// [sortOrder]: teklif düzenlenirken satırlar silinip yeniden yazılır
/// (`OfferRepositoryImpl.update`); kullanıcının girdiği sıranın korunması
/// otomatik id sırasına bırakılmaz, açıkça bu sütunla garanti edilir.
///
/// [quantity] **binde bir** cinsindendir (12,5 → 12500): miktar m²/m³ gibi
/// birimlerde kesirli olur ve `double` ile tutmak fiyatı bozar (bkz. `Quantity`).
/// v8 migration'ı eski tam sayı adetleri 1000 ile çarparak taşır.
///
/// [unit] serbest metindir (`adet`, `m²` ya da kullanıcının kendi birimi);
/// yalnızca etikettir, hesaba girmez.
@DataClassName('OfferItemRow')
class OfferItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get offerId =>
      integer().references(Offers, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().nullable().references(
    Products,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get productName => text().withLength(min: 1, max: 200)();
  IntColumn get unitPriceMinor => integer()();
  IntColumn get quantity => integer()();
  TextColumn get unit =>
      text().withLength(min: 1, max: 20).withDefault(const Constant('adet'))();
  IntColumn get vatRateBasisPoints => integer()();
  IntColumn get discountBasisPoints =>
      integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<String> get customConstraints => const ['CHECK (quantity > 0)'];
}

/// Yeniden kullanılabilir bir teklif taslağı. Satırları [TemplateItems]'tadır.
///
/// [Offers]/[OfferItems] ile aynı desen — aggregate root, tek transaction'da
/// yazılır — ancak müşteri hiç yoktur: şablon müşteriden bağımsızdır.
/// [name] benzersizdir (`Categories.name` ile aynı gerekçe).
@DataClassName('TemplateRow')
class Templates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200).unique()();

  /// ISO 4217 kodu; [Offers.currencyCode] ile aynı kısıt.
  TextColumn get currencyCode =>
      text().withLength(min: 3, max: 3).withDefault(const Constant('TRY'))();

  IntColumn get generalDiscountBasisPoints =>
      integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withLength(max: 1000).nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => const [
    "CHECK (currency_code IN ('TRY', 'USD', 'EUR', 'GBP'))",
  ];
}

/// Bir şablonun satırları. [OfferItems] ile birebir aynı şekil — ayrı bir
/// domain tipi yoktur (`Template.items` zaten `OfferItem` kullanır), yalnızca
/// hangi tabloya ait olduğu farklıdır.
@DataClassName('TemplateItemRow')
class TemplateItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get templateId =>
      integer().references(Templates, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId => integer().nullable().references(
    Products,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get productName => text().withLength(min: 1, max: 200)();
  IntColumn get unitPriceMinor => integer()();
  IntColumn get quantity => integer()();
  TextColumn get unit =>
      text().withLength(min: 1, max: 20).withDefault(const Constant('adet'))();
  IntColumn get vatRateBasisPoints => integer()();
  IntColumn get discountBasisPoints =>
      integer().withDefault(const Constant(0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  List<String> get customConstraints => const ['CHECK (quantity > 0)'];
}

/// Kullanıcının kendi eklediği ölçü birimleri.
///
/// Hazır birimler koddadır (`OfferUnit`) ve burada **tutulmaz**: onlar dile göre
/// etiketlenir, bu tablo ise kullanıcının yazdığı metni olduğu gibi saklar.
/// Bir kez eklenen birim sonraki tekliflerin birim listesinde de çıkar.
@DataClassName('CustomUnitRow')
class CustomUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 20).unique()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Ayarların tutulduğu **tek satır**. [id] her zaman 1'dir ve bu, CHECK kısıtıyla
/// veritabanı seviyesinde garanti altındadır — ikinci bir ayar satırı, hangi
/// satırın geçerli olduğu sorusunu doğurur ve o soru sessiz bir hataya döner.
///
/// [languageCode] `NULL` ise "sistem dili" demektir; "seçim yapılmadı" ile
/// "Türkçe seçildi" farklı durumlardır (bkz. `AppLanguage.system`).
///
/// Firma bilgileri de burada yaşar: hepsi **opsiyoneldir** (nullable) — sahada
/// vergi dairesini doldurmadan da teklif çıkarılabilmelidir. Boş alan `''` değil
/// `NULL` tutulur; repository sınırında normalize edilir.
///
/// [companyLogoPath] görselin **kendisini değil, yolunu** tutar: blob olarak
/// saklamak veritabanını şişirir ve her okumada belleğe alınır. Yol, uygulamanın
/// belge klasörüne kopyalanmış dosyayı gösterir (bkz. `LogoStorage`) — galerinin
/// geçici yolu OS tarafından silinebilir.
@DataClassName('SettingsRow')
class Settings extends Table {
  IntColumn get id => integer()();
  TextColumn get languageCode => text().withLength(max: 8).nullable()();
  TextColumn get themeMode => text()
      .withLength(min: 1, max: 16)
      .withDefault(const Constant('system'))();

  TextColumn get companyName => text().withLength(max: 200).nullable()();
  TextColumn get companyLogoPath => text().withLength(max: 500).nullable()();
  TextColumn get companyPhone => text().withLength(max: 32).nullable()();
  TextColumn get companyEmail => text().withLength(max: 200).nullable()();
  TextColumn get companyWebsite => text().withLength(max: 200).nullable()();
  TextColumn get companyAddress => text().withLength(max: 500).nullable()();
  TextColumn get companyTaxOffice => text().withLength(max: 100).nullable()();

  /// Vergi no serbest metindir (bkz. `Customers.taxNumber`): uzunluk/biçim
  /// sınırı yoktur.
  TextColumn get companyTaxNumber => text().nullable()();

  /// Teklifi hazırlayan kişi (bkz. `PreparerInfo`). Firma bilgisinden ayrıdır:
  /// aynı firmada birden çok satış temsilcisi teklif hazırlar. Hepsi opsiyonel;
  /// PDF'in altına yalnızca doldurulanlar basılır.
  TextColumn get preparerFirstName => text().withLength(max: 100).nullable()();
  TextColumn get preparerLastName => text().withLength(max: 100).nullable()();
  TextColumn get preparerTitle => text().withLength(max: 100).nullable()();
  TextColumn get preparerEmail => text().withLength(max: 200).nullable()();
  TextColumn get preparerPhone => text().withLength(max: 32).nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<String> get customConstraints => const [
    'CHECK (id = 1)',
    // Değerler AppLanguage.languageCode / AppThemeMode.wireName ile eşleşir.
    "CHECK (language_code IN ('tr', 'en'))",
    "CHECK (theme_mode IN ('system', 'light', 'dark'))",
  ];
}

/// Ayarlar satırının sabit birincil anahtarı.
const int kSettingsRowId = 1;

/// Uygulamanın tek veri kaynağı. Backend yok — bu dosyadaki her şema
/// değişikliği geri alınamaz kullanıcı verisine dokunur (CLAUDE.md: Database Rules).
@DriftDatabase(
  tables: [
    Products,
    Categories,
    Customers,
    Settings,
    Offers,
    OfferItems,
    Templates,
    TemplateItems,
    CustomUnits,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'isimcebimde'));

  /// Testlerde bellek içi veritabanı vermek için.
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 10;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Yeni kurulumda da en az bir kategori bulunmalı: kategori zorunlu.
      await into(
        categories,
      ).insert(CategoriesCompanion.insert(name: kDefaultCategoryName));
      await _insertDefaultSettings();
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
      if (from < 4) {
        // v3 → v4: ayarlar (dil + tema). Yeni tablo; mevcut veriye dokunulmaz.
        // Satır burada yaratılır ki okuma yolu "satır yoksa" durumunu bilmesin.
        await m.createTable(settings);
        await _insertDefaultSettings();
      }
      if (from >= 4 && from < 5) {
        // v4 → v5: firma bilgileri. Yalnızca nullable sütun ekleme — mevcut
        // ayar satırı ve verisi olduğu gibi kalır (CLAUDE.md: alan ekleme serbest).
        //
        // `from < 4` koşulu bilinçli olarak dışarıda: yukarıdaki `createTable`
        // tabloyu **güncel** tanımıyla (firma sütunları dahil) yaratır; aynı
        // sütunları bir de burada eklemek "duplicate column" hatası verir.
        await m.addColumn(settings, settings.companyName);
        await m.addColumn(settings, settings.companyLogoPath);
        await m.addColumn(settings, settings.companyPhone);
        await m.addColumn(settings, settings.companyEmail);
        await m.addColumn(settings, settings.companyWebsite);
        await m.addColumn(settings, settings.companyAddress);
        await m.addColumn(settings, settings.companyTaxOffice);
        await m.addColumn(settings, settings.companyTaxNumber);
      }
      if (from < 6) {
        // v5 → v6: teklif modülü. Yalnızca yeni tablolar — mevcut veriye dokunulmaz.
        await m.createTable(offers);
        await m.createTable(offerItems);
      }
      if (from < 7) {
        // v6 → v7: şablon modülü. Yalnızca yeni tablolar — mevcut veriye dokunulmaz.
        await m.createTable(templates);
        await m.createTable(templateItems);
      }
      if (from < 8) {
        await _migrateV7ToV8(m, from);
      }
      if (from >= 4 && from < 9) {
        // v8 → v9: teklifi hazırlayan kişi. Yalnızca nullable sütun ekleme.
        //
        // `from >= 4` koşulu v4 → v5 adımıyla aynı gerekçeye dayanır: daha eski
        // bir sürümden geliniyorsa `settings` tablosu yukarıda zaten **güncel**
        // tanımıyla (bu sütunlar dahil) yaratılmıştır.
        await m.addColumn(settings, settings.preparerFirstName);
        await m.addColumn(settings, settings.preparerLastName);
        await m.addColumn(settings, settings.preparerTitle);
        await m.addColumn(settings, settings.preparerEmail);
        await m.addColumn(settings, settings.preparerPhone);
      }
      if (from >= 6 && from < 10) {
        // v9 → v10: müşteri iletişim/vergi bilgileri teklife snapshot'lanır.
        // Yalnızca nullable sütun ekleme — mevcut teklifler olduğu gibi kalır,
        // yeni alanları `NULL` gelir (eski tekliflerde müşteri detayı yoktu).
        //
        // `from >= 6` koşulu v4 → v5 / v8 → v9 adımlarıyla aynı gerekçeye
        // dayanır: `offers` tablosu v6'da yaratılıyor; daha eski bir sürümden
        // geliniyorsa yukarıdaki `createTable` onu zaten **güncel** tanımıyla
        // (bu sütunlar dahil) kurmuştur.
        await m.addColumn(offers, offers.customerPhone);
        await m.addColumn(offers, offers.customerEmail);
        await m.addColumn(offers, offers.customerAddress);
        await m.addColumn(offers, offers.customerTaxOffice);
        await m.addColumn(offers, offers.customerTaxNumber);
      }
    },
    beforeOpen: (details) async {
      // Teklif → teklif satırı ilişkisi buna dayanacak.
      // SQLite'ta varsayılan KAPALI olduğu için her açılışta açılmalı.
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Varsayılan ayar satırı: sistem dili, sistem teması. Zaten varsa dokunmaz.
  Future<void> _insertDefaultSettings() => into(settings).insert(
    const SettingsCompanion(id: Value(kSettingsRowId)),
    mode: InsertMode.insertOrIgnore,
  );

  /// v7 → v8: teklif satırında birim + kesirli miktar, kullanıcı birimleri.
  ///
  /// **Miktarın anlamı değişir**: adet → binde bir. Mevcut satırlar 1000 ile
  /// çarpılarak taşınır; bu adım atlanırsa kullanıcının "3 adet"i "0,003"e
  /// döner. Sütun tipi ve `CHECK (quantity > 0)` kısıtı aynı kalır, veri
  /// silinmez (CLAUDE.md: şema değişikliği yıkıcı olamaz).
  ///
  /// [from] parametresi zorunlu: teklif (v6) ve şablon (v7) tabloları bu
  /// sürümden önce yaratılıyorsa yukarıdaki `createTable` onları zaten **güncel**
  /// tanımıyla (unit sütunu dahil, tablo boş) kurar — aynı sütunu bir de burada
  /// eklemek "duplicate column" hatası verirdi.
  Future<void> _migrateV7ToV8(Migrator m, int from) async {
    await m.createTable(customUnits);

    if (from >= 6) {
      await m.addColumn(offerItems, offerItems.unit);
      await customStatement(
        'UPDATE offer_items SET quantity = quantity * 1000',
      );
    }
    if (from >= 7) {
      await m.addColumn(templateItems, templateItems.unit);
      await customStatement(
        'UPDATE template_items SET quantity = quantity * 1000',
      );
    }
  }

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
