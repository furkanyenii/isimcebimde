# Changelog

Bu dosya [Keep a Changelog](https://keepachangelog.com/tr/1.1.0/) biçimini izler.

## [Unreleased]

### Phase 6 — Offer Templates

#### Eklendi

- **Teklif şablonları:** bir teklifi şablon olarak kaydetme, şablon listesi,
  şablondan yeni teklif oluşturma, şablon düzenleme, şablon silme.
- `OfferFormScreen`'e iki yeni AppBar aksiyonu: "Şablondan oluştur" (yalnızca
  yeni teklifte) ve "Şablon olarak kaydet" (satır varken).
- `OfferListScreen`'den "Şablonlar" ekranına giriş (`/quotes/templates`).

#### Şema

- **schemaVersion 6 → 7.** `Templates` + `TemplateItems` tabloları. Mevcut
  tablolara dokunmayan yeni-tablo-only migration (v5→v6 deseninin aynısı).
  Şablon adı `UNIQUE`; para birimi ve miktar kısıtları `Offers`/`OfferItems`
  ile birebir aynı (`CHECK`).

#### Kararlar

- **`Template.items` için ayrı bir `TemplateItem` tipi yok** — `OfferItem`
  aynen kullanılır. Ayrım yalnızca hangi tabloda saklandıkları; bu bir
  persistence detayı, domain modelini ikiye bölmeyi gerektirmez.
- **Şablon müşteriden tamamen bağımsızdır.** `Template.toDraftOffer()`
  müşteriyi boş bırakır. Satırlar `copyWith` değil doğrudan `OfferItem(...)`
  ile kurulur: `OfferItem.copyWith` `id`'yi temizleyemez (`id ?? this.id`
  deseni), taslak satırların gerçekten kaydedilmemiş (`id: null`) olması
  gerekiyordu.
- **Şablon adı benzersizdir, en az bir satır zorunludur** — sırasıyla
  `Categories.name` ve `Offer`'ın kendi kuralıyla aynı gerekçe; repository
  sınırında da zorunlu kılınır (`DuplicateTemplateNameFailure`,
  `EmptyTemplateFailure`).
- **"Şablon olarak kaydet" ayrı bir controller üzerinden gitmez** —
  `CategoryPicker._createCategory` ile aynı desen: küçük, tek seferlik bir
  eylem için repository doğrudan çağrılır.
- **Şablonlar Dashboard'da ayrı bir kart değildir**, Teklifler'in bir alt
  özelliği olarak yaşar (Ayarlar → Firma Bilgileri ile aynı gerekçe).

#### Bilinen eksikler

- Şablon içeriğinin ürün/müşteri gibi ayrı bir arama kutusu paylaşan global
  bir provider'ı yok (picker kendi yerel arama metnini tutar) — bu bilinçli,
  ölçek sorun olmadıkça değişmeyecek.

### Phase 5 — Offer Module (Temel)

#### Eklendi

- **Teklif oluşturma akışı uçtan uca çalışıyor:** müşteri seç → para birimi
  seç → ürün ekle → miktar/fiyat/iskonto düzenle → genel indirim → kaydet.
- Teklif listesi ve teklif formu (oluşturma + düzenleme aynı ekranda,
  Product/Customer formlarıyla aynı desen).
- `CustomerPicker` / `ProductPicker`: teklif satırı eklerken arama destekli
  seçim (bottom sheet), kendi yerel arama metnini tutar.
- Satır bazlı KDV ve iskonto hesabı, genel indirim, ara toplam/KDV
  toplamı/genel toplam özeti — tamamı `Offer`/`OfferItem` domain
  entity'lerinin getter'ları (12 birim testle doğrulandı).

#### Şema

