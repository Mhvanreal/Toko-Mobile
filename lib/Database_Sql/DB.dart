import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
  await db.execute('''
    CREATE TABLE user (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      email TEXT,
      password TEXT,
      role TEXT,
      pertanyaan TEXT,
      jawaban TEXT
    )
  ''');

    // Contoh Table yang berelasi //

    //   await db.execute('''
    //   CREATE TABLE posts (
    //     id INTEGER PRIMARY KEY AUTOINCREMENT,
    //     user_id INTEGER,
    //     title TEXT,
    //     content TEXT,
    //     FOREIGN KEY (user_id) REFERENCES user (id) ON DELETE CASCADE
    //   )
    // ''');
  }

  Future<int> insertUser (Map<String, dynamic> user ) async {
    Database db = await database;
    return await db.insert('user', user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query('user');
  }

Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'app_database.db');
    await databaseFactory.deleteDatabase(path);
  }
  

  
}
