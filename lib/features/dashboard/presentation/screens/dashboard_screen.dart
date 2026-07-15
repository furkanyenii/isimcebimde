import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/customers/presentation/screens/customer_form_screen.dart';
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
    final customers = ref.watch(allCustomersProvider);

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
                _BrandHeader(offers: offers, customers: customers),
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

/// Gradyanlı marka paneli ve iki tıklanabilir özet.
///
/// Sayılar ekranın birincil içeriği değil: liste henüz yüklenmemiş veya
/// okunamamışsa modüllere giriş yine de çalışmalı. Bu yüzden burada
/// spinner/hata ekranı gösterilmez, rakam yerine "—" basılır. Hatanın kendisi
/// ilgili liste ekranında tekrar-dene aksiyonuyla birlikte gösterilir.
///
/// Her sayı bir kısayoldur: teklif → yeni teklif, müşteri → yeni müşteri.
class _BrandHeader extends StatelessWidget {
  const _BrandHeader({required this.offers, required this.customers});

  final AsyncValue<List<Offer>> offers;
  final AsyncValue<List<Customer>> customers;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final offerCount = offers.value?.length;
    final customerCount = customers.value?.length;

    return AppGradientPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Gradyan her iki temada koyu: marka adı her koşulda beyaz okunur.
              Text(
                'Quotra',
                style: context.textStyles.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ), // Marka adı çevrilmez.
              const Icon(Icons.bolt_rounded, size: AppSizes.iconSm),
            ],
          ),
          const SizedBox(height: AppSizes.lg),
          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  icon: Icons.description_outlined,
                  label: l10n.dashboardStatQuotes,
                  value: offerCount == null ? '—' : '$offerCount',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const OfferFormScreen(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.md),
              Expanded(
                child: _HeaderStat(
                  icon: Icons.people_outline,
                  label: l10n.dashboardStatCustomers,
                  value: customerCount == null ? '—' : '$customerCount',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (context) => const CustomerFormScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Gradyan üzerinde tıklanabilir özet: yarı saydam beyaz yüzey onu buton gibi
/// okutur; değer büyük ve tabular, altında etiket ve ekleme ipucu ikonu.
class _HeaderStat extends StatelessWidget {
  const _HeaderStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSizes.radiusLg);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Ink(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: borderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(icon, size: AppSizes.iconSm),
                  const Icon(Icons.add_rounded, size: AppSizes.iconSm),
                ],
              ),
              const SizedBox(height: AppSizes.sm),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.displaySmall?.tabular,
              ),
              Text(label, style: context.textStyles.labelSmall),
            ],
          ),
        ),
      ),
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
