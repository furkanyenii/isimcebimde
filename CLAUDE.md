# CLAUDE.md

Bu dosya, bu repoda çalışan her geliştiricinin (insan veya AI) uyması zorunlu olan mimari ve kalite sözleşmesidir.
Bir talep bu dosyadaki kurallarla çelişiyorsa: **önce çelişkiyi belirt, sonra onay iste.** Sessizce kural esnetme.

---

## Project Overview

**Quotra** (paket adı: `isimcebimde`), saha satış ekipleri, pazarlamacılar ve KOBİ'ler için geliştirilen, **tamamen offline çalışan mobil teklif hazırlama uygulamasıdır.**

Kullanıcı uygulama üzerinden:

- Ürünlerini yönetir (ekle / düzenle / arşivle)
- Ürünlerini kategorilere ayırır
- Müşterilerini kaydeder
- Dakikalar içinde teklif oluşturur
- Teklifi **PDF** veya **Excel** olarak dışa aktarır
- WhatsApp, e-posta ve diğer uygulamalar üzerinden paylaşır

### Hedef kullanıcı kitlesi

- Sahada, çoğu zaman internetsiz veya zayıf bağlantıda çalışan satış temsilcileri
- Ofis/muhasebe altyapısı olmayan küçük işletme sahipleri
- Müşteri karşısında **anında** fiyat verip teklif göndermesi gereken kullanıcılar

Bu kitle "Excel'de teklif hazırlayıp WhatsApp'tan atan" kullanıcıdır. Rakibimiz başka bir uygulama değil, **Excel ve WhatsApp'tır.** Ürün, o akıştan daha hızlı olmadığı gün başarısızdır.

### Ürün vizyonu

> Müşterinin karşısındayken, internetsiz, 60 saniyede profesyonel teklif.

Bu vizyon üç mühendislik kısıtına çevrilir ve **hepsi bağlayıcıdır**:

1. **Offline-first, taviz yok.** Hiçbir kritik akış network'e bağlı olamaz. Ağ yoksa uygulama tam işlevlidir.
2. **Hız bir feature'dır.** Teklif oluşturma akışı minimum adımda tamamlanır. "Bir ekran daha ekleyelim" varsayılan olarak reddedilir.
3. **Veri kutsaldır.** Kullanıcının tek veri kopyası cihazdadır. Veri kaybı = ürün ölümü. Migration ve backup kuralları (bkz. Database Rules) pazarlıksızdır.

### Ölçeklenebilirlik hedefi

Bugün backend **yoktur**. Ancak mimari; **Cloud senkronizasyon, ekip çalışması ve CRM** özellikleri ileride eklenebilecek şekilde kurgulanır. Bunun tek pratik karşılığı şudur:

- UI ve state katmanı **asla** veritabanını (`AppDatabase`) veya Drift tiplerini görmez.
- Repository arayüzleri `domain` katmanında tanımlanır; `data` katmanı onları implemente eder.
- Bugün tek data source var: `LocalDataSource`. Yarın `RemoteDataSource` eklendiğinde **presentation katmanında tek satır değişmemelidir.**

Bunun ötesinde spekülatif genelleme yapma. Sync için bugünden abstraction katmanı, event queue veya conflict resolver **yazma** (YAGNI). Sadece yolu kapatma.

---

## Tech Stack

| Katman | Teknoloji | Not |
|---|---|---|
| Framework | Flutter (stable) | Şu an 3.44.x |
| Dil | Dart 3.x | `sdk: ^3.12.2` |
| State Management | **Riverpod** (code generation ile) | `riverpod_annotation` + `riverpod_generator` |
| Database | **Drift** (SQLite) | Lokal, offline-first, tek kaynak. Karar gerekçesi aşağıda. |
| Routing | **GoRouter** | Declarative, type-safe route'lar |
| Design System | **Material 3** | `useMaterial3: true`, dinamik tema |
| Mimari | **Clean Architecture** + **Feature-First** | domain / data / presentation |
| Desenler | **Repository Pattern**, **SOLID** | |
| Export | PDF (+ CSV) | `pdf` / `printing`. Gerçek `.xlsx` henüz yok — aşağıya bakınız. |
| Paylaşım | `share_plus` | WhatsApp/e-posta OS share sheet üzerinden |

