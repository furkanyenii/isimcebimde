# Quotra Roadmap

Bu doküman projenin geliştirme planını içerir.

## Genel Kurallar

- Her phase bağımsız olarak tamamlanmalıdır.
- Bir phase tamamlanmadan diğerine geçilmemelidir.
- Her phase sonunda kod analizi yapılmalıdır.
- Her phase sonunda test edilmelidir.
- Her phase sonunda Git commit atılmalıdır.
- Büyük feature'lar tek seferde geliştirilmemelidir.

## Çapraz Kesen Gereksinim — Çok Dillilik (TR + EN)

Uygulama **Türkçe ve İngilizce** desteklemelidir. Bu tek bir phase'in işi değil,
tüm UI'ı kesen bir gereksinimdir:

- Kullanıcıya görünen her metin `l10n` dosyalarından gelir (`context.l10n.xxx`).
  Hardcoded string yasak (CLAUDE.md: Coding Standards).
- Dil seçimi Ayarlar'da yapılır: **Sistem / Türkçe / İngilizce** (Phase 4).
- Tarih, sayı ve para biçimi `intl` ile **locale'e göre** üretilir.
  Ondalık ayracı Türkçe'de `,`, İngilizce'de `.` olur — `MoneyField` ve
  `Money.format()` bunu locale'den almalıdır (şu an `,` sabit).
- **Para birimi dilden bağımsızdır.** İngilizce arayüz kullanan biri de ₺ ile
  teklif verebilir. Locale biçimi belirler, para birimini değil.
- **Veritabanı içeriği çevrilmez.** Kullanıcının yazdığı ürün/müşteri adları ve
  seed edilen "Genel" kategorisi kullanıcı verisidir; dil değişince değişmez
  (kullanıcı isterse yeniden adlandırır).

**Mevcut borç:** Phase 1–2 ekranlarındaki metinler Türkçe hardcoded yazıldı.
l10n altyapısı kurulduğunda bu ekranlar da geriye dönük taşınacaktır.

---

# Phase 1 - Project Foundation

## Amaç

Projenin temel altyapısını oluşturmak.

## Yapılacaklar

- [x] Flutter proje yapısını düzenle
- [x] Clean Architecture oluştur
- [x] Feature First yapı oluştur
- [x] Riverpod kurulumu (codegen: `riverpod_generator`)
- [x] GoRouter kurulumu
- [x] Drift kurulumu (Isar yerine — gerekçe aşağıda)
- [x] Theme sistemi
- [x] Light / Dark Theme
- [x] Splash Screen
- [x] Dashboard ekranı (kart yapısı)
- [x] Bottom Navigation → **gerekmiyor**, Dashboard kartları tercih edildi
- [x] Ortak Widget yapıları (`AppLoadingView` / `AppErrorView` / `AppEmptyView`)
- [x] Ortak Theme Extension'ları (`BuildContextX`)

## Phase 1'de ayrıca yapılanlar (plan dışı, gerekliydi)

- **`Money` value object + 30 test.** Para kuruş cinsinden `int`; `double` yasak.
  Ticari yuvarlama tek noktada tanımlı. Tüm fiyat/KDV hesabının temeli bu.
- **Ürün altyapısı (dikey hat kanıtı):** `products` Drift tablosu, `Product` entity,
  `ProductRepository` arayüzü + Drift implementasyonu, provider'lar ve entegrasyon
  testleri. Phase 2 bunun **üzerine** kurulacak, sıfırdan başlamayacak.
- **Riverpod retry politikası kapatıldı.** Riverpod 3 hata veren provider'ı otomatik
  yeniden dener ve state `AsyncLoading(error:)` olarak kalır — kullanıcı hata ekranı
  yerine sonsuz spinner görürdü. `ProviderScope(retry: (_, _) => null)` ile kapatıldı.

## Neden Isar değil Drift

Resmi `isar` paketinin Android native kütüphaneleri 4KB hizalı; Google Play'in 16KB
page size zorunluluğu 1 Mayıs 2026'da yürürlüğe girdi → o paketle mağazaya güncelleme
gönderilemiyor. Ayrıca domain ilişkisel (teklif → satır → ürün/müşteri) ve backend
olmadığı için test edilebilir migration şart. Detay: `CLAUDE.md`.

