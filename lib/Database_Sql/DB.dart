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

 Future<List<Map<String, dynamic>>> getKaryawanUsers() async {
  Database db = await database;
  return await db.query('user', where: 'role = ?', whereArgs: ['karyawan']);
}

Future<List<Map<String, dynamic>>> getDataBarang() async{
    Database db = await database;
    return await db.query('barang');
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
  id_barang INTEGER PRIMARY KEY,
  nama_barang TEXT,
  harga_jual TEXT,
  tgl_exp Date,
  stok TEXT
    )
  ''');

  await db.execute('''
  CREATE TABLE suplyer (
  id_sup INTEGER PRIMARY KEY AUTOINCREMENT,
  nama_sup TEXT,
  no_telp TEXT,
  alamat TEXT

  )
    ''');
    
//   await db.execute('''
//   CREATE TABLE dtl_suply(
//   hargaBeli TEXT,
//   reStok TEXT,
//   tgl_reStok Date,
//   total_harga TEXT,
//   FOREIGN KEY (id_sup) REFERENCES suplyer (id_sup),
//   FOREIGN KEY (id_barang) REFERENCES barang (id_barang)
//   )
//   ''');

  await db.execute('''
  CREATE TABLE pembeli (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT
  )
''');

  }


  //  Future<List<Map<String, dynamic>>> getBarang() async {
  //   Database db = await database;
  //   return await db.rawQuery('''
  //   SELECT barang.*, dtl_suply.hargaBeli, dtl_suply.reStok, dtl_suply.tgl_reStok, dtl_suply.total_harga
  //   FROM barang
  //   LEFT JOIN dtl_suply ON barang.id_barang = dtl_suply.id_barang
  //   ''');
  // }

  
}