### Neden Isar değil, Drift?

Proje başlangıcında Isar planlanmıştı. Bağımlılıklar kurulmadan önce yapılan doğrulama bunu geçersiz kıldı; karar bilinçlidir ve geri alınmamalıdır:

- **Resmi `isar` (3.1.0+1, Nisan 2023) kullanılamaz.** Native kütüphanelerinin ELF hizalaması 4KB (`p_align = 0x1000`). Google Play'in 16KB page size zorunluluğu 1 Mayıs 2026'da yürürlüğe girdi — bu paketle mağazaya güncelleme gönderilemez.
- **Domain ilişkiseldir.** Ürün → kategori, müşteri → teklif → teklif satırı, KDV/iskonto toplamları. Bu, SQL'in var olma sebebidir.
- **Backend yok, veri kutsaldır.** Drift, şema versiyonlama ve **migration'ları test edebilme** altyapısı sunar. "Migration testsiz merge edilmez" kuralını fiilen uygulanabilir kılan tek seçenek budur.

### Excel export hakkında

`excel` paketi bayat (son yayın Ağustos 2024). `syncfusion_flutter_xlsio` aktiftir ancak **ticari lisans kısıtı taşır** ve hukuki karar gerektirir. Bu netleşene kadar "Excel'e aktar" ihtiyacı **CSV** ile karşılanır (Excel doğrudan açar, sıfır bağımlılık). Gerçek `.xlsx` üretmeden önce lisans kararı alınmalıdır.

### Bağımlılık ekleme kuralı

Yeni bir pakete **karar vermeden önce sor.** Her paket bir bakım yüküdür. Eklemeden önce şunları cevapla:

- Bu iş 50 satır kendi kodumuzla çözülür mü?
- Paket son 12 ayda güncellenmiş mi, null-safety ve güncel Flutter ile uyumlu mu?
- Platform kanalı (native) gerektiriyor mu? Gerekiyorsa iOS + Android desteği tam mı?

`dependencies` listesine giren her satırın gerekçesi PR açıklamasında yer alır.

---

## Project Rules

### Folder Structure

Feature-first. Katman değil, **özellik** birinci sınıf vatandaştır.

```
lib/
├── main.dart                  # Sadece bootstrap: ensureInitialized, Isar open, ProviderScope
├── app/
│   ├── app.dart               # MaterialApp.router
│   ├── router/                # GoRouter config, route isimleri, guard'lar
│   └── di/                    # Isar instance, override'lar, bootstrap provider'ları
├── core/                      # Feature'lardan BAĞIMSIZ, her yerden kullanılabilir kod
│   ├── constants/             # AppSizes, AppDurations
│   ├── theme/                 # AppTheme (Material 3, light + dark)
│   ├── database/              # app_database.dart — Drift şeması, migration'lar
│   ├── extensions/            # BuildContext, num, DateTime, String extension'ları
│   ├── errors/                # Failure hiyerarşisi
│   ├── utils/                 # Money, Percent, formatter'lar, validator'lar
│   └── widgets/               # Uygulama geneli reusable widget'lar (AppEmptyView…)
├── features/
│   ├── products/
│   │   ├── domain/            # Saf Dart. Flutter/Drift import'u YASAK.
│   │   │   ├── entities/      # product.dart          (immutable model)
│   │   │   └── repositories/  # product_repository.dart (abstract interface)
│   │   ├── data/
│   │   │   └── repositories/  # product_repository_impl.dart (Drift → domain)
│   │   └── presentation/
│   │       ├── providers/     # product_list_provider.dart
│   │       ├── screens/       # product_list_screen.dart
│   │       └── widgets/       # product_card.dart     (sadece bu feature'a ait)
│   ├── categories/
│   ├── customers/
│   ├── quotes/                # Çekirdek feature: teklif oluşturma + export + share
│   └── settings/              # Firma bilgisi, logo, para birimi, KDV varsayılanı
└── l10n/                      # Lokalizasyon (arb dosyaları)
```

