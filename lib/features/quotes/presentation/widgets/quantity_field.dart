import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
import 'package:isimcebimde/core/utils/quantity.dart';

/// Teklif satırının miktar girişi. Kesirli olabilir (12,5 m²).
///
/// Ondalık ayracı dile göre değişir (TR `,`, EN `.`); ikisi de kabul edilir,
/// çünkü kullanıcının klavyesi her zaman uygulamanın diliyle uyuşmaz.
class QuantityField extends StatefulWidget {
  const QuantityField({
    required this.initialValue,
    required this.onChanged,
    super.key,
  });

  final Quantity initialValue;

  /// Yalnızca **geçerli ve pozitif** bir miktar girildiğinde çağrılır. Kullanıcı
  /// alanı silip yeniden yazarken satır tutarı sıfırlanmaz.
  final ValueChanged<Quantity> onChanged;

  @override
  State<QuantityField> createState() => _QuantityFieldState();
}

class _QuantityFieldState extends State<QuantityField> {
  final _controller = TextEditingController();
  bool _isInitialized = false;

  /// Başlangıç metni aktif dile göre biçimlenir; `context.localeTag`
  /// `initState`'te okunamaz, bu yüzden ilk `didChangeDependencies`'te yazılır.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    _controller.text = widget.initialValue.format(locale: context.localeTag);
    _isInitialized = true;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChanged(String text) {
    final normalized = text.replaceAll(',', '.');
    final value = double.tryParse(normalized);
    if (value == null || value <= 0) return;
    widget.onChanged(Quantity.of(value));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      decoration: InputDecoration(labelText: context.l10n.quantityLabel),
      onChanged: _handleChanged,
    );
  }
}
