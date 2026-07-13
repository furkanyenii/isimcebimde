import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_form_controller.g.dart';

/// Müşteri kaydetme/silme işlemlerinin durumu.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
@riverpod
class CustomerFormController extends _$CustomerFormController {
  @override
  FutureOr<void> build() {}

  Future<bool> save(Customer customer) async {
    state = const AsyncLoading();
    final repository = ref.read(customerRepositoryProvider);

    state = await AsyncValue.guard(() async {
      if (customer.id == null) {
        await repository.create(customer);
      } else {
        await repository.update(customer);
      }
    });

    return !state.hasError;
  }

  Future<bool> delete(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(customerRepositoryProvider).delete(id),
    );
    return !state.hasError;
  }
}
