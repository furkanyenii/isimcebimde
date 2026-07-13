/// Müşterinin bireysel mi kurumsal mı olduğunu belirtir.
///
/// Form ve teklif PDF'i bu tipe göre şekil değiştirir: bireysel müşteride
/// yetkili kişi ve vergi dairesi alanları anlamsızdır, gösterilmez.
enum CustomerType {
  individual('individual'),
  company('company');

  const CustomerType(this.wireName);

  /// Veritabanında saklanan değer.
  ///
  /// Enum **index'i saklanmaz**: enum sabitlerinin sırasını değiştiren bir
  /// refactor, index saklansaydı mevcut tüm müşterileri sessizce yanlış tipe
  /// çevirirdi. Metin gösterim bu tuzağı tamamen ortadan kaldırır.
  final String wireName;

  /// Veritabanından okunan değeri enum'a çevirir.
  ///
  /// Bilinmeyen değer, veritabanındaki CHECK kısıtı sayesinde oluşamaz;
  /// yine de sessizce varsayılana düşmek yerine hata fırlatılır — bozuk veriyi
  /// gizlemek, onu göstermekten daha tehlikelidir.
  static CustomerType fromWireName(String value) {
    for (final type in values) {
      if (type.wireName == value) return type;
    }
    throw ArgumentError.value(value, 'value', 'Bilinmeyen müşteri tipi');
  }

  bool get isCompany => this == CustomerType.company;

  bool get isIndividual => this == CustomerType.individual;
}
