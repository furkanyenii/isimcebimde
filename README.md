# Quotra

Saha satış ekipleri, pazarlamacılar ve KOBİ'ler için **tamamen offline çalışan mobil teklif hazırlama uygulaması.**

> Dart paket adı `isimcebimde` olarak kalır (repo geçmişiyle uyum için); ürün adı **Quotra**'dır.

Kullanıcı ürünlerini ve müşterilerini kaydeder, dakikalar içinde teklif oluşturur, PDF olarak dışa aktarır ve WhatsApp/e-posta üzerinden paylaşır. İnternet gerekmez.

> **Mimari ve kod kuralları [CLAUDE.md](CLAUDE.md) dosyasındadır.** Kod yazmadan önce okunması zorunludur.

Arayüz **Türkçe ve İngilizce**'dir; dil ve tema Ayarlar'dan seçilir (Sistem / TR / EN). Para biçimi dile göre değişir, para birimi (₺) değişmez.

## Teknoloji

Flutter · Riverpod (codegen) · Drift (SQLite) · GoRouter · Material 3 · Clean Architecture (feature-first) · `flutter_localizations` + ARB

## Kurulum

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Geliştirme komutları

```bash
dart run build_runner watch --delete-conflicting-outputs   # geliştirme sırasında
flutter gen-l10n                                           # ARB → AppLocalizations
flutter analyze                                            # sıfır uyarı hedefi
flutter test
dart format .
```

Yeni bir kullanıcı metni **ARB'ye eklenir** (`lib/l10n/app_tr.arb` + `app_en.arb`), ekranda `context.l10n.xxx` ile okunur. Hardcoded string yasaktır.

Şema değiştiyse dökümü almadan commit yok:

```bash
dart run drift_dev schema dump lib/core/database/app_database.dart test/drift_schemas
dart run drift_dev schema generate test/drift_schemas test/drift_schemas
```

## Commit öncesi

`dart format .` → `build_runner build` → `flutter analyze` → `flutter test`. Hepsi temiz geçmeden commit atılmaz.
