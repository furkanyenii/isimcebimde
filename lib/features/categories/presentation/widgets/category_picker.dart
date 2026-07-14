import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// Kategori seçimi + yeni kategori oluşturma.
///
/// Liste Drift stream'inden beslenir: yeni kategori eklenince dropdown
/// kendiliğinden güncellenir, manuel yenileme gerekmez.
class CategoryPicker extends ConsumerWidget {
  const CategoryPicker({
    required this.selectedId,
    required this.onChanged,
    super.key,
  });

  final int? selectedId;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoryListProvider);
    final l10n = context.l10n;

    return categories.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text(
        l10n.categoriesLoadError,
        style: TextStyle(color: context.colors.error),
      ),
      data: (items) => Row(
        children: [
          Expanded(child: _dropdown(items, l10n)),
          const SizedBox(width: AppSizes.sm),
          IconButton.filledTonal(
            onPressed: () => _createCategory(context, ref),
            icon: const Icon(Icons.add),
            tooltip: l10n.categoryNew,
          ),
        ],
      ),
    );
  }

  Widget _dropdown(List<Category> items, AppLocalizations l10n) {
    // Seçili kategori silinmiş olabilir; geçersiz değer dropdown'ı çökertir.
    final value = items.any((c) => c.id == selectedId) ? selectedId : null;

    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: InputDecoration(labelText: l10n.categoryLabel),
      items: [
        for (final category in items)
          DropdownMenuItem(value: category.id, child: Text(category.name)),
      ],
      onChanged: (id) {
        if (id != null) onChanged(id);
      },
      validator: (id) => id == null ? l10n.categoryRequired : null,
    );
  }

  Future<void> _createCategory(BuildContext context, WidgetRef ref) async {
    // Await'ten önce alınır: sonrasında context kullanmak güvenli değil.
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _NewCategoryDialog(),
    );
    if (name == null) return;

    try {
      final id = await ref.read(categoryRepositoryProvider).create(name);
      onChanged(id); // Yeni kategori doğrudan seçili gelsin.
    } on Failure catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.localized(l10n))));
    }
  }
}

class _NewCategoryDialog extends StatefulWidget {
  const _NewCategoryDialog();

  @override
  State<_NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<_NewCategoryDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.categoryNew),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(labelText: l10n.categoryNameLabel),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.actionAdd)),
      ],
    );
  }
}
