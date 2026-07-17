// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryRepository)
final categoryRepositoryProvider = CategoryRepositoryProvider._();

final class CategoryRepositoryProvider
    extends
        $FunctionalProvider<
          CategoryRepository,
          CategoryRepository,
          CategoryRepository
        >
    with $Provider<CategoryRepository> {
  CategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<CategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CategoryRepository create(Ref ref) {
    return categoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CategoryRepository>(value),
    );
  }
}

String _$categoryRepositoryHash() =>
    r'796ee74efef7619c331ae494af6b73e25b263565';

/// Kategori listesi. Yeni kategori eklenince liste kendiliğinden güncellenir
/// (ROADMAP Phase 2: "Kategori listesinin otomatik güncellenmesi").

@ProviderFor(categoryList)
final categoryListProvider = CategoryListProvider._();

/// Kategori listesi. Yeni kategori eklenince liste kendiliğinden güncellenir
/// (ROADMAP Phase 2: "Kategori listesinin otomatik güncellenmesi").

final class CategoryListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  /// Kategori listesi. Yeni kategori eklenince liste kendiliğinden güncellenir
  /// (ROADMAP Phase 2: "Kategori listesinin otomatik güncellenmesi").
  CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return categoryList(ref);
  }
}

String _$categoryListHash() => r'3d906a7e7213488bae94afd56b12cf14deacaa0f';

/// En az bir ürüne bağlı kategorilerin id'leri. Kategori seçici, silme
/// aksiyonunu (çöp kutusu) yalnızca bu kümede olmayan kategorilerde gösterir.

@ProviderFor(usedCategoryIds)
final usedCategoryIdsProvider = UsedCategoryIdsProvider._();

/// En az bir ürüne bağlı kategorilerin id'leri. Kategori seçici, silme
/// aksiyonunu (çöp kutusu) yalnızca bu kümede olmayan kategorilerde gösterir.

final class UsedCategoryIdsProvider
    extends
        $FunctionalProvider<AsyncValue<Set<int>>, Set<int>, Stream<Set<int>>>
    with $FutureModifier<Set<int>>, $StreamProvider<Set<int>> {
  /// En az bir ürüne bağlı kategorilerin id'leri. Kategori seçici, silme
  /// aksiyonunu (çöp kutusu) yalnızca bu kümede olmayan kategorilerde gösterir.
  UsedCategoryIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'usedCategoryIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$usedCategoryIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<int>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Set<int>> create(Ref ref) {
    return usedCategoryIds(ref);
  }
}

String _$usedCategoryIdsHash() => r'bd357f9f73ffec15c13af86b356ae401c1f419ca';
