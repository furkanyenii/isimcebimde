import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';

/// Teklif oluştururken müşteri seçimi.
///
/// Dropdown değil bir bottom sheet: müşteri listesi kategoriden farklı olarak
/// onlarca/yüzlerce kayda çıkabilir, dropdown'da aranamaz hale gelirdi.
/// Aramak için kendi yerel metnini tutar — ekranın paylaşılan
/// `customerSearchQueryProvider`'ını kullanmaz, aksi halde picker'daki arama
/// arkadaki Müşteriler ekranının arama kutusunu da sessizce değiştirirdi.
class CustomerPicker extends StatelessWidget {
  const CustomerPicker({
    required this.selectedName,
    required this.onChanged,
    super.key,
  });

  /// Yalnızca gösterim içindir. Var olan bir teklifi düzenlerken elimizde
  /// müşterinin **snapshot** adı vardır, tam `Customer` nesnesi değil —
  /// bu yüzden seçim gösterimi bir isme, seçim sonucu ise gerçek [Customer]'a
  /// dayanır.
  final String? selectedName;
  final ValueChanged<Customer> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return InkWell(
      onTap: () => _open(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.customerFieldLabel,
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          selectedName ?? l10n.customerRequired,
          style: selectedName == null
              ? TextStyle(color: context.colors.onSurfaceVariant)
              : null,
        ),
      ),
    );
  }

  Future<void> _open(BuildContext context) async {
    final customer = await showModalBottomSheet<Customer>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CustomerPickerSheet(),
    );
    if (customer != null) onChanged(customer);
  }
}

class _CustomerPickerSheet extends ConsumerStatefulWidget {
  const _CustomerPickerSheet();

  @override
  ConsumerState<_CustomerPickerSheet> createState() =>
      _CustomerPickerSheetState();
}

class _CustomerPickerSheetState extends ConsumerState<_CustomerPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Bilerek global arama provider'ı değil, tüm liste izlenir; filtre burada
    // yerel metinle uygulanır (yukarıdaki class doc'una bakınız).
    final customers = ref.watch(customerListProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: l10n.customerSearchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSizes.sm),
            Flexible(
              child: customers.when(
                loading: () => const AppLoadingView(),
                error: (error, _) =>
                    AppErrorView(message: l10n.customersLoadError),
                data: (items) {
                  final query = _searchController.text;
                  final filtered = items
                      .where(
                        (c) =>
                            containsNormalized(c.name, query) ||
                            containsNormalized(c.contactPerson ?? '', query) ||
                            containsNormalized(c.phone ?? '', query),
                      )
                      .toList();

                  if (filtered.isEmpty) {
                    return AppEmptyView(
                      icon: Icons.search_off,
                      title: l10n.emptySearchTitle,
                      description: l10n.emptySearchDescription,
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final customer = filtered[index];
                      return ListTile(
                        title: Text(customer.name),
                        subtitle: customer.contactPerson == null
                            ? null
                            : Text(customer.contactPerson!),
                        onTap: () => Navigator.of(context).pop(customer),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
