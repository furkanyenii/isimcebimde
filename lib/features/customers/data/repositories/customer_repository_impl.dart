import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/turkish_text.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer.dart';
import 'package:isimcebimde/features/customers/domain/entities/customer_type.dart';
import 'package:isimcebimde/features/customers/domain/repositories/customer_repository.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Customer>> watchAll({String? query, CustomerType? type}) {
    final statement = _db.select(_db.customers)
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);

    if (type != null) {
      statement.where((c) => c.type.equals(type.wireName));
    }

    final search = query ?? '';

    return statement
        .watch()
        .map((rows) => rows.map(_toDomain).toList())
        .map(
          // Arama SQL'de değil Dart'ta; gerekçe: core/utils/turkish_text.dart
          (customers) => customers.where((c) => _matches(c, search)).toList(),
        )
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.customer,
            cause: e,
          ),
        );
  }

  /// Kullanıcı müşteriyi firma adıyla da, yetkilinin adıyla da, telefonuyla da
  /// arar. Tek alanda arama sahada yetersiz kalır.
  static bool _matches(Customer customer, String query) =>
      containsNormalized(customer.name, query) ||
      containsNormalized(customer.contactPerson ?? '', query) ||
      containsNormalized(customer.phone ?? '', query);

  @override
  Stream<Customer?> watchById(int id) {
    final statement = _db.select(_db.customers)..where((c) => c.id.equals(id));

    return statement.watchSingleOrNull().map(
      (row) => row == null ? null : _toDomain(row),
    );
  }

  @override
  Future<int> create(Customer customer) async {
    final clean = _validated(customer);

    try {
      return await _db
          .into(_db.customers)
          .insert(
            CustomersCompanion.insert(
              type: clean.type.wireName,
              name: clean.name,
              contactPerson: Value(clean.contactPerson),
              phone: Value(clean.phone),
              email: Value(clean.email),
              address: Value(clean.address),
              taxOffice: Value(clean.taxOffice),
              taxNumber: Value(clean.taxNumber),
              notes: Value(clean.notes),
            ),
          );
    } on Object catch (e) {
      // Ham Drift hatası üst katmana çıkmaz (CLAUDE.md: Database Rules).
      throw DatabaseFailure(
        DataOperation.create,
        EntityKind.customer,
        cause: e,
      );
    }
  }

  @override
  Future<void> update(Customer customer) async {
    final id = customer.id;
    if (id == null) {
      throw const UnsavedEntityFailure(EntityKind.customer);
    }
    final clean = _validated(customer);

    try {
      await (_db.update(_db.customers)..where((c) => c.id.equals(id))).write(
        CustomersCompanion(
          type: Value(clean.type.wireName),
          name: Value(clean.name),
          contactPerson: Value(clean.contactPerson),
          phone: Value(clean.phone),
          email: Value(clean.email),
          address: Value(clean.address),
          taxOffice: Value(clean.taxOffice),
          taxNumber: Value(clean.taxNumber),
          notes: Value(clean.notes),
        ),
      );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.update,
        EntityKind.customer,
        cause: e,
      );
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      await (_db.delete(_db.customers)..where((c) => c.id.equals(id))).go();
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.delete,
        EntityKind.customer,
        cause: e,
      );
    }
  }

  /// Doğrular **ve** normalize eder; kaydedilecek hâli döner.
  ///
  /// İş kuralları repository sınırında zorunlu kılınır; UI'ın doğrulama yapması
  /// yeterli değildir (repository başka yerden de çağrılabilir).
  Customer _validated(Customer customer) {
    final name = customer.name.trim();
    if (name.isEmpty) {
      throw const EmptyNameFailure(EntityKind.customer);
    }

    final email = _blankToNull(customer.email);
    if (email != null && !_isValidEmail(email)) {
      throw const InvalidEmailFailure();
    }

    // Vergi/kimlik no serbest metindir: uygulama Türkiye dışında da
    // kullanılabilir ve numaralar harf içerebilir (ör. AB VAT). Biçim/uzunluk
    // kontrolü ve rakama indirgeme yapılmaz; yalnızca boş → null normalize edilir.
    final taxNumber = _blankToNull(customer.taxNumber);

    // Yetkili kişi yalnızca kurumsalda anlamlıdır: tip değiştirildiğinde
    // gizlenen alanın eski değeri veritabanında hayalet gibi kalmamalı.
    // Vergi dairesi artık her iki tipte de görünür, bu yüzden korunur.
    final isCompany = customer.type.isCompany;

    return Customer(
      id: customer.id,
      type: customer.type,
      name: name,
      contactPerson: isCompany ? _blankToNull(customer.contactPerson) : null,
      phone: _blankToNull(customer.phone),
      email: email,
      address: _blankToNull(customer.address),
      taxOffice: _blankToNull(customer.taxOffice),
      taxNumber: taxNumber,
      notes: _blankToNull(customer.notes),
    );
  }

  /// Boş string ile `null` aynı şeyi ifade eder ("bilgi yok"). Tek gösterim
  /// seçilmezse sorgular yalan söyler: `phone IS NULL` bazı boş kayıtları kaçırır.
  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  /// Kasıtlı olarak gevşek: amacı yazım hatasını yakalamak, RFC 5322'yi
  /// uygulamak değil. Aşırı katı bir regex geçerli adresleri reddeder.
  static bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);

  Customer _toDomain(CustomerRow row) => Customer(
    id: row.id,
    type: CustomerType.fromWireName(row.type),
    name: row.name,
    contactPerson: row.contactPerson,
    phone: row.phone,
    email: row.email,
    address: row.address,
    taxOffice: row.taxOffice,
    taxNumber: row.taxNumber,
    notes: row.notes,
  );
}
