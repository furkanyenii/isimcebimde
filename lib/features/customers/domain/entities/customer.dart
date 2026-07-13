import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:meta/meta.dart';

/// Domain katmanı: saf Dart. Flutter ve Drift import'u **yasak**.
///
/// **Tek zorunlu alan [name]'dir.** Saha kullanıcısı müşterinin karşısındayken
/// vergi dairesini sormaya vakit bulamaz; teklif önce çıkar, detay sonra
/// doldurulur. Zorunlu tutulan her alan, "60 saniyede teklif" hedefinden çalar.
///
/// [contactPerson] ve [taxOffice] yalnızca kurumsal müşteride anlamlıdır;
/// bireysel müşteride form bu alanları göstermez.
///
/// Arşivleme (`isArchived`) **bilinçli olarak yoktur.** Teklif, müşteri
/// bilgilerini oluşturulma anında kopyalar (snapshot) — tıpkı teklif satırının
/// ürün fiyatını kopyalaması gibi. Bu yüzden müşteri serbestçe silinebilir;
/// geçmiş teklifler bozulmaz (CLAUDE.md: Database Rules).
@immutable
final class Customer {
  const Customer({
    required this.id,
    required this.type,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.taxOffice,
    this.taxNumber,
    this.notes,
  });

  /// Henüz kaydedilmemiş müşteri için `null`.
  final int? id;

  final CustomerType type;

  /// Bireyselde ad soyad, kurumsalda firma ünvanı.
  final String name;

  /// Yetkili kişi. Yalnızca kurumsal müşteride kullanılır.
  final String? contactPerson;

  final String? phone;
  final String? email;
  final String? address;

  /// Yalnızca kurumsal müşteride kullanılır.
  final String? taxOffice;

  /// Bireyselde TCKN (11 hane), kurumsalda vergi no (10 hane).
  final String? taxNumber;

  final String? notes;

  /// Alanı **temizlemek** ile *değiştirmemek* farklı şeylerdir.
  ///
  /// Düz `String? phone` parametresi kullanılsaydı `copyWith(phone: null)`
  /// çağrısı telefonu silmez, sessizce eskisini korurdu — kullanıcı bir alanı
  /// boşaltıp kaydettiğinde veri güncellenmemiş olurdu. [_unchanged] nöbetçisi
  /// "dokunma" ile "null yap"ı ayırır.
  static const Object _unchanged = Object();

  Customer copyWith({
    int? id,
    CustomerType? type,
    String? name,
    Object? contactPerson = _unchanged,
    Object? phone = _unchanged,
    Object? email = _unchanged,
    Object? address = _unchanged,
    Object? taxOffice = _unchanged,
    Object? taxNumber = _unchanged,
    Object? notes = _unchanged,
  }) {
    return Customer(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      contactPerson: _pick(contactPerson, this.contactPerson),
      phone: _pick(phone, this.phone),
      email: _pick(email, this.email),
      address: _pick(address, this.address),
      taxOffice: _pick(taxOffice, this.taxOffice),
      taxNumber: _pick(taxNumber, this.taxNumber),
      notes: _pick(notes, this.notes),
    );
  }

  static String? _pick(Object? incoming, String? current) =>
      identical(incoming, _unchanged) ? current : incoming as String?;

  @override
  bool operator ==(Object other) =>
      other is Customer &&
      other.id == id &&
      other.type == type &&
      other.name == name &&
      other.contactPerson == contactPerson &&
      other.phone == phone &&
      other.email == email &&
      other.address == address &&
      other.taxOffice == taxOffice &&
      other.taxNumber == taxNumber &&
      other.notes == notes;

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    contactPerson,
    phone,
    email,
    address,
    taxOffice,
    taxNumber,
    notes,
  );
}
