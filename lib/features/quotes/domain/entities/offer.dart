import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:meta/meta.dart';

/// Bir teklif ve satırları. Domain katmanı: saf Dart. Flutter ve Drift
/// import'u **yasak**.
///
/// **Aggregate root'tur** — [items] burada taşınır, ayrı bir repository yok.
/// `OfferRepository.save` teklifi ve tüm satırlarını **tek transaction'da**
/// yazar (CLAUDE.md: "yarım kaydedilmiş teklif kabul edilemez").
///
/// [customerName] ve [customerContactPerson], müşteri seçildiği andaki
/// **snapshot**'ıdır (Phase 3'teki müşteri silme kararıyla aynı gerekçe):
/// müşteri sonradan silinse veya bilgileri değişse bile bu teklif değişmez.
@immutable
final class Offer {
  Offer({
    this.id,
    this.customerId,
    required this.customerName,
    this.customerContactPerson,
    this.currency = Currency.turkishLira,
    this.generalDiscount = Percent.zero,
    this.notes,
    this.items = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Henüz kaydedilmemiş teklif için `null`.
  final int? id;

  /// Teklifin oluşturulma anı. Kaydedilmemiş bir teklif için `DateTime.now()`
  /// varsayılır; veritabanından okunduktan sonra asıl kayıt anını taşır ve
  /// bir daha değişmez (`copyWith` bu alanı hep mevcut değerle korur).
  final DateTime createdAt;

  /// Müşteri silinirse veritabanı seviyesinde `NULL` olur (`ON DELETE SET NULL`);
  /// yalnızca "bu müşteriye kaç teklif verdim" gibi ileri bir rapor için tutulur.
  final int? customerId;

  final String customerName;

  /// Yalnızca kurumsal müşteride anlamlıdır; müşteri seçildiği anda kopyalanır.
  final String? customerContactPerson;

  /// Yalnızca gösterim etiketi — çevrim yapılmaz (bkz. [Currency]).
  final Currency currency;

  /// Ara toplam + KDV üzerine uygulanan genel indirim. Satır bazlı
  /// [OfferItem.discount]'tan ayrıdır; teklifin tamamına, KDV'den **sonra** uygulanır.
  final Percent generalDiscount;

  final String? notes;

  final List<OfferItem> items;

  /// İskonto uygulanmış, KDV hariç toplam.
  Money get subtotal => items.map((item) => item.lineSubtotal).sum();

  /// Tüm satırların KDV toplamı.
  Money get vatTotal => items.map((item) => item.lineVat).sum();

  /// Genel indirimden önceki toplam (ara toplam + KDV).
  Money get totalBeforeGeneralDiscount => subtotal + vatTotal;

  /// Genel indirim uygulanmış son tutar. Bu, "toplamdan geriye hesaplama"
  /// değildir: satır değerlerine dokunmaz, yalnızca zaten satır bazında
  /// hesaplanmış toplamın üzerine ileri yönde bir indirim uygular.
  Money get grandTotal => totalBeforeGeneralDiscount.minusRate(generalDiscount);

  /// Otomatik teklif numarası. Ayrı bir sayaç/kolon gerektirmez: `id`
  /// veritabanında zaten benzersiz ve autoincrement'tır, `createdAt.year`
  /// ile birleştirilerek türetilir. Yalnızca kaydedilmiş (`id != null`)
  /// tekliflerde anlamlıdır.
  String get quoteNumber {
    final savedId = id;
    if (savedId == null) {
      throw StateError('quoteNumber, kaydedilmemiş bir teklif için okunamaz.');
    }
    return 'TKL-${createdAt.year}-${savedId.toString().padLeft(6, '0')}';
  }

  /// Kasıtlı olarak sınırlı: alanı temizlemek gereken tek yer
  /// [customerContactPerson] ve [notes]'tur (müşteri değişince veya not
  /// silinince `null` olabilmeli). Diğer alanlar hep birlikte değişir.
  static const Object _unchanged = Object();

  Offer copyWith({
    int? id,
    int? customerId,
    String? customerName,
    Object? customerContactPerson = _unchanged,
    Currency? currency,
    Percent? generalDiscount,
    Object? notes = _unchanged,
    List<OfferItem>? items,
  }) => Offer(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    customerName: customerName ?? this.customerName,
    customerContactPerson: _pick(
      customerContactPerson,
      this.customerContactPerson,
    ),
    currency: currency ?? this.currency,
    generalDiscount: generalDiscount ?? this.generalDiscount,
    notes: _pick(notes, this.notes),
    items: items ?? this.items,
    createdAt: createdAt,
  );

  static String? _pick(Object? incoming, String? current) =>
      identical(incoming, _unchanged) ? current : incoming as String?;

  @override
  bool operator ==(Object other) =>
      other is Offer &&
      other.id == id &&
      other.customerId == customerId &&
      other.customerName == customerName &&
      other.customerContactPerson == customerContactPerson &&
      other.currency == currency &&
      other.generalDiscount == generalDiscount &&
      other.notes == notes &&
      other.createdAt == createdAt &&
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
    customerId,
    customerName,
    customerContactPerson,
    currency,
    generalDiscount,
    notes,
    createdAt,
    Object.hashAll(items),
  );
}
