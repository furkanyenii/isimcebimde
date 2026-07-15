import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'customer_providers.g.dart';

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
@Riverpod(keepAlive: true)
CustomerRepository customerRepository(Ref ref) =>
    CustomerRepositoryImpl(ref.watch(appDatabaseProvider));

/// Müşteri listesindeki arama metni. Boş string = filtre yok.
@riverpod
class CustomerSearchQuery extends _$CustomerSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
@riverpod
Stream<List<Customer>> customerList(Ref ref) {
  final query = ref.watch(customerSearchQueryProvider);
  return ref.watch(customerRepositoryProvider).watchAll(query: query);
}

/// Arama filtresinden bağımsız, tüm müşteriler. Dashboard'daki müşteri sayısı
/// bunu kullanır; [customerListProvider] arama metnine bağlı olduğundan
/// kullanıcı müşteri ararken sayının filtreye kaymasını önler.
@riverpod
Stream<List<Customer>> allCustomers(Ref ref) =>
    ref.watch(customerRepositoryProvider).watchAll(query: '');

/// Tek bir müşteriyi id ile izler. Müşteri silinirse `null` yayınlar —
/// çağıran taraf bunu bir hata değil, "artık yok" olarak ele almalı
/// (CLAUDE.md: müşteri serbestçe silinebilir, geçmiş teklif bozulmaz).
@riverpod
Stream<Customer?> customerById(Ref ref, int id) =>
    ref.watch(customerRepositoryProvider).watchById(id);
