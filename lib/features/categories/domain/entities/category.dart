import 'package:meta/meta.dart';

/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
@immutable
final class Category {
  const Category({required this.id, required this.name});

  /// Henüz kaydedilmemiş kategori için `null`.
  final int? id;
  final String name;

  Category copyWith({int? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);

  @override
  bool operator ==(Object other) =>
      other is Category && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);
}
