import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure.dart';
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

    // Hata kullanıcıya yan etki olarak gösterilir (CLAUDE.md: ref.listen).
    ref.listen(customerFormControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error is Failure ? error.message : 'İşlem tamamlanamadı.',
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Müşteriyi Düzenle' : 'Yeni Müşteri'),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: isSaving ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Sil',
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
                    labelText: _isCompany ? 'Firma ünvanı' : 'Ad soyad',
                  ),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? (_isCompany
                            ? 'Firma ünvanı boş olamaz'
                            : 'Ad soyad boş olamaz')
                      : null,
                ),
                if (_isCompany) ...[
                  const SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _contactPerson,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Yetkili kişi',
                      helperText: 'İsteğe bağlı',
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Telefon',
                    helperText: 'İsteğe bağlı',
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'E-posta',
                    helperText: 'İsteğe bağlı',
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _address,
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Adres',
                    helperText: 'İsteğe bağlı',
                  ),
                ),
                if (_isCompany) ...[
                  const SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _taxOffice,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Vergi dairesi',
                      helperText: 'İsteğe bağlı',
                    ),
                  ),
                ],
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _taxNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: _isCompany ? 'Vergi no' : 'TC Kimlik No',
                    helperText: 'İsteğe bağlı',
                  ),
                  validator: _validateTaxNumber,
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _notes,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Not',
                    helperText: 'İsteğe bağlı',
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
                : const Text('Kaydet'),
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
        : 'E-posta adresi geçersiz';
  }

  String? _validateTaxNumber(String? value) {
    final digits = value?.trim() ?? '';
    if (digits.isEmpty) return null; // isteğe bağlı

    final expected = _isCompany ? 10 : 11;
    if (digits.length != expected) {
      return _isCompany
          ? 'Vergi No 10 haneli olmalı'
          : 'TC Kimlik No 11 haneli olmalı';
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
      builder: (context) => AlertDialog(
        title: const Text('Müşteriyi sil'),
        content: Text(
          '"${widget.customer!.name}" kalıcı olarak silinecek. '
          'Bu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final deleted = await ref
        .read(customerFormControllerProvider.notifier)
        .delete(id);

    if (deleted && mounted) Navigator.of(context).pop();
  }
}
