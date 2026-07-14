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
@riverpod
Stream<List<Offer>> offerList(Ref ref) =>
    ref.watch(offerRepositoryProvider).watchAll();
