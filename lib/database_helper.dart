import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  //Create a database in sqlflite
  static Database? _database;
  static const String dbName = 'log_database.db';
  static const String tableName = 'users';

  // Open database
  static Future<Database> get database async {
    if (_database != null) return _database!;
    print("DATABASE HAS INITIALIZED");
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);

    // Check if the database file exists
    bool exists = await databaseExists(path);
    if (!exists) {
      // check if the database existed create on callback if not
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          //Create a table for the DB
          await db.execute('''
            CREATE TABLE $tableName(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              username TEXT,
              password TEXT,
              email TEXT,
              phone TEXT,
              address TEXT,
              dateOfBirth TEXT,
              gender TEXT
            )
          ''');
        },
      );
    } else {
      // If the database file already exists, simply open it
      return await openDatabase(path);
    }
  }

  // Insert user into database
  static Future<void> insertUser(
    String name,
    String username,
    String password,
    String email,
    String phone,
    String address,
    String dateOfBirth,
    String gender,
  ) async {
    final db = await database;

    // Check if the username already exists in the database
    List<Map<String, dynamic>> existingUsers = await db.query(
      tableName,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (existingUsers.isEmpty) {
      // If the username doesn't exist, insert the new user
      await db.insert(
        tableName,
        {
          'name': name,
          'username': username,
          'password': password,
          'email': email,
          'phone': phone,
          'address': address,
          'dateOfBirth': dateOfBirth,
          'gender': gender,
        },
      );
      print('User inserted successfully');
    } else {
      print('Username already exists');
    }
  }

  // Retrieve all users from database
  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query(tableName);
  }

  static Future<bool> checkUsernameExists(String username) async {
    final db = await database;

    // Query the database to check if a user with the provided username exists
    List<Map<String, dynamic>> result = await db.query(
      tableName,
      where: 'username = ?',
      whereArgs: [username],
    );

    // If the query result is not empty, it means a user with the provided username already exists
    return result.isNotEmpty;
  }

  // Check user credentials
  static Future<bool> checkUserCredentials(
    String username,
    String password,
  ) async {
    final db = await database;
    List<Map<String, dynamic>> users = await db.query(
      tableName,
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    return users.isNotEmpty;
  }
}
