// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(settingsRepository)
final settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'386b8272908126d473256fed76299cd9c9d1b218';

/// Arayüz tipiyle döner: testte sahte depolama tek satırla takılır.

@ProviderFor(logoStorage)
final logoStorageProvider = LogoStorageProvider._();

/// Arayüz tipiyle döner: testte sahte depolama tek satırla takılır.

final class LogoStorageProvider
    extends $FunctionalProvider<LogoStorage, LogoStorage, LogoStorage>
    with $Provider<LogoStorage> {
  /// Arayüz tipiyle döner: testte sahte depolama tek satırla takılır.
  LogoStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoStorageHash();

  @$internal
  @override
  $ProviderElement<LogoStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoStorage create(Ref ref) {
    return logoStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoStorage>(value),
    );
  }
}

String _$logoStorageHash() => r'51649fd24729a7d8a21cee3e306cfe9b1a9d1fa6';

/// Galeri açmak platform kanalı gerektirir; testte sahtelenebilmesi için
/// arayüz üzerinden sağlanır.

@ProviderFor(logoPicker)
final logoPickerProvider = LogoPickerProvider._();

/// Galeri açmak platform kanalı gerektirir; testte sahtelenebilmesi için
/// arayüz üzerinden sağlanır.

final class LogoPickerProvider
    extends $FunctionalProvider<LogoPicker, LogoPicker, LogoPicker>
    with $Provider<LogoPicker> {
  /// Galeri açmak platform kanalı gerektirir; testte sahtelenebilmesi için
  /// arayüz üzerinden sağlanır.
  LogoPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoPickerHash();

  @$internal
  @override
  $ProviderElement<LogoPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoPicker create(Ref ref) {
    return logoPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoPicker>(value),
    );
  }
}

String _$logoPickerHash() => r'11214fa084238b387e63dcb59fa9099da9b02825';

/// Uygulama ayarları. `App` bunu dinler: dil veya tema değişince tüm arayüz
/// kendiliğinden yeniden kurulur — manuel `invalidate` gerekmez.
///
/// `keepAlive`: uygulama ömrü boyunca dinlenir; kök widget'ın altında yaşar.

@ProviderFor(settings)
final settingsProvider = SettingsProvider._();

/// Uygulama ayarları. `App` bunu dinler: dil veya tema değişince tüm arayüz
/// kendiliğinden yeniden kurulur — manuel `invalidate` gerekmez.
///
/// `keepAlive`: uygulama ömrü boyunca dinlenir; kök widget'ın altında yaşar.

final class SettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppSettings>,
          AppSettings,
          Stream<AppSettings>
        >
    with $FutureModifier<AppSettings>, $StreamProvider<AppSettings> {
  /// Uygulama ayarları. `App` bunu dinler: dil veya tema değişince tüm arayüz
  /// kendiliğinden yeniden kurulur — manuel `invalidate` gerekmez.
  ///
  /// `keepAlive`: uygulama ömrü boyunca dinlenir; kök widget'ın altında yaşar.
  SettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsHash();

  @$internal
  @override
  $StreamProviderElement<AppSettings> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<AppSettings> create(Ref ref) {
    return settings(ref);
  }
}

String _$settingsHash() => r'3b6219f1439e57bfda762caba6bd092e11961fb0';

/// Dil ve tema tercihini kaydeder.

@ProviderFor(SettingsController)
final settingsControllerProvider = SettingsControllerProvider._();

/// Dil ve tema tercihini kaydeder.
final class SettingsControllerProvider
    extends $AsyncNotifierProvider<SettingsController, void> {
  /// Dil ve tema tercihini kaydeder.
  SettingsControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsControllerHash();

  @$internal
  @override
  SettingsController create() => SettingsController();
}

String _$settingsControllerHash() =>
    r'183b15034782f4d0b7abbcb3a343c578876dfd86';

/// Dil ve tema tercihini kaydeder.

abstract class _$SettingsController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
