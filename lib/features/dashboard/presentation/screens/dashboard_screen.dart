import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';

/// Ana ekran: marka paneli + özet rakamlar + modül listesi.
///
/// Bottom navigation bilinçli olarak tercih edilmedi: modül sayısı az ve
/// kullanıcının asıl işi "yeni teklif" — o eylem birincil buton olarak öne çıkar.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final offers = ref.watch(offerListProvider);

    return Scaffold(
      body: SafeArea(
        // Tablet/yatayda kartlar ekrana yayılıp seyrelmesin: içerik ortalanır.
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: ListView(
              padding: const EdgeInsets.all(AppSizes.md),
              children: [
                _BrandHeader(offers: offers),
                const SizedBox(height: AppSizes.lg),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const OfferFormScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.bolt_rounded),
                  label: Text(l10n.quoteNew),
                ),
                const SizedBox(height: AppSizes.lg),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSizes.xs,
                    bottom: AppSizes.sm,
                  ),
                  child: Text(
                    l10n.dashboardSectionModules.toUpperCase(),
                    style: context.textStyles.labelSmall,
                  ),
                ),
                _ModuleRow(
                  icon: Icons.description_outlined,
                  color: AppColors.accent,
                  label: l10n.moduleQuotes,
                  description: l10n.moduleQuotesSubtitle,
                  onTap: () => context.go(AppRoutes.quotes),
                ),
                const SizedBox(height: AppSizes.sm),
                _ModuleRow(
                  icon: Icons.inventory_2_outlined,
                  color: AppColors.success,
                  label: l10n.moduleProducts,
                  description: l10n.moduleProductsSubtitle,
                  onTap: () => context.go(AppRoutes.products),
                ),
                const SizedBox(height: AppSizes.sm),
                _ModuleRow(
                  icon: Icons.people_outline,
                  color: AppColors.warning,
                  label: l10n.moduleCustomers,
                  description: l10n.moduleCustomersSubtitle,
                  onTap: () => context.go(AppRoutes.customers),
                ),
                const SizedBox(height: AppSizes.sm),
                _ModuleRow(
                  icon: Icons.settings_outlined,
                  color: AppColors.accentBright,
                  label: l10n.moduleSettings,
                  description: l10n.moduleSettingsSubtitle,
                  onTap: () => context.go(AppRoutes.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradyanlı marka paneli ve iki özet rakamı.
///
/// Özetler ekranın birincil içeriği değil, süsüdür: teklifler henüz yüklenmemiş
/// veya okunamamışsa modüllere giriş yine de çalışmalı. Bu yüzden burada
/// spinner/hata ekranı gösterilmez, rakam yerine "—" basılır. Hatanın kendisi
/// Teklifler ekranında tekrar-dene aksiyonuyla birlikte gösterilir.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.offers});

  final AsyncValue<List<Offer>> offers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = offers.value;

    final total = data?.fold<Money>(
      Money.zero,
      (sum, offer) => sum + offer.grandTotal,
    );

    return AppGradientPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quotra',
                style: context.textStyles.titleLarge,
              ), // Marka adı çevrilmez.
              const Icon(Icons.bolt_rounded, size: AppSizes.iconSm),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Text(l10n.dashboardGreeting, style: context.textStyles.labelMedium),
          const SizedBox(height: AppSizes.xs),
          Text(l10n.dashboardSubtitle, style: context.textStyles.headlineSmall),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  label: l10n.dashboardStatQuotes,
                  value: data == null ? '—' : '${data.length}',
                ),
              ),
              Expanded(
                child: _HeaderStat(
                  label: l10n.dashboardStatTotal,
                  // Teklifler farklı para birimlerinde olabilir; toplam,
                  // kullanıcının varsayılan sembolüyle değil, yalın biçimlenir.
                  value: total == null
                      ? '—'
                      : total.format(locale: context.localeTag, symbol: ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  const _HeaderStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.headlineMedium?.tabular,
        ),
        Text(label, style: context.textStyles.labelSmall),
      ],
    );
  }
}

class _ModuleRow extends StatelessWidget {
  const _ModuleRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSizes.md),
      child: Row(
        children: [
          AppIconTile(icon: icon, color: color),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.textStyles.titleMedium),
                Text(description, style: context.textStyles.bodySmall),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