## Çıktı

Çalışan boş bir uygulama. ✅

`flutter analyze` temiz, 39/39 test geçiyor.

---

# Phase 2 - Product Module

## Amaç

Ürün yönetimini tamamlamak.

## Zaten hazır (Phase 1'de yapıldı, tekrar yazma)

- [x] Product Entity (`features/products/domain/entities/product.dart`)
- [x] Product Repository (arayüz + Drift implementasyonu, entegrasyon testli)
- [x] Product List (temel liste + empty/loading/error state)

## Yapılacaklar

- [x] Product Create (form + validation)
- [x] Product Edit
- [x] Product Delete (kalıcı, onay dialogu ile)
- [x] Product Detail (form ekranı düzenleme modunda)
- [x] Ürün arama (Türkçe karakter duyarlı)
- [x] Kategori Entity + tablo (`categories`), ürün → kategori FK
- [x] Kategori seçimi
- [x] Yeni kategori oluşturma (Dialog)
- [x] Kategori listesinin otomatik güncellenmesi (Drift stream)
- [x] **Şema değişikliği:** `schemaVersion` 1 → 2, migration + migration testi
- [x] Geçici "Örnek ürün" butonu gerçek "Yeni Ürün" formuyla değiştirildi

## Bu phase'de alınan kararlar

- **Kategori zorunlu.** Ürün kategorisiz olamaz. Migration mevcut ürünleri
  "Genel" kategorisine bağlar.
- **Silme kalıcıdır** (arşivleme değil), onay dialogu ile. Geçmiş teklifler
  bozulmaz: teklif satırı ürünün ad/fiyat snapshot'ını tutacak.
- **KDV oranı üründe varsayılan olarak tutulur**, teklif satırında
  değiştirilebilecek → Phase 5'te ek migration gerekmeyecek.
- **Arama SQL'de değil Dart'ta yapılır.** SQLite'ın `lower()`/`LIKE`'ı yalnızca
  ASCII için harf duyarsız; Türkçe'de "Çekiç" ≠ "çekiç" olurdu.

## Çıktı

Ürün yönetimi tamamen çalışıyor. ✅

---

# Phase 3 - Customer Module

## Amaç

Müşteri yönetimini tamamlamak.

## Yapılacaklar

- [x] Customer Entity + `CustomerType` (bireysel / kurumsal)
- [x] **Şema değişikliği:** `schemaVersion` 2 → 3, `customers` tablosu + migration testi
- [x] Customer Repository (arayüz + Drift implementasyonu)
- [x] Listeleme (empty / loading / error state)
- [x] Arama (Türkçe karakter duyarlı — ürünle aynı normalize kuralı)
- [x] Create / Edit formu (tipe göre uyarlanan alanlar)
- [x] Silme (kalıcı, onay dialogu ile)
- [x] Validation (ad zorunlu; e-posta biçimi; TCKN 11 / VKN 10 hane)
- [x] Dashboard "Müşteriler" kartı aktifleştirildi

## Alanlar

`name` **tek zorunlu alandır.** Diğer her şey opsiyoneldir — sahada müşterinin
vergi dairesini soracak vakit yoktur; teklif çıkar, detay sonra doldurulur.

| Alan | Bireysel | Kurumsal |
|---|---|---|
| `type` | `individual` | `company` |
| `name` | **Ad Soyad** (zorunlu) | **Firma Ünvanı** (zorunlu) |
| `contactPerson` | *gösterilmez* | Yetkili Kişi (ops.) |
| `phone` / `email` / `address` | ops. | ops. |
| `taxOffice` | *gösterilmez* | Vergi Dairesi (ops.) |
| `taxNumber` | TCKN, 11 hane (ops.) | Vergi No, 10 hane (ops.) |
| `notes` | ops. | ops. |

## Bu phase'de alınan kararlar

- **Müşteri tipini kullanıcı seçer** (bireysel / kurumsal); form buna göre şekil
  değiştirir. Tip, alan sayısını artırmaz — sadece doğru alanları gösterir.
