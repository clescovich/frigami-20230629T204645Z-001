// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductsDao? _productsDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `products` (`code` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `bestBefore` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductsDao get productsDao {
    return _productsDaoInstance ??= _$ProductsDao(database, changeListener);
  }
}

class _$ProductsDao extends ProductsDao {
  _$ProductsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productsInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (Products item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'bestBefore': _dateTimeConverter.encode(item.bestBefore)
                }),
        _productsUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['code'],
            (Products item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'bestBefore': _dateTimeConverter.encode(item.bestBefore)
                }),
        _productsDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['code'],
            (Products item) => <String, Object?>{
                  'code': item.code,
                  'name': item.name,
                  'bestBefore': _dateTimeConverter.encode(item.bestBefore)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Products> _productsInsertionAdapter;

  final UpdateAdapter<Products> _productsUpdateAdapter;

  final DeletionAdapter<Products> _productsDeletionAdapter;

  @override
  Future<List<Products>> findAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM Products',
        mapper: (Map<String, Object?> row) => Products(
            row['code'] as int?,
            row['name'] as String,
            _dateTimeConverter.decode(row['bestBefore'] as int)));
  }

  @override
  Future<void> insertProduct(Products product) async {
    await _productsInsertionAdapter.insert(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProducts(Products product) async {
    await _productsUpdateAdapter.update(product, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteProducts(Products task) async {
    await _productsDeletionAdapter.delete(task);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
