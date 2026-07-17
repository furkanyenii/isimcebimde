import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/pagination.dart';

void main() {
  group('pageCountFor', () {
    test('boş liste tek sayfa sayılır', () {
      expect(pageCountFor(0, 15), 1);
    });

    test('sayfayı tam doldurmayan kayıt yukarı yuvarlanır', () {
      expect(pageCountFor(1, 15), 1);
      expect(pageCountFor(15, 15), 1);
      expect(pageCountFor(16, 15), 2);
      expect(pageCountFor(31, 15), 3);
    });
  });

  group('pageSlice', () {
    final items = List.generate(37, (i) => i);

    test('ilk sayfa ilk pageSize kaydı verir', () {
      expect(pageSlice(items, 0, 15), List.generate(15, (i) => i));
    });

    test('son sayfa kalan kadar kayıt verir', () {
      expect(pageSlice(items, 2, 15), [30, 31, 32, 33, 34, 35, 36]);
    });

    test('aralık dışı sayfa boş döner', () {
      expect(pageSlice(items, 5, 15), isEmpty);
    });
  });

  group('pageWindow', () {
    test('az sayfada hepsi gösterilir', () {
      expect(pageWindow(1, 3), [1, 2, 3]);
    });

    test('ortadaki sayfada iki uçta … oluşur', () {
      // 1 … 4 5 6 … 9  (current 5)
      expect(pageWindow(5, 9), [1, null, 4, 5, 6, null, 9]);
    });

    test('ilk sayfada yalnızca sağda … oluşur', () {
      expect(pageWindow(1, 8), [1, 2, null, 8]);
    });

    test('tek boşluk … yerine sayfa numarasıyla doldurulur', () {
      // 1 ile 3 arasında yalnız 2 eksik → "…" değil "2".
      expect(pageWindow(3, 8), [1, 2, 3, 4, null, 8]);
    });
  });
}