- **Tek tablo, ayrı tablo değil.** İki tabloya bölmek teklif tarafında
  polimorfik FK'ye yol açardı. Alanların çoğu ortaktır.
- **`type` metin olarak saklanır** (`'individual'` / `'company'`), enum index'i
  olarak değil: enum sırasını değiştiren bir refactor, index saklansaydı tüm
  müşterileri sessizce yanlış tipe çevirirdi. Ayrıca DB seviyesinde
  `CHECK (type IN ('individual','company'))` kısıtı konur.
- **Boş string yerine `NULL`.** Repository sınırında `''` → `null` normalize
  edilir; aksi halde "telefonu yok" iki farklı şekilde temsil edilir.
- **Vergi/TC no'da checksum doğrulaması yok**, yalnızca uzunluk. Geçerli ama
  alışılmadık bir numarada kullanıcıyı bloklamak, hatalı numaraya izin
  vermekten daha kötüdür.
- **`isArchived` yok.** Teklif, müşteri bilgilerini oluşturulma anında
  **snapshot** alır (tıpkı teklif satırının ürün fiyatını kopyalaması gibi).
  Bu yüzden müşteri serbestçe silinebilir; eski teklifler bozulmaz.
  Teklifteki `customerId` nullable olur ve `ON DELETE SET NULL` ile bağlanır
  (yalnızca "bu müşteriye kaç teklif verdim" raporu için). → Phase 5
- **Arama tüm Türkçe diyakritikleri ASCII'ye katlar** (`ç→c`, `ş→s`, `ğ→g`,
  `ü→u`, `ö→o`, `ı→i`). Sahadaki kullanıcı telefon klavyesinde şapkalı harflerle
  uğraşmaz; "cekic" yazıp "Çekiç"i bulmalıdır. Mantık `core/utils/turkish_text.dart`
  içinde ortaklandı — ürün araması da bundan faydalandı.
- **Arama üç alanda birden yapılır:** ad, yetkili kişi ve telefon. Kullanıcı
  firmanın ünvanını değil, muhatabının adını hatırlar.

## Çıktı

Müşteri yönetimi tamamlandı. ✅

`flutter analyze` temiz, 149/149 test geçiyor.

---

# Phase 4 - Settings & Localization

## Amaç

Uygulama ayarlarını tamamlamak ve çok dilliliği (TR + EN) devreye almak.

## Yapılacaklar

Lokalizasyon (i18n)

- [x] `flutter_localizations` + `intl` ARB altyapısı (`lib/l10n/app_tr.arb`, `app_en.arb`)
- [x] `BuildContextX.l10n` extension'ı
- [x] `Failure` metin değil **tip** taşır; çeviri `failure_localizer.dart` içinde
      tek noktada yapılır (sealed → eksik çeviri derlenmez)
- [x] Dil seçimi: Sistem / Türkçe / İngilizce (kalıcı, `settings` tablosunda)
- [x] **Phase 1–3 ekranlarındaki hardcoded Türkçe metinlerin ARB'ye taşınması**
- [x] `Money.format()` ve `MoneyField` ondalık ayracını locale'den alır
      (TR `12,50` / EN `12.50`) — para birimi (`₺`) sabit kalır
- [x] İngilizce ekran testleri (hata mesajı, fiyat biçimi, para girişi)
- [ ] Metin taşması / kırık layout kontrolü (uzun İngilizce etiketler, textScale 1.3)

Tema

- [x] Light
- [x] Dark
- [x] System

Firma Bilgileri

- [x] Firma Adı
- [x] Logo (dosya yolu; görsel belge klasörüne kopyalanır)
- [x] Telefon
- [x] Email
- [x] Web Sitesi
- [x] Adres
- [x] Vergi Dairesi
- [x] Vergi No

## Bu phase'de alınan kararlar

- **Ayarlar tek satırlık bir tablodur** (`CHECK (id = 1)`). İkinci bir satır
  "hangisi geçerli?" sorusunu doğurur; o soru sessiz bir hataya döner.
- **Dil için `NULL` = sistem dili.** "Seçim yapılmadı" ile "Türkçe seçildi"
  farklı durumlardır: birincisi cihaz dili değişince onu takip eder.
