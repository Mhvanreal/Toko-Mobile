import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 // Tambahkan ini untuk format tanggal

class RestokBarang extends StatefulWidget {
  final int idBarang;

  RestokBarang({required this.idBarang});

  @override
  _ReStokBarangPageState createState() => _ReStokBarangPageState();
}

class _ReStokBarangPageState extends State<RestokBarang> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _RestokpcsbarangController = TextEditingController();
  final TextEditingController _RestokPaxbarangContoleer = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();

  String? namaBarang;
  List<Map<String, dynamic>> suplayerList = [];
  int? selectedSuplayerId;
  String? selectedSuplayerName;

  @override
  void initState() {
    super.initState();
    _fetchBarangData();
    _tanggalController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _fetchBarangData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    // Fetch barang data
    List<Map<String, dynamic>> barangData = await database.query(
      'barang',
      where: 'id_barang = ?',
      whereArgs: [widget.idBarang],
    );

    if (barangData.isNotEmpty) {
      setState(() {
        namaBarang = barangData[0]['nama_barang'];
      });
    }

    // Fetch suplayer data for the specific barang
    List<Map<String, dynamic>> suplayerData = await database.rawQuery('''
      SELECT s.id_sup, s.nama_sup 
      FROM suplyer s 
      JOIN dtl_suply ds ON s.id_sup = ds.id_sup 
      WHERE ds.id_barang = ?
    ''', [widget.idBarang]);

    setState(() {
      suplayerList = suplayerData;
      if (suplayerList.isNotEmpty) {
        selectedSuplayerId = suplayerList[0]['id_sup'];
        selectedSuplayerName = suplayerList[0]['nama_sup'];
      }
    });
  }

  void _restokBarang(BuildContext context) async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    int jumlahRestok = int.parse(_RestokpcsbarangController.text);
    int hargaBeli = int.parse(_hargaBeliController.text);

    await database.rawUpdate('''
      UPDATE barang
      SET stok_biji = stok_biji + ?
      WHERE id_barang = ?
    ''', 
    [jumlahRestok, widget.idBarang]);

    // Insert detail restok
    await database.rawInsert('''
      INSERT INTO dtl_suply (
        id_sup,
        id_barang,
        hargaBeli,
        reStok,
        tgl_reStok,
        total_harga
      ) VALUES (?, ?, ?, ?, ?, ?)
      ''', [
      selectedSuplayerId,
      widget.idBarang,
      hargaBeli,
      jumlahRestok,
      _tanggalController.text,
      hargaBeli * jumlahRestok,
    ]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Barang berhasil di-restok'),
        duration: Duration(seconds: 4),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restok Barang'),
        backgroundColor: Color.fromARGB(255, 242, 71, 9),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if(namaBarang != null)
                Text(
                  '$namaBarang',
                  style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )else CircularProgressIndicator(),
                SizedBox(height: 12,),
                Text('ReStok Barang Pcs', style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: TextFormField(
                    controller: _RestokpcsbarangController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Masukan Jumlah ReStok barang pcs',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('ReStok Barang Pax', style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: TextFormField(
                    controller: _RestokPaxbarangContoleer,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Masukan Jumlah ReStok barang Pax',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text('Tanggal Restok Barang', style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: TextFormField(
                    controller: _tanggalController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Tanggal Restok Barang',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    enabled: false, // Disable editing
                  ),
                ),
                SizedBox(height: 16),
                Text('Total Harga Barang', style: TextStyle(color: Colors.black, fontSize: 16)),
                SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: TextFormField(
                    controller: _hargaBeliController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Masukan Total pembelian reStok barang',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Total Pembelian Restok barang harus diisi';
                      }
                      return null;
                    },
                  ),
                ),
               SizedBox(height: 16.0),
                if (selectedSuplayerName != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Supplier', style: TextStyle(color: Colors.black, fontSize: 16)),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: TextFormField(
                          controller: TextEditingController(text: selectedSuplayerName),
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Nama Supplier',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          enabled: false,
                        ),
                      ),
                    ],
                  )
                else
                  CircularProgressIndicator(),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _restokBarang(context);
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
