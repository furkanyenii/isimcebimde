# Changelog

Bu dosya [Keep a Changelog](https://keepachangelog.com/tr/1.1.0/) biçimini izler.

## [Unreleased]

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
