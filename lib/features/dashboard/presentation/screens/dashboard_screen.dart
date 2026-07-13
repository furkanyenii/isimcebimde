import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';

/// Ana ekran. Modüllere kartlar üzerinden girilir.
///
/// Bottom navigation bilinçli olarak tercih edilmedi: modül sayısı az ve
/// kullanıcının asıl işi "yeni teklif" — o eylem birincil buton olarak öne çıkar.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quotra')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: null, // Phase 5 — Teklif modülü
                icon: const Icon(Icons.add),
                label: const Text('Yeni Teklif'),
              ),
              const SizedBox(height: AppSizes.lg),
              Expanded(
                child: GridView.count(
                  // Tablet/yatayda iki yerine dört sütun.
                  crossAxisCount: context.isWide ? 4 : 2,
                  crossAxisSpacing: AppSizes.md,
                  mainAxisSpacing: AppSizes.md,
                  children: [
                    const _ModuleCard(
                      icon: Icons.description_outlined,
                      label: 'Teklifler', // Phase 5
                    ),
                    _ModuleCard(
                      icon: Icons.inventory_2_outlined,
                      label: 'Ürünler',
                      onTap: () => context.go(AppRoutes.products),
                    ),
                    _ModuleCard(
                      icon: Icons.people_outline,
                      label: 'Müşteriler',
                      onTap: () => context.go(AppRoutes.customers),
                    ),
                    const _ModuleCard(
                      icon: Icons.settings_outlined,
                      label: 'Ayarlar', // Phase 4
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
          label: isEnabled ? label : '$label, yakında',
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
                  'Yakında',
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
