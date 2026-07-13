import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/widgets/app_state_views.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';
import 'package:isimcebimde/features/customers/presentation/providers/customer_providers.dart';
import 'package:isimcebimde/features/customers/presentation/screens/customer_list_screen.dart';

/// Widget testi veritabanını değil, ekranı test eder: repository arayüzünün
/// sahte bir uygulaması takılır (CLAUDE.md: Test Rules).
class _FakeCustomerRepository implements CustomerRepository {
  _FakeCustomerRepository({
    this.items = const [],
    this.error,
    this.neverEmits = false,
  });

  final List<Customer> items;
  final Object? error;

  /// Yayın yapmayan ve kapanmayan stream: ekran loading'de kalır.
  final bool neverEmits;

  /// Her çağrıda **yeni** stream döner.
  ///
  /// Arama metni değişince provider yeniden abone olur; tek dinlemelik bir
  /// stream (`Stream.value`) paylaşılsaydı ikinci abonelik patlardı.
  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) {
    if (error != null) return Stream<List<Customer>>.error(error!);
    if (neverEmits) return StreamController<List<Customer>>().stream;
    return Stream.value(items);
  }

  @override
  Stream<Customer?> watchById(int id) => const Stream.empty();

  @override
  Future<int> create(Customer customer) async => 1;

  @override
  Future<void> update(Customer customer) async {}

  @override
  Future<void> delete(int id) async {}
}

void main() {
  const company = Customer(
    id: 1,
    type: CustomerType.company,
    name: 'Yılmaz İnşaat Ltd. Şti.',
    contactPerson: 'Ahmet Yılmaz',
  );
  const individual = Customer(
    id: 2,
    type: CustomerType.individual,
    name: 'Ayşe Demir',
    phone: '0555 999 88 77',
  );

  Widget buildSubject(_FakeCustomerRepository repository) => ProviderScope(
    // Testteki retry politikası main.dart ile aynı olmalı, aksi halde test
    // üretimde olmayan bir davranışı doğrular (CLAUDE.md: Test Rules).
    retry: (retryCount, error) => null,
    overrides: [customerRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(home: CustomerListScreen()),
  );

  testWidgets('loading durumu gösterilir', (tester) async {
    await tester.pumpWidget(
      buildSubject(_FakeCustomerRepository(neverEmits: true)),
    );
    await tester.pump();

    expect(find.byType(AppLoadingView), findsOneWidget);
  });

  testWidgets('müşteriler listelenir', (tester) async {
    await tester.pumpWidget(
      buildSubject(_FakeCustomerRepository(items: const [company, individual])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Yılmaz İnşaat Ltd. Şti.'), findsOneWidget);
    expect(find.text('Ayşe Demir'), findsOneWidget);
  });

  testWidgets('kurumsal yetkiliyi, bireysel telefonu alt satırda gösterir', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(_FakeCustomerRepository(items: const [company, individual])),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ahmet Yılmaz'), findsOneWidget);
    expect(find.text('0555 999 88 77'), findsOneWidget);
    // Tip ikonları ayırt edici olmalı.
    expect(find.byIcon(Icons.business_outlined), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
  });

  testWidgets('hiç müşteri yoksa yönlendirici boş durum gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(_FakeCustomerRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Henüz müşteri yok'), findsOneWidget);
    expect(find.text('Müşteri ekle'), findsOneWidget);
  });

  testWidgets('arama sonucu boşsa farklı bir boş durum gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(buildSubject(_FakeCustomerRepository()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'bulunmayan');
    await tester.pumpAndSettle();

    // "Hiç müşterin yok" ile "aradığın bulunamadı" farklı mesajlar gerektirir.
    expect(find.text('Sonuç yok'), findsOneWidget);
    expect(find.text('Henüz müşteri yok'), findsNothing);
  });

  testWidgets('hata durumunda spinner değil hata ekranı gösterilir', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        _FakeCustomerRepository(
          error: const DatabaseFailure('Müşteriler okunamadı.'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppErrorView), findsOneWidget);
    expect(find.byType(AppLoadingView), findsNothing);
  });
}
