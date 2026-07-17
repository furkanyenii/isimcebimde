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
    // Kullanımdaki kategori id'leri. Bilinmiyorken (yükleme/hata) `null`:
    // o durumda hiçbir kategoride silme gösterilmez — yanlışlıkla kullanımdaki
    // bir kategoriyi silinebilir göstermektense aksiyonu gizlemek güvenli.
    final usedCategoryIds = ref.watch(usedCategoryIdsProvider).value;
    final l10n = context.l10n;

    return categories.when(
      loading: () => const LinearProgressIndicator(),
      error: (error, _) => Text(
        l10n.categoriesLoadError,
        style: TextStyle(color: context.colors.error),
      ),
      data: (items) => Row(
        children: [
          Expanded(
            child: _dropdown(
              items,
              l10n,
              usedCategoryIds: usedCategoryIds,
              onDelete: (category) => _deleteCategory(context, ref, category),
            ),
          ),
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

  Widget _dropdown(
    List<Category> items,
    AppLocalizations l10n, {
    required Set<int>? usedCategoryIds,
    required ValueChanged<Category> onDelete,
  }) {
    // Seçili kategori silinmiş olabilir; geçersiz değer dropdown'ı çökertir.
    final value = items.any((c) => c.id == selectedId) ? selectedId : null;

    return DropdownButtonFormField<int>(
      initialValue: value,
      // Uzun kategori adı satırı yatayda taşırmasın; menü ekranı aşmasın diye
      // yüksekliği sınırlanır.
      isExpanded: true,
      menuMaxHeight: AppSizes.dropdownMaxHeight,
      decoration: InputDecoration(labelText: l10n.categoryLabel),
      // Alan içindeki seçili metin: InputDecoration'ın kendi yatay boşluğuyla
      // hizalanır, ek padding almaz.
      selectedItemBuilder: (context) => [
        for (final category in items)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(category.name, overflow: TextOverflow.ellipsis),
          ),
      ],
      items: [
        for (final category in items)
          DropdownMenuItem(
            value: category.id,
            // Silme yalnızca ürüne bağlı OLMAYAN kategoride gösterilir: bağlı
            // kategori zaten silinemez (repository engeller), ikonu göstermek
            // yanıltıcı olurdu. Kullanım bilinmiyorsa (`usedCategoryIds == null`)
            // ikon gizlenir.
            child: _CategoryMenuItem(
              category: category,
              canDelete:
                  usedCategoryIds != null &&
                  category.id != null &&
                  !usedCategoryIds.contains(category.id),
              deleteTooltip: l10n.categoryDelete,
              onDelete: () => onDelete(category),
            ),
          ),
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

  /// Kategoriyi siler. Ürüne bağlıysa repository [CategoryInUseFailure]
  /// fırlatır; bu, kullanıcıya uyarı olarak gösterilir (silme yapılmaz).
  /// Silme geri alınamaz, bu yüzden önce onay istenir (CLAUDE.md: UI Rules).
  Future<void> _deleteCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final id = category.id;
    if (id == null) return;

    // Await'ten önce alınır: sonrasında context kullanmak güvenli değil.
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoryDelete),
        content: Text(l10n.categoryDeleteConfirm(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.actionCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: context.colors.error,
            ),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(categoryRepositoryProvider).delete(id);
    } on Failure catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.localized(l10n))));
    }
  }
}

/// Dropdown menüsündeki tek kategori satırı. [canDelete] ise sağında silme
/// ikonu gösterilir; değilse (kategori ürüne bağlı) yalnızca ad görünür.
class _CategoryMenuItem extends StatelessWidget {
  const _CategoryMenuItem({
    required this.category,
    required this.canDelete,
    required this.deleteTooltip,
    required this.onDelete,
  });

  final Category category;
  final bool canDelete;
  final String deleteTooltip;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final name = Expanded(
      child: Text(category.name, overflow: TextOverflow.ellipsis),
    );

    // Silme yokken satır, ikonun ayırdığı sağ boşluğu simetrik yatay padding
    // ile telafi eder; böylece menüdeki tüm satırlar aynı hizada durur.
    if (!canDelete) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
        child: Row(children: [name]),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: AppSizes.md),
      child: Row(
        children: [
          name,
          // `Builder`, menü overlay'inin kendi context'ini verir; onPressed
          // önce menüyü kapatır (pop(null) — değer döndürmez, dolayısıyla
          // onChanged tetiklenmez), sonra silme akışını çalıştırır.
          Builder(
            builder: (menuContext) => IconButton(
              onPressed: () {
                Navigator.of(menuContext).pop();
                onDelete();
              },
              icon: const Icon(Icons.delete_outline),
              iconSize: AppSizes.iconSm,
              tooltip: deleteTooltip,
            ),
          ),
        ],
      ),
    );
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
