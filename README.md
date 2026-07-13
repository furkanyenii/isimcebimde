# Quotra

Saha satış ekipleri, pazarlamacılar ve KOBİ'ler için **tamamen offline çalışan mobil teklif hazırlama uygulaması.**

> Dart paket adı `isimcebimde` olarak kalır (repo geçmişiyle uyum için); ürün adı **Quotra**'dır.

Kullanıcı ürünlerini ve müşterilerini kaydeder, dakikalar içinde teklif oluşturur, PDF olarak dışa aktarır ve WhatsApp/e-posta üzerinden paylaşır. İnternet gerekmez.

> **Mimari ve kod kuralları [CLAUDE.md](CLAUDE.md) dosyasındadır.** Kod yazmadan önce okunması zorunludur.

## Teknoloji

Flutter · Riverpod (codegen) · Drift (SQLite) · GoRouter · Material 3 · Clean Architecture (feature-first)

## Kurulum

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Geliştirme komutları

```bash
dart run build_runner watch --delete-conflicting-outputs   # geliştirme sırasında
flutter analyze                                            # sıfır uyarı hedefi
flutter test
dart format .
```

## Commit öncesi

`dart format .` → `build_runner build` → `flutter analyze` → `flutter test`. Hepsi temiz geçmeden commit atılmaz.
