import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:isimcebimde/features/quotes/data/repositories/custom_unit_repository_impl.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/custom_unit_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_unit_providers.g.dart';

/// Arayüz tipiyle döner — testte sahte repository takmayı tek satıra indirir.
@Riverpod(keepAlive: true)
CustomUnitRepository customUnitRepository(Ref ref) =>
    CustomUnitRepositoryImpl(ref.watch(appDatabaseProvider));

/// Kullanıcının eklediği birimler. DB değiştikçe kendiliğinden yayın yapar;
/// yeni birim eklenince teklif ekranındaki dropdown manuel invalidate olmadan
/// güncellenir.
@riverpod
Stream<List<String>> customUnitList(Ref ref) =>
    ref.watch(customUnitRepositoryProvider).watchAll();
