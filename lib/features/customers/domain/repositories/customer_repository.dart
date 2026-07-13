import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';

/// Presentation katmanı yalnızca bu arayüzü görür.
/// Drift tipleri (`AppDatabase`, `CustomerRow`) buranın dışına sızmaz.
abstract interface class CustomerRepository {
  /// Müşteriler, ada göre sıralı.
  ///
  /// [query] verilirse ad, yetkili kişi ve telefonda arar (Türkçe karakter
  /// duyarsız). [type] verilirse yalnızca o tipteki müşterileri getirir.
  Stream<List<Customer>> watchAll({String? query, CustomerType? type});

  Stream<Customer?> watchById(int id);

  /// Yeni müşteri oluşturur ve id'sini döner.
  Future<int> create(Customer customer);

  /// Var olan müşteriyi günceller. [Customer.id] null olamaz.
  Future<void> update(Customer customer);

  /// Müşteriyi kalıcı olarak siler.
  ///
  /// Geçmiş teklifler bozulmaz: teklif, müşteri bilgilerinin *snapshot*'ını
  /// tutar (CLAUDE.md: Database Rules).
  Future<void> delete(int id);
}
