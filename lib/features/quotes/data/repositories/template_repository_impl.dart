import 'package:drift/drift.dart';
import 'package:isimcebimde/core/database/app_database.dart';
import 'package:isimcebimde/core/errors/failure.dart';
import 'package:isimcebimde/core/utils/money.dart';
import 'package:isimcebimde/core/utils/quantity.dart';
import 'package:isimcebimde/features/quotes/domain/entities/currency.dart';
import 'package:isimcebimde/features/quotes/domain/entities/offer_item.dart';
import 'package:isimcebimde/features/quotes/domain/entities/template.dart';
import 'package:isimcebimde/features/quotes/domain/repositories/template_repository.dart';
import 'package:sqlite3/common.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  const TemplateRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<Template>> watchAll() {
    final query = _db.select(_db.templates)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    // `create`/`update` her zaman `templates` satırını da yazar, bu yüzden bu
    // stream satır değişikliklerinde de kendiliğinden yeniden tetiklenir.
    return query
        .watch()
        .asyncMap((rows) => Future.wait(rows.map(_toDomain)))
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.template,
            cause: e,
          ),
        );
  }

  @override
  Stream<Template?> watchById(int id) {
    final query = _db.select(_db.templates)..where((t) => t.id.equals(id));

    return query
        .watchSingleOrNull()
        .asyncMap((row) async => row == null ? null : await _toDomain(row))
        .handleError(
          (Object e) => throw DatabaseFailure(
            DataOperation.read,
            EntityKind.template,
            cause: e,
          ),
        );
  }

  @override
  Future<int> create(Template template) async {
    _validate(template);
    try {
      return await _db.transaction(() async {
        final id = await _db.into(_db.templates).insert(_toCompanion(template));
        await _insertItems(id, template.items);
        return id;
      });
    } on SqliteException catch (e) {
      // Benzersizlik kısıtı veritabanı seviyesinde; yarış durumunda da tutar.
      if (e.extendedResultCode == _uniqueConstraintCode) {
        throw DuplicateTemplateNameFailure(template.name.trim(), cause: e);
      }
      throw DatabaseFailure(
        DataOperation.create,
        EntityKind.template,
        cause: e,
      );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.create,
        EntityKind.template,
        cause: e,
      );
    }
  }

  @override
  Future<void> update(Template template) async {
    final id = template.id;
    if (id == null) throw const UnsavedEntityFailure(EntityKind.template);
    _validate(template);

    try {
      await _db.transaction(() async {
        await (_db.update(
          _db.templates,
        )..where((t) => t.id.equals(id))).write(_toCompanion(template));
        // Satırlar diff'lenmez: silinip verilen listeyle yeniden yazılır
        // (OfferRepositoryImpl.update ile aynı desen).
        await (_db.delete(
          _db.templateItems,
        )..where((i) => i.templateId.equals(id))).go();
        await _insertItems(id, template.items);
      });
    } on SqliteException catch (e) {
      if (e.extendedResultCode == _uniqueConstraintCode) {
        throw DuplicateTemplateNameFailure(template.name.trim(), cause: e);
      }
      throw DatabaseFailure(
        DataOperation.update,
        EntityKind.template,
        cause: e,
      );
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.update,
        EntityKind.template,
        cause: e,
      );
    }
  }

  @override
  Future<void> delete(int id) async {
    try {
      // TemplateItems, `ON DELETE CASCADE` ile birlikte silinir.
      await (_db.delete(_db.templates)..where((t) => t.id.equals(id))).go();
    } on Object catch (e) {
      throw DatabaseFailure(
        DataOperation.delete,
        EntityKind.template,
        cause: e,
      );
    }
  }

  /// SQLITE_CONSTRAINT_UNIQUE
  static const int _uniqueConstraintCode = 2067;

  /// İş kuralları domain sınırında zorunlu kılınır; UI'ın doğrulaması
  /// yeterli değildir (repository başka yerden de çağrılabilir).
  void _validate(Template template) {
    if (template.name.trim().isEmpty) {
      throw const EmptyNameFailure(EntityKind.template);
    }
    if (template.items.isEmpty) {
      throw const EmptyTemplateFailure();
    }
  }

  Future<void> _insertItems(int templateId, List<OfferItem> items) async {
    for (var i = 0; i < items.length; i++) {
      await _db
          .into(_db.templateItems)
          .insert(_itemCompanion(templateId, items[i], sortOrder: i));
    }
  }

  TemplatesCompanion _toCompanion(Template template) =>
      TemplatesCompanion.insert(
        name: template.name.trim(),
        currencyCode: Value(template.currency.code),
        generalDiscountBasisPoints: Value(template.generalDiscount.basisPoints),
        notes: Value(_nullIfBlank(template.notes)),
      );

  TemplateItemsCompanion _itemCompanion(
    int templateId,
    OfferItem item, {
    required int sortOrder,
  }) => TemplateItemsCompanion.insert(
    templateId: templateId,
    productId: Value(item.productId),
    productName: item.productName,
    unitPriceMinor: item.unitPrice.minor,
    quantity: item.quantity.thousandths,
    unit: Value(item.unit),
    vatRateBasisPoints: item.vatRate.basisPoints,
    discountBasisPoints: Value(item.discount.basisPoints),
    sortOrder: Value(sortOrder),
  );

  Future<Template> _toDomain(TemplateRow row) async {
    final itemRows =
        await (_db.select(_db.templateItems)
              ..where((i) => i.templateId.equals(row.id))
              ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
            .get();

    return Template(
      id: row.id,
      name: row.name,
      currency: Currency.fromCode(row.currencyCode),
      generalDiscount: Percent.fromBasisPoints(row.generalDiscountBasisPoints),
      notes: row.notes,
      items: itemRows.map(_itemToDomain).toList(),
    );
  }

  OfferItem _itemToDomain(TemplateItemRow row) => OfferItem(
    id: row.id,
    productId: row.productId,
    productName: row.productName,
    unitPrice: Money(row.unitPriceMinor),
    quantity: Quantity.fromThousandths(row.quantity),
    unit: row.unit,
    vatRate: Percent.fromBasisPoints(row.vatRateBasisPoints),
    discount: Percent.fromBasisPoints(row.discountBasisPoints),
  );

  static String? _nullIfBlank(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }
}
