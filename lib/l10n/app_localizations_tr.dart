// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get actionSave => 'Kaydet';

  @override
  String get actionCancel => 'Vazgeç';

  @override
  String get actionDelete => 'Sil';

  @override
  String get actionAdd => 'Ekle';

  @override
  String get actionRetry => 'Tekrar dene';

  @override
  String get optionalField => 'İsteğe bağlı';

  @override
  String get comingSoon => 'Yakında';

  @override
  String comingSoonSemantics(String label) {
    return '$label, yakında';
  }

  @override
  String deleteConfirmMessage(String name) {
    return '\"$name\" kalıcı olarak silinecek. Bu işlem geri alınamaz.';
  }

  @override
  String get emptySearchTitle => 'Sonuç yok';

  @override
  String get emptySearchDescription => 'Farklı bir arama dene.';

  @override
  String get appTagline => 'Dakikalar içinde teklif';

  @override
  String get splashInitError =>
      'Uygulama başlatılamadı. Veritabanı açılamıyor.';

  @override
  String get moduleQuotes => 'Teklifler';

  @override
  String get moduleProducts => 'Ürünler';

  @override
  String get moduleCustomers => 'Müşteriler';

  @override
  String get moduleSettings => 'Ayarlar';

  @override
  String get quoteNew => 'Yeni Teklif';

  @override
  String get settingsCompany => 'Firma Bilgileri';

  @override
  String get settingsCompanySubtitle => 'Teklif çıktısında görünür';

  @override
  String get companyNameFieldLabel => 'Firma adı';

  @override
  String get companyLogo => 'Logo';

  @override
  String get companyLogoAdd => 'Logo seç';

  @override
  String get companyLogoRemove => 'Logoyu kaldır';

  @override
  String get websiteLabel => 'Web sitesi';

  @override
  String get taxNumberFieldLabel => 'Vergi no';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsSystemDefault => 'Sistem';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'İngilizce';

  @override
  String get productNew => 'Yeni Ürün';

  @override
  String get productEdit => 'Ürünü Düzenle';

  @override
  String get productDelete => 'Ürünü sil';

  @override
  String get productAdd => 'Ürün ekle';

  @override
  String get productSearchHint => 'Ürün ara';

  @override
  String get productNameLabel => 'Ürün adı';

  @override
  String get productsLoadError => 'Ürünler yüklenemedi.';

  @override
  String get productsEmptyTitle => 'Henüz ürün yok';

  @override
  String get productsEmptyDescription =>
      'Teklif hazırlayabilmek için önce ürünlerini ekle.';

  @override
  String get vatRateLabel => 'KDV oranı';

  @override
  String vatRateShort(String rate) {
    return 'KDV %$rate';
  }

  @override
  String percentValue(String rate) {
    return '%$rate';
  }

  @override
  String get priceLabel => 'Fiyat';

  @override
  String get priceMustBePositive => 'Fiyat sıfırdan büyük olmalı';

  @override
  String get categoryLabel => 'Kategori';

  @override
  String get categoryRequired => 'Kategori seçmelisin';

  @override
  String get categoryNew => 'Yeni kategori';

  @override
  String get categoryNameLabel => 'Kategori adı';

  @override
  String get categoriesLoadError => 'Kategoriler yüklenemedi.';

  @override
  String get customerNew => 'Yeni Müşteri';

  @override
  String get customerEdit => 'Müşteriyi Düzenle';

  @override
  String get customerDelete => 'Müşteriyi sil';

  @override
  String get customerAdd => 'Müşteri ekle';

  @override
  String get customerSearchHint => 'Ad, yetkili veya telefon ara';

  @override
  String get customersLoadError => 'Müşteriler yüklenemedi.';

  @override
  String get customersEmptyTitle => 'Henüz müşteri yok';

  @override
  String get customersEmptyDescription =>
      'Teklif gönderebilmek için önce müşterini ekle.';

  @override
  String get customerTypeIndividual => 'Bireysel';

  @override
  String get customerTypeCompany => 'Kurumsal';

  @override
  String get companyNameLabel => 'Firma ünvanı';

  @override
  String get companyNameRequired => 'Firma ünvanı boş olamaz';

  @override
  String get fullNameLabel => 'Ad soyad';

  @override
  String get fullNameRequired => 'Ad soyad boş olamaz';

  @override
  String get contactPersonLabel => 'Yetkili kişi';

  @override
  String get phoneLabel => 'Telefon';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get addressLabel => 'Adres';

  @override
  String get taxOfficeLabel => 'Vergi dairesi';

  @override
  String get taxNumberLabel => 'Vergi no';

  @override
  String get nationalIdLabel => 'TC Kimlik No';

  @override
  String get notesLabel => 'Not';

  @override
  String get errorGeneric => 'İşlem tamamlanamadı.';

  @override
  String get errorProductsLoad => 'Ürünler okunamadı.';

  @override
  String get errorProductSave => 'Ürün kaydedilemedi.';

  @override
  String get errorProductUpdate => 'Ürün güncellenemedi.';

  @override
  String get errorProductDelete => 'Ürün silinemedi.';

  @override
  String get errorProductNameEmpty => 'Ürün adı boş olamaz.';

  @override
  String get errorProductNotSaved => 'Kaydedilmemiş ürün güncellenemez.';

  @override
  String get errorPriceNegative => 'Fiyat negatif olamaz.';

  @override
  String get errorCategoriesLoad => 'Kategoriler okunamadı.';

  @override
  String get errorCategorySave => 'Kategori kaydedilemedi.';

  @override
  String get errorCategoryUpdate => 'Kategori güncellenemedi.';

  @override
  String get errorCategoryDelete => 'Kategori silinemedi.';

  @override
  String get errorCategoryNameEmpty => 'Kategori adı boş olamaz.';

  @override
  String get errorCategoryNotSaved => 'Kaydedilmemiş kategori güncellenemez.';

  @override
  String errorCategoryDuplicate(String name) {
    return '\"$name\" adında bir kategori zaten var.';
  }

  @override
  String get errorCategoryInUse =>
      'Bu kategoride ürün var. Önce ürünleri başka kategoriye taşı.';

  @override
  String get errorCustomersLoad => 'Müşteriler okunamadı.';

  @override
  String get errorCustomerSave => 'Müşteri kaydedilemedi.';

  @override
  String get errorCustomerUpdate => 'Müşteri güncellenemedi.';

  @override
  String get errorCustomerDelete => 'Müşteri silinemedi.';

  @override
  String get errorCustomerNameEmpty => 'Müşteri adı boş olamaz.';

  @override
  String get errorCustomerNotSaved => 'Kaydedilmemiş müşteri güncellenemez.';

  @override
  String get errorEmailInvalid => 'E-posta adresi geçersiz.';

  @override
  String get errorSettingsLoad => 'Ayarlar okunamadı.';

  @override
  String get errorSettingsSave => 'Ayarlar kaydedilemedi.';

  @override
  String get errorNationalIdLength => 'TC Kimlik No 11 haneli olmalı.';

  @override
  String get errorTaxNumberLength => 'Vergi No 10 haneli olmalı.';

  @override
  String get errorExport => 'Dosya oluşturulamadı.';
}
