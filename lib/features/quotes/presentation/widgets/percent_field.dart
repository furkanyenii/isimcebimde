import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isimcebimde/core/utils/money.dart';

/// Yüzde girişi (satır/genel indirim). Kullanıcı tam sayı yüzde puanı girer
/// (`10` → %10); `Percent` kesirli oranı da desteklese bunu şimdilik basit
/// tutuyoruz — alan opsiyonel bir iskontodur, kuruş hassasiyetindeki
/// `MoneyField` kadar kritik değildir.
class PercentField extends StatefulWidget {
  const PercentField({
    required this.initialValue,
    required this.onChanged,
    required this.label,
    super.key,
  });

  final Percent initialValue;
  final ValueChanged<Percent> onChanged;
  final String label;

  @override
  State<PercentField> createState() => _PercentFieldState();
}

class _PercentFieldState extends State<PercentField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.asPercent.toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: widget.label, suffixText: '%'),
      onChanged: (text) {
        final value = int.tryParse(text) ?? 0;
        widget.onChanged(Percent.of(value.clamp(0, 100)));
      },
    );
  }
}
