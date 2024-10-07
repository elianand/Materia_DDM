// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
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

  MachinesDao? _machinesDaoInstance;

  UsersDao? _usersDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
            'CREATE TABLE IF NOT EXISTS `User` (`idUser` INTEGER PRIMARY KEY AUTOINCREMENT, `idComp` INTEGER NOT NULL, `name` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `age` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Machine` (`id` INTEGER NOT NULL, `idType` INTEGER NOT NULL, `idComp` INTEGER NOT NULL, `brand` TEXT, `description` TEXT, `posterUrl` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `InjectionMolding` (`id` INTEGER NOT NULL, `brand` TEXT NOT NULL, `description` TEXT NOT NULL, `posterUrl` TEXT, `temp` INTEGER NOT NULL, `pressure` INTEGER NOT NULL, `produced` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Crusher` (`id` INTEGER NOT NULL, `brand` TEXT NOT NULL, `description` TEXT NOT NULL, `posterUrl` TEXT, `speed` INTEGER NOT NULL, `capacity` INTEGER NOT NULL, `active` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MachinesDao get machinesDao {
    return _machinesDaoInstance ??= _$MachinesDao(database, changeListener);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
  }
}

class _$MachinesDao extends MachinesDao {
  _$MachinesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _machineInsertionAdapter = InsertionAdapter(
            database,
            'Machine',
            (Machine item) => <String, Object?>{
                  'id': item.id,
                  'idType': item.idType,
                  'idComp': item.idComp,
                  'brand': item.brand,
                  'description': item.description,
                  'posterUrl': item.posterUrl
                }),
        _injectionMoldingInsertionAdapter = InsertionAdapter(
            database,
            'InjectionMolding',
            (InjectionMolding item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'description': item.description,
                  'posterUrl': item.posterUrl,
                  'temp': item.temp,
                  'pressure': item.pressure,
                  'produced': item.produced
                }),
        _crusherInsertionAdapter = InsertionAdapter(
            database,
            'Crusher',
            (Crusher item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'description': item.description,
                  'posterUrl': item.posterUrl,
                  'speed': item.speed,
                  'capacity': item.capacity,
                  'active': item.active
                }),
        _machineUpdateAdapter = UpdateAdapter(
            database,
            'Machine',
            ['id'],
            (Machine item) => <String, Object?>{
                  'id': item.id,
                  'idType': item.idType,
                  'idComp': item.idComp,
                  'brand': item.brand,
                  'description': item.description,
                  'posterUrl': item.posterUrl
                }),
        _injectionMoldingUpdateAdapter = UpdateAdapter(
            database,
            'InjectionMolding',
            ['id'],
            (InjectionMolding item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'description': item.description,
                  'posterUrl': item.posterUrl,
                  'temp': item.temp,
                  'pressure': item.pressure,
                  'produced': item.produced
                }),
        _crusherUpdateAdapter = UpdateAdapter(
            database,
            'Crusher',
            ['id'],
            (Crusher item) => <String, Object?>{
                  'id': item.id,
                  'brand': item.brand,
                  'description': item.description,
                  'posterUrl': item.posterUrl,
                  'speed': item.speed,
                  'capacity': item.capacity,
                  'active': item.active
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Machine> _machineInsertionAdapter;

  final InsertionAdapter<InjectionMolding> _injectionMoldingInsertionAdapter;

  final InsertionAdapter<Crusher> _crusherInsertionAdapter;

  final UpdateAdapter<Machine> _machineUpdateAdapter;

  final UpdateAdapter<InjectionMolding> _injectionMoldingUpdateAdapter;

  final UpdateAdapter<Crusher> _crusherUpdateAdapter;

  @override
  Future<List<Machine>> findAllMachines() async {
    return _queryAdapter.queryList('SELECT * FROM Machine',
        mapper: (Map<String, Object?> row) => Machine(
            id: row['id'] as int,
            idType: row['idType'] as int,
            idComp: row['idComp'] as int,
            brand: row['brand'] as String?,
            description: row['description'] as String?,
            posterUrl: row['posterUrl'] as String?));
  }

  @override
  Future<List<InjectionMolding>> findAllInjMoldMachines() async {
    return _queryAdapter.queryList('SELECT * FROM InjectionMolding',
        mapper: (Map<String, Object?> row) => InjectionMolding(
            id: row['id'] as int,
            brand: row['brand'] as String,
            description: row['description'] as String,
            posterUrl: row['posterUrl'] as String?,
            temp: row['temp'] as int,
            pressure: row['pressure'] as int,
            produced: row['produced'] as int));
  }

  @override
  Future<List<Crusher>> findAllCrusherMachines() async {
    return _queryAdapter.queryList('SELECT * FROM Crusher',
        mapper: (Map<String, Object?> row) => Crusher(
            id: row['id'] as int,
            brand: row['brand'] as String,
            description: row['description'] as String,
            posterUrl: row['posterUrl'] as String?,
            speed: row['speed'] as int,
            capacity: row['capacity'] as int));
  }

  @override
  Future<Machine?> findMachineById(int id) async {
    return _queryAdapter.query('SELECT * FROM Machine WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Machine(
            id: row['id'] as int,
            idType: row['idType'] as int,
            idComp: row['idComp'] as int,
            brand: row['brand'] as String?,
            description: row['description'] as String?,
            posterUrl: row['posterUrl'] as String?),
        arguments: [id]);
  }

  @override
  Future<InjectionMolding?> findInyectMoldMachineById(int id) async {
    return _queryAdapter.query('SELECT * FROM InjectionMolding WHERE id = ?1',
        mapper: (Map<String, Object?> row) => InjectionMolding(
            id: row['id'] as int,
            brand: row['brand'] as String,
            description: row['description'] as String,
            posterUrl: row['posterUrl'] as String?,
            temp: row['temp'] as int,
            pressure: row['pressure'] as int,
            produced: row['produced'] as int),
        arguments: [id]);
  }

  @override
  Future<Crusher?> findCrusherMachineById(int id) async {
    return _queryAdapter.query('SELECT * FROM Crusher WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Crusher(
            id: row['id'] as int,
            brand: row['brand'] as String,
            description: row['description'] as String,
            posterUrl: row['posterUrl'] as String?,
            speed: row['speed'] as int,
            capacity: row['capacity'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Machine>?> findMachinesByIdComp(int idComp) async {
    return _queryAdapter.queryList('SELECT * FROM Machine WHERE idComp = ?1',
        mapper: (Map<String, Object?> row) => Machine(
            id: row['id'] as int,
            idType: row['idType'] as int,
            idComp: row['idComp'] as int,
            brand: row['brand'] as String?,
            description: row['description'] as String?,
            posterUrl: row['posterUrl'] as String?),
        arguments: [idComp]);
  }

  @override
  Future<List<Machine>> findMachineByIdCompAndIdType(
    int idComp,
    int idType,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Machine WHERE idComp = ?1 and idType = ?2',
        mapper: (Map<String, Object?> row) => Machine(
            id: row['id'] as int,
            idType: row['idType'] as int,
            idComp: row['idComp'] as int,
            brand: row['brand'] as String?,
            description: row['description'] as String?,
            posterUrl: row['posterUrl'] as String?),
        arguments: [idComp, idType]);
  }

  @override
  Future<List<InjectionMolding>> findInyectMoldMachineByIdComp(
      int idComp) async {
    return _queryAdapter.queryList(
        'SELECT i.* FROM InjectionMolding i INNER JOIN Machine m ON m.id = i.id WHERE m.idType = 1 AND m.idComp = ?1',
        mapper: (Map<String, Object?> row) => InjectionMolding(id: row['id'] as int, brand: row['brand'] as String, description: row['description'] as String, posterUrl: row['posterUrl'] as String?, temp: row['temp'] as int, pressure: row['pressure'] as int, produced: row['produced'] as int),
        arguments: [idComp]);
  }

  @override
  Future<List<Crusher>> findCrusherMachineByIdComp(int idComp) async {
    return _queryAdapter.queryList(
        'SELECT c.* FROM Crusher c INNER JOIN Machine m ON m.id = c.id WHERE m.idType = 2 AND m.idComp = ?1',
        mapper: (Map<String, Object?> row) => Crusher(id: row['id'] as int, brand: row['brand'] as String, description: row['description'] as String, posterUrl: row['posterUrl'] as String?, speed: row['speed'] as int, capacity: row['capacity'] as int),
        arguments: [idComp]);
  }

  @override
  Future<List<int>> findAllMachineIds() async {
    return _queryAdapter.queryList('SELECT id FROM Machine',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> deleteMachine(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Machine WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteInjMoldMachine(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM InjectionMolding WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteCrusherMachine(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Crusher WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> updateInyectMoldMachineById(
    int id,
    int temp,
    int pressure,
    int produced,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE InjectionMolding SET temp = ?2, pressure = ?3, produced = ?4 WHERE id = ?1',
        arguments: [id, temp, pressure, produced]);
  }

  @override
  Future<void> updateCrusherMachineById(
    int id,
    int active,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Crusher SET active = ?2 WHERE id = ?1',
        arguments: [id, active]);
  }

  @override
  Future<void> insertMachine(Machine machine) async {
    await _machineInsertionAdapter.insert(machine, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertInjMoldMachine(InjectionMolding machine) async {
    await _injectionMoldingInsertionAdapter.insert(
        machine, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertCrusherMachine(Crusher machine) async {
    await _crusherInsertionAdapter.insert(machine, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMachine(Machine machine) async {
    await _machineUpdateAdapter.update(machine, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateInyectMoldMachine(InjectionMolding machine) async {
    await _injectionMoldingUpdateAdapter.update(
        machine, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCrusherMachine(Crusher machine) async {
    await _crusherUpdateAdapter.update(machine, OnConflictStrategy.abort);
  }
}

class _$UsersDao extends UsersDao {
  _$UsersDao(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            idUser: row['idUser'] as int?,
            idComp: row['idComp'] as int,
            name: row['name'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            age: row['age'] as int?));
  }
}
