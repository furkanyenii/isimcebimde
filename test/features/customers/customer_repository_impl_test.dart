import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/customers/data/repositories/customer_repository_impl.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';

/// Veritabanına dokunan test düz `test()` içinde yazılır, `testWidgets()` içinde
/// DEĞİL: `testWidgets` sahte async zamanında çalışır, Drift'in gerçek I/O'su o
/// zamanda ilerlemez ve test asılı kalır (CLAUDE.md: Test Rules).
void main() {
  late AppDatabase db;
  late CustomerRepositoryImpl repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = CustomerRepositoryImpl(db);
  });

  tearDown(() => db.close());

  const company = Customer(
    id: null,
    type: CustomerType.company,
    name: 'Yılmaz İnşaat Ltd. Şti.',
    contactPerson: 'Ahmet Yılmaz',
    phone: '0532 111 22 33',
    email: 'info@yilmaz.com',
    taxOffice: 'Kadıköy',
    taxNumber: '1234567890',
  );

  const individual = Customer(
    id: null,
    type: CustomerType.individual,
    name: 'Ayşe Demir',
    phone: '0555 999 88 77',
  );

  group('create', () {
    test(
      'kurumsal müşteri tüm alanlarıyla kaydedilir ve geri okunur',
      () async {
        final id = await repository.create(company);
        final saved = await repository.watchById(id).first;

        expect(saved, isNotNull);
        expect(saved!.type, CustomerType.company);
        expect(saved.name, 'Yılmaz İnşaat Ltd. Şti.');
        expect(saved.contactPerson, 'Ahmet Yılmaz');
        expect(saved.taxOffice, 'Kadıköy');
        expect(saved.taxNumber, '1234567890');
      },
    );

    test(
      'vergi no harf içerebilir, uzun olabilir ve büyük/küçük harf korunur',
      () async {
        // 11 haneden uzun, harf içeren, karışık büyük/küçük harfli bir vergi
        // no: uzunluk sınırı yok, otomatik büyütme yok (Talep 2).
        final customer = company.copyWith(taxNumber: 'tr-Ab12345678901234');
        final id = await repository.create(customer);
        final saved = await repository.watchById(id).first;

        expect(saved!.taxNumber, 'tr-Ab12345678901234');
      },
    );

    test('yalnızca ad zorunludur; gerisi boş bırakılabilir', () async {
      // Sahada 60 saniyede teklif hedefi: detay sonradan doldurulur.
      const minimal = Customer(
        id: null,
        type: CustomerType.individual,
        name: 'Mehmet',
      );

      final id = await repository.create(minimal);
      final saved = await repository.watchById(id).first;

      expect(saved!.name, 'Mehmet');
      expect(saved.phone, isNull);
      expect(saved.email, isNull);
    });

    test('boş ad reddedilir', () async {
      await expectLater(
        repository.create(
          const Customer(id: null, type: CustomerType.individual, name: '   '),
        ),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('boş string NULL olarak saklanır', () async {
      // "Telefonu yok" iki farklı şekilde temsil edilirse sorgular yalan söyler.
      final id = await repository.create(
        const Customer(
          id: null,
          type: CustomerType.individual,
          name: 'Mehmet',
          phone: '   ',
          email: '',
          notes: '',
        ),
      );

      final row = await (db.select(
        db.customers,
      )..where((c) => c.id.equals(id))).getSingle();

      expect(row.phone, isNull);
      expect(row.email, isNull);
      expect(row.notes, isNull);
    });

    test('bireysel müşteride yetkili kişi saklanmaz', () async {
      // Kullanıcı kurumsalken yetkili kişi girip sonra bireysele çevirirse,
      // gizlenen alan veritabanında hayalet gibi kalmamalı. Vergi dairesi
      // bunun istisnasıdır: bireysel müşteride de sorulur, bu yüzden korunur.
      final id = await repository.create(
        const Customer(
          id: null,
          type: CustomerType.individual,
          name: 'Ayşe Demir',
          contactPerson: 'Hayalet Kişi',
          taxOffice: 'Kadıköy',
        ),
      );

      final saved = await repository.watchById(id).first;

      expect(saved!.contactPerson, isNull);
      expect(saved.taxOffice, 'Kadıköy');
    });
  });

  group('doğrulama', () {
    test('geçersiz e-posta reddedilir', () async {
      await expectLater(
        repository.create(individual.copyWith(email: 'ayse[at]demir')),
        throwsA(isA<ValidationFailure>()),
      );
    });

    test('geçerli e-posta kabul edilir', () async {
      final id = await repository.create(
        individual.copyWith(email: 'ayse@demir.com.tr'),
      );
      final saved = await repository.watchById(id).first;

      expect(saved!.email, 'ayse@demir.com.tr');
    });

    test('vergi/kimlik no serbest metindir, olduğu gibi saklanır', () async {
      // Uygulama Türkiye dışında da kullanılabilir: numara harf içerebilir
      // (ör. AB VAT) ve biçim/uzunluk kontrolü yoktur. Yalnızca trim edilir.
      final id = await repository.create(
        company.copyWith(taxNumber: 'DE123456789', taxOffice: 'Berlin'),
      );
      final saved = await repository.watchById(id).first;

      expect(saved!.taxNumber, 'DE123456789');
      expect(saved.taxOffice, 'Berlin');
    });

    test('kısa/alışılmadık vergi no reddedilmez', () async {
      final id = await repository.create(
        individual.copyWith(taxNumber: '12345'),
      );
      expect((await repository.watchById(id).first)!.taxNumber, '12345');
    });
  });

  group('arama (Türkçe karakter duyarsız)', () {
    setUp(() async {
      await repository.create(company); // Yılmaz İnşaat, yetkili: Ahmet Yılmaz
      await repository.create(individual); // Ayşe Demir
      await repository.create(
        const Customer(
          id: null,
          type: CustomerType.company,
          name: 'Işık Elektrik',
          contactPerson: 'Can Işık',
        ),
      );
    });

    Future<List<String>> search(String query) async {
      final result = await repository.watchAll(query: query).first;
      return result.map((c) => c.name).toList();
    }

    test('büyük/küçük harf farkı eşleşmeyi bozmaz', () async {
      expect(await search('yılmaz'), contains('Yılmaz İnşaat Ltd. Şti.'));
      expect(await search('YILMAZ'), contains('Yılmaz İnşaat Ltd. Şti.'));
    });

    test('noktasız ı ile de bulunur', () async {
      // SQLite'ın lower()'ı ASCII-only olduğu için bu SQL'de çalışmazdı.
      expect(await search('isik'), contains('Işık Elektrik'));
      expect(await search('ışık'), contains('Işık Elektrik'));
    });

    test('yetkili kişinin adıyla da aranabilir', () async {
      expect(await search('ahmet'), contains('Yılmaz İnşaat Ltd. Şti.'));
    });

    test('telefonla da aranabilir', () async {
      expect(await search('0555'), contains('Ayşe Demir'));
    });

    test('boş sorgu hepsini getirir, ada göre sıralı', () async {
      expect(await search(''), [
        'Ayşe Demir',
        'Işık Elektrik',
        'Yılmaz İnşaat Ltd. Şti.',
      ]);
    });

    test('eşleşme yoksa boş liste döner', () async {
      expect(await search('bulunmayan'), isEmpty);
    });
  });

  group('update', () {
    test('alan gerçekten temizlenebilir', () async {
      final id = await repository.create(company);
      final saved = (await repository.watchById(id).first)!;

      await repository.update(saved.copyWith(phone: null));
      final after = await repository.watchById(id).first;

      expect(after!.phone, isNull);
      expect(after.name, 'Yılmaz İnşaat Ltd. Şti.'); // diğerleri bozulmamalı
    });

    test('kaydedilmemiş müşteri güncellenemez', () async {
      await expectLater(
        repository.update(company),
        throwsA(isA<ValidationFailure>()),
      );
    });
  });

  group('delete', () {
    test('müşteri kalıcı olarak silinir', () async {
      final id = await repository.create(company);

      await repository.delete(id);

      expect(await repository.watchById(id).first, isNull);
      expect(await repository.watchAll().first, isEmpty);
    });
  });

  group('tip filtresi', () {
    test('yalnızca istenen tip döner', () async {
      await repository.create(company);
      await repository.create(individual);

      final companies = await repository
          .watchAll(type: CustomerType.company)
          .first;
      final individuals = await repository
          .watchAll(type: CustomerType.individual)
          .first;

      expect(companies.map((c) => c.name), ['Yılmaz İnşaat Ltd. Şti.']);
      expect(individuals.map((c) => c.name), ['Ayşe Demir']);
    });
  });
}