- **schemaVersion 5 → 6.** `Offers` + `OfferItems` tabloları. `Offers`
  tek satırlık değil; her teklif bir satır, satırları `OfferItems`'ta.
  `currency_code` ve `quantity` (`> 0`) veritabanı seviyesinde `CHECK`
  kısıtlı. `customerId`/`productId` `ON DELETE SET NULL`, `offerId`
  `ON DELETE CASCADE`.

#### Kararlar

- **Para birimi yalnızca gösterim etiketidir, çevrim yapılmaz** — offline-first
  ilkesiyle çelişecek bir kur hesaplaması eklenmedi. `Money.format()` zaten
  bir `symbol` parametresi aldığı için bu, `Money`'de değişiklik gerektirmedi.
- **`Offer` aggregate root'tur**, satırlarını kendi içinde taşır;
  `OfferRepository` teklif + satırları **tek transaction'da** yazar. Güncelleme
  satırları diff'lemez, silip yeniden yazar — `sortOrder` sütunu sırayı korur.
- **Genel indirim KDV'den sonra uygulanır** (ara toplam + KDV üzerine, ileri
  yönde) — satır değerlerine dokunmaz, toplamdan geriye hesaplama değildir.
- **Müşteri seçimi ve en az bir ürün satırı repository sınırında da
  zorunlu kılınır** (`CustomerRequiredFailure`, `EmptyOfferFailure`) — UI'ın
  doğrulaması (Kaydet butonunun pasifliği) tek güvence değildir.
- **Kaydet butonu `bottomNavigationBar`'a sabitlendi** (CustomerFormScreen'deki
  gibi): form uzun, kullanıcı hepsini kaydırmadan kaydedebilmeli.

#### Bilinen eksikler

- Teklif silme UI'da yok (repository'de var). Roadmap'in "Temel" kapsamı
  bunu istemiyordu.
- Şablon (Phase 6), PDF/CSV export ve otomatik teklif numarası (Phase 7),
  paylaşım (Phase 9) bu fazın kapsamı dışında.
- `offer_form_screen.dart` 172 satır (CLAUDE.md eşiği 150) — mevcut
  `customer_form_screen.dart` (317 satır) ile aynı kategoride bilinen borç.

### Phase 4 — Settings & Localization

#### Eklendi

- **Türkçe + İngilizce arayüz.** Kullanıcıya görünen tüm metinler ARB'den gelir
  (`lib/l10n/app_tr.arb`, `app_en.arb`); Phase 1–3 ekranlarındaki hardcoded
  Türkçe metinler taşındı. `context.l10n` tek erişim noktasıdır.
- **Ayarlar ekranı:** dil (Sistem / Türkçe / İngilizce) ve tema
  (Sistem / Açık / Koyu). Seçim anında kaydedilir ve arayüze uygulanır.
- **Firma bilgileri:** ad, logo, telefon, e-posta, web sitesi, adres, vergi
  dairesi, vergi no. Hepsi opsiyoneldir — eksik bilgi teklif çıkarmayı engellemez.
- Para biçimi locale'e göre üretilir (TR `12,50 ₺` / EN `₺12.50`); **para birimi
  dilden bağımsızdır.** `MoneyField`'ın ondalık ayracı da locale'den gelir.
- Bağımlılıklar: `image_picker` (galeri) + `path_provider` (belge klasörü).

#### Şema

- **schemaVersion 3 → 4.** `settings` tablosu: tek satır (`CHECK (id = 1)`),
  dil ve tema. Geçerli değerler `CHECK` kısıtıyla veritabanı seviyesinde sınırlı.
- **schemaVersion 4 → 5.** `settings` tablosuna firma bilgisi sütunları
  (hepsi nullable). Alan ekleme yıkıcı değildir; mevcut tercihler korunur.

#### Kararlar

- **`Failure` metin değil tip taşır.** Repository `BuildContext` göremez,
  kullanıcının dilini bilemez. Çeviri presentation sınırında, tek bir
  exhaustive `switch`'te yapılır (`core/errors/failure_localizer.dart`) —
  `Failure` sealed olduğu için çevirisi yazılmayan yeni bir hata tipi **derlenmez.**
