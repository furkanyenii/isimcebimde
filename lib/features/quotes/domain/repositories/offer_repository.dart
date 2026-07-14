import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';

/// Presentation katmanı yalnızca bu arayüzü görür.
/// Drift tipleri (`AppDatabase`, `OfferRow`, `OfferItemRow`) buranın dışına
/// sızmaz — ileride cloud sync eklendiğinde UI'da tek satır değişmemesini bu sağlar.
abstract interface class OfferRepository {
  /// Tekliflerin tamamı (satırlarıyla birlikte), oluşturulma sırasına göre.
  Stream<List<Offer>> watchAll();

  /// Tek bir teklif (satırlarıyla birlikte). Bulunamazsa `null`.
  Stream<Offer?> watchById(int id);

  /// Yeni teklifi ve tüm satırlarını **tek transaction'da** oluşturur, id'sini
  /// döner (CLAUDE.md: "yarım kaydedilmiş teklif kabul edilemez").
  Future<int> create(Offer offer);

  /// Var olan teklifi ve satırlarını günceller. [Offer.id] null olamaz.
  /// Satırlar, verilen [Offer.items] listesiyle **tamamen değiştirilir**
  /// (diff'lenmez) — form tabanlı bir düzenleyici için bu yeterli ve basittir.
  Future<void> update(Offer offer);

  /// Teklifi ve tüm satırlarını kalıcı olarak siler.
  Future<void> delete(int id);
}
