import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/template_repository.dart';

/// Şablon listesini sahteleyen repository.
///
/// Yeni teklif akışı (`openNewOfferFlow`) şablonları okur; bu yüzden teklif
/// formuna götüren **her** ekranın testi bunu takmak zorundadır — takılmazsa
/// test gerçek veritabanına uzanır (CLAUDE.md: Test Rules). Üç ekran testi
/// paylaştığı için burada tek kez tanımlanır.
///
/// Varsayılan boş liste: "şablon yok" ekranların çoğu için doğru varsayımdır ve
/// akışı doğrudan boş forma götürür.
class FakeTemplateRepository implements TemplateRepository {
  const FakeTemplateRepository({this.templates = const [], this.fails = false});

  final List<Template> templates;

  /// `true` ise okuma hata verir — şablonlar okunamadığında teklif akışının
  /// durmadığını sınamak için.
  final bool fails;

  @override
  Stream<List<Template>> watchAll() =>
      fails ? Stream.error(Exception('bozuk')) : Stream.value(templates);

  @override
  Stream<Template?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Template template) async => 1;

  @override
  Future<void> update(Template template) async {}

  @override
  Future<void> delete(int id) async {}
}
