// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionAdd => 'Add';

  @override
  String get actionRetry => 'Try again';

  @override
  String get optionalField => 'Optional';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String comingSoonSemantics(String label) {
    return '$label, coming soon';
  }

  @override
  String deleteConfirmMessage(String name) {
    return '\"$name\" will be deleted permanently. This cannot be undone.';
  }

  @override
  String get emptySearchTitle => 'No results';

  @override
  String get emptySearchDescription => 'Try a different search.';

  @override
  String get appTagline => 'Quotes in minutes';

  @override
  String get splashInitError =>
      'The app could not start. The database cannot be opened.';

  @override
  String get moduleQuotes => 'Quotes';

  @override
  String get moduleProducts => 'Products';

  @override
  String get moduleCustomers => 'Customers';

  @override
  String get moduleSettings => 'Settings';

  @override
  String get quoteNew => 'New Quote';

  @override
  String get settingsCompany => 'Company Details';

  @override
  String get settingsCompanySubtitle => 'Shown on your quotes';

  @override
  String get companyNameFieldLabel => 'Company name';

  @override
  String get companyLogo => 'Logo';

  @override
  String get companyLogoAdd => 'Choose logo';

  @override
  String get companyLogoRemove => 'Remove logo';

  @override
  String get websiteLabel => 'Website';

  @override
  String get taxNumberFieldLabel => 'Tax number';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsSystemDefault => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get languageTurkish => 'Turkish';

  @override
  String get languageEnglish => 'English';

  @override
  String get customerFieldLabel => 'Customer';

  @override
  String get customerRequired => 'Pick a customer';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get currencyTurkishLira => 'Turkish Lira (₺)';

  @override
  String get currencyUsDollar => 'US Dollar (\$)';

  @override
  String get currencyEuro => 'Euro (€)';

  @override
  String get currencyBritishPound => 'British Pound (£)';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get discountLabel => 'Discount';

  @override
  String get generalDiscountLabel => 'Overall discount';

  @override
  String get subtotalLabel => 'Subtotal';

  @override
  String get vatTotalLabel => 'VAT';

  @override
  String get grandTotalLabel => 'Grand total';

  @override
  String get offerEdit => 'Edit Quote';

  @override
  String get quotesEmptyTitle => 'No quotes yet';

  @override
  String get quotesEmptyDescription => 'Create your first quote.';

  @override
  String get quotesLoadError => 'Quotes could not be loaded.';

  @override
  String get errorOffersLoad => 'Quotes could not be loaded.';

  @override
  String get errorOfferSave => 'The quote could not be saved.';

  @override
  String get errorOfferUpdate => 'The quote could not be updated.';

  @override
  String get errorOfferDelete => 'The quote could not be deleted.';

  @override
  String get errorOfferNotSaved => 'An unsaved quote cannot be updated.';

  @override
  String get errorOfferCustomerRequired => 'Pick a customer to create a quote.';

  @override
  String get errorOfferEmpty => 'A quote must contain at least one product.';

  @override
  String get errorTemplatesLoad => 'Templates could not be loaded.';

  @override
  String get errorTemplateSave => 'The template could not be saved.';

  @override
  String get errorTemplateUpdate => 'The template could not be updated.';

  @override
  String get errorTemplateDelete => 'The template could not be deleted.';

  @override
  String get errorTemplateNotSaved => 'An unsaved template cannot be updated.';

  @override
  String get errorTemplateNameEmpty => 'Template name cannot be empty.';

  @override
  String errorTemplateDuplicate(String name) {
    return 'A template named \"$name\" already exists.';
  }

  @override
  String get errorTemplateEmpty =>
      'A template must contain at least one product.';

  @override
  String get productNew => 'New Product';

  @override
  String get productEdit => 'Edit Product';

  @override
  String get productDelete => 'Delete product';

  @override
  String get productAdd => 'Add product';

  @override
  String get productSearchHint => 'Search products';

  @override
  String get productNameLabel => 'Product name';

  @override
  String get productsLoadError => 'Products could not be loaded.';

  @override
  String get productsEmptyTitle => 'No products yet';

  @override
  String get productsEmptyDescription =>
      'Add your products first so you can prepare quotes.';

  @override
  String get vatRateLabel => 'VAT rate';

  @override
  String vatRateShort(String rate) {
    return 'VAT $rate%';
  }

  @override
  String percentValue(String rate) {
    return '$rate%';
  }

  @override
  String get priceLabel => 'Price';

  @override
  String get priceMustBePositive => 'Price must be greater than zero';

  @override
  String get categoryLabel => 'Category';

  @override
  String get categoryRequired => 'Pick a category';

  @override
  String get categoryNew => 'New category';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get categoriesLoadError => 'Categories could not be loaded.';

  @override
  String get customerNew => 'New Customer';

  @override
  String get customerEdit => 'Edit Customer';

  @override
  String get customerDelete => 'Delete customer';

  @override
  String get customerAdd => 'Add customer';

  @override
  String get customerSearchHint => 'Search name, contact or phone';

  @override
  String get customersLoadError => 'Customers could not be loaded.';

  @override
  String get customersEmptyTitle => 'No customers yet';

  @override
  String get customersEmptyDescription =>
      'Add your customers first so you can send quotes.';

  @override
  String get customerTypeIndividual => 'Individual';

  @override
  String get customerTypeCompany => 'Company';

  @override
  String get companyNameLabel => 'Company name';

  @override
  String get companyNameRequired => 'Company name cannot be empty';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameRequired => 'Full name cannot be empty';

  @override
  String get contactPersonLabel => 'Contact person';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get emailLabel => 'Email';

  @override
  String get addressLabel => 'Address';

  @override
  String get taxOfficeLabel => 'Tax office';

  @override
  String get taxNumberLabel => 'Tax number';

  @override
  String get nationalIdLabel => 'National ID';

  @override
  String get notesLabel => 'Notes';

  @override
  String get errorGeneric => 'The operation could not be completed.';

  @override
  String get errorProductsLoad => 'Products could not be loaded.';

  @override
  String get errorProductSave => 'The product could not be saved.';

  @override
  String get errorProductUpdate => 'The product could not be updated.';

  @override
  String get errorProductDelete => 'The product could not be deleted.';

  @override
  String get errorProductNameEmpty => 'Product name cannot be empty.';

  @override
  String get errorProductNotSaved => 'An unsaved product cannot be updated.';

  @override
  String get errorPriceNegative => 'Price cannot be negative.';

  @override
  String get errorCategoriesLoad => 'Categories could not be loaded.';

  @override
  String get errorCategorySave => 'The category could not be saved.';

  @override
  String get errorCategoryUpdate => 'The category could not be updated.';

  @override
  String get errorCategoryDelete => 'The category could not be deleted.';

  @override
  String get errorCategoryNameEmpty => 'Category name cannot be empty.';

  @override
  String get errorCategoryNotSaved => 'An unsaved category cannot be updated.';

  @override
  String errorCategoryDuplicate(String name) {
    return 'A category named \"$name\" already exists.';
  }

  @override
  String get errorCategoryInUse =>
      'This category has products in it. Move the products to another category first.';

  @override
  String get errorCustomersLoad => 'Customers could not be loaded.';

  @override
  String get errorCustomerSave => 'The customer could not be saved.';

  @override
  String get errorCustomerUpdate => 'The customer could not be updated.';

  @override
  String get errorCustomerDelete => 'The customer could not be deleted.';

  @override
  String get errorCustomerNameEmpty => 'Customer name cannot be empty.';

  @override
  String get errorCustomerNotSaved => 'An unsaved customer cannot be updated.';

  @override
  String get errorEmailInvalid => 'The email address is not valid.';

  @override
  String get errorSettingsLoad => 'Settings could not be loaded.';

  @override
  String get errorSettingsSave => 'Settings could not be saved.';

  @override
  String get errorNationalIdLength => 'National ID must be 11 digits.';

  @override
  String get errorTaxNumberLength => 'Tax number must be 10 digits.';

  @override
  String get errorExport => 'The file could not be created.';
}
