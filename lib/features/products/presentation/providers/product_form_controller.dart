import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_form_controller.g.dart';

/// Ürün kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
@riverpod
class ProductFormController extends _$ProductFormController {
  @override
  FutureOr<void> build() {}

  Future<bool> save(Product product) async {
    state = const AsyncLoading();
    final repository = ref.read(productRepositoryProvider);

    state = await AsyncValue.guard(() async {
      if (product.id == null) {
        await repository.create(product);
      } else {
        await repository.update(product);
      }
    });

    return !state.hasError;
  }

  Future<bool> delete(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productRepositoryProvider).delete(id),
    );
    return !state.hasError;
  }
}
