import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:isimcebimde/features/settings/domain/entities/company_info.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';

/// Teklif başlığında görünecek firma bilgileri. Tüm alanlar opsiyoneldir —
/// eksik bilgi teklif çıkarmayı engellemez (CLAUDE.md: hız bir feature'dır).
class CompanyFormScreen extends ConsumerWidget {
  const CompanyFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = context.l10n;

    ref.listen(settingsControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizeError(error, l10n))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsCompany)),
      body: settings.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: localizeError(error, l10n),
          onRetry: () => ref.invalidate(settingsProvider),
        ),
        // Form yalnızca ilk okunan değerle kurulur; sonraki yayınlar kullanıcının
        // yazdığını ezmemeli. `key` ile yeniden kurmuyoruz, bilinçli.
        data: (current) => _CompanyForm(company: current.company),
      ),
    );
  }
}

class _CompanyForm extends ConsumerStatefulWidget {
  const _CompanyForm({required this.company});

  final CompanyInfo company;

  @override
  ConsumerState<_CompanyForm> createState() => _CompanyFormState();
}

class _CompanyFormState extends ConsumerState<_CompanyForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _email;
  late final TextEditingController _website;
  late final TextEditingController _address;
  late final TextEditingController _taxOffice;
  late final TextEditingController _taxNumber;

  @override
  void initState() {
    super.initState();
    final c = widget.company;
    _name = TextEditingController(text: c.name ?? '');
    _phone = TextEditingController(text: c.phone ?? '');
    _email = TextEditingController(text: c.email ?? '');
    _website = TextEditingController(text: c.website ?? '');
    _address = TextEditingController(text: c.address ?? '');
    _taxOffice = TextEditingController(text: c.taxOffice ?? '');
    _taxNumber = TextEditingController(text: c.taxNumber ?? '');
  }

  @override
  void dispose() {
    // Memory leak kontrolü (CLAUDE.md: Review Rules).
    for (final controller in [
      _name,
      _phone,
      _email,
      _website,
      _address,
      _taxOffice,
      _taxNumber,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    // Logo yolu ekrandan değil, ayarlardan okunur: logo seçimi anında kaydedilir.
    final logoPath = ref.watch(settingsProvider).value?.company.logoPath;

    return KeyboardDismissOnTap(
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LogoField(path: logoPath, isBusy: isSaving),
                const SizedBox(height: AppSizes.lg),
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.companyNameFieldLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
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
                  controller: _website,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    labelText: l10n.websiteLabel,
                    helperText: l10n.optionalField,
                  ),
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
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _taxOffice,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.taxOfficeLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                // Vergi/kimlik no ülkeye göre harf de içerebilir; biçim/uzunluk
                // kontrolü yok, serbest metin.
                TextFormField(
                  controller: _taxNumber,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: l10n.taxNumberFieldLabel,
                    helperText: l10n.optionalField,
                  ),
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
                      : Text(l10n.actionSave),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Müşteri formuyla aynı gerekçe: amaç yazım hatasını yakalamak, RFC 5322'yi
  /// uygulamak değil.
  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null; // isteğe bağlı
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : context.l10n.errorEmailInvalid;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Boş string → null dönüşümü repository'de yapılır; burada ham metin geçilir.
    // Logo bu formdan gelmez: seçildiği anda kaydedilmiştir.
    await ref
        .read(settingsControllerProvider.notifier)
        .saveCompany(
          CompanyInfo(
            name: _name.text,
            phone: _phone.text,
            email: _email.text,
            website: _website.text,
            address: _address.text,
            taxOffice: _taxOffice.text,
            taxNumber: _taxNumber.text,
            logoPath: ref.read(settingsProvider).value?.company.logoPath,
          ),
        );

    if (!mounted) return;
    if (ref.read(settingsControllerProvider).hasError) return;
    Navigator.of(context).maybePop();
  }
}

/// Logo önizlemesi + seçme/kaldırma. Seçim anında kaydedilir: dosya kopyalama
/// işi "kaydet"e kadar bekletilirse, kullanıcı formu terk ettiğinde galeri
/// yolundaki geçici dosya çoktan silinmiş olabilir.
class _LogoField extends ConsumerWidget {
  const _LogoField({required this.path, required this.isBusy});

  final String? path;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.companyLogo, style: context.textStyles.labelLarge),
        const SizedBox(height: AppSizes.sm),
        Row(
          children: [
            if (path != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Image.file(
                  File(path!),
                  width: AppSizes.iconLg * 2,
                  height: AppSizes.iconLg * 2,
                  fit: BoxFit.cover,
                  // Dosya silinmiş olabilir; kırık görsel yerine ikon göster.
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image_outlined),
                ),
              ),
              const SizedBox(width: AppSizes.md),
            ],
            Expanded(
              child: Wrap(
                spacing: AppSizes.sm,
                children: [
                  OutlinedButton.icon(
                    onPressed: isBusy ? null : () => _pick(ref),
                    icon: const Icon(Icons.image_outlined),
                    label: Text(l10n.companyLogoAdd),
                  ),
                  if (path != null)
                    TextButton(
                      onPressed: isBusy
                          ? null
                          : () => ref
                                .read(settingsControllerProvider.notifier)
                                .removeLogo(),
                      child: Text(l10n.companyLogoRemove),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _pick(WidgetRef ref) async {
    final picked = await ref.read(logoPickerProvider).pickImage();
    if (picked == null) return; // Kullanıcı vazgeçti.
    await ref.read(settingsControllerProvider.notifier).setLogo(picked);
  }
}
