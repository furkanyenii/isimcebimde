// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

@ProviderFor(customerRepository)
final customerRepositoryProvider = CustomerRepositoryProvider._();

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.

final class CustomerRepositoryProvider
    extends
        $FunctionalProvider<
          CustomerRepository,
          CustomerRepository,
          CustomerRepository
        >
    with $Provider<CustomerRepository> {
  /// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
  CustomerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerRepositoryHash();

  @$internal
  @override
  $ProviderElement<CustomerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CustomerRepository create(Ref ref) {
    return customerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CustomerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CustomerRepository>(value),
    );
  }
}

String _$customerRepositoryHash() =>
    r'7aed67e3be4e60f5401b08f54d140559a76b2038';

/// Müşteri listesindeki arama metni. Boş string = filtre yok.

@ProviderFor(CustomerSearchQuery)
final customerSearchQueryProvider = CustomerSearchQueryProvider._();

/// Müşteri listesindeki arama metni. Boş string = filtre yok.
final class CustomerSearchQueryProvider
    extends $NotifierProvider<CustomerSearchQuery, String> {
  /// Müşteri listesindeki arama metni. Boş string = filtre yok.
  CustomerSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerSearchQueryHash();

  @$internal
  @override
  CustomerSearchQuery create() => CustomerSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$customerSearchQueryHash() =>
    r'ccb0b1be794b935a44f28b5028f7cc1b354f8756';

/// Müşteri listesindeki arama metni. Boş string = filtre yok.

abstract class _$CustomerSearchQuery extends $Notifier<String> {
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

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.

@ProviderFor(customerList)
final customerListProvider = CustomerListProvider._();

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.

final class CustomerListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Customer>>,
          List<Customer>,
          Stream<List<Customer>>
        >
    with $FutureModifier<List<Customer>>, $StreamProvider<List<Customer>> {
  /// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
  CustomerListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerListHash();

  @$internal
  @override
  $StreamProviderElement<List<Customer>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Customer>> create(Ref ref) {
    return customerList(ref);
  }
}

String _$customerListHash() => r'92177337dff91ac704b50ce70c34ba3b2696d2e5';

/// Tek bir müşteriyi id ile izler. Müşteri silinirse `null` yayınlar —
/// çağıran taraf bunu bir hata değil, "artık yok" olarak ele almalı
/// (CLAUDE.md: müşteri serbestçe silinebilir, geçmiş teklif bozulmaz).

@ProviderFor(customerById)
final customerByIdProvider = CustomerByIdFamily._();

/// Tek bir müşteriyi id ile izler. Müşteri silinirse `null` yayınlar —
/// çağıran taraf bunu bir hata değil, "artık yok" olarak ele almalı
/// (CLAUDE.md: müşteri serbestçe silinebilir, geçmiş teklif bozulmaz).

final class CustomerByIdProvider
    extends
        $FunctionalProvider<AsyncValue<Customer?>, Customer?, Stream<Customer?>>
    with $FutureModifier<Customer?>, $StreamProvider<Customer?> {
  /// Tek bir müşteriyi id ile izler. Müşteri silinirse `null` yayınlar —
  /// çağıran taraf bunu bir hata değil, "artık yok" olarak ele almalı
  /// (CLAUDE.md: müşteri serbestçe silinebilir, geçmiş teklif bozulmaz).
  CustomerByIdProvider._({
    required CustomerByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'customerByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$customerByIdHash();

  @override
  String toString() {
    return r'customerByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Customer?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Customer?> create(Ref ref) {
    final argument = this.argument as int;
    return customerById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$customerByIdHash() => r'd138ebbf29da42af44b06a7025be5083d51eca53';

/// Tek bir müşteriyi id ile izler. Müşteri silinirse `null` yayınlar —
/// çağıran taraf bunu bir hata değil, "artık yok" olarak ele almalı
/// (CLAUDE.md: müşteri serbestçe silinebilir, geçmiş teklif bozulmaz).

final class CustomerByIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Customer?>, int> {
  CustomerByIdFamily._()
    : super(
        retry: null,
        name: r'customerByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Tek bir müşteriyi id ile izler. Müşteri silinirse `null` yayınlar —
  /// çağıran taraf bunu bir hata değil, "artık yok" olarak ele almalı
  /// (CLAUDE.md: müşteri serbestçe silinebilir, geçmiş teklif bozulmaz).

  CustomerByIdProvider call(int id) =>
      CustomerByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'customerByIdProvider';
}
