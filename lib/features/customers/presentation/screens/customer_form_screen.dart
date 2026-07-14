import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_form_controller.dart';
import 'package:isimcebimde/features/customers/presentation/widgets/customer_type_selector.dart';

/// Müşteri ekleme ve düzenleme formu. [customer] null ise yeni müşteri.
///
/// Form tipe göre şekil değiştirir: bireysel müşteride yetkili kişi ve vergi
/// dairesi alanları anlamsızdır, gösterilmez. Tek zorunlu alan **ad**'dır —
/// sahada detay sormaya vakit yoktur, teklif önce çıkar.
class CustomerFormScreen extends ConsumerStatefulWidget {
  const CustomerFormScreen({this.customer, super.key});

  final Customer? customer;

  @override
  ConsumerState<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends ConsumerState<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _contactPerson;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _address;
  late final TextEditingController _taxOffice;
  late final TextEditingController _taxNumber;
  late final TextEditingController _notes;

  late CustomerType _type;

  bool get _isEditing => widget.customer != null;
  bool get _isCompany => _type.isCompany;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    _type = c?.type ?? CustomerType.individual;
    _name = TextEditingController(text: c?.name ?? '');
    _contactPerson = TextEditingController(text: c?.contactPerson ?? '');
    _phone = TextEditingController(text: c?.phone ?? '');
    _email = TextEditingController(text: c?.email ?? '');
    _address = TextEditingController(text: c?.address ?? '');
    _taxOffice = TextEditingController(text: c?.taxOffice ?? '');
    _taxNumber = TextEditingController(text: c?.taxNumber ?? '');
    _notes = TextEditingController(text: c?.notes ?? '');
  }

  @override
  void dispose() {
    // Memory leak kontrolü (CLAUDE.md: Review Rules).
    for (final controller in [
      _name,
      _contactPerson,
      _phone,
      _email,
      _address,
      _taxOffice,
      _taxNumber,
      _notes,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(customerFormControllerProvider);
    final isSaving = formState.isLoading;
    final l10n = context.l10n;

    // Hata kullanıcıya yan etki olarak gösterilir (CLAUDE.md: ref.listen).
    ref.listen(customerFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localizeError(error, context.l10n))),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.customerEdit : l10n.customerNew),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: isSaving ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.actionDelete,
            ),
        ],
      ),
      // Form 9 alanlı; `ListView` ekran dışındaki alanları tembel kurar.
      // Sabit alanlı bir formda bunun faydası yok, sakıncası var.
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomerTypeSelector(
                  value: _type,
                  onChanged: (type) => setState(() => _type = type),
                ),
                const SizedBox(height: AppSizes.lg),
                TextFormField(
                  controller: _name,
                  autofocus: !_isEditing,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: _isCompany
                        ? l10n.companyNameLabel
                        : l10n.fullNameLabel,
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? (_isCompany
                            ? l10n.companyNameRequired
                            : l10n.fullNameRequired)
                      : null,
                ),
                if (_isCompany) ...[
                  const SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _contactPerson,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.contactPersonLabel,
                      helperText: l10n.optionalField,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phoneLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    helperText: l10n.optionalField,
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _address,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.addressLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
                if (_isCompany) ...[
                  const SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _taxOffice,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: l10n.taxOfficeLabel,
                      helperText: l10n.optionalField,
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _taxNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: _isCompany
                        ? l10n.taxNumberLabel
                        : l10n.nationalIdLabel,
                    helperText: l10n.optionalField,
                  ),
                  validator: _validateTaxNumber,
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _notes,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.notesLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Kaydet her zaman parmağın altında: tek zorunlu alan "ad" olduğu için
      // kullanıcı sekiz opsiyonel alanı kaydırmadan kaydedebilmeli.
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: FilledButton(
            onPressed: isSaving ? null : _save,
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

  /// Kasıtlı olarak gevşek: amaç yazım hatasını yakalamak, RFC 5322'yi
  /// uygulamak değil. Aşırı katı bir regex geçerli adresleri reddeder.
  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null; // isteğe bağlı
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : context.l10n.errorEmailInvalid;
  }

  String? _validateTaxNumber(String? value) {
    final digits = value?.trim() ?? '';
    if (digits.isEmpty) return null; // isteğe bağlı

    final expected = _isCompany ? 10 : 11;
    if (digits.length != expected) {
      return _isCompany
          ? context.l10n.errorTaxNumberLength
          : context.l10n.errorNationalIdLength;
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Boş string → null dönüşümü repository'de yapılır; burada ham metin geçilir.
    final customer = Customer(
      id: widget.customer?.id,
      type: _type,
      name: _name.text,
      contactPerson: _contactPerson.text,
      phone: _phone.text,
      email: _email.text,
      address: _address.text,
      taxOffice: _taxOffice.text,
      taxNumber: _taxNumber.text,
      notes: _notes.text,
    );

    final saved = await ref
        .read(customerFormControllerProvider.notifier)
        .save(customer);

    if (saved && mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final id = widget.customer?.id;
    if (id == null) return;

    // Kalıcı silme geri alınamaz; onay zorunlu (CLAUDE.md: UI Rules).
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = context.l10n;
        return AlertDialog(
          title: Text(l10n.customerDelete),
          content: Text(l10n.deleteConfirmMessage(widget.customer!.name)),
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
        .read(customerFormControllerProvider.notifier)
        .delete(id);

    if (deleted && mounted) Navigator.of(context).pop();
  }
}
