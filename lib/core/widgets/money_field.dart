import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isimcebimde/core/utils/money.dart';

/// Para girişini **kuruş** olarak yöneten alan.
///
/// Kullanıcı yalnızca rakam yazar; alan sağdan sola dolar (ATM/POS mantığı):
/// `1` → `0,01`, `12` → `0,12`, `1250` → `12,50`.
///
/// Metin hiçbir aşamada `double`'a çevrilmez — girilen rakamlar doğrudan
/// [Money.minor] değeridir. Bu, CLAUDE.md'deki "para asla double değildir"
/// kuralının kullanıcı arayüzündeki karşılığıdır: `double.parse('12,50')`
/// gibi bir adım hiç var olmaz.
class MoneyField extends StatefulWidget {
  const MoneyField({
    required this.initialValue,
    required this.onChanged,
    this.label = 'Fiyat',
    this.autofocus = false,
    super.key,
  });

  final Money initialValue;
  final ValueChanged<Money> onChanged;
  final String label;
  final bool autofocus;

  @override
  State<MoneyField> createState() => _MoneyFieldState();
}

class _MoneyFieldState extends State<MoneyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: MoneyInputFormatter.formatMinor(widget.initialValue.minor),
    );
  }

  @override
  void dispose() {
    // Memory leak kontrolü (CLAUDE.md: Review Rules).
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autofocus: widget.autofocus,
      keyboardType: const TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [MoneyInputFormatter()],
      textAlign: TextAlign.end,
      decoration: InputDecoration(labelText: widget.label, suffixText: '₺'),
      onChanged: (text) =>
          widget.onChanged(Money(MoneyInputFormatter.parseMinor(text))),
      validator: (text) {
        final minor = MoneyInputFormatter.parseMinor(text ?? '');
        if (minor <= 0) return 'Fiyat sıfırdan büyük olmalı';
        return null;
      },
    );
  }
}

/// Girilen rakamları kuruş olarak yorumlar ve `12,50` biçiminde gösterir.
class MoneyInputFormatter extends TextInputFormatter {
  static const int _minorPerMajor = 100;

  /// Metindeki rakamları kuruş değerine çevirir. Rakam yoksa 0.
  static int parseMinor(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 0;
    return int.parse(digits);
  }

  /// Kuruşu `12,50` biçiminde metne çevirir.
  static String formatMinor(int minor) {
    final lira = minor ~/ _minorPerMajor;
    final kurus = (minor % _minorPerMajor).toString().padLeft(2, '0');
    return '$lira,$kurus';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final minor = parseMinor(newValue.text);
    final text = formatMinor(minor);

    // İmleç her zaman sonda: alan sağdan sola dolduğu için tek anlamlı konum bu.
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
