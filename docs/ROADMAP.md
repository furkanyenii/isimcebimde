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

- [x] Offer Entity (aggregate root, satırlarını taşır)
- [x] Offer Item Entity
- [x] Offer Repository (arayüz + Drift implementasyonu, entegrasyon testli)
- [x] Teklif Listesi
- [x] Teklif Detayı (Yeni Teklif formunun düzenleme modu)
- [x] Yeni Teklif

## Teklif Akışı

- [x] Müşteri seç
- [x] Para birimi seç (yalnızca gösterim etiketi, çevrim yok)
- [x] KDV oranı seç (ürün eklenirken kopyalanır, satırda değiştirilebilir)
- [x] Ürün ekle
- [x] Miktar gir
- [x] Fiyat otomatik getir
- [x] Fiyat düzenle
- [x] Satır indirimi
- [x] Genel indirim (KDV'den sonra uygulanır)
- [x] Toplam hesaplama
- [x] Teklif kaydet

## Bu phase'de alınan kararlar

- **Para birimi yalnızca bir gösterim etiketidir, çevrim yapılmaz.** Kullanıcı
  USD ile teklif vermek isterse tutarları o para biriminde elle girer/düzenler;
  gerçek zamanlı kur offline-first ilkesiyle çelişirdi (network gerektirir).
- **`Offer` aggregate root'tur**, satırlarını kendi içinde taşır.
  `OfferRepository.save` teklif ve tüm satırlarını **tek transaction'da**
  yazar. Güncellemede satırlar diff'lenmez, silinip verilen listeyle yeniden
  yazılır — form tabanlı bir düzenleyici için yeterli ve basittir. `sortOrder`
  sütunu bu stratejide satır sırasının korunmasını garanti eder.
- **Genel indirim KDV'den sonra uygulanır**: ara toplam + KDV toplanır, bu
  toplama ileri yönde bir indirim uygulanır. Satır değerlerine dokunulmaz;
  bu "toplamdan geriye hesaplama" değildir.
- **Müşteri seçimi ve en az bir ürün satırı zorunludur**, repository
  sınırında da tekrar doğrulanır (`CustomerRequiredFailure`,
  `EmptyOfferFailure`) — UI'ın doğrulaması tek güvence değildir.
- **`customerName`/`customerContactPerson` ve satırın `productName`/
  `unitPrice`'ı snapshot'tır** (Phase 2-3'teki ürün/müşteri silme kararlarıyla
  aynı gerekçe): müşteri veya ürün silinse/değişse bile geçmiş teklif bozulmaz.
- `CustomerPicker`/`ProductPicker` widget'ları kendi feature'larına ait
  (customers/products), `CategoryPicker`'ın kurduğu çapraz-feature import
  örüntüsünü izler. Kendi yerel arama metinlerini tutarlar ki picker'daki
  arama, arkadaki liste ekranlarının paylaşılan arama kutusunu etkilemesin.

## Çıktı

Kullanıcı teklif oluşturabiliyor. ✅

`flutter analyze` temiz, 226/226 test geçiyor. Şema v6.

---

# Phase 6 - Offer Templates

## Amaç

Teklif şablonlarını geliştirmek.

## Yapılacaklar

- [x] Teklifi şablon olarak kaydet
- [x] Şablon listeleme
- [x] Şablondan teklif oluştur
- [x] Şablon düzenleme
- [x] Şablon silme

## Bu phase'de alınan kararlar

- **`Template.items` için ayrı bir `TemplateItem` tipi yok.** `OfferItem`
  aynen kullanılıyor — aynı şekil (ürün adı/fiyat snapshot'ı, miktar, KDV,
  iskonto), ayrım yalnızca hangi tabloda saklandıkları (`TemplateItems` vs
  `OfferItems`). Bu bir persistence detayı, domain modelini ikiye bölmeyi
  gerektirmiyor.
- **Şablon müşteriden tamamen bağımsızdır.** `Template.toDraftOffer()`
  müşteriyi boş bırakır; kullanıcı normal akışta seçer. "Şablondan oluştur"
  butonu bu yüzden yalnızca yeni teklifte görünür, düzenlemede değil.
- **Şablon adı benzersizdir** (`Categories.name` ile aynı gerekçe — aynı
  isimde birden çok şablon kullanıcıyı karıştırır) ve **en az bir satır
  zorunludur** (`Offer` ile aynı kural) — ikisi de repository sınırında
  zorunlu kılınır, UI'ın doğrulaması tek güvence değildir.
- **"Şablon olarak kaydet" ayrı bir form akışı/controller üzerinden gitmez.**
  `CategoryPicker._createCategory` ile aynı desen: küçük, tek seferlik bir
  eylem için repository doğrudan çağrılır.
- **Şablonlar Dashboard'da ayrı bir kart değildir.** Teklifler modülünün bir
  alt özelliği olarak `/quotes/templates` altında yaşar (Ayarlar → Firma
  Bilgileri ile aynı gerekçe) — Dashboard'ın 4 kartlık düzeni bilinçli olarak
  bozulmadı.

## Çıktı

Yeni teklifler şablonlardan oluşturulabiliyor. ✅

Şema v7.

## Revizyon (16 Tem 2026)

Şablon akışı yeniden kurgulandı. Yukarıdaki kararların bir kısmı **artık
geçerli değil**; bölümün geri kalanı o günün kaydı olarak duruyor.

Değişimin sebebi: şablon, teklif formunun içinde bir araç olarak kaldığı
sürece keşfedilmiyordu. Artık kendi modülü ve teklif akışının başlangıcı.

- **"Teklifi şablon olarak kaydet" kaldırıldı.** Şablon yalnızca Şablonlar
  sayfasından oluşturulur; teklif formunda şablona dair hiçbir iz yok.
  Böylece formdaki tek birincil eylem kaydetmek olarak kalıyor.
  `save_as_template_dialog.dart` ve `template_picker.dart` silindi.
- **"Şablondan oluştur" butonu yerine başlangıç seçimi geldi.** "Yeni teklif"
  tek bir girişten geçiyor (`openNewOfferFlow`): şablon varsa boş teklif /
  şablon listesi sheet'i açılır, **yoksa hiç sorulmadan** boş form gelir —
  boş kutuyla başlayana fazladan dokunuş yüklenmez.
- **Şablonlar artık Dashboard'da kendi modülü.** `/quotes/templates` yerine
  `/templates`, dashboard'un doğrudan çocuğu; düzen 5 kart. "4 kartlık düzen
  bozulmasın" gerekçesi, şablonu teklif akışının başlangıcı yapma kararına
  yenildi.
- Şablon adı benzersizliği, en az bir satır zorunluluğu, `OfferItem`'ın
  paylaşılması ve şablonun müşteriden bağımsızlığı **aynen geçerli**.

Şema değişmedi (v7'de tanımlanan tablolar yerinde; güncel sürüm v10).

---

# Phase 7 - PDF

## Amaç

Profesyonel PDF oluşturmak.

## Yapılacaklar

- [x] PDF tasarımı
- [x] Firma bilgileri
- [x] Logo
- [x] Müşteri bilgileri
- [x] Ürün tablosu
- [x] Toplamlar
- [x] Not alanı
- [x] Otomatik teklif numarası

## Bu phase'de alınan kararlar

- **Teklif numarası için yeni kolon/migration yok.** `Offer.quoteNumber`,
  `id` (zaten benzersiz, autoincrement) ve `createdAt.year`'dan türetilir
  (`TKL-2026-000042`). `createdAt` DB'de zaten vardı ama domain'e
  taşınmamıştı; yalnızca bu mapping eksikliği giderildi. schemaVersion 7'de
  kaldı.
- **PDF üretimi saf bir dönüşüm fonksiyonudur** (`buildOfferPdfBytes`):
  dosya sistemine/DB'ye yazmaz, yalnızca `Uint8List` döner. Önizleme/paylaşım
  bunu nasıl kullanacağına kendi karar verir.
- **Önizleme `printing` paketinin hazır `PdfPreview` widget'ıyla yapılır.**
  Ayrı bir state/provider gerekmedi; paket kendi loading/hata durumunu
  yönetiyor. Paketin hazır yazdırma/paylaşım ikonları bu fazda kapatılmadı —
  Faz 8'de özel çoklu-kanal paylaşım akışı bunun üzerine kurulacak.
- **Giriş noktası teklif düzenleme ekranının AppBar'ı.** Yeni bir liste/detay
  ekranı açılmadı; ikon yalnızca kaydedilmiş tekliflerde (`quoteNumber`
  kaydedilmemiş bir teklifte üretilemeyeceği için) görünür.
- **Türkçe karakterler için gömülü Noto Sans fontu eklendi**
  (`assets/fonts/`, OFL lisanslı). `pdf` paketinin varsayılan Helvetica'sı
  ç/ğ/ı/ö/ş/ü'yü basamıyor.

## Çıktı

Profesyonel PDF oluşturulabiliyor. ✅

`flutter analyze` temiz, 270/270 test geçiyor. Şema v7 (değişmedi).

---

# Phase 8 - Share

## Amaç

Teklif paylaşımı.

## Yapılacaklar

- [x] PDF paylaş
- [x] WhatsApp
- [x] Mail
- [x] Sistem paylaşım ekranı

## Bu phase'de alınan kararlar

- **Ayrı bir "WhatsApp" veya "Mail" butonu yok.** `printing` paketinin
  `PdfPreview` widget'ı (Faz 7'de zaten kuruldu) hazır bir paylaşım ikonu
  içeriyor ve bu, işletim sisteminin genel paylaşım ekranını açıyor —
  WhatsApp ve Mail dahil kurulu her uygulama zaten burada bir seçenek
  olarak çıkıyor, WhatsApp'ta PDF eki native olarak destekleniyor. Roadmap'in
  dört maddesi de (PDF paylaş / WhatsApp / Mail / Sistem paylaşım ekranı)
  Faz 7'de tek bir mekanizmayla zaten karşılanmış durumdaydı.
- **WhatsApp'a özel bir deep link (`wa.me`) PDF dosyası taşıyamaz** —
  yalnızca metin. Bu WhatsApp'ın kamuya açık deep link API'sinin sınırı,
  paket seçimiyle ilgisi yok. Bu yüzden ayrı bir "WhatsApp'a Gönder"
  butonu (PDF'siz, yalnızca metinli, iki adımlı bir akış) bilinçli olarak
  eklenmedi.
- **Gerçek iş, mevcut paylaşım ikonunu zenginleştirmekti.** `PdfPreview`'in
  `shareActionExtraSubject`/`shareActionExtraBody`/`shareActionExtraEmails`
  parametreleri dolduruldu: konu teklif numarası, metin yerelleştirilmiş bir
  şablon, alıcı ise `offer.customerId` üzerinden müşterinin e-postası
  (varsa). Bu üçü de doğrudan `Printing.sharePdf`'e geçiyor.
- **Müşteri e-postası zorunlu değil, bir zenginleştirme.** `customerId`
  `null`sa (teklif müşterisiz veya müşteri silinmiş) ya da müşteride
  e-posta yoksa, paylaşım ekranı **çökmez**, yalnızca alıcısız açılır —
  kullanıcı elle girer. Yeni `customerByIdProvider` (family, `Stream<Customer?>`)
  bu yüzden `.value` (nullable) ile okunur, ekranın ana `.when()` akışını
  bloklamaz.

## Çıktı

Teklif paylaşılabiliyor. ✅

`flutter analyze` temiz, 272/272 test geçiyor. Şema v7 (değişmedi).

---

# Phase 9 - Finalization

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

- README güncellemesi
- CHANGELOG güncellemesi

Phase tamamlanmadan sonraki phase'e geçilmemelidir.

# Tüm Fazlar Bittikten Sonra Yapılacaklar
- Kod analizi
- SOLID kontrolü
- Clean Architecture kontrolü
- Gereksiz kod analizi
- Performans analizi
- Riverpod analizi
- Drift analizi
- UI analizi