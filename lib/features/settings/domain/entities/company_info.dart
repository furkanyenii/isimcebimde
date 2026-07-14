/// Teklif çıktısının başlığında görünen firma bilgileri.
///
/// **Her alan opsiyoneldir.** Sahada vergi dairesini doldurmaya vakit yoktur;
/// eksik bilgiyle de teklif çıkar, detay sonra tamamlanır (Phase 3'teki müşteri
/// kararıyla aynı gerekçe).
class CompanyInfo {
  const CompanyInfo({
    this.name,
    this.logoPath,
    this.phone,
    this.email,
    this.website,
    this.address,
    this.taxOffice,
    this.taxNumber,
  });

  final String? name;

  /// Uygulamanın belge klasöründeki logo dosyasının yolu — görselin kendisi
  /// veritabanında tutulmaz.
  final String? logoPath;

  final String? phone;
  final String? email;
  final String? website;
  final String? address;
  final String? taxOffice;
  final String? taxNumber;

  bool get hasLogo => logoPath != null;

  /// `null` geçilen alan **değişmez**; alanı temizlemek için boş string geçilir
  /// (repository sınırında `''` → `null` normalize edilir). `copyWith` ile
  /// "temizle" ile "dokunma" ayrımı aksi halde yapılamazdı.
  CompanyInfo copyWith({
    String? name,
    String? logoPath,
    String? phone,
    String? email,
    String? website,
    String? address,
    String? taxOffice,
    String? taxNumber,
  }) => CompanyInfo(
    name: name ?? this.name,
    logoPath: logoPath ?? this.logoPath,
    phone: phone ?? this.phone,
    email: email ?? this.email,
    website: website ?? this.website,
    address: address ?? this.address,
    taxOffice: taxOffice ?? this.taxOffice,
    taxNumber: taxNumber ?? this.taxNumber,
  );

  /// Logoyu kaldırır. `copyWith(logoPath: null)` "dokunma" demek olduğu için
  /// ayrı bir metod gerekir.
  CompanyInfo withoutLogo() => CompanyInfo(
    name: name,
    phone: phone,
    email: email,
    website: website,
    address: address,
    taxOffice: taxOffice,
    taxNumber: taxNumber,
  );

  @override
  bool operator ==(Object other) =>
      other is CompanyInfo &&
      other.name == name &&
      other.logoPath == logoPath &&
      other.phone == phone &&
      other.email == email &&
      other.website == website &&
      other.address == address &&
      other.taxOffice == taxOffice &&
      other.taxNumber == taxNumber;

  @override
  int get hashCode => Object.hash(
    name,
    logoPath,
    phone,
    email,
    website,
    address,
    taxOffice,
    taxNumber,
  );
}
