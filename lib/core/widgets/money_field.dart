import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isimcebimde/core/extensions/build_context_x.dart';
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
    this.label,
    this.autofocus = false,
    super.key,
  });

  final Money initialValue;
  final ValueChanged<Money> onChanged;

  /// null ise "Fiyat" kullanılır. Teklif satırında "Birim fiyat" gibi başka bir
  /// etiket gerekebilir.
  final String? label;
  final bool autofocus;

  @override
  State<MoneyField> createState() => _MoneyFieldState();
}

class _MoneyFieldState extends State<MoneyField> {
  final _controller = TextEditingController();
  String? _separator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Ayraç locale'e bağlı; locale ancak burada okunabilir (initState'te değil).
    // Dil değişirse alandaki metin yeni ayraçla yeniden yazılır.
    final separator = context.decimalSeparator;
    if (separator == _separator) return;

    final minor = _separator == null
        ? widget.initialValue.minor
        : MoneyInputFormatter.parseMinor(_controller.text);
    _separator = separator;
    _controller.text = MoneyInputFormatter.formatMinor(
      minor,
      decimalSeparator: separator,
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
      inputFormatters: [
        MoneyInputFormatter(decimalSeparator: context.decimalSeparator),
      ],
      textAlign: TextAlign.end,
      decoration: InputDecoration(
        labelText: widget.label ?? context.l10n.priceLabel,
        suffixText: '₺',
      ),
      onChanged: (text) =>
          widget.onChanged(Money(MoneyInputFormatter.parseMinor(text))),
      validator: (text) {
        final minor = MoneyInputFormatter.parseMinor(text ?? '');
        if (minor <= 0) return context.l10n.priceMustBePositive;
        return null;
      },
    );
  }
}

/// Girilen rakamları kuruş olarak yorumlar ve TR'de `12,50`, EN'de `12.50`
/// biçiminde gösterir. Ayraç yalnızca görüntüdür; değer her zaman kuruştur.
class MoneyInputFormatter extends TextInputFormatter {
  const MoneyInputFormatter({this.decimalSeparator = ','});

  final String decimalSeparator;

  static const int _minorPerMajor = 100;

  /// Metindeki rakamları kuruş değerine çevirir. Rakam yoksa 0.
  /// Ayraç ne olursa olsun rakam dışındaki her şey atılır.
  static int parseMinor(String text) {
    final digits = text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 0;
    return int.parse(digits);
  }

  /// Kuruşu `12,50` (veya `12.50`) biçiminde metne çevirir.
  static String formatMinor(int minor, {String decimalSeparator = ','}) {
    final major = minor ~/ _minorPerMajor;
    final fraction = (minor % _minorPerMajor).toString().padLeft(2, '0');
    return '$major$decimalSeparator$fraction';
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final minor = parseMinor(newValue.text);
    final text = formatMinor(minor, decimalSeparator: decimalSeparator);

    // İmleç her zaman sonda: alan sağdan sola dolduğu için tek anlamlı konum bu.
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
