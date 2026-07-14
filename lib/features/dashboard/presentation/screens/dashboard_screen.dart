import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';

/// Ana ekran. Modüllere kartlar üzerinden girilir.
///
/// Bottom navigation bilinçli olarak tercih edilmedi: modül sayısı az ve
/// kullanıcının asıl işi "yeni teklif" — o eylem birincil buton olarak öne çıkar.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: const Text('Quotra')), // Marka adı çevrilmez.
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const OfferFormScreen(),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: Text(l10n.quoteNew),
              ),
              const SizedBox(height: AppSizes.lg),
              Expanded(
                child: GridView.count(
                  // Tablet/yatayda iki yerine dört sütun.
                  crossAxisCount: context.isWide ? 4 : 2,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  children: [
                    _ModuleCard(
                      icon: Icons.description_outlined,
                      label: l10n.moduleQuotes,
                      onTap: () => context.go(AppRoutes.quotes),
                    ),
                    _ModuleCard(
                      icon: Icons.inventory_2_outlined,
                      label: l10n.moduleProducts,
                      onTap: () => context.go(AppRoutes.products),
                    ),
                    _ModuleCard(
                      icon: Icons.people_outline,
                      label: l10n.moduleCustomers,
                      onTap: () => context.go(AppRoutes.customers),
                    ),
                    _ModuleCard(
                      icon: Icons.settings_outlined,
                      label: l10n.moduleSettings,
                      onTap: () => context.go(AppRoutes.settings),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [onTap] null ise modül henüz hazır değildir: kart soluk gösterilir ve
/// "Yakında" etiketi alır. Kullanıcıya çalışmayan bir şey vaat edilmez.
class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    final foreground = isEnabled
        ? context.colors.onSurface
        : context.colors.onSurfaceVariant.withValues(alpha: 0.5);

    return Card(
      color: context.colors.surfaceContainerHighest,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        child: Semantics(
          button: true,
          enabled: isEnabled,
          label: isEnabled ? label : context.l10n.comingSoonSemantics(label),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: AppSizes.iconLg, color: foreground),
              const SizedBox(height: AppSizes.sm),
              Text(
                label,
                style: context.textStyles.titleMedium?.copyWith(
                  color: foreground,
                ),
              ),
              if (!isEnabled) ...[
                const SizedBox(height: AppSizes.xs),
                Text(
                  context.l10n.comingSoon,
                  style: context.textStyles.labelSmall?.copyWith(
                    color: foreground,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
