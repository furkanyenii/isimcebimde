import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isimcebimde/core/constants/app_sizes.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/customers/presentation/screens/customer_form_screen.dart';

class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customerListProvider);
    final query = ref.watch(customerSearchQueryProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.moduleCustomers)),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: _SearchField(),
          ),
          Expanded(
            child: customers.when(
              loading: () => const AppLoadingView(),
              error: (error, _) => AppErrorView(
                message: l10n.customersLoadError,
                onRetry: () => ref.invalidate(customerListProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  // Arama sonucu boş olmakla, hiç müşteri olmaması farklı şeylerdir.
                  return query.trim().isEmpty
                      ? AppEmptyView(
                          icon: Icons.people_outline,
                          title: l10n.customersEmptyTitle,
                          description: l10n.customersEmptyDescription,
                          actionLabel: l10n.customerAdd,
                          onAction: () => _openForm(context),
                        )
                      : AppEmptyView(
                          icon: Icons.search_off,
                          title: l10n.emptySearchTitle,
                          description: l10n.emptySearchDescription,
                        );
                }
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) => _CustomerTile(
                    customer: items[index],
                    onTap: () => _openForm(context, customer: items[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context),
        icon: const Icon(Icons.add),
        label: Text(l10n.customerNew),
      ),
    );
  }

  void _openForm(BuildContext context, {Customer? customer}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => CustomerFormScreen(customer: customer),
      ),
    );
  }
}

class _SearchField extends ConsumerStatefulWidget {
  const _SearchField();

  @override
  ConsumerState<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends ConsumerState<_SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        // Sahada kullanıcı firmanın adını değil, muhatabını hatırlar.
        hintText: context.l10n.customerSearchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  ref.read(customerSearchQueryProvider.notifier).update('');
                  setState(() {});
                },
              ),
      ),
      onChanged: (value) {
        ref.read(customerSearchQueryProvider.notifier).update(value);
        setState(() {}); // yalnızca temizle butonunun görünürlüğü için
      },
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.customer, required this.onTap});

  final Customer customer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Kurumsalda yetkili kişi, bireyselde telefon en ayırt edici ikinci bilgidir.
    final subtitle = customer.contactPerson ?? customer.phone;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
      leading: Icon(
        customer.type.isCompany
            ? Icons.business_outlined
            : Icons.person_outline,
      ),
      title: Text(customer.name),
      subtitle: subtitle == null ? null : Text(subtitle),
      onTap: onTap,
    );
  }
}
