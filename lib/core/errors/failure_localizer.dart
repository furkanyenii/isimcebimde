import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/l10n/app_localizations.dart';

/// [Failure]'ı kullanıcının dilinde bir mesaja çevirir.
///
/// Bu, hata metninin üretildiği **tek** yerdir. Repository katmanı dili bilmez;
/// çeviri presentation sınırında yapılır.
///
/// Aşağıdaki `switch`'ler exhaustive'dir çünkü [Failure] sealed'dır: yeni bir
/// hata tipi eklenip buraya çevirisi yazılmazsa **kod derlenmez**. Kural bu
/// yüzden analyzer tarafından zorlanır, code review'a bırakılmaz.
extension FailureLocalizer on Failure {
  String localized(AppLocalizations l10n) => switch (this) {
    DatabaseFailure(:final operation, :final entity) => _database(
      l10n,
      operation,
      entity,
    ),
    EmptyNameFailure(:final entity) => switch (entity) {
      EntityKind.product => l10n.errorProductNameEmpty,
      EntityKind.category => l10n.errorCategoryNameEmpty,
      EntityKind.customer => l10n.errorCustomerNameEmpty,
      // Ayarların "adı" yoktur; bu kombinasyon üretilemez.
      EntityKind.settings => l10n.errorGeneric,
    },
    UnsavedEntityFailure(:final entity) => switch (entity) {
      EntityKind.product => l10n.errorProductNotSaved,
      EntityKind.category => l10n.errorCategoryNotSaved,
      EntityKind.customer => l10n.errorCustomerNotSaved,
      // Ayar satırı her zaman vardır; kaydedilmemiş ayar diye bir şey yok.
      EntityKind.settings => l10n.errorGeneric,
    },
    NegativePriceFailure() => l10n.errorPriceNegative,
    InvalidEmailFailure() => l10n.errorEmailInvalid,
    InvalidNationalIdFailure() => l10n.errorNationalIdLength,
    InvalidTaxNumberFailure() => l10n.errorTaxNumberLength,
    DuplicateCategoryFailure(:final name) => l10n.errorCategoryDuplicate(name),
    CategoryInUseFailure() => l10n.errorCategoryInUse,
    ExportFailure() => l10n.errorExport,
  };

  static String _database(
    AppLocalizations l10n,
    DataOperation operation,
    EntityKind entity,
  ) => switch ((entity, operation)) {
    (EntityKind.product, DataOperation.read) => l10n.errorProductsLoad,
    (EntityKind.product, DataOperation.create) => l10n.errorProductSave,
    (EntityKind.product, DataOperation.update) => l10n.errorProductUpdate,
    (EntityKind.product, DataOperation.delete) => l10n.errorProductDelete,
    (EntityKind.category, DataOperation.read) => l10n.errorCategoriesLoad,
    (EntityKind.category, DataOperation.create) => l10n.errorCategorySave,
    (EntityKind.category, DataOperation.update) => l10n.errorCategoryUpdate,
    (EntityKind.category, DataOperation.delete) => l10n.errorCategoryDelete,
    (EntityKind.customer, DataOperation.read) => l10n.errorCustomersLoad,
    (EntityKind.customer, DataOperation.create) => l10n.errorCustomerSave,
    (EntityKind.customer, DataOperation.update) => l10n.errorCustomerUpdate,
    (EntityKind.customer, DataOperation.delete) => l10n.errorCustomerDelete,
    // Ayarların tek yazma yolu var (satır hep vardır, silinmez); create/update/
    // delete ayrımı kullanıcı için anlamsız, hepsi aynı mesaja düşer.
    (EntityKind.settings, DataOperation.read) => l10n.errorSettingsLoad,
    (EntityKind.settings, _) => l10n.errorSettingsSave,
  };
}

/// Hata `Failure` değilse (beklenmeyen bir istisna) genel mesaja düşülür.
/// Stack trace kullanıcıya gösterilmez (CLAUDE.md: UI Rules).
String localizeError(Object? error, AppLocalizations l10n) =>
    error is Failure ? error.localized(l10n) : l10n.errorGeneric;
