import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_paging.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';
import 'package:isimcebimde/core/widgets/app_paginated_list_view.dart';
import 'package:isimcebimde/core/widgets/app_search_field.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/template_form_screen.dart';

class TemplateListScreen extends ConsumerWidget {
  const TemplateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(templateSearchQueryProvider);
    final templates = ref.watch(filteredTemplateListProvider);
    final hasPagination =
        (templates.asData?.value.length ?? 0) > AppPaging.pageSize;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.templatesTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: AppSearchField(
              hintText: l10n.templateSearchHint,
              onChanged: (value) =>
                  ref.read(templateSearchQueryProvider.notifier).update(value),
            ),
          ),
          Expanded(
            child: templates.when(
              loading: () => const AppLoadingView(),
              error: (error, _) => AppErrorView(
                message: l10n.templatesLoadError,
                onRetry: () => ref.invalidate(templateListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  // Arama sonucu boş olmakla, hiç şablon olmaması farklı
                  // şeylerdir. Eylem butonu yok: yeni şablon zaten sağ alttaki
                  // FAB ile açılır (ProductListScreen ile aynı desen).
                  return query.trim().isEmpty
                      ? AppEmptyView(
                          icon: Icons.bookmarks_outlined,
                          title: l10n.templatesEmptyTitle,
                          description: l10n.templatesEmptyDescription,
                        )
                      : AppEmptyView(
                          icon: Icons.search_off,
                          title: l10n.emptySearchTitle,
                          description: l10n.emptySearchDescription,
                        );
                }
                return AppPaginatedListView<Template>(
                  items: items,
                  pageBuilder: (context, pageItems) => ListView.separated(
                    // FAB son kartı örtmesin.
                    padding: const EdgeInsets.fromLTRB(
                      AppSizes.md,
                      0,
                      AppSizes.md,
                      AppSizes.xxl + AppSizes.lg,
                    ),
                    itemCount: pageItems.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSizes.sm),
                    itemBuilder: (context, index) =>
                        _TemplateTile(template: pageItems[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // Sayfalama çubuğu görünürken FAB'ı çubuk yüksekliği kadar kaldır.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: hasPagination ? AppPaging.barHeight : 0,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => _openTemplateForm(context),
          icon: const Icon(Icons.add),
          label: Text(l10n.templateNew),
        ),
      ),
    );
  }
}

void _openTemplateForm(BuildContext context, {Template? template}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => TemplateFormScreen(template: template),
    ),
  );
}

class _TemplateTile extends StatelessWidget {
  const _TemplateTile({required this.template});

  final Template template;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      icon: Icons.bookmark_outline,
      iconColor: AppColors.info,
      title: template.name,
      subtitle: context.l10n.quoteItemCount(template.items.length),
      onTap: () => _openTemplateForm(context, template: template),
    );
  }
}
