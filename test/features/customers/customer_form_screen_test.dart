import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/customers/presentation/screens/customer_form_screen.dart';

class _FakeCustomerRepository implements CustomerRepository {
  final List<Customer> created = [];
  final List<Customer> updated = [];
  final List<int> deleted = [];
  Failure? failure;

  @override
  Future<int> create(Customer customer) async {
    if (failure != null) throw failure!;
    created.add(customer);
    return 1;
  }

  @override
  Future<void> update(Customer customer) async {
    if (failure != null) throw failure!;
    updated.add(customer);
  }

  @override
  Future<void> delete(int id) async {
    if (failure != null) throw failure!;
    deleted.add(id);
  }

  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) =>
      const Stream.empty();

  @override
  Stream<Customer?> watchById(int id) => const Stream.empty();
}

void main() {
  late _FakeCustomerRepository customers;

  setUp(() => customers = _FakeCustomerRepository());

  Widget buildSubject({Customer? customer}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [customerRepositoryProvider.overrideWithValue(customers)],
    child: MaterialApp(home: CustomerFormScreen(customer: customer)),
  );

  Future<void> selectCompany(WidgetTester tester) async {
    await tester.tap(find.text('Kurumsal'));
    await tester.pumpAndSettle();
  }

  group('tipe göre uyarlanan form', () {
    testWidgets('bireysel varsayılandır; kurumsal alanlar gizlidir', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Ad soyad'), findsOneWidget);
      expect(find.text('TC Kimlik No'), findsOneWidget);
      // Bireysel müşteride bunlar anlamsız — gösterilmemeli.
      expect(find.text('Yetkili kişi'), findsNothing);
      expect(find.text('Vergi dairesi'), findsNothing);
    });

    testWidgets('kurumsal seçilince ilgili alanlar açılır', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await selectCompany(tester);

      expect(find.text('Firma ünvanı'), findsOneWidget);
      expect(find.text('Yetkili kişi'), findsOneWidget);
      expect(find.text('Vergi dairesi'), findsOneWidget);
      expect(find.text('Vergi no'), findsOneWidget);
      expect(find.text('TC Kimlik No'), findsNothing);
    });
  });

  group('doğrulama', () {
    testWidgets('boş ad reddedilir, kayıt yapılmaz', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Ad soyad boş olamaz'), findsOneWidget);
      expect(customers.created, isEmpty);
    });

    testWidgets('geçersiz e-posta reddedilir', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ad soyad'),
        'Ayşe Demir',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'E-posta'),
        'ayse[at]demir',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('E-posta adresi geçersiz'), findsOneWidget);
      expect(customers.created, isEmpty);
    });

    testWidgets('eksik haneli TCKN reddedilir', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ad soyad'),
        'Ayşe Demir',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'TC Kimlik No'),
        '123',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('TC Kimlik No 11 haneli olmalı'), findsOneWidget);
      expect(customers.created, isEmpty);
    });

    testWidgets('kurumsalda vergi no 10 hane beklenir', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await selectCompany(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Firma ünvanı'),
        'Yılmaz İnşaat',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Vergi no'),
        '12345678901', // 11 hane — bireysel uzunluğu
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(find.text('Vergi No 10 haneli olmalı'), findsOneWidget);
    });
  });

  group('kayıt', () {
    testWidgets('yalnızca ad girip kaydetmek yeterlidir', (tester) async {
      // Sahadaki asıl akış: detay sonra doldurulur.
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ad soyad'),
        'Ayşe Demir',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(customers.created, hasLength(1));
      final saved = customers.created.single;
      expect(saved.name, 'Ayşe Demir');
      expect(saved.type, CustomerType.individual);
      expect(saved.id, isNull);
    });

    testWidgets('kurumsal müşteri tipiyle birlikte kaydedilir', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();
      await selectCompany(tester);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Firma ünvanı'),
        'Yılmaz İnşaat',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Yetkili kişi'),
        'Ahmet Yılmaz',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      final saved = customers.created.single;
      expect(saved.type, CustomerType.company);
      expect(saved.name, 'Yılmaz İnşaat');
      expect(saved.contactPerson, 'Ahmet Yılmaz');
    });
  });

  group('düzenleme', () {
    const existing = Customer(
      id: 7,
      type: CustomerType.company,
      name: 'Yılmaz İnşaat',
      contactPerson: 'Ahmet Yılmaz',
    );

    testWidgets('mevcut değerler forma yüklenir', (tester) async {
      await tester.pumpWidget(buildSubject(customer: existing));
      await tester.pumpAndSettle();

      expect(find.text('Müşteriyi Düzenle'), findsOneWidget);
      expect(find.text('Yılmaz İnşaat'), findsOneWidget);
      expect(find.text('Ahmet Yılmaz'), findsOneWidget);
      // Kurumsal olarak açılmalı.
      expect(find.text('Vergi dairesi'), findsOneWidget);
    });

    testWidgets('kaydetmek update çağırır, create değil', (tester) async {
      await tester.pumpWidget(buildSubject(customer: existing));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Firma ünvanı'),
        'Yılmaz İnşaat A.Ş.',
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();

      expect(customers.created, isEmpty);
      expect(customers.updated.single.id, 7);
      expect(customers.updated.single.name, 'Yılmaz İnşaat A.Ş.');
    });

    testWidgets('silme onay ister; vazgeçilirse silinmez', (tester) async {
      await tester.pumpWidget(buildSubject(customer: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.textContaining('geri alınamaz'), findsOneWidget);

      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();

      expect(customers.deleted, isEmpty);
    });

    testWidgets('onaylanınca müşteri silinir', (tester) async {
      await tester.pumpWidget(buildSubject(customer: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Sil'));
      await tester.pumpAndSettle();

      expect(customers.deleted, [7]);
    });
  });

  testWidgets('kayıt hatası kullanıcıya gösterilir', (tester) async {
    customers.failure = const DatabaseFailure('Müşteri kaydedilemedi.');

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Ad soyad'),
      'Ayşe Demir',
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();

    expect(find.text('Müşteri kaydedilemedi.'), findsOneWidget);
  });
}
