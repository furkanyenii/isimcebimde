import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

/// Teklif satırının miktarı. **Asla `double` değildir** — `Money` ile aynı
/// gerekçe: binde bir cinsinden tam sayı tutulur, 12,5 → 12500.
///
/// Miktar tam sayı olmak zorunda değildir: sahada m², m³ veya paket kesirli
/// girilir (12,5 m²). Kesir hassasiyeti üç haneyle sınırlıdır; bunun ötesi
/// bir teklif belgesinde anlamsızdır ve `Money.scaleBy`'daki yuvarlamayı
/// öngörülemez hale getirir.
@immutable
final class Quantity implements Comparable<Quantity> {
  /// [thousandths]: binde bir. 12500 → 12,5
  const Quantity.fromThousandths(this.thousandths);

  /// `Quantity.of(12.5)` → 12,5 ; `Quantity.of(3)` → 3
  factory Quantity.of(num value) =>
      Quantity.fromThousandths((value * _thousandthsPerWhole).round());

  static const int _thousandthsPerWhole = 1000;
  static const Quantity zero = Quantity.fromThousandths(0);
  static const Quantity one = Quantity.fromThousandths(_thousandthsPerWhole);

  final int thousandths;

  /// Yalnızca [Money.scaleBy] ile çarpım ve gösterim için. Hesap zinciri
  /// buradan devam etmez — çarpımın sonucu yine `Money`'dir ve yuvarlama
  /// orada, tek kuralla yapılır.
  double get asDecimal => thousandths / _thousandthsPerWhole;

  bool get isPositive => thousandths > 0;

  /// Sadece görüntüleme için. Tam sayıysa ondalık basamak gösterilmez
  /// (3 m², 3,000 m² değil); kesirliyse en fazla üç basamak yazılır.
  String format({required String locale}) {
    final formatter = NumberFormat.decimalPatternDigits(
      locale: locale,
      decimalDigits: thousandths % _thousandthsPerWhole == 0 ? 0 : 3,
    );
    return formatter.format(asDecimal);
  }

  @override
  int compareTo(Quantity other) => thousandths.compareTo(other.thousandths);

  @override
  bool operator ==(Object other) =>
      other is Quantity && other.thousandths == thousandths;

  @override
  int get hashCode => thousandths.hashCode;

  @override
  String toString() => 'Quantity($asDecimal)';
}
