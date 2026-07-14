import 'package:flutter/material.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/presentation/widgets/offer_item_row.dart';

/// Teklifin satır listesi + "Ürün ekle" butonu.
///
/// Business state (hangi satırın nasıl değiştiği) burada değil, çağıran
/// ekranda yaşar (CLAUDE.md: Riverpod Rules) — bu widget yalnızca listeyi
/// düzenleyip [onChanged] ile bütün listeyi geri verir.
///
/// **Satır anahtarları burada, satırın içeriğinden bağımsız olarak tutulur.**
/// Anahtar `item`'dan türetilseydi (ör. `ValueKey(item.hashCode)`), kullanıcı
/// miktara her rakam yazdığında anahtar değişir, Flutter satırı *yeni bir
/// widget* sanıp state'ini atar ve **klavye her basamakta kapanırdı**. Anahtar
/// satırın kimliğini temsil eder, değerini değil.
class OfferItemsSection extends StatefulWidget {
  const OfferItemsSection({
    required this.items,
    required this.currency,
    required this.customUnits,
    required this.onChanged,
    required this.onUnitCreated,
    required this.onAddPressed,
    required this.addLabel,
    super.key,
  });

  final List<OfferItem> items;
  final Currency currency;

  /// Kullanıcının daha önce eklediği birimler; satırların birim seçicisine geçer.
  final List<String> customUnits;

  final ValueChanged<List<OfferItem>> onChanged;
  final ValueChanged<String> onUnitCreated;
  final VoidCallback onAddPressed;
  final String addLabel;

  @override
  State<OfferItemsSection> createState() => _OfferItemsSectionState();
}

class _OfferItemsSectionState extends State<OfferItemsSection> {
  late List<UniqueKey> _keys = _freshKeys(widget.items.length);

  static List<UniqueKey> _freshKeys(int count) =>
      List.generate(count, (_) => UniqueKey());

  @override
  void didUpdateWidget(OfferItemsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Satır sayısı değiştiyse ya da satırlar toptan değiştiyse (şablon
    // uygulandı, teklif yeniden yüklendi) kimlikler artık geçerli değildir:
    // anahtarlar yenilenir, satırlar taze kurulur. Aksi halde eski satırın
    // metin kutuları yeni ürünün üstünde kalırdı.
    if (_isSameIdentity(oldWidget.items, widget.items)) return;
    _keys = _freshKeys(widget.items.length);
  }

  /// Aynı satırlar mı? Kullanıcının düzenlediği alanlar (miktar, fiyat, KDV…)
  /// kasıtlı olarak karşılaştırılmaz — onlar değiştiğinde satır *aynı satırdır*.
  static bool _isSameIdentity(List<OfferItem> a, List<OfferItem> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].productId != b[i].productId ||
          a[i].productName != b[i].productName) {
        return false;
      }
    }
    return true;
  }

  void _replaceAt(int index, OfferItem updated) {
    final items = [...widget.items];
    items[index] = updated;
    widget.onChanged(items);
  }

  /// Satır silinince liste kısalır ve [didUpdateWidget] anahtarları yeniler;
  /// satırlar güncel değerleriyle taze kurulur.
  void _removeAt(int index) {
    widget.onChanged([...widget.items]..removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < widget.items.length; index++)
          OfferItemRow(
            key: _keys[index],
            item: widget.items[index],
            currency: widget.currency,
            customUnits: widget.customUnits,
            onChanged: (updated) => _replaceAt(index, updated),
            onUnitCreated: widget.onUnitCreated,
            onRemove: () => _removeAt(index),
          ),
        OutlinedButton.icon(
          onPressed: widget.onAddPressed,
          icon: const Icon(Icons.add),
          label: Text(widget.addLabel),
        ),
      ],
    );
  }
}
