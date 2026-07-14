/// Teklifte kullanılan para birimi.
///
/// **Yalnızca bir etiket ve gösterim sembolüdür — çevrim yapılmaz.** Kullanıcı
/// USD ile teklif vermek isterse tutarları o para biriminde elle girer/düzenler;
/// uygulama kur hesaplamaz. Gerçek zamanlı kur, offline-first ilkesiyle
/// çelişir (CLAUDE.md: "Hiçbir kritik akış network'e bağlı olamaz").
///
/// `Money.format()` zaten bir `symbol` parametresi aldığı için bu, `Money`'de
/// hiçbir değişiklik gerektirmez — sembol burada, biçim locale'den gelir.
enum Currency {
  turkishLira('TRY', '₺'),
  usDollar('USD', '\$'),
  euro('EUR', '€'),
  britishPound('GBP', '£');

  const Currency(this.code, this.symbol);

  /// Veritabanında saklanan değer (ISO 4217).
  final String code;

  /// `Money.format(symbol: ...)` için gösterim sembolü.
  final String symbol;

  static Currency fromCode(String code) {
    for (final currency in values) {
      if (currency.code == code) return currency;
    }
    // CHECK kısıtı bunu engeller; yine de bozuk veriyi gizlemek yerine göster.
    throw ArgumentError.value(code, 'code', 'Bilinmeyen para birimi kodu');
  }
}
