import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/categories/domain/entities/category.dart';
import 'package:isimcebimde/features/categories/presentation/providers/category_providers.dart';

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

    return categories.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text(
        'Kategoriler yüklenemedi.',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
      data: (items) => Row(
        children: [
          Expanded(child: _dropdown(items)),
          const SizedBox(width: AppSizes.sm),
          IconButton.filledTonal(
            onPressed: () => _createCategory(context, ref),
            icon: const Icon(Icons.add),
            tooltip: 'Yeni kategori',
          ),
        ],
      ),
    );
  }

  Widget _dropdown(List<Category> items) {
    // Seçili kategori silinmiş olabilir; geçersiz değer dropdown'ı çökertir.
    final value = items.any((c) => c.id == selectedId) ? selectedId : null;

    return DropdownButtonFormField<int>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Kategori'),
      items: [
        for (final category in items)
          DropdownMenuItem(value: category.id, child: Text(category.name)),
      ],
      onChanged: (id) {
        if (id != null) onChanged(id);
      },
      validator: (id) => id == null ? 'Kategori seçmelisin' : null,
    );
  }

  Future<void> _createCategory(BuildContext context, WidgetRef ref) async {
    // Await'ten önce alınır: sonrasında context kullanmak güvenli değil.
    final messenger = ScaffoldMessenger.of(context);

    final name = await showDialog<String>(
      context: context,
      builder: (context) => const _NewCategoryDialog(),
    );
    if (name == null) return;

    try {
      final id = await ref.read(categoryRepositoryProvider).create(name);
      onChanged(id); // Yeni kategori doğrudan seçili gelsin.
    } on Failure catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
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
    return AlertDialog(
      title: const Text('Yeni kategori'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        decoration: const InputDecoration(labelText: 'Kategori adı'),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Vazgeç'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Ekle')),
      ],
    );
  }
}
