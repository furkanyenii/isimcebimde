// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ürün kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

@ProviderFor(ProductFormController)
final productFormControllerProvider = ProductFormControllerProvider._();

/// Ürün kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
final class ProductFormControllerProvider
    extends $AsyncNotifierProvider<ProductFormController, void> {
  /// Ürün kaydetme/silme işlemlerinin durumu.
  ///
  /// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
  /// kullanılır (CLAUDE.md: Riverpod Rules).
  ProductFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productFormControllerHash();

  @$internal
  @override
  ProductFormController create() => ProductFormController();
}

String _$productFormControllerHash() =>
    r'1f9088cb2ecd4dde6bfe0fb64a0d9b71995a9bea';

/// Ürün kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).

abstract class _$ProductFormController extends $AsyncNotifier<void> {
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
