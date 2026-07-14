import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:meta/meta.dart';

/// Yeniden kullanılabilir bir teklif taslağı. Domain katmanı: saf Dart.
/// Flutter ve Drift import'u **yasak**.
///
/// [items] için ayrı bir `TemplateItem` tipi **yoktur** — [OfferItem] aynen
/// kullanılır. Şablon satırı ile teklif satırı aynı şekle sahiptir (ürün adı/
/// fiyat snapshot'ı, miktar, KDV, iskonto); ayrım yalnızca hangi tabloda
/// saklandıklarıdır (`TemplateItems` vs `OfferItems`), bu bir persistence
/// detayıdır, domain modelini ikiye bölmeyi gerektirmez. Bu bilinçli bir
/// tekrar-etmeme kararıdır — yeni bir "TemplateItem" icat etme.
@immutable
final class Template {
  const Template({
    this.id,
    required this.name,
    this.currency = Currency.turkishLira,
    this.generalDiscount = Percent.zero,
    this.notes,
    this.items = const [],
  });

  /// Henüz kaydedilmemiş şablon için `null`.
  final int? id;

  /// Şablonun listede göründüğü ad. Veritabanı seviyesinde benzersizdir
  /// (`Categories.name` ile aynı gerekçe: aynı isimde birden çok şablon
  /// kullanıcıyı karıştırır).
  final String name;

  /// Yalnızca gösterim etiketi — çevrim yapılmaz (bkz. [Currency]).
  final Currency currency;

  final Percent generalDiscount;

  final String? notes;

  final List<OfferItem> items;

  /// "Şablondan teklif oluştur" dönüşümü. Şablonda müşteri hiç yoktur;
  /// dönen taslak boş müşteriyle başlar, kullanıcı normal akışta seçer.
  Offer toDraftOffer() => Offer(
    customerName: '',
    currency: currency,
    generalDiscount: generalDiscount,
    notes: notes,
    items: [
      for (final item in items)
        // copyWith DEĞİL: OfferItem.copyWith `id`'yi temizleyemez (`id ?? this.id`
        // deseni), burada gerçekten yeni/kaydedilmemiş satırlar istiyoruz.
        OfferItem(
          productId: item.productId,
          productName: item.productName,
          unitPrice: item.unitPrice,
          quantity: item.quantity,
          vatRate: item.vatRate,
          discount: item.discount,
        ),
    ],
  );

  /// Kasıtlı olarak sınırlı: yalnızca [notes] açıkça `null`'a çekilebilmeli
  /// (not silinince). Diğer alanlar hep birlikte değişir.
  static const Object _unchanged = Object();

  Template copyWith({
    int? id,
    String? name,
    Currency? currency,
    Percent? generalDiscount,
    Object? notes = _unchanged,
    List<OfferItem>? items,
  }) => Template(
    id: id ?? this.id,
    name: name ?? this.name,
    currency: currency ?? this.currency,
    generalDiscount: generalDiscount ?? this.generalDiscount,
    notes: _pick(notes, this.notes),
    items: items ?? this.items,
  );

  static String? _pick(Object? incoming, String? current) =>
      identical(incoming, _unchanged) ? current : incoming as String?;

  @override
  bool operator ==(Object other) =>
      other is Template &&
      other.id == id &&
      other.name == name &&
      other.currency == currency &&
      other.generalDiscount == generalDiscount &&
      other.notes == notes &&
      _listEquals(other.items, items);

  static bool _listEquals(List<OfferItem> a, List<OfferItem> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    currency,
    generalDiscount,
    notes,
    Object.hashAll(items),
  );
}
