// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

@ProviderFor(offerRepository)
final offerRepositoryProvider = OfferRepositoryProvider._();

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

final class OfferRepositoryProvider
    extends
        $FunctionalProvider<OfferRepository, OfferRepository, OfferRepository>
    with $Provider<OfferRepository> {
  /// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
  OfferRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offerRepositoryHash();

  @$internal
  @override
  $ProviderElement<OfferRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OfferRepository create(Ref ref) {
    return offerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfferRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfferRepository>(value),
    );
  }
}

String _$offerRepositoryHash() => r'a4b98401ae80f84b924ea443bbde9e32715920f6';

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.

@ProviderFor(offerList)
final offerListProvider = OfferListProvider._();

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.

final class OfferListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          List<Offer>,
          Stream<List<Offer>>
        >
    with $FutureModifier<List<Offer>>, $StreamProvider<List<Offer>> {
  /// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
  OfferListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offerListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offerListHash();

  @$internal
  @override
  $StreamProviderElement<List<Offer>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Offer>> create(Ref ref) {
    return offerList(ref);
  }
}

String _$offerListHash() => r'1e1edaef65c5b1da4ae71dd81acb4730f83c6b3f';
