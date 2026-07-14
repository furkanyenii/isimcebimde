import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isimcebimde/app/router/app_router.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
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
      appBar: AppBar(
        title: Text(l10n.moduleQuotes),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.templates),
            icon: const Icon(Icons.bookmarks_outlined),
            tooltip: l10n.templatesTitle,
          ),
        ],
      ),
      body: offers.when(
        loading: () => const AppLoadingView(),
        error: (error, _) => AppErrorView(
          message: l10n.quotesLoadError,
          onRetry: () => ref.invalidate(offerListProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyView(
              icon: Icons.description_outlined,
              title: l10n.quotesEmptyTitle,
              description: l10n.quotesEmptyDescription,
              actionLabel: l10n.quoteNew,
              onAction: () => _openOfferForm(context),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) => _OfferTile(offer: items[index]),
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

class _OfferTile extends StatelessWidget {
  const _OfferTile({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: const Icon(Icons.description_outlined),
      title: Text(offer.customerName),
      subtitle: Text('${offer.items.length} ürün'),
      trailing: Text(
        offer.grandTotal.format(
          locale: context.localeTag,
          symbol: offer.currency.symbol,
        ),
        style: context.textStyles.titleMedium,
      ),
      onTap: () => _openOfferForm(context, offer: offer),
    );
  }
}
