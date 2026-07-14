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

  /// Kaydedilen ürünü döner (yeni üründe artık `id` doludur), hata halinde
  /// `null`. Çağıran, id'ye ihtiyaç duyar: ürün picker'ı içinden oluşturulan
  /// ürün doğrudan teklife eklenir.
  Future<Product?> save(Product product) async {
    state = const AsyncLoading();
    final repository = ref.read(productRepositoryProvider);

    Product? saved;
    state = await AsyncValue.guard(() async {
      if (product.id == null) {
        final id = await repository.create(product);
        saved = product.copyWith(id: id);
      } else {
        await repository.update(product);
        saved = product;
      }
    });

    return state.hasError ? null : saved;
  }

  Future<bool> delete(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(productRepositoryProvider).delete(id),
    );
    return !state.hasError;
  }
}
