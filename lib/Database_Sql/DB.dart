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
      version: 2,
      onCreate: _onCreate,
      // onUpgrade: _onUpgrade,
    );
  }

  Future<String> _getDbPath() async {
    return join(await getDatabasesPath(), 'app_database.db');
  }

/////////// Delete Db
// Future<void> deleteDatabaseFile() async {
//   final databasePath = await getDatabasesPath();
//   final path = join(databasePath, 'app_database.db');
//   await deleteDatabase(path);
// }


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
      harga_jual INTEGER,
      harga_per_pax INTEGER,
      stok_biji INTEGER,
      stok_pax INTEGER,
      jumlah_per_pax INTEGER,
      tgl_exp DATE
    )
  ''');

  await db.execute('''
  CREATE TABLE suplyer (
  id_sup INTEGER PRIMARY KEY ,
  nama_sup TEXT,
  no_telp TEXT,
  alamat TEXT

  )
    ''');
    
await db.execute('''
  CREATE TABLE dtl_suply (
    id_sup INTEGER,
    id_barang INTEGER,
    reStok INTEGER,
    reStok_pax INTEGER,
    tgl_reStok DATE,
    total_harga INTEGER,
    FOREIGN KEY (id_sup) REFERENCES suplyer (id_sup),
    FOREIGN KEY (id_barang) REFERENCES barang (id_barang)
  )
''');

  await db.execute('''
  CREATE TABLE pembeli (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT
  )
''');

  await db.execute('''
    CREATE TABLE transaksi (
      id_trans INTEGER PRIMARY KEY AUTOINCREMENT,
      tgl DATE,
      total_barang INTEGER,
      total_harga INTEGER,
      tunai INTEGER,
      Sts_pembayaran TEXT,
      id_pembeli INTEGER,
      id_user INTEGER,
      FOREIGN KEY (id_pembeli) REFERENCES pembeli (id),
      FOREIGN KEY (id_user) REFERENCES user (id)
    )
  ''');

 await db.execute('''
    CREATE TABLE detail_transaksi (
      id_trans INTEGER,
      id_barang INTEGER,
      qty INTEGER,
   

      total_harga INTEGER,
      FOREIGN KEY (id_trans) REFERENCES transaksi (id_trans),
      FOREIGN KEY (id_barang) REFERENCES barang (id_barang)
    )
  ''');
  //ada column harga di detail_transaksi & Nama Barang//
  }


  //  Future<List<Map<String, dynamic>>> getBarang() async {
  //   Database db = await database;
  //   return await db.rawQuery('''
  //   SELECT barang.*, dtl_suply.hargaBeli, dtl_suply.reStok, dtl_suply.tgl_reStok, dtl_suply.total_harga
  //   FROM barang
  //   LEFT JOIN dtl_suply ON barang.id_barang = dtl_suply.id_barang
  //   ''');
  // }

    

  Future<void> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    await db.insert('user', user);
  }

 Future<List<Map<String, dynamic>>> getKaryawanUsers() async {
  Database db = await database;
  return await db.query('user', where: 'role = ?', whereArgs: ['karyawan']);
}

Future<List<Map<String, dynamic>>> getAllBarang() async {
  Database db = await database;
  return await db.query('barang');
}


Future<Map<String, dynamic>> getBarangDetail(int idBarang) async {
  Database db = await database;

  // Query untuk mengambil data barang dan supplier terkait
  final query = '''
    SELECT
      b.id_barang,
      b.nama_barang,
      b.harga_jual,
      b.harga_per_pax,
      b.stok_biji,
      b.stok_pax,
      b.jumlah_per_pax,
      s.nama_sup
    FROM barang b
    LEFT JOIN dtl_suply ds ON b.id_barang = ds.id_barang
    LEFT JOIN suplyer s ON ds.id_sup = s.id_sup
    WHERE b.id_barang = ?
  ''';

  List<Map<String, dynamic>> result = await db.rawQuery(query, [idBarang]);

  if (result.isNotEmpty) {
    return result.first;
  } else {
    return {};
  }
}




//search barang berdasarkan nama barang////
Future<List<Map<String, dynamic>>> searchbarang({String? keyword}) async {
    final db = await database;

    String query = 'SELECT * FROM barang';
    if (keyword != null && keyword.isNotEmpty) {
      query += " WHERE nama_barang LIKE '%$keyword%'";
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return maps;
  }
//////////////////////

////////////////////suplayer///////////
Future<List<Map<String, dynamic>>> getDatasuplayer() async{
    Database db = await database;
    return await db.query('suplyer');
  }
///////////////////
Future<List<Map<String, dynamic>>> searchSuplayer({String? keyword}) async {
    final db = await database;

    String query = 'SELECT * FROM suplyer';
    if (keyword != null && keyword.isNotEmpty) {
      query += " WHERE nama_sup LIKE '%$keyword%'";
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    return maps;
  }

//   Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
//   if (oldVersion < 2) {
//     await db.execute('''
//       ALTER TABLE dtl_suply ADD COLUMN reStok_pax INTEGER
//     ''');
//   }
// }



}
