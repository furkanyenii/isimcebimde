/// Kullanıcının kendi eklediği ölçü birimleri (top, ton, saat…).
///
/// Hazır birimler koddadır ([OfferUnit]); burada yalnızca kullanıcının teklif
/// satırında "Diğer…" ile eklediği birimler yaşar. Kalıcı olmalıdır: bir kez
/// eklenen birim sonraki tekliflerde de listede çıkar, kullanıcı her seferinde
/// yeniden yazmaz.
abstract interface class CustomUnitRepository {
  /// Kullanıcının birimleri, eklenme sırasına göre.
  Stream<List<String>> watchAll();

  /// Birimi ekler. Zaten varsa (büyük/küçük harf duyarsız) sessizce yok sayar —
  /// aynı birimin iki kez listelenmesi bir hata değil, sadece gürültüdür.
  Future<void> add(String unit);
}