- **Dil için `NULL` = sistem dili.** "Seçim yapılmadı" ile "Türkçe seçildi"
  farklı durumlardır; ilki cihaz dilini takip eder, ikincisi etmez.
- **Logo görselin kendisi değil, yolu saklanır.** Galeriden gelen geçici yol
  doğrudan yazılmaz: OS önbelleği temizlenince logo sessizce kaybolurdu. Dosya
  uygulamanın belge klasörüne kopyalanır; logo değişince eskisi silinir.

#### Düzeltildi

- **Migration'da "duplicate column" tuzağı.** v3 → v4 adımındaki
  `createTable(settings)` tabloyu *güncel* tanımıyla (v5 sütunları dahil)
  yaratıyor, ardından v5 adımı aynı sütunları tekrar eklemeye çalışıyordu.
  Sütun ekleme artık yalnızca tablo zaten varsa çalışır (`from >= 4 && from < 5`).
  Migration testi bunu yakaladı.

#### Bilinen eksikler

- Ara sürüm (v4) şema doğrulama testleri kaldırıldı: `createTable` her zaman
  güncel şemayı yarattığı için "v4 şeması" ara durumu üretilemiyor. Yükseltme
  yolları (v1/v3/v4 → v5) testli.
- İngilizce arayüzde uzun etiketlerle taşma / `textScale 1.3` layout kontrolü
  yapılmadı.
- Para birimi hâlâ sabit `₺` (üç noktada). Çoklu para birimi Phase 5'te
  Ayarlar'a bağlanmalı.

### Phase 3 — Customer Module

#### Eklendi

- Müşteri CRUD: ekleme, düzenleme, kalıcı silme (onay dialogu ile).
- **Bireysel / kurumsal müşteri tipi.** Form tipe göre şekil değiştirir:
  bireysel müşteride yetkili kişi ve vergi dairesi alanları gösterilmez.
  Tek zorunlu alan **ad**'dır; kalan sekiz alan isteğe bağlıdır.
- Müşteri arama: ad, yetkili kişi ve telefon üzerinde, Türkçe karakter duyarsız.
- Doğrulama: e-posta biçimi, TCKN 11 hane / vergi no 10 hane (checksum yok).
- `core/utils/turkish_text.dart`: arama normalizasyonu ortak hale getirildi.

#### Şema

- **schemaVersion 2 → 3.** `customers` tablosu eklendi (`name` üzerinde index).
  Migration yalnızca yeni tablo yaratır; mevcut veriye dokunmaz.
- `type` sütunu metin olarak saklanır (`'individual'` / `'company'`) ve
  `CHECK` kısıtıyla veritabanı seviyesinde sınırlandırılır. Enum index'i
  saklanmaz: sıralamayı değiştiren bir refactor tüm müşterileri sessizce
  yanlış tipe çevirirdi.

#### Düzeltildi

- **Türkçe arama eksikti.** Yalnızca noktasız `ı` katlanıyordu; `ş/ğ/ü/ö/ç`
  olduğu gibi kalıyordu. "Işık Elektrik" kaydı "isik" aramasıyla bulunmuyordu.
  Artık tüm Türkçe harfler ASCII'ye katlanıyor — **ürün araması da düzeldi**.
- **Drift şema dump'ları (`drift_schema_v*.json`) repoya eklendi.** v1 ve v2
  dump'ları daha önce commit edilmemişti; `schema generate` bu klasörden
  çalıştığı için eski sürüm helper'ları bir sonraki üretimde yok olacak ve
  tüm migration testleri sessizce çöpe gidecekti. Dump'lar git geçmişindeki
  şemalardan yeniden üretildi (`schema_v1/v2.dart` çıktıları birebir aynı).

#### Bilinen eksikler

