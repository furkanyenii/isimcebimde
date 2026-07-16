import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';

/// Tasarım dilinin temel yüzeyi: kenarlıklı, yumuşak köşeli, opsiyonel
/// dokunulabilir kart. Ekranlar `Card` + `InkWell` ikilisini her yerde
/// yeniden kurmaz (CLAUDE.md: kod tekrarından kaçın).
class AppSurfaceCard extends StatelessWidget {
  const AppSurfaceCard({
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSizes.md),
    this.isHighlighted = false,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  /// Kartı marka aksanıyla çerçeveler (seçili/öne çıkan öğe).
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(AppSizes.radiusLg);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLow,
        borderRadius: borderRadius,
        border: Border.all(
          color: isHighlighted
              ? context.colors.primary
              : context.colors.outline,
          width: isHighlighted ? 1.5 : 1,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Liste satırı: renkli ikon kutusu + başlık + alt satır + sağda değer.
/// Teklif, ürün, müşteri ve şablon listeleri aynı satır dilini paylaşır;
/// biçimi burada bir kez tanımlanır (CLAUDE.md: kod tekrarından kaçın).
class AppListCard extends StatelessWidget {
  const AppListCard({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.iconColor,
    this.isHighlighted = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  /// Sağdaki değer — tipik olarak tutar. Yoksa yerine ok işareti çizilir.
  final Widget? trailing;
  final Color? iconColor;
  final VoidCallback onTap;

  /// Satırı marka aksanıyla çerçeveler (bkz. [AppSurfaceCard.isHighlighted]).
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      isHighlighted: isHighlighted,
      child: Row(
        children: [
          AppIconTile(icon: icon, color: iconColor),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleMedium,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSizes.sm),
          trailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.onSurfaceVariant,
              ),
        ],
      ),
    );
  }
}

/// Kart içindeki renkli ikon kutusu. Modül/satır ikonlarına kimlik verir.
class AppIconTile extends StatelessWidget {
  const AppIconTile({
    required this.icon,
    this.color,
    this.size = AppSizes.iconTile,
    super.key,
  });

  final IconData icon;

  /// Verilmezse marka aksanı kullanılır.
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? context.colors.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Icon(icon, size: AppSizes.iconMd, color: tint),
    );
  }
}

/// Marka gradyanlı başlık paneli. Ana ekranın üst bölümü buradan gelir;
/// gradyan [ColorScheme]'de temsil edilemediği için renkler [AppColors]'tan
/// okunur (bkz. AppColors.accentGradient).
class AppGradientPanel extends StatelessWidget {
  const AppGradientPanel({
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.lg),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.accentGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.all(Radius.circular(AppSizes.radiusXl)),
      ),
      // Gradyanın her iki ucu da koyu: içerik her temada beyaz okunur. Renk
      // alt ağacın tema'sına yazılır — `DefaultTextStyle.merge` yetmez, çünkü
      // `context.textStyles.*` stilleri kendi rengini taşır ve merge'ü ezer.
      child: Theme(
        data: context.theme.copyWith(
          textTheme: context.textStyles.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}
