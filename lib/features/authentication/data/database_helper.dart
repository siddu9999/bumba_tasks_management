import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'authentication_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'auth_database.db');
    return await openDatabase(
      path,
      version: 2, // Ensure correct version for session table
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, password TEXT)',
        );
        await db.execute(
          'CREATE TABLE session(id INTEGER PRIMARY KEY AUTOINCREMENT, isLoggedIn INTEGER, userId INTEGER)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS session(id INTEGER PRIMARY KEY AUTOINCREMENT, isLoggedIn INTEGER, userId INTEGER)',
          );
        }
      },
    );
  }


  Future<void> insertUser(UserModel user) async {
    final db = await database;
    // Insert the user without including the `id` field
    await db.insert(
      'users',
      {
        'email': user.email,
        'password': user.password,
      },
    );
  }


  Future<UserModel?> getUserByEmail(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<void> updatePasswordByEmail(String email, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword}, // Update the password field
      where: 'email = ?',        // Match the user by email
      whereArgs: [email],
    );
  }


  // Save session: Associate logged-in userId with session
  Future<void> saveSession(int userId) async {
    final db = await database;
    await db.delete('session'); // Clear any existing session
    await db.insert('session', {
      'isLoggedIn': 1,
      'userId': userId,
    });
  }

// Clear session: Remove current user session
  Future<void> clearSession() async {
    final db = await database;
    await db.delete('session');
  }


  // Check if a session exists
  Future<bool> isLoggedIn() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('session', where: 'isLoggedIn = 1');
    return result.isNotEmpty;
  }




}