- **Logo veritabanında blob olarak tutulmaz, yolu tutulur.** Galeriden gelen yol
  da doğrudan yazılmaz — OS geçici klasörü temizlenince logo kaybolurdu; dosya
  önce uygulamanın belge klasörüne kopyalanır (`LogoStorage`).
- **Dil ve tema seçiminde "kaydet" butonu yok.** Seçim anında yazılır.
- `image_picker` + `path_provider` eklendi; ikisi de arayüz arkasında
  (`LogoPicker` / `LogoStorage`) → ekran testleri platform kanalına dokunmaz.

## Çıktı

Firma bilgileri local database'de saklanıyor. ✅
Uygulama Türkçe ve İngilizce olarak eksiksiz kullanılabiliyor. ✅

`flutter analyze` temiz, 187/187 test geçiyor. Şema v5.

---

# Phase 5 - Offer Module (Temel)

## Amaç

Teklif sistemini oluşturmak.

## Yapılacaklar

- Offer Entity
- Offer Item Entity
- Offer Repository
- Teklif Listesi
- Teklif Detayı
- Yeni Teklif

## Teklif Akışı

- Müşteri seç
- Para birimi seç
- KDV oranı seç
- Ürün ekle
- Miktar gir
- Fiyat otomatik getir
- Fiyat düzenle
- Satır indirimi
- Genel indirim
- Toplam hesaplama
- Teklif kaydet

## Çıktı

Kullanıcı teklif oluşturabilmeli.

---

# Phase 6 - Offer Templates

## Amaç

Teklif şablonlarını geliştirmek.

## Yapılacaklar

- Teklifi şablon olarak kaydet
- Şablon listeleme
- Şablondan teklif oluştur
- Şablon düzenleme
- Şablon silme

## Çıktı

Yeni teklifler şablonlardan oluşturulabiliyor olmalı.

---

# Phase 7 - PDF

## Amaç

Profesyonel PDF oluşturmak.

## Yapılacaklar

- PDF tasarımı
- Firma bilgileri
- Logo
- Müşteri bilgileri
- Ürün tablosu
- Toplamlar
- Not alanı
- Otomatik teklif numarası

## Çıktı

Profesyonel PDF oluşturulabiliyor olmalı.

---

# Phase 8 - Excel Export

## Amaç

Excel çıktısı oluşturmak.

## Yapılacaklar

- Excel oluştur
- Dosya kaydet

## ⚠️ Karar gerekiyor (bu phase'e başlamadan)

Sağlam bir `.xlsx` paketi yok:

- `excel` paketi bayat (son yayın Ağustos 2024, pub puanı 115/160).
- `syncfusion_flutter_xlsio` aktif ama **ticari lisans kısıtı** taşıyor →
  hukuki karar gerektirir.

**Öneri:** "Excel'e aktar" ihtiyacını **CSV** ile karşıla (Excel doğrudan açar,
sıfır bağımlılık, sıfır lisans riski). Gerçek `.xlsx` ancak lisans kararı
alındıktan sonra yazılır.

## Çıktı

Excel export tamamlanmalı.

---

# Phase 9 - Share

## Amaç

Teklif paylaşımı.

## Yapılacaklar

- PDF paylaş
- Excel paylaş
- WhatsApp
- Mail
- Sistem paylaşım ekranı

## Çıktı

Teklif paylaşılabiliyor olmalı.

---

# Phase 10 - Finalization

## Amaç

Uygulamayı production seviyesine getirmek.

## Yapılacaklar

- Refactoring
- Kod temizliği
- Performans optimizasyonu
- Memory leak kontrolü
- Riverpod optimizasyonu
- Widget rebuild analizi
- Responsive kontrolleri
- Empty State
- Loading State
- Error State
- Son testler

## Çıktı

Production Ready MVP.

---

# Phase Sonu Kuralları

Her phase sonunda Claude aşağıdaki işlemleri yapmalıdır.

- Kod analizi
- SOLID kontrolü
- Clean Architecture kontrolü
- Gereksiz kod analizi
- Performans analizi
- Riverpod analizi
- Drift analizi
- UI analizi
- README güncellemesi
- CHANGELOG güncellemesi

Phase tamamlanmadan sonraki phase'e geçilmemelidir.