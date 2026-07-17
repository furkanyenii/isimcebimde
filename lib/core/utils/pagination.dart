// Sayfalama için saf (Flutter'sız) yardımcılar. Ayrı bir dosyada tutulur ki
// mantık widget'tan bağımsız olarak birim testiyle doğrulanabilsin.

/// [itemCount] kaydın [pageSize]'lık sayfalara bölündüğünde kaç sayfa ettiği.
/// En az 1 döner (boş liste bile tek "sayfa"dır — çağıran taraf boş durumu
/// ayrıca ele alır).
int pageCountFor(int itemCount, int pageSize) {
  assert(pageSize > 0, 'pageSize pozitif olmalı');
  if (itemCount <= 0) return 1;
  return (itemCount + pageSize - 1) ~/ pageSize;
}

/// [items]'ın 0 tabanlı [page] numarasındaki dilimi. Aralık dışı sayfalarda
/// boş liste döner; çağıran taraf sayfayı [pageCountFor] ile sınırlar.
List<T> pageSlice<T>(List<T> items, int page, int pageSize) {
  assert(pageSize > 0, 'pageSize pozitif olmalı');
  final start = page * pageSize;
  if (start < 0 || start >= items.length) return const [];
  final end = start + pageSize;
  return items.sublist(start, end < items.length ? end : items.length);
}

/// Sayfalama çubuğunda gösterilecek 1 tabanlı sayfa numaraları. `null`, "…"
/// (atlanan aralık) demektir. İlk ve son sayfa ile [current] etrafındaki
/// [siblings] komşu her zaman gösterilir; aradaki tek bir eksik sayfa "…"
/// yerine numarasıyla gösterilir (daha okunaklı).
///
/// Örnek: `pageWindow(3, 8)` → `[1, 2, 3, 4, null, 8]`.
List<int?> pageWindow(int current, int pageCount, {int siblings = 1}) {
  if (pageCount <= 0) return const [];

  final pages = <int>{1, pageCount};
  for (var p = current - siblings; p <= current + siblings; p++) {
    if (p >= 1 && p <= pageCount) pages.add(p);
  }

  final sorted = pages.toList()..sort();
  final result = <int?>[];
  int? previous;
  for (final page in sorted) {
    if (previous != null && page - previous > 1) {
      // İki sayfa arasında tek boşluk varsa "…" yerine o sayfayı göster.
      result.add(page - previous == 2 ? previous + 1 : null);
    }
    result.add(page);
    previous = page;
  }
  return result;
}
