import 'package:flutter/material.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// Teklifin para birimi etiketi. Yalnızca gösterim içindir, çevrim yapmaz
/// (bkz. `Currency` domain entity'si).
class CurrencySelector extends StatelessWidget {
  const CurrencySelector({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Currency value;
  final ValueChanged<Currency> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return DropdownButtonFormField<Currency>(
      initialValue: value,
      decoration: InputDecoration(labelText: l10n.currencyLabel),
      items: [
        for (final currency in Currency.values)
          DropdownMenuItem(
            value: currency,
            child: Text(_label(l10n, currency)),
          ),
      ],
      onChanged: (currency) {
        if (currency != null) onChanged(currency);
      },
    );
  }

  static String _label(AppLocalizations l10n, Currency currency) =>
      switch (currency) {
        Currency.turkishLira => l10n.currencyTurkishLira,
        Currency.usDollar => l10n.currencyUsDollar,
        Currency.euro => l10n.currencyEuro,
        Currency.britishPound => l10n.currencyBritishPound,
      };
}
