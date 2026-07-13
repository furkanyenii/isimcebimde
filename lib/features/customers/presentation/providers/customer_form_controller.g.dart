// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Müşteri kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

@ProviderFor(CustomerFormController)
final customerFormControllerProvider = CustomerFormControllerProvider._();

/// Müşteri kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
final class CustomerFormControllerProvider
    extends $AsyncNotifierProvider<CustomerFormController, void> {
  /// Müşteri kaydetme/silme işlemlerinin durumu.
  ///
  /// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
  /// kullanılır (CLAUDE.md: Riverpod Rules).
  CustomerFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customerFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customerFormControllerHash();

  @$internal
  @override
  CustomerFormController create() => CustomerFormController();
}

String _$customerFormControllerHash() =>
    r'cf00a348e41b39c33468470e73dbffc7053afe66';

/// Müşteri kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

abstract class _$CustomerFormController extends $AsyncNotifier<void> {
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
