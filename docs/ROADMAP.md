# Quotra Roadmap

Bu doküman projenin geliştirme planını içerir.

## Genel Kurallar

- Her phase bağımsız olarak tamamlanmalıdır.
- Bir phase tamamlanmadan diğerine geçilmemelidir.
- Her phase sonunda kod analizi yapılmalıdır.
- Her phase sonunda test edilmelidir.
- Her phase sonunda Git commit atılmalıdır.
- Büyük feature'lar tek seferde geliştirilmemelidir.

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

- Customer Entity
- CRUD
- Listeleme
- Arama
- Güncelleme
- Silme
- Validation

## Çıktı

Müşteri yönetimi tamamlanmış olmalı.

---

# Phase 4 - Settings Module

## Amaç

Uygulama ayarlarını tamamlamak.

## Yapılacaklar

Tema

- Light
- Dark
- System

Firma Bilgileri

- Firma Adı
- Logo
- Telefon
- Email
- Web Sitesi
- Adres
- Vergi Dairesi
- Vergi No

## Çıktı

Firma bilgileri local database'de saklanıyor olmalı.

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