import 'package:isimcebimde/core/utils/money.dart';
import 'package:meta/meta.dart';

/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
///
/// Ürünün **KDV oranı yoktur**: aynı ürün farklı tekliflerde farklı oranla
/// satılabildiği için KDV, ürünün değil teklif satırının özelliğidir
/// (bkz. `OfferItem.vatRate`).
@immutable
final class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.categoryId,
    this.isArchived = false,
  });

  /// Henüz kaydedilmemiş ürün için `null`.
  final int? id;
  final String name;
  final Money price;

  /// Kategori zorunludur; ürün kategorisiz olamaz.
  final int categoryId;

  final bool isArchived;

  Product copyWith({
    int? id,
    String? name,
    Money? price,
    int? categoryId,
    bool? isArchived,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
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
      other.isArchived == isArchived;

  @override
  int get hashCode => Object.hash(id, name, price, categoryId, isArchived);
}
