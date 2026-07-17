import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/quotes/data/repositories/offer_repository_impl.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_providers.g.dart';

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
@Riverpod(keepAlive: true)
OfferRepository offerRepository(Ref ref) =>
    OfferRepositoryImpl(ref.watch(appDatabaseProvider));

/// DB değiştikçe kendiliğinden yayın yapar; manuel invalidate gerekmez.
/// Filtresiz tüm teklifler — dashboard'daki teklif sayısı bunu kullanır.
@riverpod
Stream<List<Offer>> offerList(Ref ref) =>
    ref.watch(offerRepositoryProvider).watchAll();

/// Teklifler listesindeki müşteri filtresi. `null` = tüm müşteriler.
/// Seçilen müşterinin `id`'sini tutar; gösterilecek ad, filtre bileşeni
/// müşteri listesinden bu id ile çözer (böylece ad snapshot'ı bayatlamaz).
@riverpod
class OfferCustomerFilter extends _$OfferCustomerFilter {
  @override
  int? build() => null;

  void select(int? customerId) => state = customerId;
}

/// Teklifler ekranının izlediği liste: [offerCustomerFilterProvider] seçiliyse
/// o müşteriye ait tekliflere daraltır. Silinmiş müşteri (customerId == null)
/// zaten filtre listesinde seçilemez, bu yüzden id eşitliği yeterli.
///
/// Repository'ye yeniden abone olmaz; [offerListProvider]'ın tek stream'i
/// üzerine filtre uygular. Filtre değişince yeni bir DB aboneliği açılmaz ve
/// dashboard'la aynı kaynak paylaşılır (loading/error durumları aynen taşınır).
@riverpod
AsyncValue<List<Offer>> filteredOfferList(Ref ref) {
  final customerId = ref.watch(offerCustomerFilterProvider);
  final offers = ref.watch(offerListProvider);
  if (customerId == null) return offers;
  return offers.whenData(
    (list) => list.where((offer) => offer.customerId == customerId).toList(),
  );
}
