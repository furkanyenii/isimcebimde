// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_unit_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

@ProviderFor(customUnitRepository)
final customUnitRepositoryProvider = CustomUnitRepositoryProvider._();

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

final class CustomUnitRepositoryProvider
    extends
        $FunctionalProvider<
          CustomUnitRepository,
          CustomUnitRepository,
          CustomUnitRepository
        >
    with $Provider<CustomUnitRepository> {
  /// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
  CustomUnitRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customUnitRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customUnitRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomUnitRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomUnitRepository create(Ref ref) {
    return customUnitRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomUnitRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomUnitRepository>(value),
    );
  }
}

String _$customUnitRepositoryHash() =>
    r'd548b629209886e7471b92603d65c9a04fe8d9ac';

/// Kullanıcının eklediği birimler. DB değiştikçe kendiliğinden yayın yapar;
/// yeni birim eklenince teklif ekranındaki dropdown manuel invalidate olmadan
/// güncellenir.

@ProviderFor(customUnitList)
final customUnitListProvider = CustomUnitListProvider._();

/// Kullanıcının eklediği birimler. DB değiştikçe kendiliğinden yayın yapar;
/// yeni birim eklenince teklif ekranındaki dropdown manuel invalidate olmadan
/// güncellenir.

final class CustomUnitListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          Stream<List<String>>
        >
    with $FutureModifier<List<String>>, $StreamProvider<List<String>> {
  /// Kullanıcının eklediği birimler. DB değiştikçe kendiliğinden yayın yapar;
  /// yeni birim eklenince teklif ekranındaki dropdown manuel invalidate olmadan
  /// güncellenir.
  CustomUnitListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customUnitListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customUnitListHash();

  @$internal
  @override
  $StreamProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<String>> create(Ref ref) {
    return customUnitList(ref);
  }
}

String _$customUnitListHash() => r'58c00f9f102645690833a553decf170b92ddd2eb';
