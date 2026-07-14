import 'package:isimcebimde/features/quotes/domain/entities/template.dart';

/// Presentation katmanı yalnızca bu arayüzü görür.
/// Drift tipleri (`AppDatabase`, `TemplateRow`, `TemplateItemRow`) buranın
/// dışına sızmaz.
abstract interface class TemplateRepository {
  /// Şablonların tamamı (satırlarıyla birlikte), oluşturulma sırasına göre.
  Stream<List<Template>> watchAll();

  /// Tek bir şablon (satırlarıyla birlikte). Bulunamazsa `null`.
  Stream<Template?> watchById(int id);

  /// Yeni şablonu ve tüm satırlarını **tek transaction'da** oluşturur,
  /// id'sini döner.
  Future<int> create(Template template);

  /// Var olan şablonu ve satırlarını günceller. [Template.id] null olamaz.
  /// Satırlar, verilen [Template.items] listesiyle **tamamen değiştirilir**
  /// (diff'lenmez) — `OfferRepository.update` ile aynı desen.
  Future<void> update(Template template);

  /// Şablonu ve tüm satırlarını kalıcı olarak siler.
  Future<void> delete(int id);
}
