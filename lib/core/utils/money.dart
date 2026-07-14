import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// Oran (KDV, iskonto). Yüzde değerleri kesirli olabildiği için (%12,5)
/// baz puan olarak tutulur: 10000 baz puan = %100, 2000 = %20.
@immutable
final class Percent implements Comparable<Percent> {
  const Percent.fromBasisPoints(this.basisPoints);

  /// `Percent.of(20)` → %20, `Percent.of(12.5)` → %12,5
  factory Percent.of(num percent) =>
      Percent.fromBasisPoints((percent * _basisPointsPerPercent).round());

  static const int _basisPointsPerPercent = 100;
  static const Percent zero = Percent.fromBasisPoints(0);

  final int basisPoints;

  double get asPercent => basisPoints / _basisPointsPerPercent;

  @override
  int compareTo(Percent other) => basisPoints.compareTo(other.basisPoints);

  @override
  bool operator ==(Object other) =>
      other is Percent && other.basisPoints == basisPoints;

  @override
  int get hashCode => basisPoints.hashCode;

  @override
  String toString() => '%${asPercent.toStringAsFixed(2)}';
}

/// Para birimi. **Asla `double` değildir** — kuruş cinsinden tam sayı tutar.
///
/// `0.1 + 0.2 != 0.3` hatası bir teklif uygulamasında müşteriye yanlış fiyat
/// vermek demektir; bu yüzden tüm aritmetik `int` üzerinde yapılır ve
/// yuvarlama yalnızca bu sınıfın içinde, tek bir kuralla gerçekleşir.
@immutable
final class Money implements Comparable<Money> {
  /// [minor]: kuruş. 12345 → 123,45 ₺
  const Money(this.minor);

  /// `Money.fromLira(123, 45)` → 123,45 ₺
  factory Money.fromLira(int lira, [int kurus = 0]) =>
      Money(lira * _minorPerMajor + (lira.isNegative ? -kurus : kurus));

  static const int _minorPerMajor = 100;
  static const int _basisPointsPerWhole = 10000;
  static const Money zero = Money(0);

  final int minor;

  bool get isZero => minor == 0;
  bool get isNegative => minor < 0;

  Money operator +(Money other) => Money(minor + other.minor);
  Money operator -(Money other) => Money(minor - other.minor);
  Money operator -() => Money(-minor);

  /// Adet ile çarpım. Adet tam sayıdır; kesirli miktar (kg, metre) gerekirse
  /// [scaleBy] kullanılmalı, çünkü orada yuvarlama kaçınılmazdır.
  Money operator *(int quantity) => Money(minor * quantity);

  /// Bu tutarın [rate] kadarı. KDV *tutarını* hesaplamak için kullanılır.
  /// Örn: 100 ₺ üzerinden %20 → 20 ₺
  Money rateOf(Percent rate) =>
      Money(_mulDivRound(minor, rate.basisPoints, _basisPointsPerWhole));

  /// Üzerine oran ekler (KDV dahil tutar).
  Money plusRate(Percent rate) => this + rateOf(rate);

  /// Oran kadar düşer (iskonto uygulanmış tutar).
  Money minusRate(Percent rate) => this - rateOf(rate);

  /// Kesirli miktarla çarpım (ör. 2,5 kg). Yuvarlama burada olur.
  Money scaleBy(num factor) =>
      Money(_roundHalfAwayFromZero(minor * factor.toDouble()));

  /// Ticari yuvarlama: 0,5 ve üzeri sıfırdan uzağa yuvarlanır.
  ///
  /// Bankacı yuvarlaması (`round-half-to-even`) **kullanılmaz** — teklif
  /// çıktısı kullanıcının muhasebesiyle ve elle yapılan hesapla tutmalıdır.
  static int _roundHalfAwayFromZero(double value) =>
      value.isNegative ? -(value.abs() + 0.5).floor() : (value + 0.5).floor();

  /// `value * mul / div` işlemini taşma ve kayan nokta hatası olmadan yapar.
  static int _mulDivRound(int value, int mul, int div) {
    final product = value * mul;
    final quotient = product.abs() ~/ div;
    final remainder = product.abs() % div;
    final rounded = remainder * 2 >= div ? quotient + 1 : quotient;
    return product.isNegative ? -rounded : rounded;
  }

  /// Sadece görüntüleme için. Hesapta asla kullanılmaz.
  ///
  /// [locale] biçimi belirler (TR `12,50`, EN `12.50`), [symbol] para birimini —
  /// ikisi bağımsızdır: İngilizce arayüz kullanan biri de ₺ ile teklif verebilir.
  /// Locale çağıranın sorumluluğudur; `Money` hangi dilde olduğumuzu bilemez.
  String format({required String locale, String symbol = '₺'}) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: 2,
    );
    return formatter.format(minor / _minorPerMajor);
  }

  @override
  int compareTo(Money other) => minor.compareTo(other.minor);

  bool operator <(Money other) => minor < other.minor;
  bool operator <=(Money other) => minor <= other.minor;
  bool operator >(Money other) => minor > other.minor;
  bool operator >=(Money other) => minor >= other.minor;

  @override
  bool operator ==(Object other) => other is Money && other.minor == minor;

  @override
  int get hashCode => minor.hashCode;

  @override
  String toString() => 'Money(${minor / _minorPerMajor})';
}

/// Toplama işlemleri için kısayol. Teklif satırlarını toplarken kullanılır.
extension MoneyIterableX on Iterable<Money> {
  Money sum() => fold(Money.zero, (total, item) => total + item);
}
