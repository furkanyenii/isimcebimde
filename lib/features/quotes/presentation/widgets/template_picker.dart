import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';

/// Yeni teklife şablon seçtirir. `showProductPicker`/`CustomerPicker` ile
/// aynı gerekçe: kendi yerel arama metnini tutar, ekranın paylaşılan
/// `templateSearchQueryProvider` gibi bir şeyi kullanmaz (öyle bir provider
/// zaten yok — şablon listesinde arama kutusu bu picker'a özeldir).
Future<Template?> showTemplatePicker(BuildContext context) {
  return showModalBottomSheet<Template>(
    context: context,
    isScrollControlled: true,
    builder: (context) => const _TemplatePickerSheet(),
  );
}

class _TemplatePickerSheet extends ConsumerStatefulWidget {
  const _TemplatePickerSheet();

  @override
  ConsumerState<_TemplatePickerSheet> createState() =>
      _TemplatePickerSheetState();
}

class _TemplatePickerSheetState extends ConsumerState<_TemplatePickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final templates = ref.watch(templateListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.templateSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.sm),
            Flexible(
              child: templates.when(
                loading: () => const AppLoadingView(),
                error: (error, _) =>
                    AppErrorView(message: l10n.templatesLoadError),
                data: (items) {
                  final query = _searchController.text;
                  final filtered = items
                      .where((t) => containsNormalized(t.name, query))
                      .toList();

                  if (filtered.isEmpty) {
                    return AppEmptyView(
                      icon: Icons.search_off,
                      title: l10n.emptySearchTitle,
                      description: l10n.emptySearchDescription,
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final template = filtered[index];
                      return ListTile(
                        title: Text(template.name),
                        trailing: Text('${template.items.length}'),
                        onTap: () => Navigator.of(context).pop(template),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
