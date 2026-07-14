import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:isimcebimde/features/products/presentation/widgets/product_picker.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/custom_unit_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_form_controller.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/currency_selector.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_items_section.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_summary.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/percent_field.dart';

/// Şablon oluşturma ve düzenleme formu. [template] null ise yeni şablon.
///
/// `OfferFormScreen` ile aynı desen, **müşteri hariç**: şablon
/// müşteriden bağımsızdır. Yerine bir ad alanı vardır (şablonun tek zorunlu
/// alanı, listede görünen kimliğidir).
class TemplateFormScreen extends ConsumerStatefulWidget {
  const TemplateFormScreen({this.template, super.key});

  final Template? template;

  @override
  ConsumerState<TemplateFormScreen> createState() => _TemplateFormScreenState();
}

class _TemplateFormScreenState extends ConsumerState<TemplateFormScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  late Template _template;

  bool get _isEditing => widget.template != null;

  @override
  void initState() {
    super.initState();
    _template = widget.template ?? const Template(name: '');
    _nameController.text = _template.name;
    _notesController.text = _template.notes ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canSave =
        _nameController.text.trim().isNotEmpty && _template.items.isNotEmpty;
    final isSaving = ref.watch(templateFormControllerProvider).isLoading;
    final customUnits =
        ref.watch(customUnitListProvider).value ?? const <String>[];

    // Hata kullanıcıya yan etki olarak gösterilir (CLAUDE.md: ref.listen).
    ref.listen(templateFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizeError(error, l10n))));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.templateEdit : l10n.templateNew),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: isSaving ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.actionDelete,
            ),
        ],
      ),
      body: KeyboardDismissOnTap(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(labelText: l10n.templateNameLabel),
                // setState: canSave hesabı ada bağlı, her tuşta yeniden değerlendirilmeli.
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSizes.md),
              CurrencySelector(
                value: _template.currency,
                onChanged: (currency) => setState(
                  () => _template = _template.copyWith(currency: currency),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              OfferItemsSection(
                items: _template.items,
                currency: _template.currency,
                customUnits: customUnits,
                onChanged: (items) => setState(
                  () => _template = _template.copyWith(items: items),
                ),
                onUnitCreated: _createUnit,
                onAddPressed: _addProduct,
                addLabel: l10n.productAdd,
              ),
              const SizedBox(height: AppSizes.lg),
              PercentField(
                initialValue: _template.generalDiscount,
                label: l10n.generalDiscountLabel,
                onChanged: (discount) => setState(
                  () =>
                      _template = _template.copyWith(generalDiscount: discount),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.notesLabel,
                  helperText: l10n.optionalField,
                ),
                onChanged: (text) =>
                    _template = _template.copyWith(notes: text),
              ),
              const SizedBox(height: AppSizes.lg),
              OfferSummary(offer: _template.toDraftOffer()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: FilledButton(
            onPressed: canSave && !isSaving ? _save : null,
            child: isSaving
                ? const SizedBox(
                    width: AppSizes.iconSm,
                    height: AppSizes.iconSm,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.actionSave),
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    final template = _template.copyWith(name: _nameController.text);
    final saved = await ref
        .read(templateFormControllerProvider.notifier)
        .save(template);

    if (saved && mounted) Navigator.of(context).pop();
  }

  /// Bkz. `OfferFormScreen._createUnit`.
  Future<void> _createUnit(String unit) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    try {
      await ref.read(customUnitRepositoryProvider).add(unit);
    } on Failure catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.localized(l10n))));
    }
  }

  Future<void> _addProduct() async {
    final product = await showProductPicker(context);
    if (product == null || !mounted) return;

    setState(() {
      _template = _template.copyWith(
        items: [
          ..._template.items,
          OfferItem(
            productId: product.id,
            productName: product.name,
            unitPrice: product.price,
            quantity: Quantity.one,
          ),
        ],
      );
    });
  }

  Future<void> _confirmDelete() async {
    final id = widget.template?.id;
    if (id == null) return;

    // Kalıcı silme geri alınamaz; onay zorunlu (CLAUDE.md: UI Rules).
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.templateDelete),
          content: Text(l10n.deleteConfirmMessage(widget.template!.name)),
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
        );
      },
    );

    if (confirmed != true) return;

    final deleted = await ref
        .read(templateFormControllerProvider.notifier)
        .delete(id);

    if (deleted && mounted) Navigator.of(context).pop();
  }
}
