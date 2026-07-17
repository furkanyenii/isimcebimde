import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isimcebimde/core/constants/app_paging.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
import 'package:isimcebimde/core/widgets/app_paginated_list_view.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_customer_filter_field.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_start_picker.dart';

class OfferListScreen extends ConsumerWidget {
  const OfferListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(filteredOfferListProvider);
    final isFiltered = ref.watch(offerCustomerFilterProvider) != null;
    final hasPagination =
        (offers.asData?.value.length ?? 0) > AppPaging.pageSize;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleQuotes)),
      body: offers.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: l10n.quotesLoadError,
          // Hata kaynağı alttaki tek stream; filtreli türev değil onu tazeler.
          onRetry: () => ref.invalidate(offerListProvider),
        ),
        data: (items) {
          // Filtre aktifken sonuç boşsa bile filtreyi göster: kullanıcı aşırı
          // daraltan seçimi ancak dropdown'dan "Tümü" ile geri alabilir.
          if (items.isEmpty && !isFiltered) {
            // Eylem butonu yok: yeni teklif zaten sağ alttaki FAB ile açılır.
            return AppEmptyView(
              icon: Icons.description_outlined,
              title: l10n.quotesEmptyTitle,
              description: l10n.quotesEmptyDescription,
            );
          }
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.md,
                  AppSizes.sm,
                ),
                child: OfferCustomerFilterField(),
              ),
              Expanded(
                child: items.isEmpty
                    ? AppEmptyView(
                        icon: Icons.search_off,
                        title: l10n.emptySearchTitle,
                        description: l10n.emptySearchDescription,
                      )
                    : AppPaginatedListView<Offer>(
                        items: items,
                        pageBuilder: (context, pageItems) => ListView.separated(
                          // FAB son kartı örtmesin.
                          padding: const EdgeInsets.fromLTRB(
                            AppSizes.md,
                            0,
                            AppSizes.md,
                            AppSizes.xxl + AppSizes.lg,
                          ),
                          itemCount: pageItems.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSizes.sm),
                          itemBuilder: (context, index) =>
                              _OfferCard(offer: pageItems[index]),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      // Sayfalama çubuğu görünürken FAB'ı çubuk yüksekliği kadar kaldır.
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: hasPagination ? AppPaging.barHeight : 0,
        ),
        child: FloatingActionButton.extended(
          onPressed: () => openNewOfferFlow(context, ref),
          icon: const Icon(Icons.add),
          label: Text(l10n.quoteNew),
        ),
      ),
    );
  }
}

/// Kayıtlı bir teklifi düzenlemeye açar. Yeni teklif bu yoldan geçmez:
/// başlangıç seçimi için `openNewOfferFlow` kullanılır.
void _openOfferForm(BuildContext context, {required Offer offer}) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (context) => OfferFormScreen(offer: offer),
    ),
  );
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    // "3 ürün · 15.07.2026" — adet ve tarih tek alt satırda.
    final date = DateFormat.yMd(context.localeTag).format(offer.createdAt);
    final subtitle =
        '${context.l10n.quoteItemCount(offer.items.length)} · $date';

    return AppListCard(
      icon: Icons.description_outlined,
      title: offer.customerName,
      subtitle: subtitle,
      onTap: () => _openOfferForm(context, offer: offer),
      trailing: Text(
        offer.grandTotal.format(
          locale: context.localeTag,
          symbol: offer.currency.symbol,
        ),
        style: context.textStyles.titleMedium?.tabular,
      ),
    );
  }
}
