import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/quotes/data/repositories/custom_unit_repository_impl.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/custom_unit_repository.dart';

/// Veritabanına dokunan test düz `test()` içinde yazılır, `testWidgets()`
/// içinde değil (CLAUDE.md: Test Rules).
void main() {
  late AppDatabase db;
  late CustomUnitRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CustomUnitRepositoryImpl(db);
  });

  tearDown(() => db.close());

  test('eklenen birim kalıcıdır ve eklenme sırasıyla döner', () async {
    await repository.add('ton');
    await repository.add('top');

    expect(await repository.watchAll().first, ['ton', 'top']);
  });

  test('birim adının baştaki/sondaki boşlukları temizlenir', () async {
    await repository.add('  saat  ');

    expect(await repository.watchAll().first, ['saat']);
  });

  test('aynı birim iki kez eklenirse sessizce yok sayılır', () async {
    await repository.add('ton');
    await repository.add('ton');

    expect(await repository.watchAll().first, hasLength(1));
  });

  test('boş birim adı reddedilir', () async {
    await expectLater(repository.add('   '), throwsA(isA<EmptyNameFailure>()));
  });
}
