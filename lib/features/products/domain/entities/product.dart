import 'package:isimcebimde/core/utils/money.dart';
import 'package:meta/meta.dart';

/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
@immutable
final class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.isArchived = false,
  });

  /// Henüz kaydedilmemiş ürün için `null`.
  final int? id;
  final String name;
  final Money price;
  final bool isArchived;

  Product copyWith({int? id, String? name, Money? price, bool? isArchived}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Product &&
      other.id == id &&
      other.name == name &&
      other.price == price &&
      other.isArchived == isArchived;

  @override
  int get hashCode => Object.hash(id, name, price, isArchived);
}
