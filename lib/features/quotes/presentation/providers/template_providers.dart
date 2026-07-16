import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/features/quotes/data/repositories/template_repository_impl.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/template_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_providers.g.dart';

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
@Riverpod(keepAlive: true)
TemplateRepository templateRepository(Ref ref) =>
    TemplateRepositoryImpl(ref.watch(appDatabaseProvider));

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
@riverpod
Stream<List<Template>> templateList(Ref ref) =>
    ref.watch(templateRepositoryProvider).watchAll();

/// Şablon listesindeki arama metni. Boş string = filtre yok
/// ([ProductSearchQuery] ile aynı desen).
@riverpod
class TemplateSearchQuery extends _$TemplateSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// Şablon listesi ekranının arama metniyle filtrelenmiş şablonlar.
/// Şablon eklenince/silinince kendiliğinden yeniden hesaplanır
/// ([productGroups] ile aynı desen).
///
/// Filtre SQL'de değil burada: SQLite'ın `LIKE`'ı Türkçe harflerde yanlış
/// sonuç verir (bkz. `core/utils/turkish_text.dart`).
@riverpod
Future<List<Template>> filteredTemplateList(Ref ref) async {
  final query = ref.watch(templateSearchQueryProvider);
  final templates = await ref.watch(templateListProvider.future);
  return templates.where((t) => containsNormalized(t.name, query)).toList();
}
