import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/customers/presentation/screens/customer_form_screen.dart';

import '../../support/localized_app.dart';

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
  // Beklenen metinler ARB'den okunur (bkz. test/support/localized_app.dart).
  final tr = l10nFor(const Locale('tr'));

  late _FakeCustomerRepository customers;

  setUp(() => customers = _FakeCustomerRepository());

  Widget buildSubject({Customer? customer}) => ProviderScope(
    retry: (retryCount, error) => null,
    overrides: [customerRepositoryProvider.overrideWithValue(customers)],
    child: localizedApp(CustomerFormScreen(customer: customer)),
  );

  Future<void> selectCompany(WidgetTester tester) async {
    await tester.tap(find.text(tr.customerTypeCompany));
    await tester.pumpAndSettle();
  }

  group('tipe göre uyarlanan form', () {
    testWidgets('bireysel varsayılandır; kurumsal alanlar gizlidir', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text(tr.fullNameLabel), findsOneWidget);
      // Vergi dairesi/no bireyselde de sorulur: şahıs firması da vergiye tabi.
      expect(find.text(tr.taxOfficeLabel), findsOneWidget);
      expect(find.text(tr.taxNumberLabel), findsOneWidget);
      // Yetkili kişi yalnızca kurumsalda anlamlı — gösterilmemeli.
      expect(find.text(tr.contactPersonLabel), findsNothing);
    });

    testWidgets('kurumsal seçilince ilgili alanlar açılır', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await selectCompany(tester);

      expect(find.text(tr.companyNameLabel), findsOneWidget);
      expect(find.text(tr.contactPersonLabel), findsOneWidget);
      expect(find.text(tr.taxOfficeLabel), findsOneWidget);
      expect(find.text(tr.taxNumberLabel), findsOneWidget);
      expect(find.text(tr.nationalIdLabel), findsNothing);
    });
  });

  group('doğrulama', () {
    testWidgets('boş ad reddedilir, kayıt yapılmaz', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.tap(find.text(tr.actionSave));
      await tester.pumpAndSettle();

      expect(find.text(tr.fullNameRequired), findsOneWidget);
      expect(customers.created, isEmpty);
    });

    testWidgets('geçersiz e-posta reddedilir', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, tr.fullNameLabel),
        'Ayşe Demir',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, tr.emailLabel),
        'ayse[at]demir',
      );
      await tester.tap(find.text(tr.actionSave));
      await tester.pumpAndSettle();

      expect(find.text(tr.errorEmailInvalid), findsOneWidget);
      expect(customers.created, isEmpty);
    });

    testWidgets(
      'harf içeren vergi/kimlik no kabul edilir (uzunluk kontrolü yok)',
      (tester) async {
        // Uygulama Türkiye dışında da kullanılabilir: numara harf içerebilir
        // (ör. AB VAT) ve biçim/uzunluk kontrolü yoktur.
        await tester.pumpWidget(buildSubject());
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, tr.fullNameLabel),
          'Ayşe Demir',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, tr.taxNumberLabel),
          'DE123456789',
        );
        await tester.tap(find.text(tr.actionSave));
        await tester.pumpAndSettle();

        expect(customers.created, hasLength(1));
        expect(customers.created.single.taxNumber, 'DE123456789');
      },
    );
  });

  group('kayıt', () {
    testWidgets('yalnızca ad girip kaydetmek yeterlidir', (tester) async {
      // Sahadaki asıl akış: detay sonra doldurulur.
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, tr.fullNameLabel),
        'Ayşe Demir',
      );
      await tester.tap(find.text(tr.actionSave));
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
        find.widgetWithText(TextFormField, tr.companyNameLabel),
        'Yılmaz İnşaat',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, tr.contactPersonLabel),
        'Ahmet Yılmaz',
      );
      await tester.tap(find.text(tr.actionSave));
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

      expect(find.text(tr.customerEdit), findsOneWidget);
      expect(find.text('Yılmaz İnşaat'), findsOneWidget);
      expect(find.text('Ahmet Yılmaz'), findsOneWidget);
      // Kurumsal olarak açılmalı.
      expect(find.text(tr.taxOfficeLabel), findsOneWidget);
    });

    testWidgets('kaydetmek update çağırır, create değil', (tester) async {
      await tester.pumpWidget(buildSubject(customer: existing));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, tr.companyNameLabel),
        'Yılmaz İnşaat A.Ş.',
      );
      await tester.tap(find.text(tr.actionSave));
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

      await tester.tap(find.text(tr.actionCancel));
      await tester.pumpAndSettle();

      expect(customers.deleted, isEmpty);
    });

    testWidgets('onaylanınca müşteri silinir', (tester) async {
      await tester.pumpWidget(buildSubject(customer: existing));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, tr.actionDelete));
      await tester.pumpAndSettle();

      expect(customers.deleted, [7]);
    });
  });

  testWidgets('kayıt hatası kullanıcıya gösterilir', (tester) async {
    customers.failure = const DatabaseFailure(
      DataOperation.create,
      EntityKind.customer,
    );

    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, tr.fullNameLabel),
      'Ayşe Demir',
    );
    await tester.tap(find.text(tr.actionSave));
    await tester.pumpAndSettle();

    // Beklenen metin ARB'den okunur, elle yazılmaz.
    expect(find.text(tr.errorCustomerSave), findsOneWidget);
  });
}
