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
/// Filtresiz tüm teklifler — dashboard'daki teklif sayısı bunu kullanır.

@ProviderFor(offerList)
final offerListProvider = OfferListProvider._();

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
/// Filtresiz tüm teklifler — dashboard'daki teklif sayısı bunu kullanır.

final class OfferListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          List<Offer>,
          Stream<List<Offer>>
        >
    with $FutureModifier<List<Offer>>, $StreamProvider<List<Offer>> {
  /// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
  /// Filtresiz tüm teklifler — dashboard'daki teklif sayısı bunu kullanır.
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

/// Teklifler listesindeki müşteri filtresi. `null` = tüm müşteriler.
/// Seçilen müşterinin `id`'sini tutar; gösterilecek ad, filtre bileşeni
/// müşteri listesinden bu id ile çözer (böylece ad snapshot'ı bayatlamaz).

@ProviderFor(OfferCustomerFilter)
final offerCustomerFilterProvider = OfferCustomerFilterProvider._();

/// Teklifler listesindeki müşteri filtresi. `null` = tüm müşteriler.
/// Seçilen müşterinin `id`'sini tutar; gösterilecek ad, filtre bileşeni
/// müşteri listesinden bu id ile çözer (böylece ad snapshot'ı bayatlamaz).
final class OfferCustomerFilterProvider
    extends $NotifierProvider<OfferCustomerFilter, int?> {
  /// Teklifler listesindeki müşteri filtresi. `null` = tüm müşteriler.
  /// Seçilen müşterinin `id`'sini tutar; gösterilecek ad, filtre bileşeni
  /// müşteri listesinden bu id ile çözer (böylece ad snapshot'ı bayatlamaz).
  OfferCustomerFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offerCustomerFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offerCustomerFilterHash();

  @$internal
  @override
  OfferCustomerFilter create() => OfferCustomerFilter();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int?>(value),
    );
  }
}

String _$offerCustomerFilterHash() =>
    r'3b921d24e0122ab24461c9eeb82efd1571d8a3ac';

/// Teklifler listesindeki müşteri filtresi. `null` = tüm müşteriler.
/// Seçilen müşterinin `id`'sini tutar; gösterilecek ad, filtre bileşeni
/// müşteri listesinden bu id ile çözer (böylece ad snapshot'ı bayatlamaz).

abstract class _$OfferCustomerFilter extends $Notifier<int?> {
  int? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int?, int?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int?, int?>,
              int?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Teklifler ekranının izlediği liste: [offerCustomerFilterProvider] seçiliyse
/// o müşteriye ait tekliflere daraltır. Silinmiş müşteri (customerId == null)
/// zaten filtre listesinde seçilemez, bu yüzden id eşitliği yeterli.
///
/// Repository'ye yeniden abone olmaz; [offerListProvider]'ın tek stream'i
/// üzerine filtre uygular. Filtre değişince yeni bir DB aboneliği açılmaz ve
/// dashboard'la aynı kaynak paylaşılır (loading/error durumları aynen taşınır).

@ProviderFor(filteredOfferList)
final filteredOfferListProvider = FilteredOfferListProvider._();

/// Teklifler ekranının izlediği liste: [offerCustomerFilterProvider] seçiliyse
/// o müşteriye ait tekliflere daraltır. Silinmiş müşteri (customerId == null)
/// zaten filtre listesinde seçilemez, bu yüzden id eşitliği yeterli.
///
/// Repository'ye yeniden abone olmaz; [offerListProvider]'ın tek stream'i
/// üzerine filtre uygular. Filtre değişince yeni bir DB aboneliği açılmaz ve
/// dashboard'la aynı kaynak paylaşılır (loading/error durumları aynen taşınır).

final class FilteredOfferListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Offer>>,
          AsyncValue<List<Offer>>,
          AsyncValue<List<Offer>>
        >
    with $Provider<AsyncValue<List<Offer>>> {
  /// Teklifler ekranının izlediği liste: [offerCustomerFilterProvider] seçiliyse
  /// o müşteriye ait tekliflere daraltır. Silinmiş müşteri (customerId == null)
  /// zaten filtre listesinde seçilemez, bu yüzden id eşitliği yeterli.
  ///
  /// Repository'ye yeniden abone olmaz; [offerListProvider]'ın tek stream'i
  /// üzerine filtre uygular. Filtre değişince yeni bir DB aboneliği açılmaz ve
  /// dashboard'la aynı kaynak paylaşılır (loading/error durumları aynen taşınır).
  FilteredOfferListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredOfferListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredOfferListHash();

  @$internal
  @override
  $ProviderElement<AsyncValue<List<Offer>>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AsyncValue<List<Offer>> create(Ref ref) {
    return filteredOfferList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Offer>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Offer>>>(value),
    );
  }
}

String _$filteredOfferListHash() => r'af6adbab390993e226be7f54b4e5737c181cef98';
