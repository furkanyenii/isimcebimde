import 'package:isimcebimde/app/di/database_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_initialization_provider.g.dart';

/// Uygulama açılışında bir kez çalışan hazırlık adımı.
///
/// Drift veritabanını tembel açar: ilk sorgu, dosyanın oluşturulmasını,
/// şemanın kurulmasını ve migration'ların çalışmasını tetikler. Bunu splash
/// ekranında yapmak, kullanıcının ilk ekranda takılmasını önler ve
/// veritabanı açılamazsa hatayı **görünür** kılar (sessizce yutulmaz).
@Riverpod(keepAlive: true)
Future<void> appInitialization(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  await db.customSelect('SELECT 1').get();
}
