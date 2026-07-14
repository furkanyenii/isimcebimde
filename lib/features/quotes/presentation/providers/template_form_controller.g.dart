// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'template_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Şablon kaydetme/silme işlemlerinin durumu.
///
/// Form alanları (ad, satırlar, indirim...) yerel widget state'inde tutulur
/// (Offer/Product/Customer formlarıyla aynı desen); burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

@ProviderFor(TemplateFormController)
final templateFormControllerProvider = TemplateFormControllerProvider._();

/// Şablon kaydetme/silme işlemlerinin durumu.
///
/// Form alanları (ad, satırlar, indirim...) yerel widget state'inde tutulur
/// (Offer/Product/Customer formlarıyla aynı desen); burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
final class TemplateFormControllerProvider
    extends $AsyncNotifierProvider<TemplateFormController, void> {
  /// Şablon kaydetme/silme işlemlerinin durumu.
  ///
  /// Form alanları (ad, satırlar, indirim...) yerel widget state'inde tutulur
  /// (Offer/Product/Customer formlarıyla aynı desen); burada yalnızca
  /// kaydetme işleminin async durumu yaşar.
  ///
  /// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
  /// kullanılır (CLAUDE.md: Riverpod Rules).
  TemplateFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'templateFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$templateFormControllerHash();

  @$internal
  @override
  TemplateFormController create() => TemplateFormController();
}

String _$templateFormControllerHash() =>
    r'9a1a6978ea67faeef282c172ac712ef84a41c51c';

/// Şablon kaydetme/silme işlemlerinin durumu.
///
/// Form alanları (ad, satırlar, indirim...) yerel widget state'inde tutulur
/// (Offer/Product/Customer formlarıyla aynı desen); burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

abstract class _$TemplateFormController extends $AsyncNotifier<void> {
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
