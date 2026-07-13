import 'package:isimcebimde/core/database/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_provider.g.dart';

/// Uygulama ömrü boyunca tek veritabanı örneği.
/// DI yalnızca Riverpod ile yapılır — get_it/singleton yasak (CLAUDE.md).
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
