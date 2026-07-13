/// Türkçe metinlerde arama yardımcıları.
///
/// **Neden filtre SQL'de değil de burada?**
/// SQLite'ın `LIKE` ve `lower()` fonksiyonları yalnızca ASCII için harf
/// duyarsızdır: "Çekiç" kaydı SQL'de "çekiç" aramasıyla **eşleşmez**.
/// Türkçe bir uygulamada bu kabul edilemez, bu yüzden arama filtresi Dart
/// tarafında uygulanır. Bir kullanıcının ürün/müşteri sayısı birkaç bini
/// geçmeyeceğinden bu hem doğru hem yeterince hızlıdır.
///
/// Ölçek sorun olursa çözüm, tabloya normalize edilmiş bir arama sütunu
/// eklemektir (yeni migration) — filtreyi SQL'e geri taşımak değil.
library;

/// Türkçe harflerin ASCII karşılıkları.
///
/// Sahadaki kullanıcı telefon klavyesinde şapkalı harflerle uğraşmaz: "çekiç"
/// yerine "cekic", "ısıtıcı" yerine "isitici" yazar. Arama bunu bulmalıdır.
/// Katlama her iki tarafa da uygulandığı için "çekiç" yazan da bulur.
///
/// Büyük harfler burada yok: `toLowerCase()` onları zaten küçültür
/// (`I` ve `İ` → `i`, `Ş` → `ş` ...). Katlama küçültmeden **sonra** yapılır.
const Map<String, String> _turkishToAscii = {
  'ı': 'i',
  'ş': 's',
  'ğ': 'g',
  'ü': 'u',
  'ö': 'o',
  'ç': 'c',
};

/// Metni arama için normalize eder: boşlukları kırpar, küçültür ve Türkçe
/// harfleri ASCII karşılıklarına katlar.
String normalizeForSearch(String value) {
  var result = value.trim().toLowerCase();
  for (final entry in _turkishToAscii.entries) {
    result = result.replaceAll(entry.key, entry.value);
  }
  return result;
}

/// [haystack] içinde [needle] geçiyor mu (Türkçe karakter duyarsız)?
///
/// [needle] boşsa `true` döner — "filtre yok" demektir.
bool containsNormalized(String haystack, String needle) {
  final search = normalizeForSearch(needle);
  if (search.isEmpty) return true;
  return normalizeForSearch(haystack).contains(search);
}
