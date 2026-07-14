import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:isimcebimde/features/customers/presentation/widgets/customer_picker.dart';
import 'package:isimcebimde/features/products/presentation/widgets/product_picker.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/custom_unit_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_form_controller.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_pdf_preview_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/currency_selector.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_items_section.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_summary.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/percent_field.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/save_as_template_dialog.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/template_picker.dart';

/// Teklif oluşturma ve düzenleme formu. [offer] null ise yeni teklif.
///
/// Satırlar/müşteri/indirim gibi form alanları yerel widget state'inde
/// tutulur (Product/Customer formlarıyla aynı desen); yalnızca kaydetme
/// işleminin async durumu `OfferFormController`'da yaşar.
class OfferFormScreen extends ConsumerStatefulWidget {
  const OfferFormScreen({this.offer, super.key});

  final Offer? offer;

  @override
  ConsumerState<OfferFormScreen> createState() => _OfferFormScreenState();
}

class _OfferFormScreenState extends ConsumerState<OfferFormScreen> {
  final _notesController = TextEditingController();

  late Offer _offer;

  bool get _isEditing => widget.offer != null;

  @override
  void initState() {
    super.initState();
    _offer = widget.offer ?? Offer(customerName: '', items: const []);
    _notesController.text = _offer.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final hasCustomer = _offer.customerId != null;
    final canSave = hasCustomer && _offer.items.isNotEmpty;
    final isSaving = ref.watch(offerFormControllerProvider).isLoading;
    // Birim listesi ikincil veridir: yüklenmediyse hazır birimlerle devam
    // edilir, teklif akışı bunun için bekletilmez.
    final customUnits =
        ref.watch(customUnitListProvider).value ?? const <String>[];

    // Hata kullanıcıya yan etki olarak gösterilir (CLAUDE.md: ref.listen).
    ref.listen(offerFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizeError(error, l10n))));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.offerEdit : l10n.quoteNew),
        actions: [
          if (!_isEditing)
            IconButton(
              onPressed: _useTemplate,
              icon: const Icon(Icons.dashboard_customize_outlined),
              tooltip: l10n.templateUseTooltip,
            ),
          // Yalnızca kaydedilmiş tekliflerde anlamlı: quoteNumber id'den
          // türetilir, kaydedilmemiş bir teklifte üretilemez.
          if (_isEditing)
            IconButton(
              onPressed: _openPdfPreview,
              icon: const Icon(Icons.picture_as_pdf_outlined),
              tooltip: l10n.pdfGenerateTooltip,
            ),
          if (_offer.items.isNotEmpty)
            IconButton(
              onPressed: _saveAsTemplate,
              icon: const Icon(Icons.bookmark_add_outlined),
              tooltip: l10n.templateSaveAsTooltip,
            ),
        ],
      ),
      body: KeyboardDismissOnTap(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              CustomerPicker(
                selectedName: _offer.customerName.isEmpty
                    ? null
                    : _offer.customerName,
                onChanged: (customer) => setState(() {
                  _offer = _offer.copyWith(
                    customerId: customer.id,
                    customerName: customer.name,
                    customerContactPerson: customer.contactPerson ?? '',
                  );
                }),
              ),
              const SizedBox(height: AppSizes.md),
              CurrencySelector(
                value: _offer.currency,
                onChanged: (currency) => setState(
                  () => _offer = _offer.copyWith(currency: currency),
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              OfferItemsSection(
                items: _offer.items,
                currency: _offer.currency,
                customUnits: customUnits,
                onChanged: (items) =>
                    setState(() => _offer = _offer.copyWith(items: items)),
                onUnitCreated: _createUnit,
                onAddPressed: _addProduct,
                addLabel: l10n.productAdd,
              ),
              const SizedBox(height: AppSizes.lg),
              PercentField(
                initialValue: _offer.generalDiscount,
                label: l10n.generalDiscountLabel,
                onChanged: (discount) => setState(
                  () => _offer = _offer.copyWith(generalDiscount: discount),
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
                onChanged: (text) => _offer = _offer.copyWith(notes: text),
              ),
              const SizedBox(height: AppSizes.lg),
              OfferSummary(offer: _offer),
            ],
          ),
        ),
      ),
      // Kaydet her zaman parmağın altında: form uzun (müşteri, satırlar,
      // indirim, not, özet); kullanıcı hepsini kaydırmadan kaydedebilmeli
      // (CustomerFormScreen ile aynı desen).
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
    final saved = await ref
        .read(offerFormControllerProvider.notifier)
        .save(_offer);

    if (saved && mounted) Navigator.of(context).pop();
  }

  Future<void> _openPdfPreview() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => OfferPdfPreviewScreen(offer: _offer),
      ),
    );
  }

  Future<void> _useTemplate() async {
    final template = await showTemplatePicker(context);
    if (template == null || !mounted) return;

    // Müşteriye dokunulmaz: şablon müşteriden bağımsızdır.
    final draft = template.toDraftOffer();
    setState(() {
      _offer = _offer.copyWith(
        currency: draft.currency,
        generalDiscount: draft.generalDiscount,
        notes: draft.notes,
        items: draft.items,
      );
      _notesController.text = _offer.notes ?? '';
    });
  }

  Future<void> _saveAsTemplate() async {
    final name = await showSaveAsTemplateDialog(context);
    if (name == null || !mounted) return;

    // Küçük, tek seferlik bir eylem: CategoryPicker._createCategory ile aynı
    // desen — ayrı bir controller üzerinden değil, repository doğrudan çağrılır.
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;

    try {
      await ref
          .read(templateRepositoryProvider)
          .create(
            Template(
              name: name,
              currency: _offer.currency,
              generalDiscount: _offer.generalDiscount,
              notes: _offer.notes,
              items: _offer.items,
            ),
          );
    } on Failure catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.localized(l10n))));
    }
  }

  /// Kullanıcının yazdığı birim kalıcılaştırılır; sonraki tekliflerde de
  /// listede çıkar. `CategoryPicker._createCategory` ile aynı desen: küçük ve
  /// tek seferlik bir yazma için ayrı controller kurulmaz.
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
      _offer = _offer.copyWith(
        items: [
          ..._offer.items,
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
}
