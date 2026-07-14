import 'package:isimcebimde/core/utils/money.dart';
import 'package:meta/meta.dart';

/// Bir teklifin tek satırı.
///
/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
///
/// [productName] ve [unitPrice] eklendiği andaki ürünün **snapshot**'ıdır.
/// Ürünün fiyatı sonra değişse (hatta ürün silinse) bile bu satır değişmez —
/// bu bir muhasebe doğruluğu gereğidir (CLAUDE.md: Database Rules). [vatRate]
/// da ürünün o anki varsayılanından kopyalanır ama satırda serbestçe değiştirilebilir.
@immutable
final class OfferItem {
  const OfferItem({
    this.id,
    this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.vatRate,
    this.discount = Percent.zero,
  });

  /// Henüz kaydedilmemiş satır için `null`.
  final int? id;

  /// Ürün silinirse veritabanı seviyesinde `NULL` olur (`ON DELETE SET NULL`);
  /// yalnızca "bu üründen kaç teklif çıktı" gibi ileri bir rapor için tutulur.
  /// Satırın kendisi [productName]/[unitPrice] sayesinde bundan etkilenmez.
  final int? productId;

  final String productName;
  final Money unitPrice;

  /// Adet tam sayıdır (CLAUDE.md: `Money` — kesirli miktar `scaleBy` gerektirir).
  /// Sıfır veya negatif olamaz.
  final int quantity;

  /// Ürünün eklendiği andaki varsayılanı; bu satırda serbestçe değiştirilebilir.
  final Percent vatRate;

  /// Satır bazlı iskonto. Genel indirimden (bkz. `Offer.generalDiscount`) ayrıdır.
  final Percent discount;

  /// İskonto uygulanmış, KDV hariç satır tutarı.
  Money get lineSubtotal => (unitPrice * quantity).minusRate(discount);

  /// Bu satırın KDV tutarı.
  Money get lineVat => lineSubtotal.rateOf(vatRate);

  /// KDV dahil satır tutarı.
  Money get lineTotal => lineSubtotal + lineVat;

  OfferItem copyWith({
    int? id,
    int? productId,
    String? productName,
    Money? unitPrice,
    int? quantity,
    Percent? vatRate,
    Percent? discount,
  }) => OfferItem(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    unitPrice: unitPrice ?? this.unitPrice,
    quantity: quantity ?? this.quantity,
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
      other.vatRate == vatRate &&
      other.discount == discount;

  @override
  int get hashCode => Object.hash(
    id,
    productId,
    productName,
    unitPrice,
    quantity,
    vatRate,
    discount,
  );
}
