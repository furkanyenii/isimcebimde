import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/categories/data/repositories/category_repository_impl.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/domain/repositories/category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'category_providers.g.dart';

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) =>
    CategoryRepositoryImpl(ref.watch(appDatabaseProvider));

/// Kategori listesi. Yeni kategori eklenince liste kendiliğinden güncellenir
/// (ROADMAP Phase 2: "Kategori listesinin otomatik güncellenmesi").
@riverpod
Stream<List<Category>> categoryList(Ref ref) =>
    ref.watch(categoryRepositoryProvider).watchAll();

/// En az bir ürüne bağlı kategorilerin id'leri. Kategori seçici, silme
/// aksiyonunu (çöp kutusu) yalnızca bu kümede olmayan kategorilerde gösterir.
@riverpod
Stream<Set<int>> usedCategoryIds(Ref ref) =>
    ref.watch(categoryRepositoryProvider).watchUsedCategoryIds();
