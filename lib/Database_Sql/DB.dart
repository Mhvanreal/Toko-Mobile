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
    String path = await _getDbPath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<String> _getDbPath() async {
    return join(await getDatabasesPath(), 'app_database.db');
  }

//  Future<void> deleteDatabase() async {
//   String path = await _getDbPath();
//   await databaseFactory.deleteDatabase(path);
//   _database = null;
// }

  Future<void> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    await db.insert('user', user);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    Database db = await database;
    return await db.query('user');
  }

  Future<void> _onCreate(Database db, int version) async {
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
  
  await db.execute('''
  CREATE TABLE barang (
  id_barang INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_barang TEXT,
  harga_jual TEXT,
  tgl_exp TEXT,
  stok TEXT
    )
  ''');

  await db.execute('''
  CREATE TABLE suplyer (
  id_sup INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_sup TEXT,
  no_telp TEXT,
  alamat TEXT,
  )
    ''');

  }

  
}
