import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/theme/app_typography.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/core/widgets/app_surfaces.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/screens/offer_form_screen.dart';

class OfferListScreen extends ConsumerWidget {
  const OfferListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offers = ref.watch(offerListProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleQuotes)),
      body: offers.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: l10n.quotesLoadError,
          onRetry: () => ref.invalidate(offerListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            // Eylem butonu yok: yeni teklif zaten sağ alttaki FAB ile açılır.
            return AppEmptyView(
              icon: Icons.description_outlined,
              title: l10n.quotesEmptyTitle,
              description: l10n.quotesEmptyDescription,
            );
          }
          return ListView.separated(
            // FAB son kartı örtmesin.
            padding: const EdgeInsets.fromLTRB(
              AppSizes.md,
              AppSizes.sm,
              AppSizes.md,
              AppSizes.xxl + AppSizes.lg,
            ),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSizes.sm),
            itemBuilder: (context, index) => _OfferCard(offer: items[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openOfferForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.quoteNew),
      ),
    );
  }
}

void _openOfferForm(BuildContext context, {Offer? offer}) {
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