**Bağımlılık yönü tek yönlüdür ve ihlal edilemez:**

```
presentation ──> domain <── data
```

- `domain` hiçbir şeye bağımlı değildir. `package:flutter` bile import edilmez.
- `presentation` **asla** `data` katmanından import yapmaz.
- Bir feature başka bir feature'ın `data` veya `presentation` katmanını import edemez. Sadece `domain` üzerinden konuşur (ör. `quotes`, `products/domain/entities/product.dart` kullanabilir).
- Ortak bir şey iki feature'a birden lazımsa `core/` altına taşınır.

### Dosya isimlendirme

- Dosyalar: `snake_case.dart`
- Bir dosya = bir public sınıf. İstisna: sadece o sınıfa ait küçük yardımcılar.
- Suffix zorunlu ve tutarlı: `*_screen.dart`, `*_provider.dart`, `*_repository.dart`, `*_repository_impl.dart`, `*_local_data_source.dart`, `*_model.dart`, `*_card.dart`
- Generated dosyalar (`*.g.dart`, `*.freezed.dart`) **elle düzenlenmez** ve git'e commit **edilir**.

### Naming Convention

- Sınıflar: `PascalCase` — `QuoteRepositoryImpl`
- Değişken/metod: `camelCase` — `calculateGrandTotal()`
- Sabitler: `static const` + `camelCase` — `AppSizes.paddingMedium`
- Private: `_` öneki — `_buildHeader()`
- Boolean isimleri soru gibi okunur: `isLoading`, `hasDiscount`, `canExport`
- Domain dilini koru. Türkçe iş terimlerini koda **çevirme, karıştırma:** `Quote`, `QuoteLine`, `Customer`, `Product`, `Category`. Kod İngilizce, kullanıcıya görünen metin Türkçe.

### Widget yapısı

- Bir widget = bir sorumluluk. Ekran widget'ı **layout'u kurar**, iş yapmaz.
- **`_buildXxx()` metodu yazma.** Bir parçayı ayırma ihtiyacı duyduysan onu ayrı bir `Widget` sınıfına çıkar. `_build*` metodları rebuild'i optimize etmez ve dosyayı şişirir.
- Widget dosyası 150 satırı geçiyorsa parçalanması gerekiyor demektir.
- `const` kullanılabilecek her yerde `const` kullan. Bu bir stil tercihi değil, rebuild maliyetidir.
- Widget ağacı 3 seviyeden fazla iç içe geçtiyse, alt ağacı ayrı widget'a çıkar.

### State Management

- Tek state çözümü **Riverpod**'dur. `setState` yalnızca widget'ın tamamen kendine ait, dışarı sızmayan geçici UI state'i için serbesttir (ör. `AnimationController`, `TextEditingController`, açık/kapalı expansion paneli).
- Business state **her zaman** provider'da yaşar.
- `StatefulWidget` gerekliyse gerekçesi yorum satırıyla yazılır.
- State immutable'dır. Listeyi/objeyi yerinde mutasyona uğratma; yeni instance üret (`copyWith`).

### Dependency Injection

