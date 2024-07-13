import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';

class TambahBarang extends StatefulWidget {
  const TambahBarang({super.key});

  @override
  State<TambahBarang> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _hargaJualController = TextEditingController();
  TextEditingController _tglExpController = TextEditingController();
  TextEditingController _stokController = TextEditingController();


int generateRandomId() {
  var rng = Random();
  return rng.nextInt(1000000000); // Generate a random number between 0 and 99999
}

 Future<void> _simpanData(BuildContext context) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    int idBarang = generateRandomId();

    await database.rawInsert('''
      INSERT INTO barang (id_barang, nama_barang, harga_jual, tgl_exp, stok)
      VALUES (?, ?, ?, ?, ?)
    ''', [
      idBarang,
      _namaBarangController.text,
      _hargaJualController.text,
      _tglExpController.text,
      _stokController.text,
    ]);

    // Tampilkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data Barang berhasil ditambahkan'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Informasi Barang', style: Theme.of(context).textTheme.headlineMedium),
            TextFormField(
              controller: _namaBarangController,
              decoration: InputDecoration(labelText: 'Nama Barang'),
            ),
            TextFormField(
              controller: _hargaJualController,
              decoration: InputDecoration(labelText: 'Harga Jual'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _tglExpController,
              decoration: InputDecoration(labelText: 'Tanggal Exp (YYYY-MM-DD)'),
            ),
            TextFormField(
              controller: _stokController,
              decoration: InputDecoration(labelText: 'Stok'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
            onPressed: () async {
            await _simpanData(context);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data Barang berhasil ditambahkan'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text('Simpan'),
        ),

          ],
        ),
      ),
    );
  }
}
