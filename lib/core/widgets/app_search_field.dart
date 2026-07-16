import 'package:flutter/material.dart';

/// Liste ekranlarının ve seçici sheet'lerin arama kutusu: metin girildiğinde
/// beliren temizle butonuyla birlikte.
///
/// Metnin nerede tutulacağına çağıran karar verir ([onChanged]): ürün listesi
/// paylaşılan bir provider'a yazar, seçici sheet'ler kendi yerel state'lerinde
/// tutar. Kutunun kendi mekaniği (controller'ın ömrü, temizle butonunun
/// görünürlüğü) her seferinde yeniden kurulmasın diye burada bir kez tanımlanır
/// (CLAUDE.md: kod tekrarından kaçın).
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.hintText,
    required this.onChanged,
    this.autofocus = false,
    super.key,
  });

  final String hintText;
  final ValueChanged<String> onChanged;

  /// Sheet'te açılır açılmaz yazmaya başlanabilsin diye; tam ekran listelerde
  /// klavyeyi kendiliğinden açmak istemeyiz.
  final bool autofocus;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _update(String value) {
    widget.onChanged(value);
    setState(() {}); // yalnızca temizle butonunun görünürlüğü için
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _update('');
                },
              ),
      ),
      onChanged: _update,
    );
  }
}
