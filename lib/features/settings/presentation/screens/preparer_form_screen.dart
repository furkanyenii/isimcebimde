import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/keyboard_dismiss_on_tap.dart';
import 'package:isimcebimde/features/settings/domain/entities/preparer_info.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';

/// Teklifi hazırlayan kişinin bilgileri; PDF'in altına basılır.
/// `CompanyFormScreen` ile aynı desen — tüm alanlar opsiyoneldir.
class PreparerFormScreen extends ConsumerWidget {
  const PreparerFormScreen({super.key});

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
      appBar: AppBar(title: Text(l10n.settingsPreparer)),
      body: settings.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: localizeError(error, l10n),
          onRetry: () => ref.invalidate(settingsProvider),
        ),
        // Form yalnızca ilk okunan değerle kurulur; sonraki yayınlar kullanıcının
        // yazdığını ezmemeli (CompanyFormScreen ile aynı bilinçli tercih).
        data: (current) => _PreparerForm(preparer: current.preparer),
      ),
    );
  }
}

class _PreparerForm extends ConsumerStatefulWidget {
  const _PreparerForm({required this.preparer});

  final PreparerInfo preparer;

  @override
  ConsumerState<_PreparerForm> createState() => _PreparerFormState();
}

class _PreparerFormState extends ConsumerState<_PreparerForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _title;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final p = widget.preparer;
    _firstName = TextEditingController(text: p.firstName ?? '');
    _lastName = TextEditingController(text: p.lastName ?? '');
    _title = TextEditingController(text: p.title ?? '');
    _email = TextEditingController(text: p.email ?? '');
    _phone = TextEditingController(text: p.phone ?? '');
  }

  @override
  void dispose() {
    // Memory leak kontrolü (CLAUDE.md: Review Rules).
    for (final controller in [_firstName, _lastName, _title, _email, _phone]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isSaving = ref.watch(settingsControllerProvider).isLoading;

    return KeyboardDismissOnTap(
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _firstName,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.firstNameLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _lastName,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.lastNameLabel,
                    helperText: l10n.optionalField,
                  ),
                ),
                const SizedBox(height: AppSizes.md),
                TextFormField(
                  controller: _title,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.jobTitleLabel,
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
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phoneLabel,
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

  /// Firma/müşteri formlarıyla aynı gerekçe: amaç yazım hatasını yakalamak,
  /// RFC 5322'yi uygulamak değil.
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
    await ref
        .read(settingsControllerProvider.notifier)
        .savePreparer(
          PreparerInfo(
            firstName: _firstName.text,
            lastName: _lastName.text,
            title: _title.text,
            email: _email.text,
            phone: _phone.text,
          ),
        );

    if (!mounted) return;
    if (ref.read(settingsControllerProvider).hasError) return;
    Navigator.of(context).maybePop();
  }
}
