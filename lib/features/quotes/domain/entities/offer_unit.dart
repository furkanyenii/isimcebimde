/// Yeni satırın ve eski (birimsiz) kayıtların varsayılan birimi.
const String kDefaultUnit = 'adet';

/// Teklif satırının ölçü birimi.
///
/// Birim veritabanında **serbest metin** olarak saklanır (`OfferItem.unit`),
/// enum indeksi olarak değil: sektöre göre değişir ve kullanıcı kendi birimini
/// ekleyebilir (top, ton, saat…). Bu enum yalnızca **hazır gelen** birimleri
/// tanımlar; kullanıcının eklediği birimler `CustomUnitRepository`'de yaşar.
///
/// [wireName] hem veritabanına yazılan hem PDF'e basılan değerdir; ekranda
/// gösterilen etiket l10n'dan gelir.
enum OfferUnit {
  piece(kDefaultUnit),
  squareMeter('m²'),
  cubicMeter('m³'),
  package('paket'),
  set('set'),
  box('kutu');

  const OfferUnit(this.wireName);

  final String wireName;

  /// Serbest metin bir birimin hazır birimlerden biri olup olmadığını söyler;
  /// değilse `null` döner (kullanıcının kendi eklediği birimdir).
  static OfferUnit? tryFromWireName(String value) {
    for (final unit in OfferUnit.values) {
      if (unit.wireName == value) return unit;
    }
    return null;
  }
}
