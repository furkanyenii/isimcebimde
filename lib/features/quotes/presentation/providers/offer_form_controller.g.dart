// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Teklif kaydetme/silme işlemlerinin durumu.
///
/// Formun kendisi (müşteri, satırlar, indirim...) yerel widget state'inde
/// tutulur — Product/Customer formlarıyla aynı desen (CLAUDE.md: Riverpod
/// Rules, `setState` yalnızca widget'a özel geçici state için). Burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

@ProviderFor(OfferFormController)
final offerFormControllerProvider = OfferFormControllerProvider._();

/// Teklif kaydetme/silme işlemlerinin durumu.
///
/// Formun kendisi (müşteri, satırlar, indirim...) yerel widget state'inde
/// tutulur — Product/Customer formlarıyla aynı desen (CLAUDE.md: Riverpod
/// Rules, `setState` yalnızca widget'a özel geçici state için). Burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
final class OfferFormControllerProvider
    extends $AsyncNotifierProvider<OfferFormController, void> {
  /// Teklif kaydetme/silme işlemlerinin durumu.
  ///
  /// Formun kendisi (müşteri, satırlar, indirim...) yerel widget state'inde
  /// tutulur — Product/Customer formlarıyla aynı desen (CLAUDE.md: Riverpod
  /// Rules, `setState` yalnızca widget'a özel geçici state için). Burada yalnızca
  /// kaydetme işleminin async durumu yaşar.
  ///
  /// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
  /// kullanılır (CLAUDE.md: Riverpod Rules).
  OfferFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offerFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offerFormControllerHash();

  @$internal
  @override
  OfferFormController create() => OfferFormController();
}

String _$offerFormControllerHash() =>
    r'a3384a3d0711de138aeee1b4a06866e32e306ccf';

/// Teklif kaydetme/silme işlemlerinin durumu.
///
/// Formun kendisi (müşteri, satırlar, indirim...) yerel widget state'inde
/// tutulur — Product/Customer formlarıyla aynı desen (CLAUDE.md: Riverpod
/// Rules, `setState` yalnızca widget'a özel geçici state için). Burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

abstract class _$OfferFormController extends $AsyncNotifier<void> {
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
