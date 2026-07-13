import 'package:isimcebimde/core/utils/money.dart';
import 'package:meta/meta.dart';

/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
@immutable
final class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.vatRate = defaultVatRate,
    this.isArchived = false,
  });

  /// Türkiye'de en yaygın oran. Ürün eklerken varsayılan olarak gelir.
  static const Percent defaultVatRate = Percent.fromBasisPoints(2000);

  /// Henüz kaydedilmemiş ürün için `null`.
  final int? id;
  final String name;
  final Money price;

  /// Kategori zorunludur; ürün kategorisiz olamaz.
  final int categoryId;

  /// Ürünün *varsayılan* KDV oranı. Teklif satırına kopyalanır ve orada
  /// değiştirilebilir — geçmiş teklifler ürün değişse de bozulmaz.
  final Percent vatRate;

  final bool isArchived;

  Product copyWith({
    int? id,
    String? name,
    Money? price,
    int? categoryId,
    Percent? vatRate,
    bool? isArchived,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      vatRate: vatRate ?? this.vatRate,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Product &&
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.categoryId == categoryId &&
      other.vatRate == vatRate &&
      other.isArchived == isArchived;

  @override
  int get hashCode =>
      Object.hash(id, name, price, categoryId, vatRate, isArchived);
}
