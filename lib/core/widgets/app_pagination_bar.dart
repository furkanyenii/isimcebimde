import 'package:flutter/material.dart';
import 'package:isimcebimde/core/constants/app_paging.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/pagination.dart';

/// Numaralı sayfalama çubuğu: `‹ 1 2 [3] 4 … 8 ›`.
///
/// Sayfa numarasına dokununca o sayfaya atlar (kullanıcının seçtiği "sayfa
/// arama" davranışı). **Tek satırdır** ve sabit [AppPaging.barHeight]
/// yüksekliğindedir (ekranlar FAB'ı bu kadar kaldırıp çakışmayı önler);
/// sığmazsa yatay kaydırılır, ortalanır.
class AppPaginationBar extends StatelessWidget {
  const AppPaginationBar({
    required this.currentPage,
    required this.pageCount,
    required this.onSelected,
    super.key,
  });

  /// 0 tabanlı geçerli sayfa.
  final int currentPage;

  /// Toplam sayfa sayısı. Çağıran taraf yalnızca > 1 iken gösterir.
  final int pageCount;

  /// Seçilen 0 tabanlı sayfayı bildirir.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // pageWindow 1 tabanlı çalışır; UI 1 tabanlı gösterir, dışarı 0 tabanlı verir.
    final tokens = pageWindow(currentPage + 1, pageCount);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border(top: BorderSide(color: context.colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppPaging.barHeight,
          // Tek satır: sığmazsa yatay kaydırılır; sığıyorsa ortalanır
          // (ConstrainedBox minWidth + Row center).
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ArrowButton(
                      icon: Icons.chevron_left,
                      tooltip: l10n.paginationPrevious,
                      onTap: currentPage > 0
                          ? () => onSelected(currentPage - 1)
                          : null,
                    ),
                    for (final token in tokens)
                      if (token == null)
                        const _Ellipsis()
                      else
                        _PageButton(
                          page: token,
                          semanticLabel: l10n.paginationPageSemantic(token),
                          isSelected: token == currentPage + 1,
                          // 1 tabanlı token'ı 0 tabanlıya çevirir.
                          onTap: () => onSelected(token - 1),
                        ),
                    _ArrowButton(
                      icon: Icons.chevron_right,
                      tooltip: l10n.paginationNext,
                      onTap: currentPage < pageCount - 1
                          ? () => onSelected(currentPage + 1)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;

  /// `null` iken buton pasif (ilk/son sayfada).
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon), tooltip: tooltip, onPressed: onTap);
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.semanticLabel,
    required this.isSelected,
    required this.onTap,
  });

  final int page;
  final String semanticLabel;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Semantics(
      label: semanticLabel,
      selected: isSelected,
      button: true,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.xs),
        child: Material(
          color: isSelected ? colors.primary : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
          ),
          child: InkWell(
            // Seçili sayfada tekrar tıklama anlamsız; hedefi pasifleştir.
            onTap: isSelected ? null : onTap,
            borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            child: SizedBox(
              width: AppSizes.minTapTarget,
              height: AppSizes.minTapTarget,
              child: Center(
                child: Text(
                  '$page',
                  style: context.textStyles.titleSmall?.copyWith(
                    color: isSelected ? colors.onPrimary : colors.onSurface,
                    fontWeight: isSelected ? FontWeight.bold : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Ellipsis extends StatelessWidget {
  const _Ellipsis();

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox(
        width: AppSizes.lg,
        height: AppSizes.minTapTarget,
        child: Center(
          child: Text(
            '…',
            style: context.textStyles.titleSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
