import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_form_controller.g.dart';

/// Teklif kaydetme/silme işlemlerinin durumu.
///
/// Formun kendisi (müşteri, satırlar, indirim...) yerel widget state'inde
/// tutulur — Product/Customer formlarıyla aynı desen (CLAUDE.md: Riverpod
/// Rules, `setState` yalnızca widget'a özel geçici state için). Burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
@riverpod
class OfferFormController extends _$OfferFormController {
  @override
  FutureOr<void> build() {}

  Future<bool> save(Offer offer) async {
    state = const AsyncLoading();
    final repository = ref.read(offerRepositoryProvider);

    state = await AsyncValue.guard(() async {
      if (offer.id == null) {
        await repository.create(offer);
      } else {
        await repository.update(offer);
      }
    });

    return !state.hasError;
  }

  Future<bool> delete(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(offerRepositoryProvider).delete(id),
    );
    return !state.hasError;
  }
}
