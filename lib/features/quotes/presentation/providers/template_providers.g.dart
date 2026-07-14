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
