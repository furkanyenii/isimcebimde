import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/errors/failure_localizer.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/settings/domain/entities/app_settings.dart';
import 'package:isimcebimde/features/settings/presentation/providers/settings_providers.dart';

/// Dil ve tema tercihi. Seçim anında kaydedilir ve arayüze uygulanır —
/// "kaydet" butonu yoktur: iki seçenekli bir tercihi onaylatmak gereksiz adımdır.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = context.l10n;

    // Kaydetme hatası yan etki olarak gösterilir (CLAUDE.md: ref.listen).
    ref.listen(settingsControllerProvider, (previous, next) {
      final error = next.error;
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(localizeError(error, l10n))));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleSettings)),
      body: settings.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: localizeError(error, l10n),
          onRetry: () => ref.invalidate(settingsProvider),
        ),
        data: (current) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                AppListCard(
                  icon: Icons.business_outlined,
                  title: l10n.settingsCompany,
                  subtitle:
                      current.company.name ?? l10n.settingsCompanySubtitle,
                  onTap: () => context.push(AppRoutes.company),
                ),
                const SizedBox(height: AppSizes.sm),
                AppListCard(
                  icon: Icons.person_outline,
                  title: l10n.settingsPreparer,
                  subtitle:
                      current.preparer.fullName ??
                      l10n.settingsPreparerSubtitle,
                  onTap: () => context.push(AppRoutes.preparer),
                ),
                _SectionHeader(title: l10n.settingsLanguage),
                for (final language in AppLanguage.values)
                  _ChoiceTile(
                    label: _languageLabel(context, language),
                    isSelected: language == current.language,
                    onTap: () => ref
                        .read(settingsControllerProvider.notifier)
                        .setLanguage(language),
                  ),
                _SectionHeader(title: l10n.settingsTheme),
                for (final mode in AppThemeMode.values)
                  _ChoiceTile(
                    label: _themeLabel(context, mode),
                    isSelected: mode == current.themeMode,
                    onTap: () => ref
                        .read(settingsControllerProvider.notifier)
                        .setThemeMode(mode),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _languageLabel(BuildContext context, AppLanguage language) =>
      switch (language) {
        AppLanguage.system => context.l10n.settingsSystemDefault,
        AppLanguage.turkish => context.l10n.languageTurkish,
        AppLanguage.english => context.l10n.languageEnglish,
      };

  static String _themeLabel(BuildContext context, AppThemeMode mode) =>
      switch (mode) {
        AppThemeMode.system => context.l10n.settingsSystemDefault,
        AppThemeMode.light => context.l10n.settingsThemeLight,
        AppThemeMode.dark => context.l10n.settingsThemeDark,
      };
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.xs,
        AppSizes.lg,
        AppSizes.xs,
        AppSizes.sm,
      ),
      child: Text(title.toUpperCase(), style: context.textStyles.labelSmall),
    );
  }
}

/// Seçili olanı işaretli gösteren satır. `RadioListTile` yerine kart:
/// dokunma hedefi tüm satırdır ve seçim, aksan çerçevesi + tek onay ikonuyla
/// anlatılır.
class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: AppSurfaceCard(
        onTap: onTap,
        isHighlighted: isSelected,
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.textStyles.titleMedium)),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: context.colors.primary,
                size: AppSizes.iconSm,
              ),
          ],
        ),
      ),
    );
  }
}
