// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

@ProviderFor(templateRepository)
final templateRepositoryProvider = TemplateRepositoryProvider._();

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

final class TemplateRepositoryProvider
    extends
        $FunctionalProvider<
          TemplateRepository,
          TemplateRepository,
          TemplateRepository
        >
    with $Provider<TemplateRepository> {
  /// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
  TemplateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateRepositoryHash();

  @$internal
  @override
  $ProviderElement<TemplateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TemplateRepository create(Ref ref) {
    return templateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TemplateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TemplateRepository>(value),
    );
  }
}

String _$templateRepositoryHash() =>
    r'08d11285c4facbf0aa3652322a992a8333adc7b2';

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.

@ProviderFor(templateList)
final templateListProvider = TemplateListProvider._();

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.

final class TemplateListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Template>>,
          List<Template>,
          Stream<List<Template>>
        >
    with $FutureModifier<List<Template>>, $StreamProvider<List<Template>> {
  /// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
  TemplateListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateListHash();

  @$internal
  @override
  $StreamProviderElement<List<Template>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Template>> create(Ref ref) {
    return templateList(ref);
  }
}

String _$templateListHash() => r'6f5d0968e232cd85b15cebb7ac455e868a14b54c';

/// Şablon listesindeki arama metni. Boş string = filtre yok
/// ([ProductSearchQuery] ile aynı desen).

@ProviderFor(TemplateSearchQuery)
final templateSearchQueryProvider = TemplateSearchQueryProvider._();

/// Şablon listesindeki arama metni. Boş string = filtre yok
/// ([ProductSearchQuery] ile aynı desen).
final class TemplateSearchQueryProvider
    extends $NotifierProvider<TemplateSearchQuery, String> {
  /// Şablon listesindeki arama metni. Boş string = filtre yok
  /// ([ProductSearchQuery] ile aynı desen).
  TemplateSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateSearchQueryHash();

  @$internal
  @override
  TemplateSearchQuery create() => TemplateSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$templateSearchQueryHash() =>
    r'68096194786b0ae67df11b46bce1503802c9a49b';

/// Şablon listesindeki arama metni. Boş string = filtre yok
/// ([ProductSearchQuery] ile aynı desen).

abstract class _$TemplateSearchQuery extends $Notifier<String> {
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

/// Şablon listesi ekranının arama metniyle filtrelenmiş şablonlar.
/// Şablon eklenince/silinince kendiliğinden yeniden hesaplanır
/// ([productGroups] ile aynı desen).
///
/// Filtre SQL'de değil burada: SQLite'ın `LIKE`'ı Türkçe harflerde yanlış
/// sonuç verir (bkz. `core/utils/turkish_text.dart`).

@ProviderFor(filteredTemplateList)
final filteredTemplateListProvider = FilteredTemplateListProvider._();

/// Şablon listesi ekranının arama metniyle filtrelenmiş şablonlar.
/// Şablon eklenince/silinince kendiliğinden yeniden hesaplanır
/// ([productGroups] ile aynı desen).
///
/// Filtre SQL'de değil burada: SQLite'ın `LIKE`'ı Türkçe harflerde yanlış
/// sonuç verir (bkz. `core/utils/turkish_text.dart`).

final class FilteredTemplateListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Template>>,
          List<Template>,
          FutureOr<List<Template>>
        >
    with $FutureModifier<List<Template>>, $FutureProvider<List<Template>> {
  /// Şablon listesi ekranının arama metniyle filtrelenmiş şablonlar.
  /// Şablon eklenince/silinince kendiliğinden yeniden hesaplanır
  /// ([productGroups] ile aynı desen).
  ///
  /// Filtre SQL'de değil burada: SQLite'ın `LIKE`'ı Türkçe harflerde yanlış
  /// sonuç verir (bkz. `core/utils/turkish_text.dart`).
  FilteredTemplateListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredTemplateListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredTemplateListHash();

  @$internal
  @override
  $FutureProviderElement<List<Template>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Template>> create(Ref ref) {
    return filteredTemplateList(ref);
  }
}

String _$filteredTemplateListHash() =>
    r'141da1b1cc0fc4f2bafb4f85983610993823ef01';