- DI **sadece Riverpod ile** yapılır. `get_it`, service locator, singleton, global değişken **yasaktır**.
- Veritabanı tek bir `keepAlive` provider'da yaşar ve dispose'da kapatılır (`app/di/database_provider.dart`):

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
```

Testte bellek içi veritabanı ile override edilir:

```dart
ProviderScope(
  overrides: [
    appDatabaseProvider.overrideWithValue(
      AppDatabase.forTesting(NativeDatabase.memory()),
    ),
  ],
  child: ...,
);
```

- Repository'ler provider üzerinden sağlanır ve **arayüz tipiyle** döner. Bu, test'te tek satırla sahte repository takmayı mümkün kılar:

```dart
@Riverpod(keepAlive: true)
ProductRepository productRepository(Ref ref) =>
    ProductRepositoryImpl(ref.watch(productLocalDataSourceProvider));
```

---

## Coding Standards

- **Kod tekrarından kaçın.** Aynı mantık ikinci kez yazılıyorsa dur ve ortak bir yere çıkar. Üçüncü kez yazılıyorsa bu bir hatadır.
- **Tek sorumluluk.** Her widget, sınıf ve fonksiyon tek bir şeyden sorumludur. Bir fonksiyonu açıklarken "ve" demek zorunda kalıyorsan böl.
- **StatelessWidget varsayılandır.** `ConsumerWidget` sadece o widget provider dinliyorsa kullanılır. Provider'ı üstte dinleyip aşağı veri geçmek, tüm alt ağacı `ConsumerWidget` yapmaktan iyidir — ama bu da prop drilling'e dönüşüyorsa, dinlemeyi ihtiyaç duyulan yere indir.
- **Magic number yok.** Her ölçü `AppSizes`, her süre `AppDurations` altında tanımlıdır.
  ```dart
  // Yanlış
  padding: const EdgeInsets.all(16),
  // Doğru
  padding: const EdgeInsets.all(AppSizes.md),
  ```
- **Hardcoded string yok.** Kullanıcıya görünen her metin lokalizasyon dosyasından gelir (`context.l10n.quoteCreated`). Log ve exception mesajları bu kuralın dışındadır.
- **Extension kullan.** Tekrar eden erişimleri kısalt, ama extension'ı çöplüğe çevirme:
  ```dart
  extension BuildContextX on BuildContext {
    ThemeData get theme => Theme.of(this);
    ColorScheme get colors => Theme.of(this).colorScheme;
    TextTheme get textStyles => Theme.of(this).textTheme;
    AppLocalizations get l10n => AppLocalizations.of(this)!;
  }
  ```
- **Reusable widget geliştir.** İki farklı ekranda benzeyen bir görsel bileşen varsa, `core/widgets/` altına parametrik tek bir widget olarak taşı.
- **Para asla `double` değildir.** Kuruş cinsinden `int` olarak sakla ve hesapla. `0.1 + 0.2 != 0.3` hatası bir teklif uygulamasında müşteriye yanlış fiyat vermek demektir. Formatlama sadece görüntüleme anında yapılır (`Money` value object + `intl`).
- Yuvarlama kuralı tek bir yerde tanımlıdır (`core/utils/money.dart`). KDV ve iskonto hesapları **satır bazında** yapılır, sonra toplanır — toplam üzerinden geriye doğru hesaplanmaz.
- `dynamic` ve implicit `var` kaçınılır; public API'lerde dönüş tipi her zaman açık yazılır.
- Async fonksiyonlarda `BuildContext` await sonrası kullanılacaksa `if (!context.mounted) return;` zorunludur.
- `print` yasak. Loglama `core/utils/logger.dart` üzerinden.
- Yorum satırı **neden**'i açıklar, **ne**'yi değil. Kodun ne yaptığını tekrar eden yorum silinir.

---

## UI Rules

- **Material 3.** `ThemeData(useMaterial3: true)`. Renkler `ColorScheme.fromSeed` ile üretilir; widget içinde **doğrudan renk sabiti (`Colors.blue`) kullanılmaz**, `context.colors.primary` kullanılır. Light + Dark tema ilk günden desteklenir.
- **Responsive.** Sabit genişlik/yükseklik verme. `LayoutBuilder`, `Flexible`, `Expanded`, `Wrap` kullan. Tablet ve katlanabilir cihazlarda kırılmamalı. Teklif ekranı yatay modda da kullanılabilir olmalı (sahada tablet kullanımı hedef senaryodur).
- **Minimal ve modern.** Boşluk (whitespace) bir tasarım aracıdır. Ekran başına tek birincil eylem (tek FAB / tek dolu buton).
- **Accessibility.** Dokunma hedefi min 48x48. Kontrast oranı WCAG AA. İkon-only butonlara `tooltip`/`Semantics` etiketi. Yazı tipi ölçekleme (`textScaleFactor`) 1.3'e kadar layout'u bozmamalı.
- **Her asenkron ekran üç durumu da kapsar. Bu opsiyonel değildir:**
  - **Loading** — skeleton/shimmer tercih edilir; tam ekran spinner son çare.
  - **Error** — kullanıcı diliyle anlaşılır mesaj + **tekrar dene** aksiyonu. Stack trace kullanıcıya gösterilmez.
  - **Empty** — açıklayıcı görsel + tek net eylem ("İlk ürününü ekle").
  Bu üç durum `core/widgets/` altındaki ortak bileşenlerle karşılanır; her ekranda yeniden yazılmaz.
- Kullanıcı verisini silen her aksiyon onay ister ve mümkünse geri alınabilir (`SnackBar` + undo).

---

## Riverpod Rules

> **Teknik borç:** `riverpod_lint`/`custom_lint` şu an kurulamıyor — `custom_lint` eski bir `analyzer` sürümüne bağlı ve `drift_dev` ile çakışıyor. Bu yüzden aşağıdaki kurallar **analyzer tarafından denetlenmiyor**, code review'da elle kontrol edilmeleri gerekiyor. `custom_lint` yetiştiğinde geri eklenecek.

- **Kod üretimi (`@riverpod`) zorunludur.** Elle `StateNotifierProvider`, `ChangeNotifierProvider` yazılmaz. `StateProvider` yalnızca basit UI filtresi/seçimi için kabul edilir.
- **İsimlendirme:** provider fonksiyonu `camelCase`, üretilen provider `xxxProvider` olur.
  - Veri okuyan: `productListProvider`, `quoteByIdProvider`
  - Mutasyon/işlem yapan Notifier: `QuoteFormController`, `ProductController` (`*Controller` suffix'i)
- **AsyncValue:**
  - `AsyncValue`'yu **asla** `.value!` veya `.requireValue` ile zorlamayın (sadece varlığı garanti edilmiş noktalarda).
  - UI'da her zaman `.when(data:, loading:, error:)` (veya `AsyncValueWidget` sarmalayıcısı) kullan. Loading ve error kolları boş bırakılamaz.
  - Notifier içinde mutasyon:
    ```dart
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repository.save(quote));
    ```
    `try/catch` ile elle state set etmek yerine `AsyncValue.guard` kullan.
- **Ref kullanımı:**
  - `build` içinde **her zaman** `ref.watch`. `ref.read` **asla** `build` içinde kullanılmaz.
  - `ref.read` yalnızca event handler (`onPressed`, `onSubmit`) içinde.
  - `ref.listen` yalnızca yan etki için: SnackBar, dialog, navigasyon.
  - Provider dispose olduğunda temizlenmesi gereken her kaynak için `ref.onDispose` yazılır.
  - Otomatik dispose varsayılandır. `keepAlive` sadece gerçekten uygulama ömrü boyu yaşaması gereken şeyler içindir (Isar, repository'ler).
- **Organizasyon:** Provider'lar ait oldukları feature'ın `presentation/providers/` klasöründe yaşar. Global `providers.dart` çöplüğü **yasaktır**. Repository provider'ları ise `data/` yakınında değil, feature'ın DI noktasında tanımlanır ve arayüz tipiyle döner.
- Provider'lar arası bağımlılık `ref.watch` ile kurulur; bir provider başka bir provider'ın state'ini elle kopyalamaz.
- Drift `Stream`'leri (`watch()`) `@riverpod Stream<...>` ile expose edilir — DB değişince UI kendiliğinden güncellenir. Manuel `invalidate` çağrısı bir kod kokusudur; önce reaktif zinciri düzelt.

---

## Database Rules

Veritabanı, kullanıcının **tek** veri kopyasıdır. Backend yok, sunucuda yedek yok. Bu bölümdeki kurallar diğerlerinden daha katıdır.

Veritabanı `lib/core/database/app_database.dart` içinde tanımlıdır.

> **Tuzak:** Drift tabloları, üretilen sembolleri (`db.products`, `ProductsCompanion`) **tüketen** dosyayla aynı dosyada tanımlanırsa, kod üretimi tabloları sessizce boş üretir. Veritabanı her zaman kendi dosyasında yaşar.

### Tablo kuralları

- Tablolar Drift `Table` sınıflarıdır ve **persistence detayıdır**, domain modeli değildir. `@DataClassName('ProductRow')` ile domain entity'sinden (`Product`) ayrı isimlendirilir.
- **Para her zaman `IntColumn` (kuruş).** `RealColumn` ile para tutmak yasaktır.
- Sorgulanan/sıralanan alanlar indekslenir.
- İlişkiler gerçek foreign key ile kurulur (`references(...)`). `PRAGMA foreign_keys = ON` her açılışta `beforeOpen` içinde verilir — SQLite'ta varsayılan kapalıdır.
- **Teklif satırı (`QuoteLine`) ürünün o anki fiyatını ve adını kopyalar (snapshot).** Ürün fiyatı sonra değişse bile geçmiş teklif değişmez. Satır, `Product`'a canlı FK ile bağlanıp fiyatı oradan okumaz — bu bir muhasebe doğruluğu gereğidir, optimizasyon değil.
- Row ↔ Entity dönüşümü `data/repositories/` içinde yapılır (`_toDomain`). Domain entity'si Drift anotasyonu **taşımaz**.

### Repository Pattern

- Arayüz `domain/repositories/` altında, implementasyon `data/repositories/` altındadır.
- Repository **domain entity'si döner**, asla Drift row'u değil.
- Repository dışına Drift tipi (`AppDatabase`, `ProductRow`, `Companion`, `Selectable`) **sızmaz**.
- Hatalar repository sınırında yakalanır ve `Failure`'a çevrilir (`core/errors/failure.dart`). Ham Drift hatası üst katmana çıkmaz.
- Okuma tercihen `Stream` döner (`watch()`); DB değişince UI kendiliğinden güncellenir. Manuel `invalidate` bir kod kokusudur.
- Birden fazla tabloya dokunan yazma işlemi `db.transaction(...)` içinde yapılır. Teklif ve satırlarını kaydetmek **tek transaction**'dır — yarım kaydedilmiş teklif kabul edilemez.

### Migration stratejisi

Kullanıcının cihazındaki veri geri getirilemez. Bu yüzden:

1. **Şema değişikliği yıkıcı olamaz.** Alan ekleme serbesttir (nullable veya default değerli). Alan **silme** ve **tip değiştirme** doğrudan yapılamaz; önce yeni alan eklenir, veri taşınır, eski alan bir sonraki sürümde kaldırılır.
2. Her şema değişikliğinde `schemaVersion` artırılır ve `MigrationStrategy.onUpgrade` içine adım eklenir. Adımlar **sırayla** çalışır; sürüm atlanamaz.
3. **Migration testsiz merge edilmez.** Drift'in şema dökümü (`drift_dev schema dump` / `schema generate`) ile eski sürümden yeni sürüme geçiş testi yazılır. Bu kural pazarlığa kapalıdır.
4. Migration öncesi veritabanı dosyası yedeklenir; başarısız olursa yedeğe dönülür ve kullanıcı bilgilendirilir.
5. **Export/import (yedekleme) ilk sürümde bulunmalıdır.** Kullanıcının verisini dışa alıp geri yükleyebilmesi, backend'i olmayan bir üründe zorunlu güvenlik ağıdır.

---

## Test Rules

Aşağıdaki üç kural deneyle öğrenildi; ihlal edilirse testler ya asılı kalır ya da yanlış şeyi doğrular.

1. **Veritabanına dokunan test düz `test()` içinde yazılır, `testWidgets()` içinde DEĞİL.**
   `testWidgets` sahte (fake) bir async zamanında çalışır; Drift'in gerçek I/O'su o zamanda ilerlemez ve test ya sonsuza kadar asılı kalır ya da "A Timer is still pending" hatası verir.
   Repository ↔ veritabanı entegrasyonu: `test()` + `NativeDatabase.memory()`.

2. **Widget testi veritabanını değil, ekranı test eder.** Repository arayüzünün sahte bir uygulaması `ProviderScope.overrides` ile takılır. Loading / data / empty / error dallarının hepsi ayrı ayrı sınanır.

3. **Testteki `ProviderScope`, `main.dart` ile aynı `retry` politikasını kullanır.** Aksi halde test, üretimde olmayan bir davranışı doğrular.

## Hata Yönetimi Politikası (Riverpod retry)

Riverpod 3, hata veren bir provider'ı **varsayılan olarak arka planda yeniden dener**. Bu sırada state `AsyncError` değil, `AsyncLoading(error: ...)` olur — yani `.when()` **loading** dalını çağırır ve **kullanıcı hata ekranı yerine sonsuz spinner görür.**

Veri kaynağımız yerel bir veritabanıdır; yeniden denemek bozuk bir DB'yi düzeltmez. Bu yüzden otomatik retry `main.dart` içindeki `ProviderScope(retry: (_, _) => null)` ile **kapatılmıştır**. Hata kullanıcıya gösterilir, tekrar denemeyi kullanıcı başlatır.

Bu politika değiştirilecekse, her asenkron ekranın hâlâ görünür bir error state ürettiği kanıtlanmalıdır.

## Git Rules

- **Conventional Commits** zorunludur:
  ```
  feat(quotes): teklif PDF dışa aktarımı eklendi
  fix(products): negatif fiyat girişi engellendi
  refactor(core): money hesaplaması Money value object'ine taşındı
  test(quotes): KDV hesaplama testleri
  chore(deps): riverpod 3.x güncellemesi
  docs: CLAUDE.md mimari kuralları
  ```
  Tipler: `feat`, `fix`, `refactor`, `test`, `chore`, `docs`, `perf`, `style`.
- **Feature branch:** `feature/<konu>`, `fix/<konu>`, `refactor/<konu>`. `main`'e doğrudan commit yapılmaz.
- **Commit öncesi zorunlu kapı** — hepsi temiz geçmeden commit yok:
  ```bash
  dart format .
  dart run build_runner build --delete-conflicting-outputs
  flutter analyze          # sıfır warning, sıfır error
  flutter test
  ```
- Commit atomiktir: bir commit tek bir mantıksal değişikliktir. Formatlama + refactor + feature aynı commit'te olmaz.
- Generated dosyalar (`*.g.dart`) commit edilir. `build/`, `.dart_tool/` edilmez.
- **Commit ve push, kullanıcı açıkça istemediği sürece yapılmaz.**

---

## Review Rules

Her geliştirme fazının sonunda aşağıdaki kontroller **yapılır ve sonucu raporlanır.** "Yaptım" demek yetmez; ne bulunduğu yazılır.

1. **Kod analizi** — `flutter analyze` sıfır uyarı. Bastırılan lint varsa gerekçesi yazılır.
2. **SOLID kontrolü** — Özellikle: bir sınıf birden fazla nedenle değişiyor mu (SRP)? Presentation, `data`'ya bağımlı mı (DIP ihlali)?
3. **Performans** — Gereksiz `build` çağrısı, `ListView` yerine `ListView.builder`, ağır işin `build` içinde yapılması, `const` eksikleri.
4. **Memory leak** — `TextEditingController`, `ScrollController`, `AnimationController`, `StreamSubscription` dispose ediliyor mu? Provider'larda `ref.onDispose` var mı?
5. **Widget rebuild** — Provider'ı gereğinden geniş dinlemek en yaygın hatadır. `ref.watch(bigProvider)` yerine `ref.watch(bigProvider.select((s) => s.field))` kullanılabilir mi? Rebuild kapsamı en dar yaprağa indirildi mi?
6. **Riverpod kullanımı** — `build` içinde `ref.read` var mı? `AsyncValue` doğru ele alınmış mı? Gereksiz `keepAlive` veya manuel `invalidate` var mı?
7. **Kod tekrarı** — Kopyalanmış blok var mı? `core/`'a taşınacak bir şey doğdu mu?
8. **Veri güvenliği** — Yazma işlemi transaction içinde mi? Şema değiştiyse migration yazıldı mı?

---

## Working Style

**Hiçbir zaman büyük bir feature'ı tek seferde geliştirme.**

Her feature şu fazlara bölünür ve **her fazın sonunda durup onay beklenir:**

| Faz | Çıktı |
|---|---|
| **0. Plan** | Kapsam, etkilenen dosyalar, domain modeli, riskler. Kod yok. |
| **1. Domain** | Entity + repository arayüzü. Saf Dart. |
| **2. UI** | Ekran ve widget'lar, sahte/statik veriyle. Görsel onay alınır. |
| **3. State** | Riverpod provider'ları, UI'ın gerçek state'e bağlanması. |
| **4. Repository** | Isar model, data source, repository implementasyonu, migration. |
| **5. Test** | Domain birim testleri (özellikle para/KDV), repository testleri, kritik widget testleri. |

Kurallar:

- Bir fazı bitirmeden diğerine geçme.
- Faz sonunda **dur, özetle, onay iste.** Onay gelmeden sonraki faza başlama.
- Faz sırası pazarlığa açık değil; ancak küçük bir düzeltme (tek dosya, tek davranış) için faz süreci işletilmez.
- İstenmeyen dosyayı değiştirme. "Bu arada şunu da düzelttim" yapma — bulguyu **rapor et**, düzeltmeyi ayrı iş olarak öner.
- Emin olmadığın bir ürün kararını **uydurma, sor.**

---

## Output Format

Her yanıt şu iskeleti izler:

**Kod yazmadan ÖNCE:**
1. **Plan** — Ne yapılacak, hangi fazdayız.
2. **Etkilenecek dosyalar** — Yeni oluşturulacak / değiştirilecek dosya listesi.
3. **Kararlar ve alternatifler** — Kritik bir tercih varsa (ör. paket seçimi, model tasarımı) gerekçesiyle birlikte tek bir öneri sun.

**Kod yazdıktan SONRA:**
1. **Özet** — Ne değişti, sade cümlelerle. Dosya yolları `path:line` formatında.
2. **Doğrulama** — Hangi komutlar çalıştırıldı, sonucu ne. Test başarısızsa **gizleme, çıktısıyla söyle.**
3. **Riskler** — Teknik borç, tamamlanmamış kısım, dikkat edilmesi gereken davranış. Risk yoksa "risk yok" yaz.
4. **Sonraki adım** — Tek bir net öneri.

Bu format kısa tutulur. Başlıklar ritüel değil; söylenecek bir şey yoksa satırı doldurmak için cümle üretme.

---

## Komut Referansı

```bash
flutter pub get
dart run build_runner watch --delete-conflicting-outputs   # geliştirme sırasında
dart run build_runner build --delete-conflicting-outputs   # tek seferlik
flutter analyze
flutter test
dart format .
flutter run
```
