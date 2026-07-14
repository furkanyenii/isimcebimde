import 'package:isimcebimde/app/di/database_provider.dart';
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
