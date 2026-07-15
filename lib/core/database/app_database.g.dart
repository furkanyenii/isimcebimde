// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final int id;
  final String name;
  final DateTime createdAt;
  const CategoryRow({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryRow copyWith({int? id, String? name, DateTime? createdAt}) =>
      CategoryRow(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMinorMeta = const VerificationMeta(
    'priceMinor',
  );
  @override
  late final GeneratedColumn<int> priceMinor = GeneratedColumn<int>(
    'price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _vatRateBasisPointsMeta =
      const VerificationMeta('vatRateBasisPoints');
  @override
  late final GeneratedColumn<int> vatRateBasisPoints = GeneratedColumn<int>(
    'vat_rate_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    priceMinor,
    vatRateBasisPoints,
    categoryId,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price_minor')) {
      context.handle(
        _priceMinorMeta,
        priceMinor.isAcceptableOrUnknown(data['price_minor']!, _priceMinorMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMinorMeta);
    }
    if (data.containsKey('vat_rate_basis_points')) {
      context.handle(
        _vatRateBasisPointsMeta,
        vatRateBasisPoints.isAcceptableOrUnknown(
          data['vat_rate_basis_points']!,
          _vatRateBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      priceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_minor'],
      )!,
      vatRateBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vat_rate_basis_points'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final int id;
  final String name;
  final int priceMinor;
  final int vatRateBasisPoints;
  final int categoryId;
  final bool isArchived;
  final DateTime createdAt;
  const ProductRow({
    required this.id,
    required this.name,
    required this.priceMinor,
    required this.vatRateBasisPoints,
    required this.categoryId,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price_minor'] = Variable<int>(priceMinor);
    map['vat_rate_basis_points'] = Variable<int>(vatRateBasisPoints);
    map['category_id'] = Variable<int>(categoryId);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      priceMinor: Value(priceMinor),
      vatRateBasisPoints: Value(vatRateBasisPoints),
      categoryId: Value(categoryId),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      priceMinor: serializer.fromJson<int>(json['priceMinor']),
      vatRateBasisPoints: serializer.fromJson<int>(json['vatRateBasisPoints']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'priceMinor': serializer.toJson<int>(priceMinor),
      'vatRateBasisPoints': serializer.toJson<int>(vatRateBasisPoints),
      'categoryId': serializer.toJson<int>(categoryId),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductRow copyWith({
    int? id,
    String? name,
    int? priceMinor,
    int? vatRateBasisPoints,
    int? categoryId,
    bool? isArchived,
    DateTime? createdAt,
  }) => ProductRow(
    id: id ?? this.id,
    name: name ?? this.name,
    priceMinor: priceMinor ?? this.priceMinor,
    vatRateBasisPoints: vatRateBasisPoints ?? this.vatRateBasisPoints,
    categoryId: categoryId ?? this.categoryId,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      priceMinor: data.priceMinor.present
          ? data.priceMinor.value
          : this.priceMinor,
      vatRateBasisPoints: data.vatRateBasisPoints.present
          ? data.vatRateBasisPoints.value
          : this.vatRateBasisPoints,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('vatRateBasisPoints: $vatRateBasisPoints, ')
          ..write('categoryId: $categoryId, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    priceMinor,
    vatRateBasisPoints,
    categoryId,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.priceMinor == this.priceMinor &&
          other.vatRateBasisPoints == this.vatRateBasisPoints &&
          other.categoryId == this.categoryId &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> priceMinor;
  final Value<int> vatRateBasisPoints;
  final Value<int> categoryId;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.priceMinor = const Value.absent(),
    this.vatRateBasisPoints = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int priceMinor,
    this.vatRateBasisPoints = const Value.absent(),
    required int categoryId,
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       priceMinor = Value(priceMinor),
       categoryId = Value(categoryId);
  static Insertable<ProductRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? priceMinor,
    Expression<int>? vatRateBasisPoints,
    Expression<int>? categoryId,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (priceMinor != null) 'price_minor': priceMinor,
      if (vatRateBasisPoints != null)
        'vat_rate_basis_points': vatRateBasisPoints,
      if (categoryId != null) 'category_id': categoryId,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? priceMinor,
    Value<int>? vatRateBasisPoints,
    Value<int>? categoryId,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      priceMinor: priceMinor ?? this.priceMinor,
      vatRateBasisPoints: vatRateBasisPoints ?? this.vatRateBasisPoints,
      categoryId: categoryId ?? this.categoryId,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (priceMinor.present) {
      map['price_minor'] = Variable<int>(priceMinor.value);
    }
    if (vatRateBasisPoints.present) {
      map['vat_rate_basis_points'] = Variable<int>(vatRateBasisPoints.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('priceMinor: $priceMinor, ')
          ..write('vatRateBasisPoints: $vatRateBasisPoints, ')
          ..write('categoryId: $categoryId, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactPersonMeta = const VerificationMeta(
    'contactPerson',
  );
  @override
  late final GeneratedColumn<String> contactPerson = GeneratedColumn<String>(
    'contact_person',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 32),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxOfficeMeta = const VerificationMeta(
    'taxOffice',
  );
  @override
  late final GeneratedColumn<String> taxOffice = GeneratedColumn<String>(
    'tax_office',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _taxNumberMeta = const VerificationMeta(
    'taxNumber',
  );
  @override
  late final GeneratedColumn<String> taxNumber = GeneratedColumn<String>(
    'tax_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1000),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    name,
    contactPerson,
    phone,
    email,
    address,
    taxOffice,
    taxNumber,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact_person')) {
      context.handle(
        _contactPersonMeta,
        contactPerson.isAcceptableOrUnknown(
          data['contact_person']!,
          _contactPersonMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('tax_office')) {
      context.handle(
        _taxOfficeMeta,
        taxOffice.isAcceptableOrUnknown(data['tax_office']!, _taxOfficeMeta),
      );
    }
    if (data.containsKey('tax_number')) {
      context.handle(
        _taxNumberMeta,
        taxNumber.isAcceptableOrUnknown(data['tax_number']!, _taxNumberMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      contactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact_person'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      taxOffice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_office'],
      ),
      taxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_number'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerRow extends DataClass implements Insertable<CustomerRow> {
  final int id;
  final String type;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? email;
  final String? address;
  final String? taxOffice;

  /// Vergi/kimlik no serbest metindir: rakam, harf (büyük/küçük) içerebilir ve
  /// uzunluğu ülkeye göre değişir (TCKN 11, vergi no 10, AB VAT farklı). Bu
  /// yüzden **uzunluk sınırı yoktur**; biçim kontrolü de yapılmaz.
  final String? taxNumber;
  final String? notes;
  final DateTime createdAt;
  const CustomerRow({
    required this.id,
    required this.type,
    required this.name,
    this.contactPerson,
    this.phone,
    this.email,
    this.address,
    this.taxOffice,
    this.taxNumber,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || contactPerson != null) {
      map['contact_person'] = Variable<String>(contactPerson);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || taxOffice != null) {
      map['tax_office'] = Variable<String>(taxOffice);
    }
    if (!nullToAbsent || taxNumber != null) {
      map['tax_number'] = Variable<String>(taxNumber);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      contactPerson: contactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(contactPerson),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      taxOffice: taxOffice == null && nullToAbsent
          ? const Value.absent()
          : Value(taxOffice),
      taxNumber: taxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(taxNumber),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory CustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      contactPerson: serializer.fromJson<String?>(json['contactPerson']),
      phone: serializer.fromJson<String?>(json['phone']),
      email: serializer.fromJson<String?>(json['email']),
      address: serializer.fromJson<String?>(json['address']),
      taxOffice: serializer.fromJson<String?>(json['taxOffice']),
      taxNumber: serializer.fromJson<String?>(json['taxNumber']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'contactPerson': serializer.toJson<String?>(contactPerson),
      'phone': serializer.toJson<String?>(phone),
      'email': serializer.toJson<String?>(email),
      'address': serializer.toJson<String?>(address),
      'taxOffice': serializer.toJson<String?>(taxOffice),
      'taxNumber': serializer.toJson<String?>(taxNumber),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomerRow copyWith({
    int? id,
    String? type,
    String? name,
    Value<String?> contactPerson = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<String?> taxOffice = const Value.absent(),
    Value<String?> taxNumber = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => CustomerRow(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    contactPerson: contactPerson.present
        ? contactPerson.value
        : this.contactPerson,
    phone: phone.present ? phone.value : this.phone,
    email: email.present ? email.value : this.email,
    address: address.present ? address.value : this.address,
    taxOffice: taxOffice.present ? taxOffice.value : this.taxOffice,
    taxNumber: taxNumber.present ? taxNumber.value : this.taxNumber,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  CustomerRow copyWithCompanion(CustomersCompanion data) {
    return CustomerRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      contactPerson: data.contactPerson.present
          ? data.contactPerson.value
          : this.contactPerson,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      taxOffice: data.taxOffice.present ? data.taxOffice.value : this.taxOffice,
      taxNumber: data.taxNumber.present ? data.taxNumber.value : this.taxNumber,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('taxOffice: $taxOffice, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    name,
    contactPerson,
    phone,
    email,
    address,
    taxOffice,
    taxNumber,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.contactPerson == this.contactPerson &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.address == this.address &&
          other.taxOffice == this.taxOffice &&
          other.taxNumber == this.taxNumber &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> contactPerson;
  final Value<String?> phone;
  final Value<String?> email;
  final Value<String?> address;
  final Value<String?> taxOffice;
  final Value<String?> taxNumber;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.taxOffice = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String name,
    this.contactPerson = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.taxOffice = const Value.absent(),
    this.taxNumber = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : type = Value(type),
       name = Value(name);
  static Insertable<CustomerRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? contactPerson,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? taxOffice,
    Expression<String>? taxNumber,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (contactPerson != null) 'contact_person': contactPerson,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (taxOffice != null) 'tax_office': taxOffice,
      if (taxNumber != null) 'tax_number': taxNumber,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? name,
    Value<String?>? contactPerson,
    Value<String?>? phone,
    Value<String?>? email,
    Value<String?>? address,
    Value<String?>? taxOffice,
    Value<String?>? taxNumber,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      taxOffice: taxOffice ?? this.taxOffice,
      taxNumber: taxNumber ?? this.taxNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactPerson.present) {
      map['contact_person'] = Variable<String>(contactPerson.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (taxOffice.present) {
      map['tax_office'] = Variable<String>(taxOffice.value);
    }
    if (taxNumber.present) {
      map['tax_number'] = Variable<String>(taxNumber.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactPerson: $contactPerson, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('taxOffice: $taxOffice, ')
          ..write('taxNumber: $taxNumber, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 8),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 16,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _companyNameMeta = const VerificationMeta(
    'companyName',
  );
  @override
  late final GeneratedColumn<String> companyName = GeneratedColumn<String>(
    'company_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyLogoPathMeta = const VerificationMeta(
    'companyLogoPath',
  );
  @override
  late final GeneratedColumn<String> companyLogoPath = GeneratedColumn<String>(
    'company_logo_path',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyPhoneMeta = const VerificationMeta(
    'companyPhone',
  );
  @override
  late final GeneratedColumn<String> companyPhone = GeneratedColumn<String>(
    'company_phone',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 32),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyEmailMeta = const VerificationMeta(
    'companyEmail',
  );
  @override
  late final GeneratedColumn<String> companyEmail = GeneratedColumn<String>(
    'company_email',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyWebsiteMeta = const VerificationMeta(
    'companyWebsite',
  );
  @override
  late final GeneratedColumn<String> companyWebsite = GeneratedColumn<String>(
    'company_website',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyAddressMeta = const VerificationMeta(
    'companyAddress',
  );
  @override
  late final GeneratedColumn<String> companyAddress = GeneratedColumn<String>(
    'company_address',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyTaxOfficeMeta = const VerificationMeta(
    'companyTaxOffice',
  );
  @override
  late final GeneratedColumn<String> companyTaxOffice = GeneratedColumn<String>(
    'company_tax_office',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyTaxNumberMeta = const VerificationMeta(
    'companyTaxNumber',
  );
  @override
  late final GeneratedColumn<String> companyTaxNumber = GeneratedColumn<String>(
    'company_tax_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preparerFirstNameMeta = const VerificationMeta(
    'preparerFirstName',
  );
  @override
  late final GeneratedColumn<String> preparerFirstName =
      GeneratedColumn<String>(
        'preparer_first_name',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _preparerLastNameMeta = const VerificationMeta(
    'preparerLastName',
  );
  @override
  late final GeneratedColumn<String> preparerLastName = GeneratedColumn<String>(
    'preparer_last_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preparerTitleMeta = const VerificationMeta(
    'preparerTitle',
  );
  @override
  late final GeneratedColumn<String> preparerTitle = GeneratedColumn<String>(
    'preparer_title',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preparerEmailMeta = const VerificationMeta(
    'preparerEmail',
  );
  @override
  late final GeneratedColumn<String> preparerEmail = GeneratedColumn<String>(
    'preparer_email',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _preparerPhoneMeta = const VerificationMeta(
    'preparerPhone',
  );
  @override
  late final GeneratedColumn<String> preparerPhone = GeneratedColumn<String>(
    'preparer_phone',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 32),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    languageCode,
    themeMode,
    companyName,
    companyLogoPath,
    companyPhone,
    companyEmail,
    companyWebsite,
    companyAddress,
    companyTaxOffice,
    companyTaxNumber,
    preparerFirstName,
    preparerLastName,
    preparerTitle,
    preparerEmail,
    preparerPhone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('company_name')) {
      context.handle(
        _companyNameMeta,
        companyName.isAcceptableOrUnknown(
          data['company_name']!,
          _companyNameMeta,
        ),
      );
    }
    if (data.containsKey('company_logo_path')) {
      context.handle(
        _companyLogoPathMeta,
        companyLogoPath.isAcceptableOrUnknown(
          data['company_logo_path']!,
          _companyLogoPathMeta,
        ),
      );
    }
    if (data.containsKey('company_phone')) {
      context.handle(
        _companyPhoneMeta,
        companyPhone.isAcceptableOrUnknown(
          data['company_phone']!,
          _companyPhoneMeta,
        ),
      );
    }
    if (data.containsKey('company_email')) {
      context.handle(
        _companyEmailMeta,
        companyEmail.isAcceptableOrUnknown(
          data['company_email']!,
          _companyEmailMeta,
        ),
      );
    }
    if (data.containsKey('company_website')) {
      context.handle(
        _companyWebsiteMeta,
        companyWebsite.isAcceptableOrUnknown(
          data['company_website']!,
          _companyWebsiteMeta,
        ),
      );
    }
    if (data.containsKey('company_address')) {
      context.handle(
        _companyAddressMeta,
        companyAddress.isAcceptableOrUnknown(
          data['company_address']!,
          _companyAddressMeta,
        ),
      );
    }
    if (data.containsKey('company_tax_office')) {
      context.handle(
        _companyTaxOfficeMeta,
        companyTaxOffice.isAcceptableOrUnknown(
          data['company_tax_office']!,
          _companyTaxOfficeMeta,
        ),
      );
    }
    if (data.containsKey('company_tax_number')) {
      context.handle(
        _companyTaxNumberMeta,
        companyTaxNumber.isAcceptableOrUnknown(
          data['company_tax_number']!,
          _companyTaxNumberMeta,
        ),
      );
    }
    if (data.containsKey('preparer_first_name')) {
      context.handle(
        _preparerFirstNameMeta,
        preparerFirstName.isAcceptableOrUnknown(
          data['preparer_first_name']!,
          _preparerFirstNameMeta,
        ),
      );
    }
    if (data.containsKey('preparer_last_name')) {
      context.handle(
        _preparerLastNameMeta,
        preparerLastName.isAcceptableOrUnknown(
          data['preparer_last_name']!,
          _preparerLastNameMeta,
        ),
      );
    }
    if (data.containsKey('preparer_title')) {
      context.handle(
        _preparerTitleMeta,
        preparerTitle.isAcceptableOrUnknown(
          data['preparer_title']!,
          _preparerTitleMeta,
        ),
      );
    }
    if (data.containsKey('preparer_email')) {
      context.handle(
        _preparerEmailMeta,
        preparerEmail.isAcceptableOrUnknown(
          data['preparer_email']!,
          _preparerEmailMeta,
        ),
      );
    }
    if (data.containsKey('preparer_phone')) {
      context.handle(
        _preparerPhoneMeta,
        preparerPhone.isAcceptableOrUnknown(
          data['preparer_phone']!,
          _preparerPhoneMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      ),
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      companyName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_name'],
      ),
      companyLogoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_logo_path'],
      ),
      companyPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_phone'],
      ),
      companyEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_email'],
      ),
      companyWebsite: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_website'],
      ),
      companyAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_address'],
      ),
      companyTaxOffice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_tax_office'],
      ),
      companyTaxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company_tax_number'],
      ),
      preparerFirstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparer_first_name'],
      ),
      preparerLastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparer_last_name'],
      ),
      preparerTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparer_title'],
      ),
      preparerEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparer_email'],
      ),
      preparerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}preparer_phone'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingsRow extends DataClass implements Insertable<SettingsRow> {
  final int id;
  final String? languageCode;
  final String themeMode;
  final String? companyName;
  final String? companyLogoPath;
  final String? companyPhone;
  final String? companyEmail;
  final String? companyWebsite;
  final String? companyAddress;
  final String? companyTaxOffice;

  /// Vergi no serbest metindir (bkz. `Customers.taxNumber`): uzunluk/biçim
  /// sınırı yoktur.
  final String? companyTaxNumber;

  /// Teklifi hazırlayan kişi (bkz. `PreparerInfo`). Firma bilgisinden ayrıdır:
  /// aynı firmada birden çok satış temsilcisi teklif hazırlar. Hepsi opsiyonel;
  /// PDF'in altına yalnızca doldurulanlar basılır.
  final String? preparerFirstName;
  final String? preparerLastName;
  final String? preparerTitle;
  final String? preparerEmail;
  final String? preparerPhone;
  const SettingsRow({
    required this.id,
    this.languageCode,
    required this.themeMode,
    this.companyName,
    this.companyLogoPath,
    this.companyPhone,
    this.companyEmail,
    this.companyWebsite,
    this.companyAddress,
    this.companyTaxOffice,
    this.companyTaxNumber,
    this.preparerFirstName,
    this.preparerLastName,
    this.preparerTitle,
    this.preparerEmail,
    this.preparerPhone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || languageCode != null) {
      map['language_code'] = Variable<String>(languageCode);
    }
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || companyName != null) {
      map['company_name'] = Variable<String>(companyName);
    }
    if (!nullToAbsent || companyLogoPath != null) {
      map['company_logo_path'] = Variable<String>(companyLogoPath);
    }
    if (!nullToAbsent || companyPhone != null) {
      map['company_phone'] = Variable<String>(companyPhone);
    }
    if (!nullToAbsent || companyEmail != null) {
      map['company_email'] = Variable<String>(companyEmail);
    }
    if (!nullToAbsent || companyWebsite != null) {
      map['company_website'] = Variable<String>(companyWebsite);
    }
    if (!nullToAbsent || companyAddress != null) {
      map['company_address'] = Variable<String>(companyAddress);
    }
    if (!nullToAbsent || companyTaxOffice != null) {
      map['company_tax_office'] = Variable<String>(companyTaxOffice);
    }
    if (!nullToAbsent || companyTaxNumber != null) {
      map['company_tax_number'] = Variable<String>(companyTaxNumber);
    }
    if (!nullToAbsent || preparerFirstName != null) {
      map['preparer_first_name'] = Variable<String>(preparerFirstName);
    }
    if (!nullToAbsent || preparerLastName != null) {
      map['preparer_last_name'] = Variable<String>(preparerLastName);
    }
    if (!nullToAbsent || preparerTitle != null) {
      map['preparer_title'] = Variable<String>(preparerTitle);
    }
    if (!nullToAbsent || preparerEmail != null) {
      map['preparer_email'] = Variable<String>(preparerEmail);
    }
    if (!nullToAbsent || preparerPhone != null) {
      map['preparer_phone'] = Variable<String>(preparerPhone);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      languageCode: languageCode == null && nullToAbsent
          ? const Value.absent()
          : Value(languageCode),
      themeMode: Value(themeMode),
      companyName: companyName == null && nullToAbsent
          ? const Value.absent()
          : Value(companyName),
      companyLogoPath: companyLogoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(companyLogoPath),
      companyPhone: companyPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(companyPhone),
      companyEmail: companyEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(companyEmail),
      companyWebsite: companyWebsite == null && nullToAbsent
          ? const Value.absent()
          : Value(companyWebsite),
      companyAddress: companyAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(companyAddress),
      companyTaxOffice: companyTaxOffice == null && nullToAbsent
          ? const Value.absent()
          : Value(companyTaxOffice),
      companyTaxNumber: companyTaxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(companyTaxNumber),
      preparerFirstName: preparerFirstName == null && nullToAbsent
          ? const Value.absent()
          : Value(preparerFirstName),
      preparerLastName: preparerLastName == null && nullToAbsent
          ? const Value.absent()
          : Value(preparerLastName),
      preparerTitle: preparerTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(preparerTitle),
      preparerEmail: preparerEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(preparerEmail),
      preparerPhone: preparerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(preparerPhone),
    );
  }

  factory SettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsRow(
      id: serializer.fromJson<int>(json['id']),
      languageCode: serializer.fromJson<String?>(json['languageCode']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      companyName: serializer.fromJson<String?>(json['companyName']),
      companyLogoPath: serializer.fromJson<String?>(json['companyLogoPath']),
      companyPhone: serializer.fromJson<String?>(json['companyPhone']),
      companyEmail: serializer.fromJson<String?>(json['companyEmail']),
      companyWebsite: serializer.fromJson<String?>(json['companyWebsite']),
      companyAddress: serializer.fromJson<String?>(json['companyAddress']),
      companyTaxOffice: serializer.fromJson<String?>(json['companyTaxOffice']),
      companyTaxNumber: serializer.fromJson<String?>(json['companyTaxNumber']),
      preparerFirstName: serializer.fromJson<String?>(
        json['preparerFirstName'],
      ),
      preparerLastName: serializer.fromJson<String?>(json['preparerLastName']),
      preparerTitle: serializer.fromJson<String?>(json['preparerTitle']),
      preparerEmail: serializer.fromJson<String?>(json['preparerEmail']),
      preparerPhone: serializer.fromJson<String?>(json['preparerPhone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'languageCode': serializer.toJson<String?>(languageCode),
      'themeMode': serializer.toJson<String>(themeMode),
      'companyName': serializer.toJson<String?>(companyName),
      'companyLogoPath': serializer.toJson<String?>(companyLogoPath),
      'companyPhone': serializer.toJson<String?>(companyPhone),
      'companyEmail': serializer.toJson<String?>(companyEmail),
      'companyWebsite': serializer.toJson<String?>(companyWebsite),
      'companyAddress': serializer.toJson<String?>(companyAddress),
      'companyTaxOffice': serializer.toJson<String?>(companyTaxOffice),
      'companyTaxNumber': serializer.toJson<String?>(companyTaxNumber),
      'preparerFirstName': serializer.toJson<String?>(preparerFirstName),
      'preparerLastName': serializer.toJson<String?>(preparerLastName),
      'preparerTitle': serializer.toJson<String?>(preparerTitle),
      'preparerEmail': serializer.toJson<String?>(preparerEmail),
      'preparerPhone': serializer.toJson<String?>(preparerPhone),
    };
  }

  SettingsRow copyWith({
    int? id,
    Value<String?> languageCode = const Value.absent(),
    String? themeMode,
    Value<String?> companyName = const Value.absent(),
    Value<String?> companyLogoPath = const Value.absent(),
    Value<String?> companyPhone = const Value.absent(),
    Value<String?> companyEmail = const Value.absent(),
    Value<String?> companyWebsite = const Value.absent(),
    Value<String?> companyAddress = const Value.absent(),
    Value<String?> companyTaxOffice = const Value.absent(),
    Value<String?> companyTaxNumber = const Value.absent(),
    Value<String?> preparerFirstName = const Value.absent(),
    Value<String?> preparerLastName = const Value.absent(),
    Value<String?> preparerTitle = const Value.absent(),
    Value<String?> preparerEmail = const Value.absent(),
    Value<String?> preparerPhone = const Value.absent(),
  }) => SettingsRow(
    id: id ?? this.id,
    languageCode: languageCode.present ? languageCode.value : this.languageCode,
    themeMode: themeMode ?? this.themeMode,
    companyName: companyName.present ? companyName.value : this.companyName,
    companyLogoPath: companyLogoPath.present
        ? companyLogoPath.value
        : this.companyLogoPath,
    companyPhone: companyPhone.present ? companyPhone.value : this.companyPhone,
    companyEmail: companyEmail.present ? companyEmail.value : this.companyEmail,
    companyWebsite: companyWebsite.present
        ? companyWebsite.value
        : this.companyWebsite,
    companyAddress: companyAddress.present
        ? companyAddress.value
        : this.companyAddress,
    companyTaxOffice: companyTaxOffice.present
        ? companyTaxOffice.value
        : this.companyTaxOffice,
    companyTaxNumber: companyTaxNumber.present
        ? companyTaxNumber.value
        : this.companyTaxNumber,
    preparerFirstName: preparerFirstName.present
        ? preparerFirstName.value
        : this.preparerFirstName,
    preparerLastName: preparerLastName.present
        ? preparerLastName.value
        : this.preparerLastName,
    preparerTitle: preparerTitle.present
        ? preparerTitle.value
        : this.preparerTitle,
    preparerEmail: preparerEmail.present
        ? preparerEmail.value
        : this.preparerEmail,
    preparerPhone: preparerPhone.present
        ? preparerPhone.value
        : this.preparerPhone,
  );
  SettingsRow copyWithCompanion(SettingsCompanion data) {
    return SettingsRow(
      id: data.id.present ? data.id.value : this.id,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      companyName: data.companyName.present
          ? data.companyName.value
          : this.companyName,
      companyLogoPath: data.companyLogoPath.present
          ? data.companyLogoPath.value
          : this.companyLogoPath,
      companyPhone: data.companyPhone.present
          ? data.companyPhone.value
          : this.companyPhone,
      companyEmail: data.companyEmail.present
          ? data.companyEmail.value
          : this.companyEmail,
      companyWebsite: data.companyWebsite.present
          ? data.companyWebsite.value
          : this.companyWebsite,
      companyAddress: data.companyAddress.present
          ? data.companyAddress.value
          : this.companyAddress,
      companyTaxOffice: data.companyTaxOffice.present
          ? data.companyTaxOffice.value
          : this.companyTaxOffice,
      companyTaxNumber: data.companyTaxNumber.present
          ? data.companyTaxNumber.value
          : this.companyTaxNumber,
      preparerFirstName: data.preparerFirstName.present
          ? data.preparerFirstName.value
          : this.preparerFirstName,
      preparerLastName: data.preparerLastName.present
          ? data.preparerLastName.value
          : this.preparerLastName,
      preparerTitle: data.preparerTitle.present
          ? data.preparerTitle.value
          : this.preparerTitle,
      preparerEmail: data.preparerEmail.present
          ? data.preparerEmail.value
          : this.preparerEmail,
      preparerPhone: data.preparerPhone.present
          ? data.preparerPhone.value
          : this.preparerPhone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsRow(')
          ..write('id: $id, ')
          ..write('languageCode: $languageCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('companyName: $companyName, ')
          ..write('companyLogoPath: $companyLogoPath, ')
          ..write('companyPhone: $companyPhone, ')
          ..write('companyEmail: $companyEmail, ')
          ..write('companyWebsite: $companyWebsite, ')
          ..write('companyAddress: $companyAddress, ')
          ..write('companyTaxOffice: $companyTaxOffice, ')
          ..write('companyTaxNumber: $companyTaxNumber, ')
          ..write('preparerFirstName: $preparerFirstName, ')
          ..write('preparerLastName: $preparerLastName, ')
          ..write('preparerTitle: $preparerTitle, ')
          ..write('preparerEmail: $preparerEmail, ')
          ..write('preparerPhone: $preparerPhone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    languageCode,
    themeMode,
    companyName,
    companyLogoPath,
    companyPhone,
    companyEmail,
    companyWebsite,
    companyAddress,
    companyTaxOffice,
    companyTaxNumber,
    preparerFirstName,
    preparerLastName,
    preparerTitle,
    preparerEmail,
    preparerPhone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsRow &&
          other.id == this.id &&
          other.languageCode == this.languageCode &&
          other.themeMode == this.themeMode &&
          other.companyName == this.companyName &&
          other.companyLogoPath == this.companyLogoPath &&
          other.companyPhone == this.companyPhone &&
          other.companyEmail == this.companyEmail &&
          other.companyWebsite == this.companyWebsite &&
          other.companyAddress == this.companyAddress &&
          other.companyTaxOffice == this.companyTaxOffice &&
          other.companyTaxNumber == this.companyTaxNumber &&
          other.preparerFirstName == this.preparerFirstName &&
          other.preparerLastName == this.preparerLastName &&
          other.preparerTitle == this.preparerTitle &&
          other.preparerEmail == this.preparerEmail &&
          other.preparerPhone == this.preparerPhone);
}

class SettingsCompanion extends UpdateCompanion<SettingsRow> {
  final Value<int> id;
  final Value<String?> languageCode;
  final Value<String> themeMode;
  final Value<String?> companyName;
  final Value<String?> companyLogoPath;
  final Value<String?> companyPhone;
  final Value<String?> companyEmail;
  final Value<String?> companyWebsite;
  final Value<String?> companyAddress;
  final Value<String?> companyTaxOffice;
  final Value<String?> companyTaxNumber;
  final Value<String?> preparerFirstName;
  final Value<String?> preparerLastName;
  final Value<String?> preparerTitle;
  final Value<String?> preparerEmail;
  final Value<String?> preparerPhone;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.companyName = const Value.absent(),
    this.companyLogoPath = const Value.absent(),
    this.companyPhone = const Value.absent(),
    this.companyEmail = const Value.absent(),
    this.companyWebsite = const Value.absent(),
    this.companyAddress = const Value.absent(),
    this.companyTaxOffice = const Value.absent(),
    this.companyTaxNumber = const Value.absent(),
    this.preparerFirstName = const Value.absent(),
    this.preparerLastName = const Value.absent(),
    this.preparerTitle = const Value.absent(),
    this.preparerEmail = const Value.absent(),
    this.preparerPhone = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.companyName = const Value.absent(),
    this.companyLogoPath = const Value.absent(),
    this.companyPhone = const Value.absent(),
    this.companyEmail = const Value.absent(),
    this.companyWebsite = const Value.absent(),
    this.companyAddress = const Value.absent(),
    this.companyTaxOffice = const Value.absent(),
    this.companyTaxNumber = const Value.absent(),
    this.preparerFirstName = const Value.absent(),
    this.preparerLastName = const Value.absent(),
    this.preparerTitle = const Value.absent(),
    this.preparerEmail = const Value.absent(),
    this.preparerPhone = const Value.absent(),
  });
  static Insertable<SettingsRow> custom({
    Expression<int>? id,
    Expression<String>? languageCode,
    Expression<String>? themeMode,
    Expression<String>? companyName,
    Expression<String>? companyLogoPath,
    Expression<String>? companyPhone,
    Expression<String>? companyEmail,
    Expression<String>? companyWebsite,
    Expression<String>? companyAddress,
    Expression<String>? companyTaxOffice,
    Expression<String>? companyTaxNumber,
    Expression<String>? preparerFirstName,
    Expression<String>? preparerLastName,
    Expression<String>? preparerTitle,
    Expression<String>? preparerEmail,
    Expression<String>? preparerPhone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (languageCode != null) 'language_code': languageCode,
      if (themeMode != null) 'theme_mode': themeMode,
      if (companyName != null) 'company_name': companyName,
      if (companyLogoPath != null) 'company_logo_path': companyLogoPath,
      if (companyPhone != null) 'company_phone': companyPhone,
      if (companyEmail != null) 'company_email': companyEmail,
      if (companyWebsite != null) 'company_website': companyWebsite,
      if (companyAddress != null) 'company_address': companyAddress,
      if (companyTaxOffice != null) 'company_tax_office': companyTaxOffice,
      if (companyTaxNumber != null) 'company_tax_number': companyTaxNumber,
      if (preparerFirstName != null) 'preparer_first_name': preparerFirstName,
      if (preparerLastName != null) 'preparer_last_name': preparerLastName,
      if (preparerTitle != null) 'preparer_title': preparerTitle,
      if (preparerEmail != null) 'preparer_email': preparerEmail,
      if (preparerPhone != null) 'preparer_phone': preparerPhone,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String?>? languageCode,
    Value<String>? themeMode,
    Value<String?>? companyName,
    Value<String?>? companyLogoPath,
    Value<String?>? companyPhone,
    Value<String?>? companyEmail,
    Value<String?>? companyWebsite,
    Value<String?>? companyAddress,
    Value<String?>? companyTaxOffice,
    Value<String?>? companyTaxNumber,
    Value<String?>? preparerFirstName,
    Value<String?>? preparerLastName,
    Value<String?>? preparerTitle,
    Value<String?>? preparerEmail,
    Value<String?>? preparerPhone,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      companyName: companyName ?? this.companyName,
      companyLogoPath: companyLogoPath ?? this.companyLogoPath,
      companyPhone: companyPhone ?? this.companyPhone,
      companyEmail: companyEmail ?? this.companyEmail,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyAddress: companyAddress ?? this.companyAddress,
      companyTaxOffice: companyTaxOffice ?? this.companyTaxOffice,
      companyTaxNumber: companyTaxNumber ?? this.companyTaxNumber,
      preparerFirstName: preparerFirstName ?? this.preparerFirstName,
      preparerLastName: preparerLastName ?? this.preparerLastName,
      preparerTitle: preparerTitle ?? this.preparerTitle,
      preparerEmail: preparerEmail ?? this.preparerEmail,
      preparerPhone: preparerPhone ?? this.preparerPhone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (companyName.present) {
      map['company_name'] = Variable<String>(companyName.value);
    }
    if (companyLogoPath.present) {
      map['company_logo_path'] = Variable<String>(companyLogoPath.value);
    }
    if (companyPhone.present) {
      map['company_phone'] = Variable<String>(companyPhone.value);
    }
    if (companyEmail.present) {
      map['company_email'] = Variable<String>(companyEmail.value);
    }
    if (companyWebsite.present) {
      map['company_website'] = Variable<String>(companyWebsite.value);
    }
    if (companyAddress.present) {
      map['company_address'] = Variable<String>(companyAddress.value);
    }
    if (companyTaxOffice.present) {
      map['company_tax_office'] = Variable<String>(companyTaxOffice.value);
    }
    if (companyTaxNumber.present) {
      map['company_tax_number'] = Variable<String>(companyTaxNumber.value);
    }
    if (preparerFirstName.present) {
      map['preparer_first_name'] = Variable<String>(preparerFirstName.value);
    }
    if (preparerLastName.present) {
      map['preparer_last_name'] = Variable<String>(preparerLastName.value);
    }
    if (preparerTitle.present) {
      map['preparer_title'] = Variable<String>(preparerTitle.value);
    }
    if (preparerEmail.present) {
      map['preparer_email'] = Variable<String>(preparerEmail.value);
    }
    if (preparerPhone.present) {
      map['preparer_phone'] = Variable<String>(preparerPhone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('languageCode: $languageCode, ')
          ..write('themeMode: $themeMode, ')
          ..write('companyName: $companyName, ')
          ..write('companyLogoPath: $companyLogoPath, ')
          ..write('companyPhone: $companyPhone, ')
          ..write('companyEmail: $companyEmail, ')
          ..write('companyWebsite: $companyWebsite, ')
          ..write('companyAddress: $companyAddress, ')
          ..write('companyTaxOffice: $companyTaxOffice, ')
          ..write('companyTaxNumber: $companyTaxNumber, ')
          ..write('preparerFirstName: $preparerFirstName, ')
          ..write('preparerLastName: $preparerLastName, ')
          ..write('preparerTitle: $preparerTitle, ')
          ..write('preparerEmail: $preparerEmail, ')
          ..write('preparerPhone: $preparerPhone')
          ..write(')'))
        .toString();
  }
}

class $OffersTable extends Offers with TableInfo<$OffersTable, OfferRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerContactPersonMeta =
      const VerificationMeta('customerContactPerson');
  @override
  late final GeneratedColumn<String> customerContactPerson =
      GeneratedColumn<String>(
        'customer_contact_person',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customerPhoneMeta = const VerificationMeta(
    'customerPhone',
  );
  @override
  late final GeneratedColumn<String> customerPhone = GeneratedColumn<String>(
    'customer_phone',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 32),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerEmailMeta = const VerificationMeta(
    'customerEmail',
  );
  @override
  late final GeneratedColumn<String> customerEmail = GeneratedColumn<String>(
    'customer_email',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 200),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerAddressMeta = const VerificationMeta(
    'customerAddress',
  );
  @override
  late final GeneratedColumn<String> customerAddress = GeneratedColumn<String>(
    'customer_address',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customerTaxOfficeMeta = const VerificationMeta(
    'customerTaxOffice',
  );
  @override
  late final GeneratedColumn<String> customerTaxOffice =
      GeneratedColumn<String>(
        'customer_tax_office',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _customerTaxNumberMeta = const VerificationMeta(
    'customerTaxNumber',
  );
  @override
  late final GeneratedColumn<String> customerTaxNumber =
      GeneratedColumn<String>(
        'customer_tax_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('TRY'),
  );
  static const VerificationMeta _generalDiscountBasisPointsMeta =
      const VerificationMeta('generalDiscountBasisPoints');
  @override
  late final GeneratedColumn<int> generalDiscountBasisPoints =
      GeneratedColumn<int>(
        'general_discount_basis_points',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1000),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerId,
    customerName,
    customerContactPerson,
    customerPhone,
    customerEmail,
    customerAddress,
    customerTaxOffice,
    customerTaxNumber,
    currencyCode,
    generalDiscountBasisPoints,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfferRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_contact_person')) {
      context.handle(
        _customerContactPersonMeta,
        customerContactPerson.isAcceptableOrUnknown(
          data['customer_contact_person']!,
          _customerContactPersonMeta,
        ),
      );
    }
    if (data.containsKey('customer_phone')) {
      context.handle(
        _customerPhoneMeta,
        customerPhone.isAcceptableOrUnknown(
          data['customer_phone']!,
          _customerPhoneMeta,
        ),
      );
    }
    if (data.containsKey('customer_email')) {
      context.handle(
        _customerEmailMeta,
        customerEmail.isAcceptableOrUnknown(
          data['customer_email']!,
          _customerEmailMeta,
        ),
      );
    }
    if (data.containsKey('customer_address')) {
      context.handle(
        _customerAddressMeta,
        customerAddress.isAcceptableOrUnknown(
          data['customer_address']!,
          _customerAddressMeta,
        ),
      );
    }
    if (data.containsKey('customer_tax_office')) {
      context.handle(
        _customerTaxOfficeMeta,
        customerTaxOffice.isAcceptableOrUnknown(
          data['customer_tax_office']!,
          _customerTaxOfficeMeta,
        ),
      );
    }
    if (data.containsKey('customer_tax_number')) {
      context.handle(
        _customerTaxNumberMeta,
        customerTaxNumber.isAcceptableOrUnknown(
          data['customer_tax_number']!,
          _customerTaxNumberMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('general_discount_basis_points')) {
      context.handle(
        _generalDiscountBasisPointsMeta,
        generalDiscountBasisPoints.isAcceptableOrUnknown(
          data['general_discount_basis_points']!,
          _generalDiscountBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfferRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfferRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      customerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_name'],
      )!,
      customerContactPerson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_contact_person'],
      ),
      customerPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_phone'],
      ),
      customerEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_email'],
      ),
      customerAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_address'],
      ),
      customerTaxOffice: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_tax_office'],
      ),
      customerTaxNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_tax_number'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      generalDiscountBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}general_discount_basis_points'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OffersTable createAlias(String alias) {
    return $OffersTable(attachedDatabase, alias);
  }
}

class OfferRow extends DataClass implements Insertable<OfferRow> {
  final int id;
  final int? customerId;
  final String customerName;
  final String? customerContactPerson;
  final String? customerPhone;
  final String? customerEmail;
  final String? customerAddress;
  final String? customerTaxOffice;

  /// Vergi no serbest metindir (bkz. `Customers.taxNumber`): uzunluk sınırı yok.
  final String? customerTaxNumber;

  /// ISO 4217 kodu; yalnızca gösterim etiketi, çevrim yapılmaz (bkz. `Currency`).
  final String currencyCode;
  final int generalDiscountBasisPoints;
  final String? notes;
  final DateTime createdAt;
  const OfferRow({
    required this.id,
    this.customerId,
    required this.customerName,
    this.customerContactPerson,
    this.customerPhone,
    this.customerEmail,
    this.customerAddress,
    this.customerTaxOffice,
    this.customerTaxNumber,
    required this.currencyCode,
    required this.generalDiscountBasisPoints,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerContactPerson != null) {
      map['customer_contact_person'] = Variable<String>(customerContactPerson);
    }
    if (!nullToAbsent || customerPhone != null) {
      map['customer_phone'] = Variable<String>(customerPhone);
    }
    if (!nullToAbsent || customerEmail != null) {
      map['customer_email'] = Variable<String>(customerEmail);
    }
    if (!nullToAbsent || customerAddress != null) {
      map['customer_address'] = Variable<String>(customerAddress);
    }
    if (!nullToAbsent || customerTaxOffice != null) {
      map['customer_tax_office'] = Variable<String>(customerTaxOffice);
    }
    if (!nullToAbsent || customerTaxNumber != null) {
      map['customer_tax_number'] = Variable<String>(customerTaxNumber);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['general_discount_basis_points'] = Variable<int>(
      generalDiscountBasisPoints,
    );
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OffersCompanion toCompanion(bool nullToAbsent) {
    return OffersCompanion(
      id: Value(id),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      customerName: Value(customerName),
      customerContactPerson: customerContactPerson == null && nullToAbsent
          ? const Value.absent()
          : Value(customerContactPerson),
      customerPhone: customerPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(customerPhone),
      customerEmail: customerEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(customerEmail),
      customerAddress: customerAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(customerAddress),
      customerTaxOffice: customerTaxOffice == null && nullToAbsent
          ? const Value.absent()
          : Value(customerTaxOffice),
      customerTaxNumber: customerTaxNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(customerTaxNumber),
      currencyCode: Value(currencyCode),
      generalDiscountBasisPoints: Value(generalDiscountBasisPoints),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory OfferRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfferRow(
      id: serializer.fromJson<int>(json['id']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerContactPerson: serializer.fromJson<String?>(
        json['customerContactPerson'],
      ),
      customerPhone: serializer.fromJson<String?>(json['customerPhone']),
      customerEmail: serializer.fromJson<String?>(json['customerEmail']),
      customerAddress: serializer.fromJson<String?>(json['customerAddress']),
      customerTaxOffice: serializer.fromJson<String?>(
        json['customerTaxOffice'],
      ),
      customerTaxNumber: serializer.fromJson<String?>(
        json['customerTaxNumber'],
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      generalDiscountBasisPoints: serializer.fromJson<int>(
        json['generalDiscountBasisPoints'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerId': serializer.toJson<int?>(customerId),
      'customerName': serializer.toJson<String>(customerName),
      'customerContactPerson': serializer.toJson<String?>(
        customerContactPerson,
      ),
      'customerPhone': serializer.toJson<String?>(customerPhone),
      'customerEmail': serializer.toJson<String?>(customerEmail),
      'customerAddress': serializer.toJson<String?>(customerAddress),
      'customerTaxOffice': serializer.toJson<String?>(customerTaxOffice),
      'customerTaxNumber': serializer.toJson<String?>(customerTaxNumber),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'generalDiscountBasisPoints': serializer.toJson<int>(
        generalDiscountBasisPoints,
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OfferRow copyWith({
    int? id,
    Value<int?> customerId = const Value.absent(),
    String? customerName,
    Value<String?> customerContactPerson = const Value.absent(),
    Value<String?> customerPhone = const Value.absent(),
    Value<String?> customerEmail = const Value.absent(),
    Value<String?> customerAddress = const Value.absent(),
    Value<String?> customerTaxOffice = const Value.absent(),
    Value<String?> customerTaxNumber = const Value.absent(),
    String? currencyCode,
    int? generalDiscountBasisPoints,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => OfferRow(
    id: id ?? this.id,
    customerId: customerId.present ? customerId.value : this.customerId,
    customerName: customerName ?? this.customerName,
    customerContactPerson: customerContactPerson.present
        ? customerContactPerson.value
        : this.customerContactPerson,
    customerPhone: customerPhone.present
        ? customerPhone.value
        : this.customerPhone,
    customerEmail: customerEmail.present
        ? customerEmail.value
        : this.customerEmail,
    customerAddress: customerAddress.present
        ? customerAddress.value
        : this.customerAddress,
    customerTaxOffice: customerTaxOffice.present
        ? customerTaxOffice.value
        : this.customerTaxOffice,
    customerTaxNumber: customerTaxNumber.present
        ? customerTaxNumber.value
        : this.customerTaxNumber,
    currencyCode: currencyCode ?? this.currencyCode,
    generalDiscountBasisPoints:
        generalDiscountBasisPoints ?? this.generalDiscountBasisPoints,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  OfferRow copyWithCompanion(OffersCompanion data) {
    return OfferRow(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      customerContactPerson: data.customerContactPerson.present
          ? data.customerContactPerson.value
          : this.customerContactPerson,
      customerPhone: data.customerPhone.present
          ? data.customerPhone.value
          : this.customerPhone,
      customerEmail: data.customerEmail.present
          ? data.customerEmail.value
          : this.customerEmail,
      customerAddress: data.customerAddress.present
          ? data.customerAddress.value
          : this.customerAddress,
      customerTaxOffice: data.customerTaxOffice.present
          ? data.customerTaxOffice.value
          : this.customerTaxOffice,
      customerTaxNumber: data.customerTaxNumber.present
          ? data.customerTaxNumber.value
          : this.customerTaxNumber,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      generalDiscountBasisPoints: data.generalDiscountBasisPoints.present
          ? data.generalDiscountBasisPoints.value
          : this.generalDiscountBasisPoints,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfferRow(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerContactPerson: $customerContactPerson, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerEmail: $customerEmail, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('customerTaxOffice: $customerTaxOffice, ')
          ..write('customerTaxNumber: $customerTaxNumber, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('generalDiscountBasisPoints: $generalDiscountBasisPoints, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    customerName,
    customerContactPerson,
    customerPhone,
    customerEmail,
    customerAddress,
    customerTaxOffice,
    customerTaxNumber,
    currencyCode,
    generalDiscountBasisPoints,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfferRow &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.customerName == this.customerName &&
          other.customerContactPerson == this.customerContactPerson &&
          other.customerPhone == this.customerPhone &&
          other.customerEmail == this.customerEmail &&
          other.customerAddress == this.customerAddress &&
          other.customerTaxOffice == this.customerTaxOffice &&
          other.customerTaxNumber == this.customerTaxNumber &&
          other.currencyCode == this.currencyCode &&
          other.generalDiscountBasisPoints == this.generalDiscountBasisPoints &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class OffersCompanion extends UpdateCompanion<OfferRow> {
  final Value<int> id;
  final Value<int?> customerId;
  final Value<String> customerName;
  final Value<String?> customerContactPerson;
  final Value<String?> customerPhone;
  final Value<String?> customerEmail;
  final Value<String?> customerAddress;
  final Value<String?> customerTaxOffice;
  final Value<String?> customerTaxNumber;
  final Value<String> currencyCode;
  final Value<int> generalDiscountBasisPoints;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const OffersCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerContactPerson = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerEmail = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.customerTaxOffice = const Value.absent(),
    this.customerTaxNumber = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.generalDiscountBasisPoints = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  OffersCompanion.insert({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    required String customerName,
    this.customerContactPerson = const Value.absent(),
    this.customerPhone = const Value.absent(),
    this.customerEmail = const Value.absent(),
    this.customerAddress = const Value.absent(),
    this.customerTaxOffice = const Value.absent(),
    this.customerTaxNumber = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.generalDiscountBasisPoints = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : customerName = Value(customerName);
  static Insertable<OfferRow> custom({
    Expression<int>? id,
    Expression<int>? customerId,
    Expression<String>? customerName,
    Expression<String>? customerContactPerson,
    Expression<String>? customerPhone,
    Expression<String>? customerEmail,
    Expression<String>? customerAddress,
    Expression<String>? customerTaxOffice,
    Expression<String>? customerTaxNumber,
    Expression<String>? currencyCode,
    Expression<int>? generalDiscountBasisPoints,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (customerName != null) 'customer_name': customerName,
      if (customerContactPerson != null)
        'customer_contact_person': customerContactPerson,
      if (customerPhone != null) 'customer_phone': customerPhone,
      if (customerEmail != null) 'customer_email': customerEmail,
      if (customerAddress != null) 'customer_address': customerAddress,
      if (customerTaxOffice != null) 'customer_tax_office': customerTaxOffice,
      if (customerTaxNumber != null) 'customer_tax_number': customerTaxNumber,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (generalDiscountBasisPoints != null)
        'general_discount_basis_points': generalDiscountBasisPoints,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  OffersCompanion copyWith({
    Value<int>? id,
    Value<int?>? customerId,
    Value<String>? customerName,
    Value<String?>? customerContactPerson,
    Value<String?>? customerPhone,
    Value<String?>? customerEmail,
    Value<String?>? customerAddress,
    Value<String?>? customerTaxOffice,
    Value<String?>? customerTaxNumber,
    Value<String>? currencyCode,
    Value<int>? generalDiscountBasisPoints,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return OffersCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerContactPerson:
          customerContactPerson ?? this.customerContactPerson,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      customerAddress: customerAddress ?? this.customerAddress,
      customerTaxOffice: customerTaxOffice ?? this.customerTaxOffice,
      customerTaxNumber: customerTaxNumber ?? this.customerTaxNumber,
      currencyCode: currencyCode ?? this.currencyCode,
      generalDiscountBasisPoints:
          generalDiscountBasisPoints ?? this.generalDiscountBasisPoints,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerContactPerson.present) {
      map['customer_contact_person'] = Variable<String>(
        customerContactPerson.value,
      );
    }
    if (customerPhone.present) {
      map['customer_phone'] = Variable<String>(customerPhone.value);
    }
    if (customerEmail.present) {
      map['customer_email'] = Variable<String>(customerEmail.value);
    }
    if (customerAddress.present) {
      map['customer_address'] = Variable<String>(customerAddress.value);
    }
    if (customerTaxOffice.present) {
      map['customer_tax_office'] = Variable<String>(customerTaxOffice.value);
    }
    if (customerTaxNumber.present) {
      map['customer_tax_number'] = Variable<String>(customerTaxNumber.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (generalDiscountBasisPoints.present) {
      map['general_discount_basis_points'] = Variable<int>(
        generalDiscountBasisPoints.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OffersCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('customerName: $customerName, ')
          ..write('customerContactPerson: $customerContactPerson, ')
          ..write('customerPhone: $customerPhone, ')
          ..write('customerEmail: $customerEmail, ')
          ..write('customerAddress: $customerAddress, ')
          ..write('customerTaxOffice: $customerTaxOffice, ')
          ..write('customerTaxNumber: $customerTaxNumber, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('generalDiscountBasisPoints: $generalDiscountBasisPoints, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $OfferItemsTable extends OfferItems
    with TableInfo<$OfferItemsTable, OfferItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfferItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _offerIdMeta = const VerificationMeta(
    'offerId',
  );
  @override
  late final GeneratedColumn<int> offerId = GeneratedColumn<int>(
    'offer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES offers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMinorMeta = const VerificationMeta(
    'unitPriceMinor',
  );
  @override
  late final GeneratedColumn<int> unitPriceMinor = GeneratedColumn<int>(
    'unit_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('adet'),
  );
  static const VerificationMeta _vatRateBasisPointsMeta =
      const VerificationMeta('vatRateBasisPoints');
  @override
  late final GeneratedColumn<int> vatRateBasisPoints = GeneratedColumn<int>(
    'vat_rate_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountBasisPointsMeta =
      const VerificationMeta('discountBasisPoints');
  @override
  late final GeneratedColumn<int> discountBasisPoints = GeneratedColumn<int>(
    'discount_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    offerId,
    productId,
    productName,
    unitPriceMinor,
    quantity,
    unit,
    vatRateBasisPoints,
    discountBasisPoints,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offer_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfferItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('offer_id')) {
      context.handle(
        _offerIdMeta,
        offerId.isAcceptableOrUnknown(data['offer_id']!, _offerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_offerIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit_price_minor')) {
      context.handle(
        _unitPriceMinorMeta,
        unitPriceMinor.isAcceptableOrUnknown(
          data['unit_price_minor']!,
          _unitPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMinorMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('vat_rate_basis_points')) {
      context.handle(
        _vatRateBasisPointsMeta,
        vatRateBasisPoints.isAcceptableOrUnknown(
          data['vat_rate_basis_points']!,
          _vatRateBasisPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vatRateBasisPointsMeta);
    }
    if (data.containsKey('discount_basis_points')) {
      context.handle(
        _discountBasisPointsMeta,
        discountBasisPoints.isAcceptableOrUnknown(
          data['discount_basis_points']!,
          _discountBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfferItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfferItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      offerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offer_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      unitPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_minor'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      vatRateBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vat_rate_basis_points'],
      )!,
      discountBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_basis_points'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $OfferItemsTable createAlias(String alias) {
    return $OfferItemsTable(attachedDatabase, alias);
  }
}

class OfferItemRow extends DataClass implements Insertable<OfferItemRow> {
  final int id;
  final int offerId;
  final int? productId;
  final String productName;
  final int unitPriceMinor;
  final int quantity;
  final String unit;
  final int vatRateBasisPoints;
  final int discountBasisPoints;
  final int sortOrder;
  const OfferItemRow({
    required this.id,
    required this.offerId,
    this.productId,
    required this.productName,
    required this.unitPriceMinor,
    required this.quantity,
    required this.unit,
    required this.vatRateBasisPoints,
    required this.discountBasisPoints,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['offer_id'] = Variable<int>(offerId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['product_name'] = Variable<String>(productName);
    map['unit_price_minor'] = Variable<int>(unitPriceMinor);
    map['quantity'] = Variable<int>(quantity);
    map['unit'] = Variable<String>(unit);
    map['vat_rate_basis_points'] = Variable<int>(vatRateBasisPoints);
    map['discount_basis_points'] = Variable<int>(discountBasisPoints);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  OfferItemsCompanion toCompanion(bool nullToAbsent) {
    return OfferItemsCompanion(
      id: Value(id),
      offerId: Value(offerId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productName: Value(productName),
      unitPriceMinor: Value(unitPriceMinor),
      quantity: Value(quantity),
      unit: Value(unit),
      vatRateBasisPoints: Value(vatRateBasisPoints),
      discountBasisPoints: Value(discountBasisPoints),
      sortOrder: Value(sortOrder),
    );
  }

  factory OfferItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfferItemRow(
      id: serializer.fromJson<int>(json['id']),
      offerId: serializer.fromJson<int>(json['offerId']),
      productId: serializer.fromJson<int?>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      unitPriceMinor: serializer.fromJson<int>(json['unitPriceMinor']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      vatRateBasisPoints: serializer.fromJson<int>(json['vatRateBasisPoints']),
      discountBasisPoints: serializer.fromJson<int>(
        json['discountBasisPoints'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'offerId': serializer.toJson<int>(offerId),
      'productId': serializer.toJson<int?>(productId),
      'productName': serializer.toJson<String>(productName),
      'unitPriceMinor': serializer.toJson<int>(unitPriceMinor),
      'quantity': serializer.toJson<int>(quantity),
      'unit': serializer.toJson<String>(unit),
      'vatRateBasisPoints': serializer.toJson<int>(vatRateBasisPoints),
      'discountBasisPoints': serializer.toJson<int>(discountBasisPoints),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  OfferItemRow copyWith({
    int? id,
    int? offerId,
    Value<int?> productId = const Value.absent(),
    String? productName,
    int? unitPriceMinor,
    int? quantity,
    String? unit,
    int? vatRateBasisPoints,
    int? discountBasisPoints,
    int? sortOrder,
  }) => OfferItemRow(
    id: id ?? this.id,
    offerId: offerId ?? this.offerId,
    productId: productId.present ? productId.value : this.productId,
    productName: productName ?? this.productName,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    vatRateBasisPoints: vatRateBasisPoints ?? this.vatRateBasisPoints,
    discountBasisPoints: discountBasisPoints ?? this.discountBasisPoints,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  OfferItemRow copyWithCompanion(OfferItemsCompanion data) {
    return OfferItemRow(
      id: data.id.present ? data.id.value : this.id,
      offerId: data.offerId.present ? data.offerId.value : this.offerId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      unitPriceMinor: data.unitPriceMinor.present
          ? data.unitPriceMinor.value
          : this.unitPriceMinor,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      vatRateBasisPoints: data.vatRateBasisPoints.present
          ? data.vatRateBasisPoints.value
          : this.vatRateBasisPoints,
      discountBasisPoints: data.discountBasisPoints.present
          ? data.discountBasisPoints.value
          : this.discountBasisPoints,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfferItemRow(')
          ..write('id: $id, ')
          ..write('offerId: $offerId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('vatRateBasisPoints: $vatRateBasisPoints, ')
          ..write('discountBasisPoints: $discountBasisPoints, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    offerId,
    productId,
    productName,
    unitPriceMinor,
    quantity,
    unit,
    vatRateBasisPoints,
    discountBasisPoints,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfferItemRow &&
          other.id == this.id &&
          other.offerId == this.offerId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.unitPriceMinor == this.unitPriceMinor &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.vatRateBasisPoints == this.vatRateBasisPoints &&
          other.discountBasisPoints == this.discountBasisPoints &&
          other.sortOrder == this.sortOrder);
}

class OfferItemsCompanion extends UpdateCompanion<OfferItemRow> {
  final Value<int> id;
  final Value<int> offerId;
  final Value<int?> productId;
  final Value<String> productName;
  final Value<int> unitPriceMinor;
  final Value<int> quantity;
  final Value<String> unit;
  final Value<int> vatRateBasisPoints;
  final Value<int> discountBasisPoints;
  final Value<int> sortOrder;
  const OfferItemsCompanion({
    this.id = const Value.absent(),
    this.offerId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitPriceMinor = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.vatRateBasisPoints = const Value.absent(),
    this.discountBasisPoints = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  OfferItemsCompanion.insert({
    this.id = const Value.absent(),
    required int offerId,
    this.productId = const Value.absent(),
    required String productName,
    required int unitPriceMinor,
    required int quantity,
    this.unit = const Value.absent(),
    required int vatRateBasisPoints,
    this.discountBasisPoints = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : offerId = Value(offerId),
       productName = Value(productName),
       unitPriceMinor = Value(unitPriceMinor),
       quantity = Value(quantity),
       vatRateBasisPoints = Value(vatRateBasisPoints);
  static Insertable<OfferItemRow> custom({
    Expression<int>? id,
    Expression<int>? offerId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<int>? unitPriceMinor,
    Expression<int>? quantity,
    Expression<String>? unit,
    Expression<int>? vatRateBasisPoints,
    Expression<int>? discountBasisPoints,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (offerId != null) 'offer_id': offerId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (unitPriceMinor != null) 'unit_price_minor': unitPriceMinor,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (vatRateBasisPoints != null)
        'vat_rate_basis_points': vatRateBasisPoints,
      if (discountBasisPoints != null)
        'discount_basis_points': discountBasisPoints,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  OfferItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? offerId,
    Value<int?>? productId,
    Value<String>? productName,
    Value<int>? unitPriceMinor,
    Value<int>? quantity,
    Value<String>? unit,
    Value<int>? vatRateBasisPoints,
    Value<int>? discountBasisPoints,
    Value<int>? sortOrder,
  }) {
    return OfferItemsCompanion(
      id: id ?? this.id,
      offerId: offerId ?? this.offerId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      vatRateBasisPoints: vatRateBasisPoints ?? this.vatRateBasisPoints,
      discountBasisPoints: discountBasisPoints ?? this.discountBasisPoints,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (offerId.present) {
      map['offer_id'] = Variable<int>(offerId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitPriceMinor.present) {
      map['unit_price_minor'] = Variable<int>(unitPriceMinor.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (vatRateBasisPoints.present) {
      map['vat_rate_basis_points'] = Variable<int>(vatRateBasisPoints.value);
    }
    if (discountBasisPoints.present) {
      map['discount_basis_points'] = Variable<int>(discountBasisPoints.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfferItemsCompanion(')
          ..write('id: $id, ')
          ..write('offerId: $offerId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('vatRateBasisPoints: $vatRateBasisPoints, ')
          ..write('discountBasisPoints: $discountBasisPoints, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $TemplatesTable extends Templates
    with TableInfo<$TemplatesTable, TemplateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('TRY'),
  );
  static const VerificationMeta _generalDiscountBasisPointsMeta =
      const VerificationMeta('generalDiscountBasisPoints');
  @override
  late final GeneratedColumn<int> generalDiscountBasisPoints =
      GeneratedColumn<int>(
        'general_discount_basis_points',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 1000),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    currencyCode,
    generalDiscountBasisPoints,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('general_discount_basis_points')) {
      context.handle(
        _generalDiscountBasisPointsMeta,
        generalDiscountBasisPoints.isAcceptableOrUnknown(
          data['general_discount_basis_points']!,
          _generalDiscountBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      generalDiscountBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}general_discount_basis_points'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TemplatesTable createAlias(String alias) {
    return $TemplatesTable(attachedDatabase, alias);
  }
}

class TemplateRow extends DataClass implements Insertable<TemplateRow> {
  final int id;
  final String name;

  /// ISO 4217 kodu; [Offers.currencyCode] ile aynı kısıt.
  final String currencyCode;
  final int generalDiscountBasisPoints;
  final String? notes;
  final DateTime createdAt;
  const TemplateRow({
    required this.id,
    required this.name,
    required this.currencyCode,
    required this.generalDiscountBasisPoints,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['currency_code'] = Variable<String>(currencyCode);
    map['general_discount_basis_points'] = Variable<int>(
      generalDiscountBasisPoints,
    );
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TemplatesCompanion toCompanion(bool nullToAbsent) {
    return TemplatesCompanion(
      id: Value(id),
      name: Value(name),
      currencyCode: Value(currencyCode),
      generalDiscountBasisPoints: Value(generalDiscountBasisPoints),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory TemplateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      generalDiscountBasisPoints: serializer.fromJson<int>(
        json['generalDiscountBasisPoints'],
      ),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'generalDiscountBasisPoints': serializer.toJson<int>(
        generalDiscountBasisPoints,
      ),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TemplateRow copyWith({
    int? id,
    String? name,
    String? currencyCode,
    int? generalDiscountBasisPoints,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => TemplateRow(
    id: id ?? this.id,
    name: name ?? this.name,
    currencyCode: currencyCode ?? this.currencyCode,
    generalDiscountBasisPoints:
        generalDiscountBasisPoints ?? this.generalDiscountBasisPoints,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  TemplateRow copyWithCompanion(TemplatesCompanion data) {
    return TemplateRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      generalDiscountBasisPoints: data.generalDiscountBasisPoints.present
          ? data.generalDiscountBasisPoints.value
          : this.generalDiscountBasisPoints,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('generalDiscountBasisPoints: $generalDiscountBasisPoints, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    currencyCode,
    generalDiscountBasisPoints,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.currencyCode == this.currencyCode &&
          other.generalDiscountBasisPoints == this.generalDiscountBasisPoints &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TemplatesCompanion extends UpdateCompanion<TemplateRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> currencyCode;
  final Value<int> generalDiscountBasisPoints;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const TemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.generalDiscountBasisPoints = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TemplatesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.currencyCode = const Value.absent(),
    this.generalDiscountBasisPoints = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<TemplateRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? currencyCode,
    Expression<int>? generalDiscountBasisPoints,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (generalDiscountBasisPoints != null)
        'general_discount_basis_points': generalDiscountBasisPoints,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TemplatesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? currencyCode,
    Value<int>? generalDiscountBasisPoints,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return TemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      currencyCode: currencyCode ?? this.currencyCode,
      generalDiscountBasisPoints:
          generalDiscountBasisPoints ?? this.generalDiscountBasisPoints,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (generalDiscountBasisPoints.present) {
      map['general_discount_basis_points'] = Variable<int>(
        generalDiscountBasisPoints.value,
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('generalDiscountBasisPoints: $generalDiscountBasisPoints, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TemplateItemsTable extends TemplateItems
    with TableInfo<$TemplateItemsTable, TemplateItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TemplateItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<int> templateId = GeneratedColumn<int>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES templates (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceMinorMeta = const VerificationMeta(
    'unitPriceMinor',
  );
  @override
  late final GeneratedColumn<int> unitPriceMinor = GeneratedColumn<int>(
    'unit_price_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('adet'),
  );
  static const VerificationMeta _vatRateBasisPointsMeta =
      const VerificationMeta('vatRateBasisPoints');
  @override
  late final GeneratedColumn<int> vatRateBasisPoints = GeneratedColumn<int>(
    'vat_rate_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountBasisPointsMeta =
      const VerificationMeta('discountBasisPoints');
  @override
  late final GeneratedColumn<int> discountBasisPoints = GeneratedColumn<int>(
    'discount_basis_points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    productId,
    productName,
    unitPriceMinor,
    quantity,
    unit,
    vatRateBasisPoints,
    discountBasisPoints,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'template_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TemplateItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit_price_minor')) {
      context.handle(
        _unitPriceMinorMeta,
        unitPriceMinor.isAcceptableOrUnknown(
          data['unit_price_minor']!,
          _unitPriceMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceMinorMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('vat_rate_basis_points')) {
      context.handle(
        _vatRateBasisPointsMeta,
        vatRateBasisPoints.isAcceptableOrUnknown(
          data['vat_rate_basis_points']!,
          _vatRateBasisPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_vatRateBasisPointsMeta);
    }
    if (data.containsKey('discount_basis_points')) {
      context.handle(
        _discountBasisPointsMeta,
        discountBasisPoints.isAcceptableOrUnknown(
          data['discount_basis_points']!,
          _discountBasisPointsMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TemplateItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TemplateItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}template_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      unitPriceMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_minor'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      vatRateBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}vat_rate_basis_points'],
      )!,
      discountBasisPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount_basis_points'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TemplateItemsTable createAlias(String alias) {
    return $TemplateItemsTable(attachedDatabase, alias);
  }
}

class TemplateItemRow extends DataClass implements Insertable<TemplateItemRow> {
  final int id;
  final int templateId;
  final int? productId;
  final String productName;
  final int unitPriceMinor;
  final int quantity;
  final String unit;
  final int vatRateBasisPoints;
  final int discountBasisPoints;
  final int sortOrder;
  const TemplateItemRow({
    required this.id,
    required this.templateId,
    this.productId,
    required this.productName,
    required this.unitPriceMinor,
    required this.quantity,
    required this.unit,
    required this.vatRateBasisPoints,
    required this.discountBasisPoints,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['template_id'] = Variable<int>(templateId);
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<int>(productId);
    }
    map['product_name'] = Variable<String>(productName);
    map['unit_price_minor'] = Variable<int>(unitPriceMinor);
    map['quantity'] = Variable<int>(quantity);
    map['unit'] = Variable<String>(unit);
    map['vat_rate_basis_points'] = Variable<int>(vatRateBasisPoints);
    map['discount_basis_points'] = Variable<int>(discountBasisPoints);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TemplateItemsCompanion toCompanion(bool nullToAbsent) {
    return TemplateItemsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      productName: Value(productName),
      unitPriceMinor: Value(unitPriceMinor),
      quantity: Value(quantity),
      unit: Value(unit),
      vatRateBasisPoints: Value(vatRateBasisPoints),
      discountBasisPoints: Value(discountBasisPoints),
      sortOrder: Value(sortOrder),
    );
  }

  factory TemplateItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TemplateItemRow(
      id: serializer.fromJson<int>(json['id']),
      templateId: serializer.fromJson<int>(json['templateId']),
      productId: serializer.fromJson<int?>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      unitPriceMinor: serializer.fromJson<int>(json['unitPriceMinor']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      vatRateBasisPoints: serializer.fromJson<int>(json['vatRateBasisPoints']),
      discountBasisPoints: serializer.fromJson<int>(
        json['discountBasisPoints'],
      ),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'templateId': serializer.toJson<int>(templateId),
      'productId': serializer.toJson<int?>(productId),
      'productName': serializer.toJson<String>(productName),
      'unitPriceMinor': serializer.toJson<int>(unitPriceMinor),
      'quantity': serializer.toJson<int>(quantity),
      'unit': serializer.toJson<String>(unit),
      'vatRateBasisPoints': serializer.toJson<int>(vatRateBasisPoints),
      'discountBasisPoints': serializer.toJson<int>(discountBasisPoints),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TemplateItemRow copyWith({
    int? id,
    int? templateId,
    Value<int?> productId = const Value.absent(),
    String? productName,
    int? unitPriceMinor,
    int? quantity,
    String? unit,
    int? vatRateBasisPoints,
    int? discountBasisPoints,
    int? sortOrder,
  }) => TemplateItemRow(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    productId: productId.present ? productId.value : this.productId,
    productName: productName ?? this.productName,
    unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    vatRateBasisPoints: vatRateBasisPoints ?? this.vatRateBasisPoints,
    discountBasisPoints: discountBasisPoints ?? this.discountBasisPoints,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TemplateItemRow copyWithCompanion(TemplateItemsCompanion data) {
    return TemplateItemRow(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      unitPriceMinor: data.unitPriceMinor.present
          ? data.unitPriceMinor.value
          : this.unitPriceMinor,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      vatRateBasisPoints: data.vatRateBasisPoints.present
          ? data.vatRateBasisPoints.value
          : this.vatRateBasisPoints,
      discountBasisPoints: data.discountBasisPoints.present
          ? data.discountBasisPoints.value
          : this.discountBasisPoints,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TemplateItemRow(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('vatRateBasisPoints: $vatRateBasisPoints, ')
          ..write('discountBasisPoints: $discountBasisPoints, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    templateId,
    productId,
    productName,
    unitPriceMinor,
    quantity,
    unit,
    vatRateBasisPoints,
    discountBasisPoints,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TemplateItemRow &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.unitPriceMinor == this.unitPriceMinor &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.vatRateBasisPoints == this.vatRateBasisPoints &&
          other.discountBasisPoints == this.discountBasisPoints &&
          other.sortOrder == this.sortOrder);
}

class TemplateItemsCompanion extends UpdateCompanion<TemplateItemRow> {
  final Value<int> id;
  final Value<int> templateId;
  final Value<int?> productId;
  final Value<String> productName;
  final Value<int> unitPriceMinor;
  final Value<int> quantity;
  final Value<String> unit;
  final Value<int> vatRateBasisPoints;
  final Value<int> discountBasisPoints;
  final Value<int> sortOrder;
  const TemplateItemsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.unitPriceMinor = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.vatRateBasisPoints = const Value.absent(),
    this.discountBasisPoints = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  TemplateItemsCompanion.insert({
    this.id = const Value.absent(),
    required int templateId,
    this.productId = const Value.absent(),
    required String productName,
    required int unitPriceMinor,
    required int quantity,
    this.unit = const Value.absent(),
    required int vatRateBasisPoints,
    this.discountBasisPoints = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : templateId = Value(templateId),
       productName = Value(productName),
       unitPriceMinor = Value(unitPriceMinor),
       quantity = Value(quantity),
       vatRateBasisPoints = Value(vatRateBasisPoints);
  static Insertable<TemplateItemRow> custom({
    Expression<int>? id,
    Expression<int>? templateId,
    Expression<int>? productId,
    Expression<String>? productName,
    Expression<int>? unitPriceMinor,
    Expression<int>? quantity,
    Expression<String>? unit,
    Expression<int>? vatRateBasisPoints,
    Expression<int>? discountBasisPoints,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (unitPriceMinor != null) 'unit_price_minor': unitPriceMinor,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (vatRateBasisPoints != null)
        'vat_rate_basis_points': vatRateBasisPoints,
      if (discountBasisPoints != null)
        'discount_basis_points': discountBasisPoints,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  TemplateItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? templateId,
    Value<int?>? productId,
    Value<String>? productName,
    Value<int>? unitPriceMinor,
    Value<int>? quantity,
    Value<String>? unit,
    Value<int>? vatRateBasisPoints,
    Value<int>? discountBasisPoints,
    Value<int>? sortOrder,
  }) {
    return TemplateItemsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitPriceMinor: unitPriceMinor ?? this.unitPriceMinor,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      vatRateBasisPoints: vatRateBasisPoints ?? this.vatRateBasisPoints,
      discountBasisPoints: discountBasisPoints ?? this.discountBasisPoints,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<int>(templateId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unitPriceMinor.present) {
      map['unit_price_minor'] = Variable<int>(unitPriceMinor.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (vatRateBasisPoints.present) {
      map['vat_rate_basis_points'] = Variable<int>(vatRateBasisPoints.value);
    }
    if (discountBasisPoints.present) {
      map['discount_basis_points'] = Variable<int>(discountBasisPoints.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TemplateItemsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('unitPriceMinor: $unitPriceMinor, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('vatRateBasisPoints: $vatRateBasisPoints, ')
          ..write('discountBasisPoints: $discountBasisPoints, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $CustomUnitsTable extends CustomUnits
    with TableInfo<$CustomUnitsTable, CustomUnitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomUnitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomUnitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomUnitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomUnitsTable createAlias(String alias) {
    return $CustomUnitsTable(attachedDatabase, alias);
  }
}

class CustomUnitRow extends DataClass implements Insertable<CustomUnitRow> {
  final int id;
  final String name;
  final DateTime createdAt;
  const CustomUnitRow({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomUnitsCompanion toCompanion(bool nullToAbsent) {
    return CustomUnitsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory CustomUnitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomUnitRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomUnitRow copyWith({int? id, String? name, DateTime? createdAt}) =>
      CustomUnitRow(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomUnitRow copyWithCompanion(CustomUnitsCompanion data) {
    return CustomUnitRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomUnitRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomUnitRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CustomUnitsCompanion extends UpdateCompanion<CustomUnitRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const CustomUnitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomUnitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CustomUnitRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomUnitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return CustomUnitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomUnitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $OffersTable offers = $OffersTable(this);
  late final $OfferItemsTable offerItems = $OfferItemsTable(this);
  late final $TemplatesTable templates = $TemplatesTable(this);
  late final $TemplateItemsTable templateItems = $TemplateItemsTable(this);
  late final $CustomUnitsTable customUnits = $CustomUnitsTable(this);
  late final Index idxCustomersName = Index(
    'idx_customers_name',
    'CREATE INDEX idx_customers_name ON customers (name)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    products,
    customers,
    settings,
    offers,
    offerItems,
    templates,
    templateItems,
    customUnits,
    idxCustomersName,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'customers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('offers', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'offers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('offer_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('offer_items', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'templates',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('template_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'products',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('template_items', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductsTable, List<ProductRow>>
  _productsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.products,
    aliasName: 'categories__id__products__category_id',
  );

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productsRefs(
    Expression<bool> Function($$ProductsTableFilterComposer f) f,
  ) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> productsRefs<T extends Object>(
    Expression<T> Function($$ProductsTableAnnotationComposer a) f,
  ) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({bool productsRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) =>
                  CategoriesCompanion(id: id, name: name, createdAt: createdAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<
                      CategoryRow,
                      $CategoriesTable,
                      ProductRow
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._productsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).productsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({bool productsRefs})
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      required int priceMinor,
      Value<int> vatRateBasisPoints,
      required int categoryId,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> priceMinor,
      Value<int> vatRateBasisPoints,
      Value<int> categoryId,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, ProductRow> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('products__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OfferItemsTable, List<OfferItemRow>>
  _offerItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.offerItems,
    aliasName: 'products__id__offer_items__product_id',
  );

  $$OfferItemsTableProcessedTableManager get offerItemsRefs {
    final manager = $$OfferItemsTableTableManager(
      $_db,
      $_db.offerItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_offerItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TemplateItemsTable, List<TemplateItemRow>>
  _templateItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.templateItems,
    aliasName: 'products__id__template_items__product_id',
  );

  $$TemplateItemsTableProcessedTableManager get templateItemsRefs {
    final manager = $$TemplateItemsTableTableManager(
      $_db,
      $_db.templateItems,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_templateItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> offerItemsRefs(
    Expression<bool> Function($$OfferItemsTableFilterComposer f) f,
  ) {
    final $$OfferItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offerItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfferItemsTableFilterComposer(
            $db: $db,
            $table: $db.offerItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> templateItemsRefs(
    Expression<bool> Function($$TemplateItemsTableFilterComposer f) f,
  ) {
    final $$TemplateItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableFilterComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get priceMinor => $composableBuilder(
    column: $table.priceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> offerItemsRefs<T extends Object>(
    Expression<T> Function($$OfferItemsTableAnnotationComposer a) f,
  ) {
    final $$OfferItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offerItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfferItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.offerItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> templateItemsRefs<T extends Object>(
    Expression<T> Function($$TemplateItemsTableAnnotationComposer a) f,
  ) {
    final $$TemplateItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductRow,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (ProductRow, $$ProductsTableReferences),
          ProductRow,
          PrefetchHooks Function({
            bool categoryId,
            bool offerItemsRefs,
            bool templateItemsRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> priceMinor = const Value.absent(),
                Value<int> vatRateBasisPoints = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                priceMinor: priceMinor,
                vatRateBasisPoints: vatRateBasisPoints,
                categoryId: categoryId,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int priceMinor,
                Value<int> vatRateBasisPoints = const Value.absent(),
                required int categoryId,
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                priceMinor: priceMinor,
                vatRateBasisPoints: vatRateBasisPoints,
                categoryId: categoryId,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                offerItemsRefs = false,
                templateItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (offerItemsRefs) db.offerItems,
                    if (templateItemsRefs) db.templateItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ProductsTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ProductsTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (offerItemsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          OfferItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._offerItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).offerItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (templateItemsRefs)
                        await $_getPrefetchedData<
                          ProductRow,
                          $ProductsTable,
                          TemplateItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._templateItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).templateItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductRow,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductRow, $$ProductsTableReferences),
      ProductRow,
      PrefetchHooks Function({
        bool categoryId,
        bool offerItemsRefs,
        bool templateItemsRefs,
      })
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String type,
      required String name,
      Value<String?> contactPerson,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> taxOffice,
      Value<String?> taxNumber,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> name,
      Value<String?> contactPerson,
      Value<String?> phone,
      Value<String?> email,
      Value<String?> address,
      Value<String?> taxOffice,
      Value<String?> taxNumber,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerRow> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OffersTable, List<OfferRow>> _offersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.offers,
    aliasName: 'customers__id__offers__customer_id',
  );

  $$OffersTableProcessedTableManager get offersRefs {
    final manager = $$OffersTableTableManager(
      $_db,
      $_db.offers,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_offersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxOffice => $composableBuilder(
    column: $table.taxOffice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> offersRefs(
    Expression<bool> Function($$OffersTableFilterComposer f) f,
  ) {
    final $$OffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offers,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OffersTableFilterComposer(
            $db: $db,
            $table: $db.offers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxOffice => $composableBuilder(
    column: $table.taxOffice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxNumber => $composableBuilder(
    column: $table.taxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactPerson => $composableBuilder(
    column: $table.contactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get taxOffice =>
      $composableBuilder(column: $table.taxOffice, builder: (column) => column);

  GeneratedColumn<String> get taxNumber =>
      $composableBuilder(column: $table.taxNumber, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> offersRefs<T extends Object>(
    Expression<T> Function($$OffersTableAnnotationComposer a) f,
  ) {
    final $$OffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offers,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OffersTableAnnotationComposer(
            $db: $db,
            $table: $db.offers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          CustomerRow,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (CustomerRow, $$CustomersTableReferences),
          CustomerRow,
          PrefetchHooks Function({bool offersRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> taxOffice = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                type: type,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                address: address,
                taxOffice: taxOffice,
                taxNumber: taxNumber,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String name,
                Value<String?> contactPerson = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<String?> taxOffice = const Value.absent(),
                Value<String?> taxNumber = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                type: type,
                name: name,
                contactPerson: contactPerson,
                phone: phone,
                email: email,
                address: address,
                taxOffice: taxOffice,
                taxNumber: taxNumber,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({offersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (offersRefs) db.offers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (offersRefs)
                    await $_getPrefetchedData<
                      CustomerRow,
                      $CustomersTable,
                      OfferRow
                    >(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._offersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(db, table, p0).offersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      CustomerRow,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (CustomerRow, $$CustomersTableReferences),
      CustomerRow,
      PrefetchHooks Function({bool offersRefs})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String?> languageCode,
      Value<String> themeMode,
      Value<String?> companyName,
      Value<String?> companyLogoPath,
      Value<String?> companyPhone,
      Value<String?> companyEmail,
      Value<String?> companyWebsite,
      Value<String?> companyAddress,
      Value<String?> companyTaxOffice,
      Value<String?> companyTaxNumber,
      Value<String?> preparerFirstName,
      Value<String?> preparerLastName,
      Value<String?> preparerTitle,
      Value<String?> preparerEmail,
      Value<String?> preparerPhone,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<int> id,
      Value<String?> languageCode,
      Value<String> themeMode,
      Value<String?> companyName,
      Value<String?> companyLogoPath,
      Value<String?> companyPhone,
      Value<String?> companyEmail,
      Value<String?> companyWebsite,
      Value<String?> companyAddress,
      Value<String?> companyTaxOffice,
      Value<String?> companyTaxNumber,
      Value<String?> preparerFirstName,
      Value<String?> preparerLastName,
      Value<String?> preparerTitle,
      Value<String?> preparerEmail,
      Value<String?> preparerPhone,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyLogoPath => $composableBuilder(
    column: $table.companyLogoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyPhone => $composableBuilder(
    column: $table.companyPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyEmail => $composableBuilder(
    column: $table.companyEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyWebsite => $composableBuilder(
    column: $table.companyWebsite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyAddress => $composableBuilder(
    column: $table.companyAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyTaxOffice => $composableBuilder(
    column: $table.companyTaxOffice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get companyTaxNumber => $composableBuilder(
    column: $table.companyTaxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparerFirstName => $composableBuilder(
    column: $table.preparerFirstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparerLastName => $composableBuilder(
    column: $table.preparerLastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparerTitle => $composableBuilder(
    column: $table.preparerTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparerEmail => $composableBuilder(
    column: $table.preparerEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get preparerPhone => $composableBuilder(
    column: $table.preparerPhone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyLogoPath => $composableBuilder(
    column: $table.companyLogoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyPhone => $composableBuilder(
    column: $table.companyPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyEmail => $composableBuilder(
    column: $table.companyEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyWebsite => $composableBuilder(
    column: $table.companyWebsite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyAddress => $composableBuilder(
    column: $table.companyAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyTaxOffice => $composableBuilder(
    column: $table.companyTaxOffice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get companyTaxNumber => $composableBuilder(
    column: $table.companyTaxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparerFirstName => $composableBuilder(
    column: $table.preparerFirstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparerLastName => $composableBuilder(
    column: $table.preparerLastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparerTitle => $composableBuilder(
    column: $table.preparerTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparerEmail => $composableBuilder(
    column: $table.preparerEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preparerPhone => $composableBuilder(
    column: $table.preparerPhone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get companyName => $composableBuilder(
    column: $table.companyName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyLogoPath => $composableBuilder(
    column: $table.companyLogoPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyPhone => $composableBuilder(
    column: $table.companyPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyEmail => $composableBuilder(
    column: $table.companyEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyWebsite => $composableBuilder(
    column: $table.companyWebsite,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyAddress => $composableBuilder(
    column: $table.companyAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyTaxOffice => $composableBuilder(
    column: $table.companyTaxOffice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get companyTaxNumber => $composableBuilder(
    column: $table.companyTaxNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparerFirstName => $composableBuilder(
    column: $table.preparerFirstName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparerLastName => $composableBuilder(
    column: $table.preparerLastName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparerTitle => $composableBuilder(
    column: $table.preparerTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparerEmail => $composableBuilder(
    column: $table.preparerEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get preparerPhone => $composableBuilder(
    column: $table.preparerPhone,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingsRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingsRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>,
          ),
          SettingsRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> languageCode = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> companyLogoPath = const Value.absent(),
                Value<String?> companyPhone = const Value.absent(),
                Value<String?> companyEmail = const Value.absent(),
                Value<String?> companyWebsite = const Value.absent(),
                Value<String?> companyAddress = const Value.absent(),
                Value<String?> companyTaxOffice = const Value.absent(),
                Value<String?> companyTaxNumber = const Value.absent(),
                Value<String?> preparerFirstName = const Value.absent(),
                Value<String?> preparerLastName = const Value.absent(),
                Value<String?> preparerTitle = const Value.absent(),
                Value<String?> preparerEmail = const Value.absent(),
                Value<String?> preparerPhone = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                languageCode: languageCode,
                themeMode: themeMode,
                companyName: companyName,
                companyLogoPath: companyLogoPath,
                companyPhone: companyPhone,
                companyEmail: companyEmail,
                companyWebsite: companyWebsite,
                companyAddress: companyAddress,
                companyTaxOffice: companyTaxOffice,
                companyTaxNumber: companyTaxNumber,
                preparerFirstName: preparerFirstName,
                preparerLastName: preparerLastName,
                preparerTitle: preparerTitle,
                preparerEmail: preparerEmail,
                preparerPhone: preparerPhone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> languageCode = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> companyName = const Value.absent(),
                Value<String?> companyLogoPath = const Value.absent(),
                Value<String?> companyPhone = const Value.absent(),
                Value<String?> companyEmail = const Value.absent(),
                Value<String?> companyWebsite = const Value.absent(),
                Value<String?> companyAddress = const Value.absent(),
                Value<String?> companyTaxOffice = const Value.absent(),
                Value<String?> companyTaxNumber = const Value.absent(),
                Value<String?> preparerFirstName = const Value.absent(),
                Value<String?> preparerLastName = const Value.absent(),
                Value<String?> preparerTitle = const Value.absent(),
                Value<String?> preparerEmail = const Value.absent(),
                Value<String?> preparerPhone = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                languageCode: languageCode,
                themeMode: themeMode,
                companyName: companyName,
                companyLogoPath: companyLogoPath,
                companyPhone: companyPhone,
                companyEmail: companyEmail,
                companyWebsite: companyWebsite,
                companyAddress: companyAddress,
                companyTaxOffice: companyTaxOffice,
                companyTaxNumber: companyTaxNumber,
                preparerFirstName: preparerFirstName,
                preparerLastName: preparerLastName,
                preparerTitle: preparerTitle,
                preparerEmail: preparerEmail,
                preparerPhone: preparerPhone,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingsRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingsRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingsRow>),
      SettingsRow,
      PrefetchHooks Function()
    >;
typedef $$OffersTableCreateCompanionBuilder =
    OffersCompanion Function({
      Value<int> id,
      Value<int?> customerId,
      required String customerName,
      Value<String?> customerContactPerson,
      Value<String?> customerPhone,
      Value<String?> customerEmail,
      Value<String?> customerAddress,
      Value<String?> customerTaxOffice,
      Value<String?> customerTaxNumber,
      Value<String> currencyCode,
      Value<int> generalDiscountBasisPoints,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$OffersTableUpdateCompanionBuilder =
    OffersCompanion Function({
      Value<int> id,
      Value<int?> customerId,
      Value<String> customerName,
      Value<String?> customerContactPerson,
      Value<String?> customerPhone,
      Value<String?> customerEmail,
      Value<String?> customerAddress,
      Value<String?> customerTaxOffice,
      Value<String?> customerTaxNumber,
      Value<String> currencyCode,
      Value<int> generalDiscountBasisPoints,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$OffersTableReferences
    extends BaseReferences<_$AppDatabase, $OffersTable, OfferRow> {
  $$OffersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias('offers__customer_id__customers__id');

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OfferItemsTable, List<OfferItemRow>>
  _offerItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.offerItems,
    aliasName: 'offers__id__offer_items__offer_id',
  );

  $$OfferItemsTableProcessedTableManager get offerItemsRefs {
    final manager = $$OfferItemsTableTableManager(
      $_db,
      $_db.offerItems,
    ).filter((f) => f.offerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_offerItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OffersTableFilterComposer
    extends Composer<_$AppDatabase, $OffersTable> {
  $$OffersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerContactPerson => $composableBuilder(
    column: $table.customerContactPerson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerEmail => $composableBuilder(
    column: $table.customerEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerAddress => $composableBuilder(
    column: $table.customerAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerTaxOffice => $composableBuilder(
    column: $table.customerTaxOffice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerTaxNumber => $composableBuilder(
    column: $table.customerTaxNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generalDiscountBasisPoints => $composableBuilder(
    column: $table.generalDiscountBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> offerItemsRefs(
    Expression<bool> Function($$OfferItemsTableFilterComposer f) f,
  ) {
    final $$OfferItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offerItems,
      getReferencedColumn: (t) => t.offerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfferItemsTableFilterComposer(
            $db: $db,
            $table: $db.offerItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OffersTableOrderingComposer
    extends Composer<_$AppDatabase, $OffersTable> {
  $$OffersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerContactPerson => $composableBuilder(
    column: $table.customerContactPerson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerEmail => $composableBuilder(
    column: $table.customerEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerAddress => $composableBuilder(
    column: $table.customerAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerTaxOffice => $composableBuilder(
    column: $table.customerTaxOffice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerTaxNumber => $composableBuilder(
    column: $table.customerTaxNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generalDiscountBasisPoints => $composableBuilder(
    column: $table.generalDiscountBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OffersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OffersTable> {
  $$OffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerContactPerson => $composableBuilder(
    column: $table.customerContactPerson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerPhone => $composableBuilder(
    column: $table.customerPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerEmail => $composableBuilder(
    column: $table.customerEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerAddress => $composableBuilder(
    column: $table.customerAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerTaxOffice => $composableBuilder(
    column: $table.customerTaxOffice,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerTaxNumber => $composableBuilder(
    column: $table.customerTaxNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generalDiscountBasisPoints => $composableBuilder(
    column: $table.generalDiscountBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> offerItemsRefs<T extends Object>(
    Expression<T> Function($$OfferItemsTableAnnotationComposer a) f,
  ) {
    final $$OfferItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offerItems,
      getReferencedColumn: (t) => t.offerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfferItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.offerItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OffersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OffersTable,
          OfferRow,
          $$OffersTableFilterComposer,
          $$OffersTableOrderingComposer,
          $$OffersTableAnnotationComposer,
          $$OffersTableCreateCompanionBuilder,
          $$OffersTableUpdateCompanionBuilder,
          (OfferRow, $$OffersTableReferences),
          OfferRow,
          PrefetchHooks Function({bool customerId, bool offerItemsRefs})
        > {
  $$OffersTableTableManager(_$AppDatabase db, $OffersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerContactPerson = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String?> customerEmail = const Value.absent(),
                Value<String?> customerAddress = const Value.absent(),
                Value<String?> customerTaxOffice = const Value.absent(),
                Value<String?> customerTaxNumber = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> generalDiscountBasisPoints = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OffersCompanion(
                id: id,
                customerId: customerId,
                customerName: customerName,
                customerContactPerson: customerContactPerson,
                customerPhone: customerPhone,
                customerEmail: customerEmail,
                customerAddress: customerAddress,
                customerTaxOffice: customerTaxOffice,
                customerTaxNumber: customerTaxNumber,
                currencyCode: currencyCode,
                generalDiscountBasisPoints: generalDiscountBasisPoints,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                required String customerName,
                Value<String?> customerContactPerson = const Value.absent(),
                Value<String?> customerPhone = const Value.absent(),
                Value<String?> customerEmail = const Value.absent(),
                Value<String?> customerAddress = const Value.absent(),
                Value<String?> customerTaxOffice = const Value.absent(),
                Value<String?> customerTaxNumber = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> generalDiscountBasisPoints = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => OffersCompanion.insert(
                id: id,
                customerId: customerId,
                customerName: customerName,
                customerContactPerson: customerContactPerson,
                customerPhone: customerPhone,
                customerEmail: customerEmail,
                customerAddress: customerAddress,
                customerTaxOffice: customerTaxOffice,
                customerTaxNumber: customerTaxNumber,
                currencyCode: currencyCode,
                generalDiscountBasisPoints: generalDiscountBasisPoints,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OffersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerId = false, offerItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (offerItemsRefs) db.offerItems],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$OffersTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$OffersTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (offerItemsRefs)
                        await $_getPrefetchedData<
                          OfferRow,
                          $OffersTable,
                          OfferItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$OffersTableReferences
                              ._offerItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OffersTableReferences(
                                db,
                                table,
                                p0,
                              ).offerItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.offerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OffersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OffersTable,
      OfferRow,
      $$OffersTableFilterComposer,
      $$OffersTableOrderingComposer,
      $$OffersTableAnnotationComposer,
      $$OffersTableCreateCompanionBuilder,
      $$OffersTableUpdateCompanionBuilder,
      (OfferRow, $$OffersTableReferences),
      OfferRow,
      PrefetchHooks Function({bool customerId, bool offerItemsRefs})
    >;
typedef $$OfferItemsTableCreateCompanionBuilder =
    OfferItemsCompanion Function({
      Value<int> id,
      required int offerId,
      Value<int?> productId,
      required String productName,
      required int unitPriceMinor,
      required int quantity,
      Value<String> unit,
      required int vatRateBasisPoints,
      Value<int> discountBasisPoints,
      Value<int> sortOrder,
    });
typedef $$OfferItemsTableUpdateCompanionBuilder =
    OfferItemsCompanion Function({
      Value<int> id,
      Value<int> offerId,
      Value<int?> productId,
      Value<String> productName,
      Value<int> unitPriceMinor,
      Value<int> quantity,
      Value<String> unit,
      Value<int> vatRateBasisPoints,
      Value<int> discountBasisPoints,
      Value<int> sortOrder,
    });

final class $$OfferItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OfferItemsTable, OfferItemRow> {
  $$OfferItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OffersTable _offerIdTable(_$AppDatabase db) =>
      db.offers.createAlias('offer_items__offer_id__offers__id');

  $$OffersTableProcessedTableManager get offerId {
    final $_column = $_itemColumn<int>('offer_id')!;

    final manager = $$OffersTableTableManager(
      $_db,
      $_db.offers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_offerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('offer_items__product_id__products__id');

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OfferItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OfferItemsTable> {
  $$OfferItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountBasisPoints => $composableBuilder(
    column: $table.discountBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$OffersTableFilterComposer get offerId {
    final $$OffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.offers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OffersTableFilterComposer(
            $db: $db,
            $table: $db.offers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfferItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfferItemsTable> {
  $$OfferItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountBasisPoints => $composableBuilder(
    column: $table.discountBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$OffersTableOrderingComposer get offerId {
    final $$OffersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.offers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OffersTableOrderingComposer(
            $db: $db,
            $table: $db.offers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfferItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfferItemsTable> {
  $$OfferItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountBasisPoints => $composableBuilder(
    column: $table.discountBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$OffersTableAnnotationComposer get offerId {
    final $$OffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.offers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OffersTableAnnotationComposer(
            $db: $db,
            $table: $db.offers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfferItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfferItemsTable,
          OfferItemRow,
          $$OfferItemsTableFilterComposer,
          $$OfferItemsTableOrderingComposer,
          $$OfferItemsTableAnnotationComposer,
          $$OfferItemsTableCreateCompanionBuilder,
          $$OfferItemsTableUpdateCompanionBuilder,
          (OfferItemRow, $$OfferItemsTableReferences),
          OfferItemRow,
          PrefetchHooks Function({bool offerId, bool productId})
        > {
  $$OfferItemsTableTableManager(_$AppDatabase db, $OfferItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfferItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfferItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfferItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> offerId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> unitPriceMinor = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> vatRateBasisPoints = const Value.absent(),
                Value<int> discountBasisPoints = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => OfferItemsCompanion(
                id: id,
                offerId: offerId,
                productId: productId,
                productName: productName,
                unitPriceMinor: unitPriceMinor,
                quantity: quantity,
                unit: unit,
                vatRateBasisPoints: vatRateBasisPoints,
                discountBasisPoints: discountBasisPoints,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int offerId,
                Value<int?> productId = const Value.absent(),
                required String productName,
                required int unitPriceMinor,
                required int quantity,
                Value<String> unit = const Value.absent(),
                required int vatRateBasisPoints,
                Value<int> discountBasisPoints = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => OfferItemsCompanion.insert(
                id: id,
                offerId: offerId,
                productId: productId,
                productName: productName,
                unitPriceMinor: unitPriceMinor,
                quantity: quantity,
                unit: unit,
                vatRateBasisPoints: vatRateBasisPoints,
                discountBasisPoints: discountBasisPoints,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OfferItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({offerId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (offerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.offerId,
                                referencedTable: $$OfferItemsTableReferences
                                    ._offerIdTable(db),
                                referencedColumn: $$OfferItemsTableReferences
                                    ._offerIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$OfferItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$OfferItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OfferItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfferItemsTable,
      OfferItemRow,
      $$OfferItemsTableFilterComposer,
      $$OfferItemsTableOrderingComposer,
      $$OfferItemsTableAnnotationComposer,
      $$OfferItemsTableCreateCompanionBuilder,
      $$OfferItemsTableUpdateCompanionBuilder,
      (OfferItemRow, $$OfferItemsTableReferences),
      OfferItemRow,
      PrefetchHooks Function({bool offerId, bool productId})
    >;
typedef $$TemplatesTableCreateCompanionBuilder =
    TemplatesCompanion Function({
      Value<int> id,
      required String name,
      Value<String> currencyCode,
      Value<int> generalDiscountBasisPoints,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$TemplatesTableUpdateCompanionBuilder =
    TemplatesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> currencyCode,
      Value<int> generalDiscountBasisPoints,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$TemplatesTableReferences
    extends BaseReferences<_$AppDatabase, $TemplatesTable, TemplateRow> {
  $$TemplatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TemplateItemsTable, List<TemplateItemRow>>
  _templateItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.templateItems,
    aliasName: 'templates__id__template_items__template_id',
  );

  $$TemplateItemsTableProcessedTableManager get templateItemsRefs {
    final manager = $$TemplateItemsTableTableManager(
      $_db,
      $_db.templateItems,
    ).filter((f) => f.templateId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_templateItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get generalDiscountBasisPoints => $composableBuilder(
    column: $table.generalDiscountBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> templateItemsRefs(
    Expression<bool> Function($$TemplateItemsTableFilterComposer f) f,
  ) {
    final $$TemplateItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableFilterComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get generalDiscountBasisPoints => $composableBuilder(
    column: $table.generalDiscountBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplatesTable> {
  $$TemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get generalDiscountBasisPoints => $composableBuilder(
    column: $table.generalDiscountBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> templateItemsRefs<T extends Object>(
    Expression<T> Function($$TemplateItemsTableAnnotationComposer a) f,
  ) {
    final $$TemplateItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.templateItems,
      getReferencedColumn: (t) => t.templateId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplateItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.templateItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplatesTable,
          TemplateRow,
          $$TemplatesTableFilterComposer,
          $$TemplatesTableOrderingComposer,
          $$TemplatesTableAnnotationComposer,
          $$TemplatesTableCreateCompanionBuilder,
          $$TemplatesTableUpdateCompanionBuilder,
          (TemplateRow, $$TemplatesTableReferences),
          TemplateRow,
          PrefetchHooks Function({bool templateItemsRefs})
        > {
  $$TemplatesTableTableManager(_$AppDatabase db, $TemplatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<int> generalDiscountBasisPoints = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TemplatesCompanion(
                id: id,
                name: name,
                currencyCode: currencyCode,
                generalDiscountBasisPoints: generalDiscountBasisPoints,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> currencyCode = const Value.absent(),
                Value<int> generalDiscountBasisPoints = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TemplatesCompanion.insert(
                id: id,
                name: name,
                currencyCode: currencyCode,
                generalDiscountBasisPoints: generalDiscountBasisPoints,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TemplatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (templateItemsRefs) db.templateItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (templateItemsRefs)
                    await $_getPrefetchedData<
                      TemplateRow,
                      $TemplatesTable,
                      TemplateItemRow
                    >(
                      currentTable: table,
                      referencedTable: $$TemplatesTableReferences
                          ._templateItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$TemplatesTableReferences(
                            db,
                            table,
                            p0,
                          ).templateItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.templateId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplatesTable,
      TemplateRow,
      $$TemplatesTableFilterComposer,
      $$TemplatesTableOrderingComposer,
      $$TemplatesTableAnnotationComposer,
      $$TemplatesTableCreateCompanionBuilder,
      $$TemplatesTableUpdateCompanionBuilder,
      (TemplateRow, $$TemplatesTableReferences),
      TemplateRow,
      PrefetchHooks Function({bool templateItemsRefs})
    >;
typedef $$TemplateItemsTableCreateCompanionBuilder =
    TemplateItemsCompanion Function({
      Value<int> id,
      required int templateId,
      Value<int?> productId,
      required String productName,
      required int unitPriceMinor,
      required int quantity,
      Value<String> unit,
      required int vatRateBasisPoints,
      Value<int> discountBasisPoints,
      Value<int> sortOrder,
    });
typedef $$TemplateItemsTableUpdateCompanionBuilder =
    TemplateItemsCompanion Function({
      Value<int> id,
      Value<int> templateId,
      Value<int?> productId,
      Value<String> productName,
      Value<int> unitPriceMinor,
      Value<int> quantity,
      Value<String> unit,
      Value<int> vatRateBasisPoints,
      Value<int> discountBasisPoints,
      Value<int> sortOrder,
    });

final class $$TemplateItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TemplateItemsTable, TemplateItemRow> {
  $$TemplateItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TemplatesTable _templateIdTable(_$AppDatabase db) =>
      db.templates.createAlias('template_items__template_id__templates__id');

  $$TemplatesTableProcessedTableManager get templateId {
    final $_column = $_itemColumn<int>('template_id')!;

    final manager = $$TemplatesTableTableManager(
      $_db,
      $_db.templates,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_templateIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias('template_items__product_id__products__id');

  $$ProductsTableProcessedTableManager? get productId {
    final $_column = $_itemColumn<int>('product_id');
    if ($_column == null) return null;
    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TemplateItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discountBasisPoints => $composableBuilder(
    column: $table.discountBasisPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TemplatesTableFilterComposer get templateId {
    final $$TemplatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableFilterComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discountBasisPoints => $composableBuilder(
    column: $table.discountBasisPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TemplatesTableOrderingComposer get templateId {
    final $$TemplatesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableOrderingComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TemplateItemsTable> {
  $$TemplateItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unitPriceMinor => $composableBuilder(
    column: $table.unitPriceMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get vatRateBasisPoints => $composableBuilder(
    column: $table.vatRateBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discountBasisPoints => $composableBuilder(
    column: $table.discountBasisPoints,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TemplatesTableAnnotationComposer get templateId {
    final $$TemplatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.templateId,
      referencedTable: $db.templates,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TemplatesTableAnnotationComposer(
            $db: $db,
            $table: $db.templates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TemplateItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TemplateItemsTable,
          TemplateItemRow,
          $$TemplateItemsTableFilterComposer,
          $$TemplateItemsTableOrderingComposer,
          $$TemplateItemsTableAnnotationComposer,
          $$TemplateItemsTableCreateCompanionBuilder,
          $$TemplateItemsTableUpdateCompanionBuilder,
          (TemplateItemRow, $$TemplateItemsTableReferences),
          TemplateItemRow,
          PrefetchHooks Function({bool templateId, bool productId})
        > {
  $$TemplateItemsTableTableManager(_$AppDatabase db, $TemplateItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TemplateItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TemplateItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TemplateItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> templateId = const Value.absent(),
                Value<int?> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> unitPriceMinor = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int> vatRateBasisPoints = const Value.absent(),
                Value<int> discountBasisPoints = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => TemplateItemsCompanion(
                id: id,
                templateId: templateId,
                productId: productId,
                productName: productName,
                unitPriceMinor: unitPriceMinor,
                quantity: quantity,
                unit: unit,
                vatRateBasisPoints: vatRateBasisPoints,
                discountBasisPoints: discountBasisPoints,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int templateId,
                Value<int?> productId = const Value.absent(),
                required String productName,
                required int unitPriceMinor,
                required int quantity,
                Value<String> unit = const Value.absent(),
                required int vatRateBasisPoints,
                Value<int> discountBasisPoints = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => TemplateItemsCompanion.insert(
                id: id,
                templateId: templateId,
                productId: productId,
                productName: productName,
                unitPriceMinor: unitPriceMinor,
                quantity: quantity,
                unit: unit,
                vatRateBasisPoints: vatRateBasisPoints,
                discountBasisPoints: discountBasisPoints,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TemplateItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({templateId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (templateId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.templateId,
                                referencedTable: $$TemplateItemsTableReferences
                                    ._templateIdTable(db),
                                referencedColumn: $$TemplateItemsTableReferences
                                    ._templateIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$TemplateItemsTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$TemplateItemsTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TemplateItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TemplateItemsTable,
      TemplateItemRow,
      $$TemplateItemsTableFilterComposer,
      $$TemplateItemsTableOrderingComposer,
      $$TemplateItemsTableAnnotationComposer,
      $$TemplateItemsTableCreateCompanionBuilder,
      $$TemplateItemsTableUpdateCompanionBuilder,
      (TemplateItemRow, $$TemplateItemsTableReferences),
      TemplateItemRow,
      PrefetchHooks Function({bool templateId, bool productId})
    >;
typedef $$CustomUnitsTableCreateCompanionBuilder =
    CustomUnitsCompanion Function({
      Value<int> id,
      required String name,
      Value<DateTime> createdAt,
    });
typedef $$CustomUnitsTableUpdateCompanionBuilder =
    CustomUnitsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

class $$CustomUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomUnitsTable> {
  $$CustomUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CustomUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomUnitsTable> {
  $$CustomUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomUnitsTable> {
  $$CustomUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CustomUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomUnitsTable,
          CustomUnitRow,
          $$CustomUnitsTableFilterComposer,
          $$CustomUnitsTableOrderingComposer,
          $$CustomUnitsTableAnnotationComposer,
          $$CustomUnitsTableCreateCompanionBuilder,
          $$CustomUnitsTableUpdateCompanionBuilder,
          (
            CustomUnitRow,
            BaseReferences<_$AppDatabase, $CustomUnitsTable, CustomUnitRow>,
          ),
          CustomUnitRow,
          PrefetchHooks Function()
        > {
  $$CustomUnitsTableTableManager(_$AppDatabase db, $CustomUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomUnitsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomUnitsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CustomUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomUnitsTable,
      CustomUnitRow,
      $$CustomUnitsTableFilterComposer,
      $$CustomUnitsTableOrderingComposer,
      $$CustomUnitsTableAnnotationComposer,
      $$CustomUnitsTableCreateCompanionBuilder,
      $$CustomUnitsTableUpdateCompanionBuilder,
      (
        CustomUnitRow,
        BaseReferences<_$AppDatabase, $CustomUnitsTable, CustomUnitRow>,
      ),
      CustomUnitRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$OffersTableTableManager get offers =>
      $$OffersTableTableManager(_db, _db.offers);
  $$OfferItemsTableTableManager get offerItems =>
      $$OfferItemsTableTableManager(_db, _db.offerItems);
  $$TemplatesTableTableManager get templates =>
      $$TemplatesTableTableManager(_db, _db.templates);
  $$TemplateItemsTableTableManager get templateItems =>
      $$TemplateItemsTableTableManager(_db, _db.templateItems);
  $$CustomUnitsTableTableManager get customUnits =>
      $$CustomUnitsTableTableManager(_db, _db.customUnits);
}
