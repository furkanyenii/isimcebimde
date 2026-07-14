/// Teklifi hazırlayan kişinin bilgileri; PDF'in altına basılır.
///
/// [CompanyInfo]'dan ayrıdır: firma bir, teklifi hazırlayan satış temsilcisi
/// başkadır. **Her alan opsiyoneldir** — hiçbiri doldurulmazsa PDF'e alt bilgi
/// hiç eklenmez (CLAUDE.md: hız bir feature'dır, zorunlu alan eklemiyoruz).
class PreparerInfo {
  const PreparerInfo({
    this.firstName,
    this.lastName,
    this.title,
    this.email,
    this.phone,
  });

  final String? firstName;
  final String? lastName;

  /// Ünvan: "Satış Temsilcisi", "Bölge Müdürü"…
  final String? title;

  final String? email;
  final String? phone;

  /// PDF'e basılacak bir şey var mı? Hepsi boşsa alt bilgi çizilmez.
  bool get isEmpty =>
      firstName == null &&
      lastName == null &&
      title == null &&
      email == null &&
      phone == null;

  /// Ad ve soyad ayrı saklanır (ileride "Sayın {ad}" gibi kullanımlar için),
  /// gösterimde birleşir. Yalnızca biri doluysa o yazılır.
  String? get fullName {
    final parts = [?firstName, ?lastName];
    return parts.isEmpty ? null : parts.join(' ');
  }

  /// `null` geçilen alan **değişmez**; alanı temizlemek için boş string geçilir
  /// (repository sınırında `''` → `null` normalize edilir) — [CompanyInfo] ile
  /// aynı sözleşme.
  PreparerInfo copyWith({
    String? firstName,
    String? lastName,
    String? title,
    String? email,
    String? phone,
  }) => PreparerInfo(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    title: title ?? this.title,
    email: email ?? this.email,
    phone: phone ?? this.phone,
  );

  @override
  bool operator ==(Object other) =>
      other is PreparerInfo &&
      other.firstName == firstName &&
      other.lastName == lastName &&
      other.title == title &&
      other.email == email &&
      other.phone == phone;

  @override
  int get hashCode => Object.hash(firstName, lastName, title, email, phone);
}
