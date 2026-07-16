import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @optionalField.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalField;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Semantics label of a module card that is not available yet.
  ///
  /// In en, this message translates to:
  /// **'{label}, coming soon'**
  String comingSoonSemantics(String label);

  /// Confirmation body shown before a permanent delete.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be deleted permanently. This cannot be undone.'**
  String deleteConfirmMessage(String name);

  /// No description provided for @emptySearchTitle.
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get emptySearchTitle;

  /// No description provided for @emptySearchDescription.
  ///
  /// In en, this message translates to:
  /// **'Try a different search.'**
  String get emptySearchDescription;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Create quotes in minutes'**
  String get appTagline;

  /// No description provided for @splashInitError.
  ///
  /// In en, this message translates to:
  /// **'The app could not start. The database cannot be opened.'**
  String get splashInitError;

  /// No description provided for @moduleQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotes'**
  String get moduleQuotes;

  /// No description provided for @moduleTemplates.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get moduleTemplates;

  /// No description provided for @moduleProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get moduleProducts;

  /// No description provided for @moduleCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get moduleCustomers;

  /// No description provided for @moduleSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get moduleSettings;

  /// No description provided for @quoteNew.
  ///
  /// In en, this message translates to:
  /// **'New Quote'**
  String get quoteNew;

  /// No description provided for @dashboardStatQuotes.
  ///
  /// In en, this message translates to:
  /// **'Quotes'**
  String get dashboardStatQuotes;

  /// No description provided for @dashboardStatProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get dashboardStatProducts;

  /// No description provided for @dashboardStatCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get dashboardStatCustomers;

  /// No description provided for @dashboardSectionModules.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get dashboardSectionModules;

  /// No description provided for @moduleQuotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create, edit, share'**
  String get moduleQuotesSubtitle;

  /// No description provided for @moduleTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ready-made quote drafts'**
  String get moduleTemplatesSubtitle;

  /// No description provided for @moduleProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Price list and categories'**
  String get moduleProductsSubtitle;

  /// No description provided for @moduleCustomersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saved customers'**
  String get moduleCustomersSubtitle;

  /// No description provided for @moduleSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Company, theme, language'**
  String get moduleSettingsSubtitle;

  /// No description provided for @offerStartBlank.
  ///
  /// In en, this message translates to:
  /// **'Blank quote'**
  String get offerStartBlank;

  /// No description provided for @offerStartBlankSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start from scratch'**
  String get offerStartBlankSubtitle;

  /// No description provided for @offerStartFromTemplate.
  ///
  /// In en, this message translates to:
  /// **'Start from a template'**
  String get offerStartFromTemplate;

  /// No description provided for @quoteDraftLabel.
  ///
  /// In en, this message translates to:
  /// **'Quote-Draft'**
  String get quoteDraftLabel;

  /// No description provided for @quoteItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String quoteItemCount(int count);

  /// No description provided for @settingsCompany.
  ///
  /// In en, this message translates to:
  /// **'Company Details'**
  String get settingsCompany;

  /// No description provided for @settingsCompanySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown on your quotes'**
  String get settingsCompanySubtitle;

  /// No description provided for @companyNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get companyNameFieldLabel;

  /// No description provided for @companyLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get companyLogo;

  /// No description provided for @companyLogoAdd.
  ///
  /// In en, this message translates to:
  /// **'Choose logo'**
  String get companyLogoAdd;

  /// No description provided for @companyLogoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove logo'**
  String get companyLogoRemove;

  /// No description provided for @websiteLabel.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get websiteLabel;

  /// No description provided for @taxNumberFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax number'**
  String get taxNumberFieldLabel;

  /// No description provided for @settingsPreparer.
  ///
  /// In en, this message translates to:
  /// **'Your Details'**
  String get settingsPreparer;

  /// No description provided for @settingsPreparerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shown at the bottom of your quotes'**
  String get settingsPreparerSubtitle;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @jobTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Job title'**
  String get jobTitleLabel;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Follow the device setting, for both language and theme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystemDefault;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @languageTurkish.
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @customerFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerFieldLabel;

  /// No description provided for @customerRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a customer'**
  String get customerRequired;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @currencyTurkishLira.
  ///
  /// In en, this message translates to:
  /// **'Turkish Lira (₺)'**
  String get currencyTurkishLira;

  /// No description provided for @currencyUsDollar.
  ///
  /// In en, this message translates to:
  /// **'US Dollar (\$)'**
  String get currencyUsDollar;

  /// No description provided for @currencyEuro.
  ///
  /// In en, this message translates to:
  /// **'Euro (€)'**
  String get currencyEuro;

  /// No description provided for @currencyBritishPound.
  ///
  /// In en, this message translates to:
  /// **'British Pound (£)'**
  String get currencyBritishPound;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'pcs'**
  String get unitPiece;

  /// No description provided for @unitSquareMeter.
  ///
  /// In en, this message translates to:
  /// **'m²'**
  String get unitSquareMeter;

  /// No description provided for @unitCubicMeter.
  ///
  /// In en, this message translates to:
  /// **'m³'**
  String get unitCubicMeter;

  /// No description provided for @unitPackage.
  ///
  /// In en, this message translates to:
  /// **'pack'**
  String get unitPackage;

  /// No description provided for @unitSet.
  ///
  /// In en, this message translates to:
  /// **'set'**
  String get unitSet;

  /// No description provided for @unitBox.
  ///
  /// In en, this message translates to:
  /// **'box'**
  String get unitBox;

  /// No description provided for @unitCustomAdd.
  ///
  /// In en, this message translates to:
  /// **'Other…'**
  String get unitCustomAdd;

  /// No description provided for @unitCustomTitle.
  ///
  /// In en, this message translates to:
  /// **'New unit'**
  String get unitCustomTitle;

  /// No description provided for @unitCustomHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. ton, hour, roll'**
  String get unitCustomHint;

  /// No description provided for @discountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountLabel;

  /// No description provided for @generalDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Overall discount'**
  String get generalDiscountLabel;

  /// No description provided for @subtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotalLabel;

  /// No description provided for @vatTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vatTotalLabel;

  /// No description provided for @grandTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Grand total'**
  String get grandTotalLabel;

  /// No description provided for @offerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Quote'**
  String get offerEdit;

  /// No description provided for @quotesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No quotes yet'**
  String get quotesEmptyTitle;

  /// No description provided for @quotesEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your first quote.'**
  String get quotesEmptyDescription;

  /// No description provided for @quotesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Quotes could not be loaded.'**
  String get quotesLoadError;

  /// No description provided for @pdfAction.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdfAction;

  /// No description provided for @pdfPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Quote PDF'**
  String get pdfPreviewTitle;

  /// No description provided for @quoteNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Quote No'**
  String get quoteNumberLabel;

  /// No description provided for @quoteDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get quoteDateLabel;

  /// No description provided for @lineTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get lineTotalLabel;

  /// No description provided for @shareEmailBody.
  ///
  /// In en, this message translates to:
  /// **'Dear {customerName}, please find your quote attached.'**
  String shareEmailBody(Object customerName);

  /// No description provided for @templateNew.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get templateNew;

  /// No description provided for @templateEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get templateEdit;

  /// No description provided for @templateDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get templateDelete;

  /// No description provided for @templateAdd.
  ///
  /// In en, this message translates to:
  /// **'Add template'**
  String get templateAdd;

  /// No description provided for @templatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get templatesTitle;

  /// No description provided for @templatesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Templates could not be loaded.'**
  String get templatesLoadError;

  /// No description provided for @templatesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No templates yet'**
  String get templatesEmptyTitle;

  /// No description provided for @templatesEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create your first template.'**
  String get templatesEmptyDescription;

  /// No description provided for @templateNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get templateNameLabel;

  /// No description provided for @templateSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search templates'**
  String get templateSearchHint;

  /// No description provided for @templateUseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Start from a template'**
  String get templateUseTooltip;

  /// No description provided for @templateSaveAsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Save as template'**
  String get templateSaveAsTooltip;

  /// No description provided for @errorOffersLoad.
  ///
  /// In en, this message translates to:
  /// **'Quotes could not be loaded.'**
  String get errorOffersLoad;

  /// No description provided for @errorOfferSave.
  ///
  /// In en, this message translates to:
  /// **'The quote could not be saved.'**
  String get errorOfferSave;

  /// No description provided for @errorOfferUpdate.
  ///
  /// In en, this message translates to:
  /// **'The quote could not be updated.'**
  String get errorOfferUpdate;

  /// No description provided for @errorOfferDelete.
  ///
  /// In en, this message translates to:
  /// **'The quote could not be deleted.'**
  String get errorOfferDelete;

  /// No description provided for @errorOfferNotSaved.
  ///
  /// In en, this message translates to:
  /// **'An unsaved quote cannot be updated.'**
  String get errorOfferNotSaved;

  /// No description provided for @errorOfferCustomerRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a customer to create a quote.'**
  String get errorOfferCustomerRequired;

  /// No description provided for @errorOfferEmpty.
  ///
  /// In en, this message translates to:
  /// **'A quote must contain at least one product.'**
  String get errorOfferEmpty;

  /// No description provided for @errorTemplatesLoad.
  ///
  /// In en, this message translates to:
  /// **'Templates could not be loaded.'**
  String get errorTemplatesLoad;

  /// No description provided for @errorTemplateSave.
  ///
  /// In en, this message translates to:
  /// **'The template could not be saved.'**
  String get errorTemplateSave;

  /// No description provided for @errorTemplateUpdate.
  ///
  /// In en, this message translates to:
  /// **'The template could not be updated.'**
  String get errorTemplateUpdate;

  /// No description provided for @errorTemplateDelete.
  ///
  /// In en, this message translates to:
  /// **'The template could not be deleted.'**
  String get errorTemplateDelete;

  /// No description provided for @errorTemplateNotSaved.
  ///
  /// In en, this message translates to:
  /// **'An unsaved template cannot be updated.'**
  String get errorTemplateNotSaved;

  /// No description provided for @errorTemplateNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Template name cannot be empty.'**
  String get errorTemplateNameEmpty;

  /// Template names are unique.
  ///
  /// In en, this message translates to:
  /// **'A template named \"{name}\" already exists.'**
  String errorTemplateDuplicate(String name);

  /// No description provided for @errorTemplateEmpty.
  ///
  /// In en, this message translates to:
  /// **'A template must contain at least one product.'**
  String get errorTemplateEmpty;

  /// No description provided for @productNew.
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get productNew;

  /// No description provided for @productEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get productEdit;

  /// No description provided for @productDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete product'**
  String get productDelete;

  /// No description provided for @productAdd.
  ///
  /// In en, this message translates to:
  /// **'Add product'**
  String get productAdd;

  /// No description provided for @productSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get productSearchHint;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productNameLabel;

  /// No description provided for @productsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Products could not be loaded.'**
  String get productsLoadError;

  /// No description provided for @productsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get productsEmptyTitle;

  /// No description provided for @productsEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your products first so you can prepare quotes.'**
  String get productsEmptyDescription;

  /// Shown in the product picker when the search matches nothing; creates the product on the spot.
  ///
  /// In en, this message translates to:
  /// **'Add \"{query}\" as a new product'**
  String productCreateFromSearch(String query);

  /// No description provided for @vatRateLabel.
  ///
  /// In en, this message translates to:
  /// **'VAT rate'**
  String get vatRateLabel;

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'{rate}%'**
  String percentValue(String rate);

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @priceMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than zero'**
  String get priceMustBePositive;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @categoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Pick a category'**
  String get categoryRequired;

  /// No description provided for @categoryNew.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get categoryNew;

  /// No description provided for @categoryNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Category name'**
  String get categoryNameLabel;

  /// No description provided for @categoriesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Categories could not be loaded.'**
  String get categoriesLoadError;

  /// No description provided for @customerNew.
  ///
  /// In en, this message translates to:
  /// **'New Customer'**
  String get customerNew;

  /// No description provided for @customerEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get customerEdit;

  /// No description provided for @customerDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete customer'**
  String get customerDelete;

  /// No description provided for @customerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get customerAdd;

  /// No description provided for @customerSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, contact or phone'**
  String get customerSearchHint;

  /// No description provided for @customersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Customers could not be loaded.'**
  String get customersLoadError;

  /// No description provided for @customersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get customersEmptyTitle;

  /// No description provided for @customersEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your customers first so you can send quotes.'**
  String get customersEmptyDescription;

  /// No description provided for @customerTypeIndividual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get customerTypeIndividual;

  /// No description provided for @customerTypeCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get customerTypeCompany;

  /// No description provided for @companyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Company name'**
  String get companyNameLabel;

  /// No description provided for @companyNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Company name cannot be empty'**
  String get companyNameRequired;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name cannot be empty'**
  String get fullNameRequired;

  /// No description provided for @contactPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact person'**
  String get contactPersonLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @taxOfficeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax office'**
  String get taxOfficeLabel;

  /// No description provided for @taxNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax number'**
  String get taxNumberLabel;

  /// No description provided for @nationalIdLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalIdLabel;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// Fallback when a failure has no specific message.
  ///
  /// In en, this message translates to:
  /// **'The operation could not be completed.'**
  String get errorGeneric;

  /// No description provided for @errorProductsLoad.
  ///
  /// In en, this message translates to:
  /// **'Products could not be loaded.'**
  String get errorProductsLoad;

  /// No description provided for @errorProductSave.
  ///
  /// In en, this message translates to:
  /// **'The product could not be saved.'**
  String get errorProductSave;

  /// No description provided for @errorProductUpdate.
  ///
  /// In en, this message translates to:
  /// **'The product could not be updated.'**
  String get errorProductUpdate;

  /// No description provided for @errorProductDelete.
  ///
  /// In en, this message translates to:
  /// **'The product could not be deleted.'**
  String get errorProductDelete;

  /// No description provided for @errorProductNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Product name cannot be empty.'**
  String get errorProductNameEmpty;

  /// No description provided for @errorProductNotSaved.
  ///
  /// In en, this message translates to:
  /// **'An unsaved product cannot be updated.'**
  String get errorProductNotSaved;

  /// No description provided for @errorPriceNegative.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative.'**
  String get errorPriceNegative;

  /// No description provided for @errorCategoriesLoad.
  ///
  /// In en, this message translates to:
  /// **'Categories could not be loaded.'**
  String get errorCategoriesLoad;

  /// No description provided for @errorCategorySave.
  ///
  /// In en, this message translates to:
  /// **'The category could not be saved.'**
  String get errorCategorySave;

  /// No description provided for @errorCategoryUpdate.
  ///
  /// In en, this message translates to:
  /// **'The category could not be updated.'**
  String get errorCategoryUpdate;

  /// No description provided for @errorCategoryDelete.
  ///
  /// In en, this message translates to:
  /// **'The category could not be deleted.'**
  String get errorCategoryDelete;

  /// No description provided for @errorCategoryNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Category name cannot be empty.'**
  String get errorCategoryNameEmpty;

  /// No description provided for @errorCategoryNotSaved.
  ///
  /// In en, this message translates to:
  /// **'An unsaved category cannot be updated.'**
  String get errorCategoryNotSaved;

  /// Category names are unique.
  ///
  /// In en, this message translates to:
  /// **'A category named \"{name}\" already exists.'**
  String errorCategoryDuplicate(String name);

  /// No description provided for @errorCategoryInUse.
  ///
  /// In en, this message translates to:
  /// **'This category has products in it. Move the products to another category first.'**
  String get errorCategoryInUse;

  /// No description provided for @errorCustomersLoad.
  ///
  /// In en, this message translates to:
  /// **'Customers could not be loaded.'**
  String get errorCustomersLoad;

  /// No description provided for @errorCustomerSave.
  ///
  /// In en, this message translates to:
  /// **'The customer could not be saved.'**
  String get errorCustomerSave;

  /// No description provided for @errorCustomerUpdate.
  ///
  /// In en, this message translates to:
  /// **'The customer could not be updated.'**
  String get errorCustomerUpdate;

  /// No description provided for @errorCustomerDelete.
  ///
  /// In en, this message translates to:
  /// **'The customer could not be deleted.'**
  String get errorCustomerDelete;

  /// No description provided for @errorCustomerNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Customer name cannot be empty.'**
  String get errorCustomerNameEmpty;

  /// No description provided for @errorCustomerNotSaved.
  ///
  /// In en, this message translates to:
  /// **'An unsaved customer cannot be updated.'**
  String get errorCustomerNotSaved;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'The email address is not valid.'**
  String get errorEmailInvalid;

  /// No description provided for @errorSettingsLoad.
  ///
  /// In en, this message translates to:
  /// **'Settings could not be loaded.'**
  String get errorSettingsLoad;

  /// No description provided for @errorSettingsSave.
  ///
  /// In en, this message translates to:
  /// **'Settings could not be saved.'**
  String get errorSettingsSave;

  /// Individual customers. Not merged with errorTaxNumberLength: the two differ by field name, not just digit count.
  ///
  /// In en, this message translates to:
  /// **'National ID must be 11 digits.'**
  String get errorNationalIdLength;

  /// Company customers.
  ///
  /// In en, this message translates to:
  /// **'Tax number must be 10 digits.'**
  String get errorTaxNumberLength;

  /// No description provided for @errorUnitNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Unit name cannot be empty.'**
  String get errorUnitNameEmpty;

  /// No description provided for @errorUnitSave.
  ///
  /// In en, this message translates to:
  /// **'The unit could not be saved.'**
  String get errorUnitSave;

  /// No description provided for @errorExport.
  ///
  /// In en, this message translates to:
  /// **'The file could not be created.'**
  String get errorExport;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
