/// Repository sınırında yakalanan hataların üst katmana taşındığı tip.
/// CLAUDE.md: ham veritabanı hatası (DriftRemoteException vb.) repository dışına sızmaz.
sealed class Failure implements Exception {
  const Failure(this.message, {this.cause});

  /// Kullanıcıya gösterilebilir, teknik olmayan mesaj.
  final String message;

  /// Loglama için orijinal hata. Kullanıcıya gösterilmez.
  final Object? cause;

  @override
  String toString() =>
      '$runtimeType: $message${cause == null ? '' : ' ($cause)'}';
}

/// Yerel veritabanı okuma/yazma hatası.
final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.cause});
}

/// İş kuralı ihlali (ör. negatif fiyat, boş teklif).
final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.cause});
}

/// Aynı isimde kategori zaten var (kategori adı benzersizdir).
final class DuplicateCategoryFailure extends Failure {
  const DuplicateCategoryFailure(super.message, {super.cause});
}

/// Kategoriye bağlı ürün olduğu için silinemez. Kategori zorunlu olduğundan
/// ürünler sahipsiz kalamaz.
final class CategoryInUseFailure extends Failure {
  const CategoryInUseFailure(super.message, {super.cause});
}

/// Dosya üretimi/paylaşımı hatası (PDF, dışa aktarma).
final class ExportFailure extends Failure {
  const ExportFailure(super.message, {super.cause});
}
