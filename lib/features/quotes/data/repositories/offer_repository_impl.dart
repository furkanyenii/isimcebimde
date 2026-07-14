import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/offer_repository.dart';

class OfferRepositoryImpl implements OfferRepository {
  const OfferRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Offer>> watchAll() {
    final query = _db.select(_db.offers)
      ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]);

    // `create`/`update` her zaman `offers` satırını da yazar (satırlar tek
    // başına değişemez), bu yüzden bu stream satır değişikliklerinde de
    // kendiliğinden yeniden tetiklenir.
    return query
        .watch()
        .asyncMap((rows) => Future.wait(rows.map(_toDomain)))
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.offer,
            cause: e,
          ),
        );
  }

  @override
  Stream<Offer?> watchById(int id) {
    final query = _db.select(_db.offers)..where((o) => o.id.equals(id));

    return query
        .watchSingleOrNull()
        .asyncMap((row) async => row == null ? null : await _toDomain(row))
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.offer,
            cause: e,
          ),
        );
  }

  @override
  Future<int> create(Offer offer) async {
    _validate(offer);
    try {
      return await _db.transaction(() async {
        final id = await _db.into(_db.offers).insert(_toCompanion(offer));
        await _insertItems(id, offer.items);
        return id;
      });
    } on Object catch (e) {
      throw DatabaseFailure(DataOperation.create, EntityKind.offer, cause: e);
    }
  }

  @override
  Future<void> update(Offer offer) async {
    final id = offer.id;
    if (id == null) throw const UnsavedEntityFailure(EntityKind.offer);
    _validate(offer);

    try {
      await _db.transaction(() async {
        await (_db.update(
          _db.offers,
        )..where((o) => o.id.equals(id))).write(_toCompanion(offer));
        // Satırlar diff'lenmez: silinip verilen listeyle yeniden yazılır
        // (CLAUDE.md: Working Style — form tabanlı bir düzenleyici için yeterli).
        await (_db.delete(
          _db.offerItems,
        )..where((i) => i.offerId.equals(id))).go();
        await _insertItems(id, offer.items);
      });
    } on Object catch (e) {
      throw DatabaseFailure(DataOperation.update, EntityKind.offer, cause: e);
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      // OfferItems, `ON DELETE CASCADE` ile birlikte silinir.
      await (_db.delete(_db.offers)..where((o) => o.id.equals(id))).go();
    } on Object catch (e) {
      throw DatabaseFailure(DataOperation.delete, EntityKind.offer, cause: e);
    }
  }

  /// İş kuralları domain sınırında zorunlu kılınır; UI'ın doğrulaması
  /// yeterli değildir (repository başka yerden de çağrılabilir).
  void _validate(Offer offer) {
    if (offer.customerId == null) {
      throw const CustomerRequiredFailure();
    }
    if (offer.items.isEmpty) {
      throw const EmptyOfferFailure();
    }
  }

  Future<void> _insertItems(int offerId, List<OfferItem> items) async {
    for (var i = 0; i < items.length; i++) {
      await _db
          .into(_db.offerItems)
          .insert(_itemCompanion(offerId, items[i], sortOrder: i));
    }
  }

  OffersCompanion _toCompanion(Offer offer) => OffersCompanion.insert(
    customerId: Value(offer.customerId),
    customerName: offer.customerName.trim(),
    customerContactPerson: Value(_nullIfBlank(offer.customerContactPerson)),
    currencyCode: Value(offer.currency.code),
    generalDiscountBasisPoints: Value(offer.generalDiscount.basisPoints),
    notes: Value(_nullIfBlank(offer.notes)),
  );

  OfferItemsCompanion _itemCompanion(
    int offerId,
    OfferItem item, {
    required int sortOrder,
  }) => OfferItemsCompanion.insert(
    offerId: offerId,
    productId: Value(item.productId),
    productName: item.productName,
    unitPriceMinor: item.unitPrice.minor,
    quantity: item.quantity,
    vatRateBasisPoints: item.vatRate.basisPoints,
    discountBasisPoints: Value(item.discount.basisPoints),
    sortOrder: Value(sortOrder),
  );

  Future<Offer> _toDomain(OfferRow row) async {
    final itemRows =
        await (_db.select(_db.offerItems)
              ..where((i) => i.offerId.equals(row.id))
              ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
            .get();

    return Offer(
      id: row.id,
      customerId: row.customerId,
      customerName: row.customerName,
      customerContactPerson: row.customerContactPerson,
      currency: Currency.fromCode(row.currencyCode),
      generalDiscount: Percent.fromBasisPoints(row.generalDiscountBasisPoints),
      notes: row.notes,
      items: itemRows.map(_itemToDomain).toList(),
      createdAt: row.createdAt,
    );
  }

  OfferItem _itemToDomain(OfferItemRow row) => OfferItem(
    id: row.id,
    productId: row.productId,
    productName: row.productName,
    unitPrice: Money(row.unitPriceMinor),
    quantity: row.quantity,
    vatRate: Percent.fromBasisPoints(row.vatRateBasisPoints),
    discount: Percent.fromBasisPoints(row.discountBasisPoints),
  );

  static String? _nullIfBlank(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
