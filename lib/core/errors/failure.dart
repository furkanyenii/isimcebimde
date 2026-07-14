/// Repository sınırında yakalanan hataların üst katmana taşındığı tip.
///
/// **Failure metin taşımaz, tip taşır.** Repository (data katmanı) `BuildContext`
/// göremez, dolayısıyla kullanıcının dilini bilemez — çeviriyi orada yapmak
/// imkânsızdır. Bu yüzden hata *ne olduğunu* söyler, *nasıl yazılacağını* değil.
/// Çeviri tek bir yerde, presentation sınırında yapılır:
/// `core/errors/failure_localizer.dart`.
///
/// [Failure] **sealed**'dır: çeviri switch'i exhaustive olur ve yeni bir hata
/// tipi eklenip çevirisi yazılmazsa **kod derlenmez**. "Bir dilde eksik metin
/// kaldı" hata sınıfı böylece tamamen ortadan kalkar.
///
/// CLAUDE.md: ham veritabanı hatası (`DriftRemoteException` vb.) repository
/// dışına sızmaz.
sealed class Failure implements Exception {
  const Failure({this.cause});

  /// Loglama için orijinal hata. Kullanıcıya gösterilmez.
  final Object? cause;

  /// **Yalnızca log ve hata ayıklama içindir.** Kullanıcıya asla gösterilmez;
  /// kullanıcıya gösterilecek metin `localized(l10n)` ile üretilir.
  String get debugLabel;

  @override
  String toString() =>
      '$runtimeType: $debugLabel${cause == null ? '' : ' ($cause)'}';
}

/// Hatanın hangi kayıt türüyle ilgili olduğu.
enum EntityKind { product, category, customer, settings, offer }

/// Hangi veritabanı işleminin başarısız olduğu.
enum DataOperation { read, create, update, delete }

/// Yerel veritabanı okuma/yazma hatası.
final class DatabaseFailure extends Failure {
  const DatabaseFailure(this.operation, this.entity, {super.cause});

  final DataOperation operation;
  final EntityKind entity;

  @override
  String get debugLabel => '${entity.name}.${operation.name} failed';
}

/// İş kuralı ihlali. Alt tipleri somut ihlali söyler.
sealed class ValidationFailure extends Failure {
  const ValidationFailure({super.cause});
}

/// Zorunlu ad alanı boş bırakıldı.
final class EmptyNameFailure extends ValidationFailure {
  const EmptyNameFailure(this.entity);

  final EntityKind entity;

  @override
  String get debugLabel => '${entity.name} name is empty';
}

/// Henüz kaydedilmemiş (id'si olmayan) bir kayıt güncellenmeye çalışıldı.
final class UnsavedEntityFailure extends ValidationFailure {
  const UnsavedEntityFailure(this.entity);

  final EntityKind entity;

  @override
  String get debugLabel => 'unsaved ${entity.name} cannot be updated';
}

/// Fiyat negatif olamaz.
final class NegativePriceFailure extends ValidationFailure {
  const NegativePriceFailure();

  @override
  String get debugLabel => 'price is negative';
}

final class InvalidEmailFailure extends ValidationFailure {
  const InvalidEmailFailure();

  @override
  String get debugLabel => 'email is not valid';
}

/// Bireysel müşterinin TC Kimlik No'su 11 hane değil.
///
/// [InvalidTaxNumberFailure] ile birleştirilmedi: ikisi yalnızca hane sayısıyla
/// değil, **alan adıyla** da ayrışır ("TC Kimlik No" / "Vergi No"). Tek bir
/// parametreli mesaj her iki dilde de doğal okunmazdı.
final class InvalidNationalIdFailure extends ValidationFailure {
  const InvalidNationalIdFailure();

  @override
  String get debugLabel => 'national id must be 11 digits';
}

/// Kurumsal müşterinin vergi numarası 10 hane değil.
final class InvalidTaxNumberFailure extends ValidationFailure {
  const InvalidTaxNumberFailure();

  @override
  String get debugLabel => 'tax number must be 10 digits';
}

/// Teklif bir müşteriye bağlı olmadan kaydedilemez.
///
/// Repository sınırında UI'dan bağımsız olarak zorunlu kılınır (CLAUDE.md:
/// "iş kuralları domain sınırında zorunlu kılınır").
final class CustomerRequiredFailure extends ValidationFailure {
  const CustomerRequiredFailure();

  @override
  String get debugLabel => 'offer requires a customer';
}

/// Teklif en az bir ürün satırı içermelidir; boş teklif kaydedilemez.
final class EmptyOfferFailure extends ValidationFailure {
  const EmptyOfferFailure();

  @override
  String get debugLabel => 'offer has no items';
}

/// Aynı isimde kategori zaten var (kategori adı benzersizdir).
final class DuplicateCategoryFailure extends Failure {
  const DuplicateCategoryFailure(this.name, {super.cause});

  /// Çakışan kategori adı. Kullanıcı verisidir; çeviriye parametre olarak girer.
  final String name;

  @override
  String get debugLabel => 'category "$name" already exists';
}

/// Kategoriye bağlı ürün olduğu için silinemez. Kategori zorunlu olduğundan
/// ürünler sahipsiz kalamaz.
final class CategoryInUseFailure extends Failure {
  const CategoryInUseFailure({super.cause});

  @override
  String get debugLabel => 'category still has products';
}

/// Dosya üretimi/paylaşımı hatası (PDF, dışa aktarma).
final class ExportFailure extends Failure {
  const ExportFailure(this.debugLabel, {super.cause});

  @override
  final String debugLabel;
}
