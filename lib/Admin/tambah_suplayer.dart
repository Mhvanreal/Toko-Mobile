import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AddSuplayer extends StatefulWidget {
  const AddSuplayer({super.key});

  @override
  State<AddSuplayer> createState() => _AddSuplayerState();
}

class _AddSuplayerState extends State<AddSuplayer> {
  TextEditingController namaSuplay = TextEditingController();
  TextEditingController noTelp = TextEditingController();
  TextEditingController alamat = TextEditingController();

  int generateRandomIdsup() {
    var rng = Random();
    return rng.nextInt(1000000000);
  }

  Future<void> Addsup(BuildContext context) async {
    try{
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    int idsup = generateRandomIdsup();
    await database.rawInsert('''
    INSERT INTO suplyer (
    id_sup,
    nama_sup,
    no_telp,
    alamat
    ) VALUES (?,?,?,?)
    ''', [
      idsup,
      namaSuplay.text,
      noTelp.text,
      alamat.text,
    ]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data Suplayer berhasil ditambahkan'),
        duration: Duration(seconds: 4),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }catch (e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menambahkan data suplayer: $e'),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
      ),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Tambah Suplayer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 242, 71, 9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Nama Suplayer',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: TextFormField(
                controller: namaSuplay,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Masukan Nama Suplayer',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Suplayer harus diisi';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Nomor Handphone',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: TextFormField(
                controller: noTelp,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Masukan Nomor Handphone',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor Handphone harus diisi';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Alamat',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: TextFormField(
                controller: alamat,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Masukan Alamat Suplayer',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat Suplayer harus diisi';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: ElevatedButton(
                onPressed: () async {
                  await Addsup(context);
                  Navigator.of(context).pop();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Data Suplyer berhasil ditambahkan'),
                  //     duration: Duration(seconds: 2),
                  //   ),
                  // );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.indigo,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Tambah Suplayer',
                      style: TextStyle(fontSize: 20, color: Colors.yellow),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
