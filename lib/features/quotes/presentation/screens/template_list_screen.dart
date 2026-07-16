import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/template_form_screen.dart';

class TemplateListScreen extends ConsumerWidget {
  const TemplateListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templates = ref.watch(templateListProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.templatesTitle)),
      body: templates.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: l10n.templatesLoadError,
          onRetry: () => ref.invalidate(templateListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            // Eylem butonu yok: yeni şablon zaten sağ alttaki FAB ile açılır
            // (ProductListScreen/OfferListScreen ile aynı desen).
            return AppEmptyView(
              icon: Icons.bookmarks_outlined,
              title: l10n.templatesEmptyTitle,
              description: l10n.templatesEmptyDescription,
            );
          }
          return ListView.separated(
            // FAB son kartı örtmesin.
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              AppSizes.xxl + AppSizes.lg,
            ),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) =>
                _TemplateTile(template: items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTemplateForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.templateNew),
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
      title: template.name,
      subtitle: context.l10n.quoteItemCount(template.items.length),
      onTap: () => _openTemplateForm(context, template: template),
    );
  }
}
