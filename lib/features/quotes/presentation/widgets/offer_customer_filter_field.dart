import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/core/widgets/app_picker_sheet.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/quotes/presentation/providers/offer_providers.dart';

/// Teklifler ekranının müşteri filtresi.
///
/// Dropdown gibi görünen bir alandır; dokununca aramalı bir **bottom sheet**
/// açar (uygulamadaki `CustomerPicker` ile aynı desen). Inline menü kullanmama
/// nedeni: 100+ müşteride açılan klavye menüyü örter, yazılan arama görünmez ve
/// en alttaki kayda kaydırılamazdı. Sheet %75 yükseklikte, klavye-duyarlı ve
/// kaydırılabilir olduğundan bunların hiçbiri olmaz.
///
/// Boş = tüm teklifler. Seçim yapılınca müşteri adı alanda görünür; sondaki
/// temizle (×) filtreyi kaldırır.
class OfferCustomerFilterField extends ConsumerWidget {
  const OfferCustomerFilterField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedId = ref.watch(offerCustomerFilterProvider);
    final selectedName = _selectedName(ref, selectedId);

    return InkWell(
      onTap: () => _openSheet(context, ref),
      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: selectedId == null
              ? const Icon(Icons.arrow_drop_down)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: l10n.quotesFilterClear,
                  onPressed: () => ref
                      .read(offerCustomerFilterProvider.notifier)
                      .select(null),
                ),
        ),
        child: Text(
          selectedName ?? l10n.quotesFilterHint,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: selectedName == null
              ? TextStyle(color: context.colors.onSurfaceVariant)
              : null,
        ),
      ),
    );
  }

  /// Seçili id'nin adını tüm müşteri listesinden çözer (provider yalnızca id
  /// tutar, ad snapshot'ı bayatlamasın diye). Liste yüklenmediyse `null`.
  String? _selectedName(WidgetRef ref, int? selectedId) {
    if (selectedId == null) return null;
    final customers = ref.watch(allCustomersProvider).asData?.value;
    if (customers == null) return null;
    for (final customer in customers) {
      if (customer.id == selectedId) return customer.name;
    }
    return null;
  }

  Future<void> _openSheet(BuildContext context, WidgetRef ref) async {
    final choice = await showAppPickerSheet<_FilterChoice>(
      context: context,
      builder: (context) => const _OfferCustomerFilterSheet(),
    );
    // null = sheet kapatıldı (seçim yok); değişiklik yapma.
    if (choice == null) return;
    ref.read(offerCustomerFilterProvider.notifier).select(choice.customerId);
  }
}

/// Sheet'ten dönen seçim. [customerId] `null` ise "Tüm müşteriler" (filtreyi
/// kaldır) demektir. Sheet hiç seçim yapılmadan kapanırsa dönen değer `null`
/// olur — bu "değişiklik yok"tur, "tümü" değil; ikisi ayrı tutulur.
class _FilterChoice {
  const _FilterChoice(this.customerId);
  final int? customerId;
}

class _OfferCustomerFilterSheet extends ConsumerStatefulWidget {
  const _OfferCustomerFilterSheet();

  @override
  ConsumerState<_OfferCustomerFilterSheet> createState() =>
      _OfferCustomerFilterSheetState();
}

class _OfferCustomerFilterSheetState
    extends ConsumerState<_OfferCustomerFilterSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final customers = ref.watch(allCustomersProvider);

    return Padding(
      padding: const EdgeInsets.all(AppSizes.md),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: l10n.quotesFilterHint,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSizes.sm),
          Expanded(
            child: customers.when(
              loading: () => const AppLoadingView(),
              error: (error, _) =>
                  AppErrorView(message: l10n.customersLoadError),
              data: (items) {
                final query = _searchController.text;
                // En yeni müşteri üstte (id desc).
                final filtered = [
                  for (final customer in items)
                    if (containsNormalized(customer.name, query) ||
                        containsNormalized(customer.contactPerson ?? '', query))
                      customer,
                ]..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

                return ListView.builder(
                  // +1: en üstteki "Tüm müşteriler" (filtreyi temizle) satırı.
                  // Arama boşken görünür; kullanıcı arıyorsa gizlenir.
                  itemCount: filtered.length + (query.isEmpty ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (query.isEmpty && index == 0) {
                      return ListTile(
                        leading: const Icon(Icons.clear_all),
                        title: Text(l10n.quotesFilterAll),
                        onTap: () => Navigator.of(
                          context,
                        ).pop(const _FilterChoice(null)),
                      );
                    }
                    final customer = filtered[index - (query.isEmpty ? 1 : 0)];
                    return ListTile(
                      title: Text(customer.name),
                      subtitle: customer.contactPerson == null
                          ? null
                          : Text(customer.contactPerson!),
                      onTap: () =>
                          Navigator.of(context).pop(_FilterChoice(customer.id)),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
