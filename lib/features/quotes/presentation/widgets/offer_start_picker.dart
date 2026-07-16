import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_colors.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/core/widgets/app_search_field.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/template_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';

/// Arama kutusunun görünmeye başladığı şablon sayısı. Birkaç şablonda arama
/// yalnızca gürültüdür; liste uzayınca gerekli olur.
const int _searchThreshold = 5;

/// Sheet ekranın en fazla bu kadarını kaplar; üstte kalan boşluk hem altındaki
/// ekranı görünür tutar hem sheet'i tam ekran bir sayfa gibi okunmaktan
/// kurtarır. Şablon listesi uzasa da sheet tepeye dayanmaz, kendi içinde kayar.
const double _sheetMaxHeightFactor = 0.8;

/// "Yeni teklif" akışının tek girişi: gerekiyorsa başlangıç seçimini sorar,
/// sonra teklif formunu açar. Teklif listesi ve ana ekran bu akışı paylaşır.
///
/// Şablon yoksa seçim hiç sorulmaz, doğrudan boş form açılır — boş kutuyla
/// başlayan kullanıcıya fazladan dokunuş yüklenmez.
Future<void> openNewOfferFlow(BuildContext context, WidgetRef ref) async {
  final draft = await _pickOfferStart(context, ref);
  if (draft == null || !context.mounted) return;

  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => OfferFormScreen(offer: draft),
    ),
  );
}

/// Kullanıcının başlamak istediği taslak. `null` = vazgeçildi.
Future<Offer?> _pickOfferStart(BuildContext context, WidgetRef ref) async {
  final templates = await _loadTemplates(ref);
  if (!context.mounted) return null;

  if (templates.isEmpty) return _blankOffer();

  return showModalBottomSheet<Offer>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * _sheetMaxHeightFactor,
    ),
    builder: (context) => _OfferStartSheet(templates: templates),
  );
}

Offer _blankOffer() => Offer(customerName: '', items: const []);

/// Şablonlar ikincil veridir: okunamazsa teklif akışı durmaz, boş teklifle
/// devam edilir (ana ekrandaki özet rakamlarıyla aynı gerekçe). Hata, şablon
/// listesi ekranında tekrar-dene aksiyonuyla birlikte gösterilir.
///
/// `listenManual` şart: `templateListProvider` autoDispose'dur ve tek başına
/// `ref.read(...future)` dinleyicisiz kalır — provider ilk değer gelmeden
/// dispose olur, future hata verir ve şablonlar sessizce "yok" sayılır.
/// Abonelik, değer elde edilene kadar provider'ı hayatta tutar.
Future<List<Template>> _loadTemplates(WidgetRef ref) async {
  final subscription = ref.listenManual(templateListProvider, (_, _) {});
  try {
    return await ref.read(templateListProvider.future);
  } catch (_) {
    return const [];
  } finally {
    subscription.close();
  }
}

/// Teklife nasıl başlanacağını sorar: boş teklif ya da bir şablon.
///
/// Şablonlar provider'dan izlenmez, [templates] olarak hazır alınır: liste
/// sheet açılmadan önce zaten yüklendi (boş olup olmadığı ona göre karara
/// bağlandı) ve bu kısa ömürlü modal boyunca değişemez. Böylece burada
/// tekrar loading/error dalı kurmak gerekmez.
class _OfferStartSheet extends StatefulWidget {
  const _OfferStartSheet({required this.templates});

  final List<Template> templates;

  @override
  State<_OfferStartSheet> createState() => _OfferStartSheetState();
}

class _OfferStartSheetState extends State<_OfferStartSheet> {
  /// Sheet'e özel arama metni; ekranın paylaşılan `templateSearchQueryProvider`
  /// state'i buraya sızmamalı — kullanıcı listede ne aradıysa teklife
  /// başlarken onunla karşılaşmasın.
  String _query = '';

  bool get _hasSearch => widget.templates.length > _searchThreshold;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final filtered = widget.templates
        .where((t) => containsNormalized(t.name, _query))
        .toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.quoteNew, style: context.textStyles.titleLarge),
            const SizedBox(height: AppSizes.md),
            // Vurgulu: şablon listesi uzadıkça "sıfırdan başla" seçeneği
            // sıradan bir satıra dönüşüp kaybolmamalı.
            AppListCard(
              icon: Icons.add,
              isHighlighted: true,
              title: l10n.offerStartBlank,
              subtitle: l10n.offerStartBlankSubtitle,
              onTap: () => Navigator.of(context).pop(_blankOffer()),
            ),
            const SizedBox(height: AppSizes.lg),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.xs,
                bottom: AppSizes.sm,
              ),
              child: Text(
                l10n.offerStartFromTemplate.toUpperCase(),
                style: context.textStyles.labelSmall,
              ),
            ),
            if (_hasSearch) ...[
              AppSearchField(
                hintText: l10n.templateSearchHint,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: AppSizes.sm),
            ],
            Flexible(
              child: filtered.isEmpty
                  ? AppEmptyView(
                      icon: Icons.search_off,
                      title: l10n.emptySearchTitle,
                      description: l10n.emptySearchDescription,
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSizes.sm),
                      itemBuilder: (context, index) =>
                          _TemplateOption(template: filtered[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplateOption extends StatelessWidget {
  const _TemplateOption({required this.template});

  final Template template;

  @override
  Widget build(BuildContext context) {
    return AppListCard(
      icon: Icons.bookmark_outline,
      iconColor: AppColors.info,
      title: template.name,
      subtitle: context.l10n.quoteItemCount(template.items.length),
      // Şablon satırları yeni/kaydedilmemiş satırlara kopyalanır; şablonun
      // kendisi tekliften etkilenmez (bkz. Template.toDraftOffer).
      onTap: () => Navigator.of(context).pop(template.toDraftOffer()),
    );
  }
}
