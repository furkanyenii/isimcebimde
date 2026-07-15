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
  String get dashboardStatQuotes => 'Teklif';

  @override
  String get dashboardStatCustomers => 'Müşteri';

  @override
  String get dashboardSectionModules => 'Yönet';

  @override
  String get moduleQuotesSubtitle => 'Oluştur, düzenle, paylaş';

  @override
  String get moduleProductsSubtitle => 'Fiyat listesi ve kategoriler';

  @override
  String get moduleCustomersSubtitle => 'Kayıtlı müşteriler';

  @override
  String get moduleSettingsSubtitle => 'Firma, tema, dil';

  @override
  String get quoteDraftLabel => 'Teklif-Taslak';

  @override
  String quoteItemCount(int count) {
    return '$count ürün';
  }

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
  String get settingsPreparer => 'Kişisel Bilgiler';

  @override
  String get settingsPreparerSubtitle => 'Teklifin altında görünür';

  @override
  String get firstNameLabel => 'Ad';

  @override
  String get lastNameLabel => 'Soyad';

  @override
  String get jobTitleLabel => 'Ünvan';

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
  String get customerFieldLabel => 'Müşteri';

  @override
  String get customerRequired => 'Müşteri seçmelisin';

  @override
  String get currencyLabel => 'Para birimi';

  @override
  String get currencyTurkishLira => 'Türk Lirası (₺)';

  @override
  String get currencyUsDollar => 'Amerikan Doları (\$)';

  @override
  String get currencyEuro => 'Euro (€)';

  @override
  String get currencyBritishPound => 'İngiliz Sterlini (£)';

  @override
  String get quantityLabel => 'Miktar';

  @override
  String get unitLabel => 'Birim';

  @override
  String get unitPiece => 'adet';

  @override
  String get unitSquareMeter => 'm²';

  @override
  String get unitCubicMeter => 'm³';

  @override
  String get unitPackage => 'paket';

  @override
  String get unitSet => 'set';

  @override
  String get unitBox => 'kutu';

  @override
  String get unitCustomAdd => 'Diğer…';

  @override
  String get unitCustomTitle => 'Yeni birim';

  @override
  String get unitCustomHint => 'örn. ton, saat, top';

  @override
  String get discountLabel => 'İskonto';

  @override
  String get generalDiscountLabel => 'Genel indirim';

  @override
  String get subtotalLabel => 'Ara toplam';

  @override
  String get vatTotalLabel => 'KDV';

  @override
  String get grandTotalLabel => 'Genel toplam';

  @override
  String get offerEdit => 'Teklifi Düzenle';

  @override
  String get quotesEmptyTitle => 'Henüz teklif yok';

  @override
  String get quotesEmptyDescription => 'İlk teklifini oluştur.';

  @override
  String get quotesLoadError => 'Teklifler yüklenemedi.';

  @override
  String get pdfGenerateTooltip => 'PDF Oluştur';

  @override
  String get pdfPreviewTitle => 'Teklif PDF\'i';

  @override
  String get quoteNumberLabel => 'Teklif No';

  @override
  String get quoteDateLabel => 'Tarih';

  @override
  String get lineTotalLabel => 'Tutar';

  @override
  String shareEmailBody(Object customerName) {
    return 'Sayın $customerName, teklifiniz ekte yer almaktadır.';
  }

  @override
  String get templateNew => 'Yeni Şablon';

  @override
  String get templateEdit => 'Şablonu Düzenle';

  @override
  String get templateDelete => 'Şablonu sil';

  @override
  String get templateAdd => 'Şablon ekle';

  @override
  String get templatesTitle => 'Şablonlar';

  @override
  String get templatesLoadError => 'Şablonlar yüklenemedi.';

  @override
  String get templatesEmptyTitle => 'Henüz şablon yok';

  @override
  String get templatesEmptyDescription => 'İlk şablonunu oluştur.';

  @override
  String get templateNameLabel => 'Şablon adı';

  @override
  String get templateSearchHint => 'Şablon ara';

  @override
  String get templateUseTooltip => 'Şablondan oluştur';

  @override
  String get templateSaveAsTooltip => 'Şablon olarak kaydet';

  @override
  String get errorOffersLoad => 'Teklifler okunamadı.';

  @override
  String get errorOfferSave => 'Teklif kaydedilemedi.';

  @override
  String get errorOfferUpdate => 'Teklif güncellenemedi.';

  @override
  String get errorOfferDelete => 'Teklif silinemedi.';

  @override
  String get errorOfferNotSaved => 'Kaydedilmemiş teklif güncellenemez.';

  @override
  String get errorOfferCustomerRequired =>
      'Teklif oluşturmak için müşteri seçmelisin.';

  @override
  String get errorOfferEmpty => 'Teklif en az bir ürün içermelidir.';

  @override
  String get errorTemplatesLoad => 'Şablonlar okunamadı.';

  @override
  String get errorTemplateSave => 'Şablon kaydedilemedi.';

  @override
  String get errorTemplateUpdate => 'Şablon güncellenemedi.';

  @override
  String get errorTemplateDelete => 'Şablon silinemedi.';

  @override
  String get errorTemplateNotSaved => 'Kaydedilmemiş şablon güncellenemez.';

  @override
  String get errorTemplateNameEmpty => 'Şablon adı boş olamaz.';

  @override
  String errorTemplateDuplicate(String name) {
    return '\"$name\" adında bir şablon zaten var.';
  }

  @override
  String get errorTemplateEmpty => 'Şablon en az bir ürün içermelidir.';

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
  String productCreateFromSearch(String query) {
    return '\"$query\" adıyla yeni ürün ekle';
  }

  @override
  String get vatRateLabel => 'KDV oranı';

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
  String get errorUnitNameEmpty => 'Birim adı boş olamaz.';

  @override
  String get errorUnitSave => 'Birim kaydedilemedi.';

  @override
  String get errorExport => 'Dosya oluşturulamadı.';
}