- Doğrulama mesajları hâlâ Türkçe hardcoded (ürün modülüyle aynı borç).
  Phase 4'te ARB'ye taşınacak; `Failure` mesaj yerine hata kodu taşımalı.

### Phase 2 — Product Module

#### Eklendi

- Kategori sistemi: `categories` tablosu, `Category` entity ve repository.
  Kategori adı benzersizdir; içinde ürün olan kategori silinemez (FK RESTRICT).
- Ürün CRUD: ekleme, düzenleme, kalıcı silme (onay dialogu ile), detay formu.
- Ürün arama (Türkçe karakter duyarlı) ve kategori filtresi.
- `MoneyField`: kuruş tabanlı fiyat girişi. Kullanıcı rakam yazar (`1250` →
  `12,50 ₺`); metin hiçbir aşamada `double`'a çevrilmez.
- Ürünlerde varsayılan KDV oranı (%20 / %10 / %1 / %0).

#### Şema

- **schemaVersion 1 → 2.** `products` tablosuna `category_id` (zorunlu, FK) ve
  `vat_rate_basis_points` eklendi. Migration mevcut ürünleri "Genel"
  kategorisine bağlar; NOT NULL kısıtı backfill'den **sonra** uygulanır.

#### Düzeltildi

- **Türkçe arama.** SQLite'ın `LIKE`/`lower()` fonksiyonları yalnızca ASCII için
  harf duyarsız; "Çekiç" kaydı "çekiç" aramasıyla eşleşmiyordu. Arama Dart
  tarafına alındı, noktalı/noktasız i de normalize ediliyor.

### Phase 1 — Project Foundation

#### Eklendi

- Clean Architecture + Feature-First klasör yapısı (`domain` / `data` / `presentation`).
- Riverpod (code generation) ile state yönetimi ve dependency injection.
- GoRouter tabanlı yönlendirme: Splash → Dashboard → Ürünler.
- Drift (SQLite) veritabanı altyapısı, `products` tablosu ve migration stratejisi.
- Material 3 tema sistemi; Light ve Dark tema desteği.
- Ortak durum widget'ları: `AppLoadingView`, `AppErrorView`, `AppEmptyView`.
- `BuildContextX` theme extension'ı.
- Splash ekranı: veritabanını açar; açılamazsa hata ve "tekrar dene" gösterir.
- Dashboard ekranı: kart yapısı, responsive grid, hazır olmayan modüller "Yakında".
- `Money` value object ve `Percent` tipi: para kuruş cinsinden `int` tutulur,
  ticari yuvarlama tek noktada tanımlıdır (30 test).
- Ürün altyapısı: `Product` entity, `ProductRepository` arayüzü ve Drift
  implementasyonu, entegrasyon testleri.

#### Kararlar

- **Isar yerine Drift.** Resmi `isar` paketinin Android native kütüphaneleri 4KB
  hizalı; Google Play'in 16KB page size zorunluluğu (1 Mayıs 2026) nedeniyle o
  paketle mağazaya güncelleme gönderilemiyor. Ayrıca domain ilişkisel ve backend
  olmadığı için test edilebilir migration şart.
- **Riverpod otomatik retry kapatıldı.** Riverpod 3 hata veren provider'ı arka
  planda yeniden dener ve state `AsyncLoading(error:)` olarak kalır; bu durumda
  kullanıcı hata ekranı yerine sonsuz spinner görürdü.
- **Bottom navigation kullanılmadı.** Modül sayısı az; Dashboard kartları tercih edildi.

#### Bilinen eksikler

- `riverpod_lint` / `custom_lint` kurulamıyor (`analyzer` sürüm çakışması,
  `drift_dev` ile uyumsuz). Riverpod kuralları şimdilik code review ile denetlenir.
- Android APK derlemesi doğrulanamadı: geliştirme makinesinde Android SDK kurulu değil.
- Excel export'a başlanmadı; paket/lisans kararı bekliyor (bkz. `docs/ROADMAP.md`).
