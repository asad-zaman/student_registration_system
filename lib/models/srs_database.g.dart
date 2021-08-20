// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'srs_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorSrsDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SrsDatabaseBuilder databaseBuilder(String name) =>
      _$SrsDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SrsDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$SrsDatabaseBuilder(null);
}

class _$SrsDatabaseBuilder {
  _$SrsDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$SrsDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$SrsDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<SrsDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SrsDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SrsDatabase extends SrsDatabase {
  _$SrsDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `User` (`username` TEXT NOT NULL, `password` TEXT NOT NULL, `mobile` TEXT, `gender` TEXT, `firstname` TEXT NOT NULL, `lastname` TEXT NOT NULL, `picture` TEXT, `location` TEXT, `registrationDate` TEXT NOT NULL, `registrationBy` TEXT NOT NULL, `userType` INTEGER, PRIMARY KEY (`username`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'username': item.username,
                  'password': item.password,
                  'mobile': item.mobile,
                  'gender': item.gender,
                  'firstname': item.firstname,
                  'lastname': item.lastname,
                  'picture': item.picture,
                  'location': item.location,
                  'registrationDate': item.registrationDate,
                  'registrationBy': item.registrationBy,
                  'userType': item.userType
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['username'],
            (User item) => <String, Object?>{
                  'username': item.username,
                  'password': item.password,
                  'mobile': item.mobile,
                  'gender': item.gender,
                  'firstname': item.firstname,
                  'lastname': item.lastname,
                  'picture': item.picture,
                  'location': item.location,
                  'registrationDate': item.registrationDate,
                  'registrationBy': item.registrationBy,
                  'userType': item.userType
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            username: row['username'] as String,
            password: row['password'] as String,
            mobile: row['mobile'] as String?,
            gender: row['gender'] as String?,
            firstname: row['firstname'] as String,
            lastname: row['lastname'] as String,
            picture: row['picture'] as String?,
            location: row['location'] as String?,
            registrationDate: row['registrationDate'] as String,
            registrationBy: row['registrationBy'] as String,
            userType: row['userType'] as int?));
  }

  @override
  Future<List<User>> findAllUsersExceptCurrent(String username) async {
    return _queryAdapter.queryList('SELECT * FROM User WHERE username != ?1',
        mapper: (Map<String, Object?> row) => User(
            username: row['username'] as String,
            password: row['password'] as String,
            mobile: row['mobile'] as String?,
            gender: row['gender'] as String?,
            firstname: row['firstname'] as String,
            lastname: row['lastname'] as String,
            picture: row['picture'] as String?,
            location: row['location'] as String?,
            registrationDate: row['registrationDate'] as String,
            registrationBy: row['registrationBy'] as String,
            userType: row['userType'] as int?),
        arguments: [username]);
  }

  @override
  Future<User?> findUserByUnsername(String username) async {
    return _queryAdapter.query('SELECT * FROM User WHERE username =?1',
        mapper: (Map<String, Object?> row) => User(
            username: row['username'] as String,
            password: row['password'] as String,
            mobile: row['mobile'] as String?,
            gender: row['gender'] as String?,
            firstname: row['firstname'] as String,
            lastname: row['lastname'] as String,
            picture: row['picture'] as String?,
            location: row['location'] as String?,
            registrationDate: row['registrationDate'] as String,
            registrationBy: row['registrationBy'] as String,
            userType: row['userType'] as int?),
        arguments: [username]);
  }

  @override
  Future<List<User>> findUserByAdmin(String registrationBy) async {
    return _queryAdapter.queryList(
        'SELECT * FROM User WHERE registrationBy =?1',
        mapper: (Map<String, Object?> row) => User(
            username: row['username'] as String,
            password: row['password'] as String,
            mobile: row['mobile'] as String?,
            gender: row['gender'] as String?,
            firstname: row['firstname'] as String,
            lastname: row['lastname'] as String,
            picture: row['picture'] as String?,
            location: row['location'] as String?,
            registrationDate: row['registrationDate'] as String,
            registrationBy: row['registrationBy'] as String,
            userType: row['userType'] as int?),
        arguments: [registrationBy]);
  }

  @override
  Future<User?> findUserByMobile(String mobile) async {
    return _queryAdapter.query('SELECT * FROM User WHERE mobileNo =?1',
        mapper: (Map<String, Object?> row) => User(
            username: row['username'] as String,
            password: row['password'] as String,
            mobile: row['mobile'] as String?,
            gender: row['gender'] as String?,
            firstname: row['firstname'] as String,
            lastname: row['lastname'] as String,
            picture: row['picture'] as String?,
            location: row['location'] as String?,
            registrationDate: row['registrationDate'] as String,
            registrationBy: row['registrationBy'] as String,
            userType: row['userType'] as int?),
        arguments: [mobile]);
  }

  @override
  Future<void> deleteUserByUnsername(String username) async {
    await _queryAdapter.queryNoReturn('DELETE FROM User WHERE username =?1',
        arguments: [username]);
  }

  @override
  Future<int> insertUser(User user) {
    return _userInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}
