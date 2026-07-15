// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

@ProviderFor(productRepository)
final productRepositoryProvider = ProductRepositoryProvider._();

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

final class ProductRepositoryProvider
    extends
        $FunctionalProvider<
          ProductRepository,
          ProductRepository,
          ProductRepository
        >
    with $Provider<ProductRepository> {
  /// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
  ProductRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductRepository create(Ref ref) {
    return productRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductRepository>(value),
    );
  }
}

String _$productRepositoryHash() => r'6a61007d1525ad19233cc2f69f49035aba68e633';

/// Ürün listesindeki arama metni. Boş string = filtre yok.

@ProviderFor(ProductSearchQuery)
final productSearchQueryProvider = ProductSearchQueryProvider._();

/// Ürün listesindeki arama metni. Boş string = filtre yok.
final class ProductSearchQueryProvider
    extends $NotifierProvider<ProductSearchQuery, String> {
  /// Ürün listesindeki arama metni. Boş string = filtre yok.
  ProductSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productSearchQueryHash();

  @$internal
  @override
  ProductSearchQuery create() => ProductSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$productSearchQueryHash() =>
    r'93d9af36560d846f0053a881a4a8c05edb0f0f7d';

/// Ürün listesindeki arama metni. Boş string = filtre yok.

abstract class _$ProductSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Tüm (arşivlenmemiş) ürünler, filtresiz. Gruplama ve arama presentation
/// katmanında yapılır (kategori adında da aranabilmesi için); DB değiştikçe
/// kendiliğinden yayın yapar.

@ProviderFor(allProducts)
final allProductsProvider = AllProductsProvider._();

/// Tüm (arşivlenmemiş) ürünler, filtresiz. Gruplama ve arama presentation
/// katmanında yapılır (kategori adında da aranabilmesi için); DB değiştikçe
/// kendiliğinden yayın yapar.

final class AllProductsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Product>>,
          List<Product>,
          Stream<List<Product>>
        >
    with $FutureModifier<List<Product>>, $StreamProvider<List<Product>> {
  /// Tüm (arşivlenmemiş) ürünler, filtresiz. Gruplama ve arama presentation
  /// katmanında yapılır (kategori adında da aranabilmesi için); DB değiştikçe
  /// kendiliğinden yayın yapar.
  AllProductsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allProductsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allProductsHash();

  @$internal
  @override
  $StreamProviderElement<List<Product>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Product>> create(Ref ref) {
    return allProducts(ref);
  }
}

String _$allProductsHash() => r'd0ac44611683a0d11b49aeeb0d6f66ba6c554088';

/// Ürünleri kategorileri altında gruplar ve [query] ile filtreler.
///
/// Hem ürün listesi ekranı (paylaşılan arama metniyle) hem teklif ürün seçici
/// bottom sheet'i (kendi yerel arama metniyle) aynı sağlayıcıyı kullanır;
/// bu yüzden [query] parametreyle geçilir. Ürün veya kategori değişince
/// kendiliğinden yeniden hesaplanır.

@ProviderFor(productGroups)
final productGroupsProvider = ProductGroupsFamily._();

/// Ürünleri kategorileri altında gruplar ve [query] ile filtreler.
///
/// Hem ürün listesi ekranı (paylaşılan arama metniyle) hem teklif ürün seçici
/// bottom sheet'i (kendi yerel arama metniyle) aynı sağlayıcıyı kullanır;
/// bu yüzden [query] parametreyle geçilir. Ürün veya kategori değişince
/// kendiliğinden yeniden hesaplanır.

final class ProductGroupsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ProductGroup>>,
          List<ProductGroup>,
          FutureOr<List<ProductGroup>>
        >
    with
        $FutureModifier<List<ProductGroup>>,
        $FutureProvider<List<ProductGroup>> {
  /// Ürünleri kategorileri altında gruplar ve [query] ile filtreler.
  ///
  /// Hem ürün listesi ekranı (paylaşılan arama metniyle) hem teklif ürün seçici
  /// bottom sheet'i (kendi yerel arama metniyle) aynı sağlayıcıyı kullanır;
  /// bu yüzden [query] parametreyle geçilir. Ürün veya kategori değişince
  /// kendiliğinden yeniden hesaplanır.
  ProductGroupsProvider._({
    required ProductGroupsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'productGroupsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$productGroupsHash();

  @override
  String toString() {
    return r'productGroupsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ProductGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ProductGroup>> create(Ref ref) {
    final argument = this.argument as String;
    return productGroups(ref, query: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductGroupsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$productGroupsHash() => r'8771677bfe45430935f7633cabd0f04116f15202';

/// Ürünleri kategorileri altında gruplar ve [query] ile filtreler.
///
/// Hem ürün listesi ekranı (paylaşılan arama metniyle) hem teklif ürün seçici
/// bottom sheet'i (kendi yerel arama metniyle) aynı sağlayıcıyı kullanır;
/// bu yüzden [query] parametreyle geçilir. Ürün veya kategori değişince
/// kendiliğinden yeniden hesaplanır.

final class ProductGroupsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ProductGroup>>, String> {
  ProductGroupsFamily._()
    : super(
        retry: null,
        name: r'productGroupsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ürünleri kategorileri altında gruplar ve [query] ile filtreler.
  ///
  /// Hem ürün listesi ekranı (paylaşılan arama metniyle) hem teklif ürün seçici
  /// bottom sheet'i (kendi yerel arama metniyle) aynı sağlayıcıyı kullanır;
  /// bu yüzden [query] parametreyle geçilir. Ürün veya kategori değişince
  /// kendiliğinden yeniden hesaplanır.

  ProductGroupsProvider call({required String query}) =>
      ProductGroupsProvider._(argument: query, from: this);

  @override
  String toString() => r'productGroupsProvider';
}
