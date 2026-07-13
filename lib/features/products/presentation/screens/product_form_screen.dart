import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/money_field.dart';
import 'package:isimcebimde/features/categories/presentation/widgets/category_picker.dart';
import 'package:isimcebimde/features/products/domain/entities/product.dart';
import 'package:isimcebimde/features/products/presentation/providers/product_form_controller.dart';

/// Ürün ekleme ve düzenleme formu. [product] null ise yeni ürün.
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({this.product, super.key});

  final Product? product;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  late Money _price;
  late Percent _vatRate;
  int? _categoryId;

  bool get _isEditing => widget.product != null;

  /// Türkiye'de kullanılan KDV oranları.
  static const List<Percent> _vatOptions = [
    Percent.fromBasisPoints(2000),
    Percent.fromBasisPoints(1000),
    Percent.fromBasisPoints(100),
    Percent.fromBasisPoints(0),
  ];

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _price = product?.price ?? Money.zero;
    _vatRate = product?.vatRate ?? Product.defaultVatRate;
    _categoryId = product?.categoryId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(productFormControllerProvider);
    final isSaving = formState.isLoading;

    // Hata kullanıcıya yan etki olarak gösterilir (CLAUDE.md: ref.listen).
    ref.listen(productFormControllerProvider, (previous, next) {
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
        title: Text(_isEditing ? 'Ürünü Düzenle' : 'Yeni Ürün'),
        actions: [
          if (_isEditing)
            IconButton(
              onPressed: isSaving ? null : _confirmDelete,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Sil',
            ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.md),
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Ürün adı'),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Ürün adı boş olamaz'
                    : null,
              ),
              const SizedBox(height: AppSizes.md),
              MoneyField(
                initialValue: _price,
                onChanged: (value) => _price = value,
              ),
              const SizedBox(height: AppSizes.md),
              CategoryPicker(
                selectedId: _categoryId,
                onChanged: (id) => setState(() => _categoryId = id),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<Percent>(
                initialValue: _vatRate,
                decoration: const InputDecoration(labelText: 'KDV oranı'),
                items: [
                  for (final rate in _vatOptions)
                    DropdownMenuItem(
                      value: rate,
                      child: Text('%${rate.asPercent.toStringAsFixed(0)}'),
                    ),
                ],
                onChanged: (rate) {
                  if (rate != null) setState(() => _vatRate = rate);
                },
              ),
              const SizedBox(height: AppSizes.xl),
              FilledButton(
                onPressed: isSaving ? null : _save,
                child: isSaving
                    ? const SizedBox(
                        width: AppSizes.iconSm,
                        height: AppSizes.iconSm,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final categoryId = _categoryId;
    if (categoryId == null) return; // CategoryPicker zaten uyarır.

    final product = Product(
      id: widget.product?.id,
      name: _nameController.text,
      price: _price,
      categoryId: categoryId,
      vatRate: _vatRate,
    );

    final saved = await ref
        .read(productFormControllerProvider.notifier)
        .save(product);

    if (saved && mounted) Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final id = widget.product?.id;
    if (id == null) return;

    // Kalıcı silme geri alınamaz; onay zorunlu (CLAUDE.md: UI Rules).
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ürünü sil'),
        content: Text(
          '"${widget.product!.name}" kalıcı olarak silinecek. '
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
        .read(productFormControllerProvider.notifier)
        .delete(id);

    if (deleted && mounted) Navigator.of(context).pop();
  }
}
