// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initialization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulama açılışında bir kez çalışan hazırlık adımı.
///
/// Drift veritabanını tembel açar: ilk sorgu, dosyanın oluşturulmasını,
/// şemanın kurulmasını ve migration'ların çalışmasını tetikler. Bunu splash
/// ekranında yapmak, kullanıcının ilk ekranda takılmasını önler ve
/// veritabanı açılamazsa hatayı **görünür** kılar (sessizce yutulmaz).

@ProviderFor(appInitialization)
final appInitializationProvider = AppInitializationProvider._();

/// Uygulama açılışında bir kez çalışan hazırlık adımı.
///
/// Drift veritabanını tembel açar: ilk sorgu, dosyanın oluşturulmasını,
/// şemanın kurulmasını ve migration'ların çalışmasını tetikler. Bunu splash
/// ekranında yapmak, kullanıcının ilk ekranda takılmasını önler ve
/// veritabanı açılamazsa hatayı **görünür** kılar (sessizce yutulmaz).

final class AppInitializationProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  /// Uygulama açılışında bir kez çalışan hazırlık adımı.
  ///
  /// Drift veritabanını tembel açar: ilk sorgu, dosyanın oluşturulmasını,
  /// şemanın kurulmasını ve migration'ların çalışmasını tetikler. Bunu splash
  /// ekranında yapmak, kullanıcının ilk ekranda takılmasını önler ve
  /// veritabanı açılamazsa hatayı **görünür** kılar (sessizce yutulmaz).
  AppInitializationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInitializationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInitializationHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appInitialization(ref);
  }
}

String _$appInitializationHash() => r'18fcda859df84ee3eecc658cf49846cf2b63843a';
