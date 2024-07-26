import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class EditBarang extends StatefulWidget {
  final int idBarang;

  const EditBarang({Key? key, required this.idBarang}) : super(key: key);

  @override
  _EditBarangState createState() => _EditBarangState();
}

class _EditBarangState extends State<EditBarang> {
  final TextEditingController _namaBarangController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();
  final TextEditingController _hargaPerPaxController = TextEditingController();
  final TextEditingController _stokBijiController = TextEditingController();
  final TextEditingController _stokPaxController = TextEditingController();
  final TextEditingController _jumlahPerPaxController = TextEditingController();
  final TextEditingController _tglExpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBarangData();
  }

  Future<void> _loadBarangData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    List<Map<String, dynamic>> barangData = await database.query(
      'barang',
      where: 'id_barang = ?',
      whereArgs: [widget.idBarang],
    );

    if (barangData.isNotEmpty) {
      setState(() {
        _namaBarangController.text = barangData[0]['nama_barang'];
        _hargaJualController.text = barangData[0]['harga_jual'].toString();
        _hargaPerPaxController.text = barangData[0]['harga_per_pax'].toString();
        // _stokBijiController.text = barangData[0]['stok_biji'].toString();
        // _stokPaxController.text = barangData[0]['stok_pax'].toString();
        // _jumlahPerPaxController.text = barangData[0]['jumlah_per_pax'].toString();
        _tglExpController.text = barangData[0]['tgl_exp'];
      });
    }
  }

  Future<void> _updateBarang(BuildContext context )async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    await database.update(
      'barang',
      {
        'nama_barang': _namaBarangController.text,
        'harga_jual': int.parse(_hargaJualController.text),
        'harga_per_pax': int.parse(_hargaPerPaxController.text),
        // 'stok_biji': int.parse(_stokBijiController.text),
        // 'stok_pax': int.parse(_stokPaxController.text),
        // 'jumlah_per_pax': int.parse(_jumlahPerPaxController.text),
        'tgl_exp': _tglExpController.text,
      },
      where: 'id_barang = ?',
      whereArgs: [widget.idBarang],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Barang berhasil diperbarui'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Barang')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _namaBarangController,
              decoration: InputDecoration(labelText: 'Nama Barang'),
            ),
            TextField(
              controller: _hargaJualController,
              decoration: InputDecoration(labelText: 'Harga Jual'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _hargaPerPaxController,
              decoration: InputDecoration(labelText: 'Harga per Pax'),
              keyboardType: TextInputType.number,
            ),
            // TextField(
            //   controller: _stokBijiController,
            //   decoration: InputDecoration(labelText: 'Stok Biji'),
            //   keyboardType: TextInputType.number,
            // ),
            // TextField(
            //   controller: _stokPaxController,
            //   decoration: InputDecoration(labelText: 'Stok Pax'),
            //   keyboardType: TextInputType.number,
            // ),
            // TextField(
            //   controller: _jumlahPerPaxController,
            //   decoration: InputDecoration(labelText: 'Jumlah per Pax'),
            //   keyboardType: TextInputType.number,
            // ),
            TextField(
              controller: _tglExpController,
              decoration: InputDecoration(labelText: 'Tanggal Expiry'),
            ),
            SizedBox(height: 20),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: ElevatedButton(
                onPressed: () async {
                await _updateBarang(context);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.indigo,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit,
                  color: Colors.yellow,
                  ),
                  SizedBox(width: 7,),
                  Text('Edit Barang', style: TextStyle(fontSize: 20, color: Colors.yellow),)
                ],
                ),
                ),
            ),
          ],
        ),
      ),
    );
  }
}


