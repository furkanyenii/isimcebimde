import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/utils/money.dart';

void main() {
  group('Money — kuruluş ve eşitlik', () {
    test('fromLira kuruşa çevirir', () {
      expect(Money.fromLira(123, 45).minor, 12345);
      expect(Money.fromLira(0, 5).minor, 5);
      expect(Money.fromLira(10).minor, 1000);
    });

    test('negatif lirada kuruş da negatif yönde uygulanır', () {
      expect(Money.fromLira(-123, 45).minor, -12345);
    });

    test('değer eşitliği (identity değil)', () {
      expect(const Money(500), const Money(500));
      expect(const Money(500).hashCode, const Money(500).hashCode);
    });
  });

  group('Money — kayan nokta hatası yapmaz', () {
    test('0.1 + 0.2 == 0.3 (double olsaydı tutmazdı)', () {
      final result = Money.fromLira(0, 10) + Money.fromLira(0, 20);
      expect(result, Money.fromLira(0, 30));
      expect(result.minor, 30);
    });

    test('0.01 tutarı 100 kez toplanınca tam 1,00 eder', () {
      final total = List.filled(100, Money.fromLira(0, 1)).sum();
      expect(total, Money.fromLira(1));
      expect(total.minor, 100);
    });
  });

  group('Money — aritmetik', () {
    test('toplama ve çıkarma', () {
      expect(const Money(1000) + const Money(250), const Money(1250));
      expect(const Money(1000) - const Money(250), const Money(750));
    });

    test('adet ile çarpım', () {
      expect(Money.fromLira(19, 99) * 3, Money.fromLira(59, 97));
    });

    test('sıfır adet sıfır tutar üretir', () {
      expect(Money.fromLira(19, 99) * 0, Money.zero);
    });

    test('boş liste toplamı sıfırdır', () {
      expect(<Money>[].sum(), Money.zero);
    });
  });

  group('Money — KDV (rateOf / plusRate)', () {
    test('%20 KDV: 100 ₺ → 20 ₺', () {
      expect(Money.fromLira(100).rateOf(Percent.of(20)), Money.fromLira(20));
    });

    test('%20 KDV dahil: 100 ₺ → 120 ₺', () {
      expect(Money.fromLira(100).plusRate(Percent.of(20)), Money.fromLira(120));
    });

    test('%1 KDV: 1000 ₺ → 10 ₺', () {
      expect(Money.fromLira(1000).rateOf(Percent.of(1)), Money.fromLira(10));
    });

    test('kesirli oran: %12,5 → 12,50 ₺', () {
      expect(
        Money.fromLira(100).rateOf(Percent.of(12.5)),
        Money.fromLira(12, 50),
      );
    });

    test('%0 oran tutarı değiştirmez', () {
      expect(Money.fromLira(100).plusRate(Percent.zero), Money.fromLira(100));
    });
  });

  group('Money — iskonto', () {
    test('%10 iskonto: 250 ₺ → 225 ₺', () {
      expect(
        Money.fromLira(250).minusRate(Percent.of(10)),
        Money.fromLira(225),
      );
    });

    test('%100 iskonto tutarı sıfırlar', () {
      expect(Money.fromLira(250).minusRate(Percent.of(100)), Money.zero);
    });
  });

  group('Money — yuvarlama (ticari: yarım sıfırdan uzağa)', () {
    test('tam yarım kuruş yukarı yuvarlanır', () {
      // 0,05 ₺ üzerinden %50 → 0,025 ₺ → 0,03 ₺
      expect(const Money(5).rateOf(Percent.of(50)), const Money(3));
    });

    test('yarımın altı aşağı yuvarlanır', () {
      // 0,04 ₺ üzerinden %10 → 0,004 ₺ → 0,00 ₺
      expect(const Money(4).rateOf(Percent.of(10)), Money.zero);
    });

    test('yarımın üstü yukarı yuvarlanır', () {
      // 0,06 ₺ üzerinden %10 → 0,006 ₺ → 0,01 ₺
      expect(const Money(6).rateOf(Percent.of(10)), const Money(1));
    });

    test(
      'negatif tutarda da yarım sıfırdan uzağa gider (bankacı yuvarlaması DEĞİL)',
      () {
        expect(const Money(-5).rateOf(Percent.of(50)), const Money(-3));
      },
    );

    test(
      'ardışık yarımlar tutarlı yuvarlanır (banker rounding olsaydı 2 ve 4 çıkardı)',
      () {
        expect(
          const Money(5).rateOf(Percent.of(50)),
          const Money(3),
        ); // 2,5 → 3
        expect(
          const Money(15).rateOf(Percent.of(50)),
          const Money(8),
        ); // 7,5 → 8
      },
    );
  });

  group('Money — scaleBy (kesirli miktar)', () {
    test('2,5 kg × 10 ₺ = 25 ₺', () {
      expect(Money.fromLira(10).scaleBy(2.5), Money.fromLira(25));
    });

    test('kesirli sonuç ticari kurala göre yuvarlanır', () {
      // 0,01 ₺ × 1,5 = 0,015 → 0,02
      expect(const Money(1).scaleBy(1.5), const Money(2));
    });
  });

  group('Money — satır toplamı senaryosu (gerçek teklif)', () {
    test('3 adet × 19,99 ₺, %10 iskonto, %20 KDV', () {
      final lineTotal = Money.fromLira(19, 99) * 3; // 59,97
      expect(lineTotal, Money.fromLira(59, 97));

      final discounted = lineTotal.minusRate(
        Percent.of(10),
      ); // 59,97 - 6,00 = 53,97
      expect(discounted, Money.fromLira(53, 97));

      final vat = discounted.rateOf(Percent.of(20)); // 10,794 → 10,79
      expect(vat, Money.fromLira(10, 79));

      expect(discounted + vat, Money.fromLira(64, 76));
    });

    test('KDV satır bazında hesaplanır, toplamdan geriye değil', () {
      // Aynı ürünün iki satırı: her satır ayrı yuvarlanır.
      final line = const Money(333).rateOf(Percent.of(20)); // 0,666 → 0,67
      expect(line, const Money(67));

      final sumOfLines = [line, line].sum(); // 1,34
      final vatOnTotal = const Money(
        666,
      ).rateOf(Percent.of(20)); // 1,332 → 1,33

      // Bu ikisi eşit DEĞİL — bu yüzden kural "satır bazında hesapla".
      expect(sumOfLines, const Money(134));
      expect(vatOnTotal, const Money(133));
      expect(sumOfLines, isNot(vatOnTotal));
    });
  });

  group('Money — karşılaştırma', () {
    test('sıralama operatörleri', () {
      expect(const Money(100) > const Money(50), isTrue);
      expect(const Money(50) < const Money(100), isTrue);
      expect(const Money(100) >= const Money(100), isTrue);
      expect(const Money(100) <= const Money(100), isTrue);
    });

    test('listede sıralanabilir', () {
      final list = [const Money(300), const Money(100), const Money(200)]
        ..sort();
      expect(list, [const Money(100), const Money(200), const Money(300)]);
    });

    test('isZero / isNegative', () {
      expect(Money.zero.isZero, isTrue);
      expect(const Money(-1).isNegative, isTrue);
    });
  });

  group('Percent', () {
    test('baz puana çevirir', () {
      expect(Percent.of(20).basisPoints, 2000);
      expect(Percent.of(12.5).basisPoints, 1250);
      expect(Percent.of(1).basisPoints, 100);
    });

    test('değer eşitliği', () {
      expect(Percent.of(20), const Percent.fromBasisPoints(2000));
    });
  });
}
