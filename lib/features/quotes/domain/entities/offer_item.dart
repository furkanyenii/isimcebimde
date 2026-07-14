import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_unit.dart';
import 'package:meta/meta.dart';

/// Bir teklifin tek satırı.
///
/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
///
/// [productName] ve [unitPrice] eklendiği andaki ürünün **snapshot**'ıdır.
/// Ürünün fiyatı sonra değişse (hatta ürün silinse) bile bu satır değişmez —
/// bu bir muhasebe doğruluğu gereğidir (CLAUDE.md: Database Rules).
///
/// [vatRate] ürünün değil **satırın** özelliğidir: aynı ürün farklı teklifte
/// farklı oranla satılabilir, bu yüzden kullanıcı KDV'yi her satırda kendisi
/// girer; ürün kartında KDV tutulmaz.
@immutable
final class OfferItem {
  const OfferItem({
    this.id,
    this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.unit = kDefaultUnit,
    this.vatRate = defaultVatRate,
    this.discount = Percent.zero,
  });

  /// Satır eklenirken kullanılan varsayılan KDV oranı (%20). Kullanıcı satırda
  /// serbestçe değiştirir — bu yalnızca en sık girilen değeri hazır getirir.
  static const Percent defaultVatRate = Percent.fromBasisPoints(2000);

  /// Henüz kaydedilmemiş satır için `null`.
  final int? id;

  /// Ürün silinirse veritabanı seviyesinde `NULL` olur (`ON DELETE SET NULL`);
  /// yalnızca "bu üründen kaç teklif çıktı" gibi ileri bir rapor için tutulur.
  /// Satırın kendisi [productName]/[unitPrice] sayesinde bundan etkilenmez.
  final int? productId;

  final String productName;
  final Money unitPrice;

  /// Kesirli olabilir (12,5 m²) — bkz. [Quantity]. Sıfır veya negatif olamaz.
  final Quantity quantity;

  /// Ölçü birimi: hazır birimlerden biri ([OfferUnit]) ya da kullanıcının
  /// eklediği serbest metin. Yalnızca bir etikettir, hesaba girmez.
  final String unit;

  /// Bu satıra uygulanan KDV oranı.
  final Percent vatRate;

  /// Satır bazlı iskonto. Genel indirimden (bkz. `Offer.generalDiscount`) ayrıdır.
  final Percent discount;

  /// İskonto uygulanmış, KDV hariç satır tutarı.
  ///
  /// Miktar kesirli olabildiği için çarpım [Money.scaleBy] ile yapılır;
  /// yuvarlama orada, tek ve ortak kuralla (ticari yuvarlama) gerçekleşir.
  Money get lineSubtotal =>
      unitPrice.scaleBy(quantity.asDecimal).minusRate(discount);

  /// Bu satırın KDV tutarı.
  Money get lineVat => lineSubtotal.rateOf(vatRate);

  /// KDV dahil satır tutarı.
  Money get lineTotal => lineSubtotal + lineVat;

  OfferItem copyWith({
    int? id,
    int? productId,
    String? productName,
    Money? unitPrice,
    Quantity? quantity,
    String? unit,
    Percent? vatRate,
    Percent? discount,
  }) => OfferItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    unitPrice: unitPrice ?? this.unitPrice,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    vatRate: vatRate ?? this.vatRate,
    discount: discount ?? this.discount,
  );

  @override
  bool operator ==(Object other) =>
      other is OfferItem &&
      other.id == id &&
      other.productId == productId &&
      other.productName == productName &&
      other.unitPrice == unitPrice &&
      other.quantity == quantity &&
      other.unit == unit &&
      other.vatRate == vatRate &&
      other.discount == discount;

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    productName,
    unitPrice,
    quantity,
    unit,
    vatRate,
    discount,
  );
}
