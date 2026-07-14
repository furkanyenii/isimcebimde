import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'template_form_controller.g.dart';

/// Şablon kaydetme/silme işlemlerinin durumu.
///
/// Form alanları (ad, satırlar, indirim...) yerel widget state'inde tutulur
/// (Offer/Product/Customer formlarıyla aynı desen); burada yalnızca
/// kaydetme işleminin async durumu yaşar.
///
/// Mutasyonlarda `try/catch` ile elle state set edilmez; `AsyncValue.guard`
/// kullanılır (CLAUDE.md: Riverpod Rules).
@riverpod
class TemplateFormController extends _$TemplateFormController {
  @override
  FutureOr<void> build() {}

  Future<bool> save(Template template) async {
    state = const AsyncLoading();
    final repository = ref.read(templateRepositoryProvider);

    state = await AsyncValue.guard(() async {
      if (template.id == null) {
        await repository.create(template);
      } else {
        await repository.update(template);
      }
    });

    return !state.hasError;
  }

  Future<bool> delete(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(templateRepositoryProvider).delete(id),
    );
    return !state.hasError;
  }
}
