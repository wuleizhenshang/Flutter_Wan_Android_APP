// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HotWallpaperTableTable extends HotWallpaperTable
    with TableInfo<$HotWallpaperTableTable, HotWallpaperTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HotWallpaperTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imgUrlMeta = const VerificationMeta('imgUrl');
  @override
  late final GeneratedColumn<String> imgUrl = GeneratedColumn<String>(
      'img_url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, description, imgUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hot_wallpaper_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<HotWallpaperTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('img_url')) {
      context.handle(_imgUrlMeta,
          imgUrl.isAcceptableOrUnknown(data['img_url']!, _imgUrlMeta));
    } else if (isInserting) {
      context.missing(_imgUrlMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HotWallpaperTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HotWallpaperTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      imgUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}img_url'])!,
    );
  }

  @override
  $HotWallpaperTableTable createAlias(String alias) {
    return $HotWallpaperTableTable(attachedDatabase, alias);
  }
}

class HotWallpaperTableData extends DataClass
    implements Insertable<HotWallpaperTableData> {
  final int id;
  final String description;
  final String imgUrl;
  const HotWallpaperTableData(
      {required this.id, required this.description, required this.imgUrl});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['description'] = Variable<String>(description);
    map['img_url'] = Variable<String>(imgUrl);
    return map;
  }

  HotWallpaperTableCompanion toCompanion(bool nullToAbsent) {
    return HotWallpaperTableCompanion(
      id: Value(id),
      description: Value(description),
      imgUrl: Value(imgUrl),
    );
  }

  factory HotWallpaperTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HotWallpaperTableData(
      id: serializer.fromJson<int>(json['id']),
      description: serializer.fromJson<String>(json['description']),
      imgUrl: serializer.fromJson<String>(json['imgUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'description': serializer.toJson<String>(description),
      'imgUrl': serializer.toJson<String>(imgUrl),
    };
  }

  HotWallpaperTableData copyWith(
          {int? id, String? description, String? imgUrl}) =>
      HotWallpaperTableData(
        id: id ?? this.id,
        description: description ?? this.description,
        imgUrl: imgUrl ?? this.imgUrl,
      );
  HotWallpaperTableData copyWithCompanion(HotWallpaperTableCompanion data) {
    return HotWallpaperTableData(
      id: data.id.present ? data.id.value : this.id,
      description:
          data.description.present ? data.description.value : this.description,
      imgUrl: data.imgUrl.present ? data.imgUrl.value : this.imgUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HotWallpaperTableData(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('imgUrl: $imgUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, description, imgUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HotWallpaperTableData &&
          other.id == this.id &&
          other.description == this.description &&
          other.imgUrl == this.imgUrl);
}

class HotWallpaperTableCompanion
    extends UpdateCompanion<HotWallpaperTableData> {
  final Value<int> id;
  final Value<String> description;
  final Value<String> imgUrl;
  const HotWallpaperTableCompanion({
    this.id = const Value.absent(),
    this.description = const Value.absent(),
    this.imgUrl = const Value.absent(),
  });
  HotWallpaperTableCompanion.insert({
    this.id = const Value.absent(),
    required String description,
    required String imgUrl,
  })  : description = Value(description),
        imgUrl = Value(imgUrl);
  static Insertable<HotWallpaperTableData> custom({
    Expression<int>? id,
    Expression<String>? description,
    Expression<String>? imgUrl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (description != null) 'description': description,
      if (imgUrl != null) 'img_url': imgUrl,
    });
  }

  HotWallpaperTableCompanion copyWith(
      {Value<int>? id, Value<String>? description, Value<String>? imgUrl}) {
    return HotWallpaperTableCompanion(
      id: id ?? this.id,
      description: description ?? this.description,
      imgUrl: imgUrl ?? this.imgUrl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imgUrl.present) {
      map['img_url'] = Variable<String>(imgUrl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HotWallpaperTableCompanion(')
          ..write('id: $id, ')
          ..write('description: $description, ')
          ..write('imgUrl: $imgUrl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HotWallpaperTableTable hotWallpaperTable =
      $HotWallpaperTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [hotWallpaperTable];
}

typedef $$HotWallpaperTableTableCreateCompanionBuilder
    = HotWallpaperTableCompanion Function({
  Value<int> id,
  required String description,
  required String imgUrl,
});
typedef $$HotWallpaperTableTableUpdateCompanionBuilder
    = HotWallpaperTableCompanion Function({
  Value<int> id,
  Value<String> description,
  Value<String> imgUrl,
});

class $$HotWallpaperTableTableFilterComposer
    extends Composer<_$AppDatabase, $HotWallpaperTableTable> {
  $$HotWallpaperTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imgUrl => $composableBuilder(
      column: $table.imgUrl, builder: (column) => ColumnFilters(column));
}

class $$HotWallpaperTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HotWallpaperTableTable> {
  $$HotWallpaperTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imgUrl => $composableBuilder(
      column: $table.imgUrl, builder: (column) => ColumnOrderings(column));
}

class $$HotWallpaperTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HotWallpaperTableTable> {
  $$HotWallpaperTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imgUrl =>
      $composableBuilder(column: $table.imgUrl, builder: (column) => column);
}

class $$HotWallpaperTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HotWallpaperTableTable,
    HotWallpaperTableData,
    $$HotWallpaperTableTableFilterComposer,
    $$HotWallpaperTableTableOrderingComposer,
    $$HotWallpaperTableTableAnnotationComposer,
    $$HotWallpaperTableTableCreateCompanionBuilder,
    $$HotWallpaperTableTableUpdateCompanionBuilder,
    (
      HotWallpaperTableData,
      BaseReferences<_$AppDatabase, $HotWallpaperTableTable,
          HotWallpaperTableData>
    ),
    HotWallpaperTableData,
    PrefetchHooks Function()> {
  $$HotWallpaperTableTableTableManager(
      _$AppDatabase db, $HotWallpaperTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HotWallpaperTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HotWallpaperTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HotWallpaperTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> description = const Value.absent(),
            Value<String> imgUrl = const Value.absent(),
          }) =>
              HotWallpaperTableCompanion(
            id: id,
            description: description,
            imgUrl: imgUrl,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String description,
            required String imgUrl,
          }) =>
              HotWallpaperTableCompanion.insert(
            id: id,
            description: description,
            imgUrl: imgUrl,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HotWallpaperTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HotWallpaperTableTable,
    HotWallpaperTableData,
    $$HotWallpaperTableTableFilterComposer,
    $$HotWallpaperTableTableOrderingComposer,
    $$HotWallpaperTableTableAnnotationComposer,
    $$HotWallpaperTableTableCreateCompanionBuilder,
    $$HotWallpaperTableTableUpdateCompanionBuilder,
    (
      HotWallpaperTableData,
      BaseReferences<_$AppDatabase, $HotWallpaperTableTable,
          HotWallpaperTableData>
    ),
    HotWallpaperTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HotWallpaperTableTableTableManager get hotWallpaperTable =>
      $$HotWallpaperTableTableTableManager(_db, _db.hotWallpaperTable);
}

mixin _$HotWallpaperDaoMixin on DatabaseAccessor<AppDatabase> {
  $HotWallpaperTableTable get hotWallpaperTable =>
      attachedDatabase.hotWallpaperTable;
}
