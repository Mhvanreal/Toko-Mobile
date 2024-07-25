import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:toko/Admin/reStok_barang.dart';
import 'package:toko/Admin/tambah_barang.dart';
import 'package:toko/Database_Sql/DB.dart';

class DataBarangAd extends StatefulWidget {
  const DataBarangAd({super.key});

  @override
  State<DataBarangAd> createState() => _DataBarangAdState();
}

class _DataBarangAdState extends State<DataBarangAd> {
  TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _futurebarang;

  @override
  void initState() {
    super.initState();
    _futurebarang = DatabaseHelper().getAllBarang();
  }

  Future<void> DeleteBarang(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('barang', where: 'id_barang = ?', whereArgs: [id]);
    setState(() {
      _futurebarang = DatabaseHelper().getAllBarang(); 
    });
  }

  void confirmDelete(int id, BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Hapus Data',
      desc: 'Apakah Anda yakin ingin menghapus data ini?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await DeleteBarang(id);
      },
    )..show();
  }

  void editBarang(Map<String, dynamic> barang) {
    // Implementasi edit barang
  }

  void caribarang() {
    setState(() {
      _futurebarang = DatabaseHelper().searchbarang(
        keyword: _searchController.text,
      );
    });
  }

  void showDetailDialog(BuildContext context, int idBarang) async {
    Map<String, dynamic> barang = await DatabaseHelper().getBarangDetail(idBarang); // Gunakan getBarangDetail

    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.leftSlide,
      title: '',
      desc: '',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text(
              '${barang['nama_barang']}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 21,
              ),
            ),
          ),
          Divider(),
          Text(
            'Id Barang: ${barang['id_barang']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            'Harga PerPcs: ${barang['harga_jual']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            'Harga PerPax: ${barang['harga_per_pax']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            'Stok satuan: ${barang['stok_biji']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            'Stok Pax: ${barang['stok_pax']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            'Jumlah Barang perPax: ${barang['jumlah_per_pax']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
          Text(
            'Nama Supplier: ${barang['nama_sup']}',
            style: TextStyle(fontSize: 18),
          ),
          Divider(),
        ],
      ),
      btnOkOnPress: () {},
    )..show();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color.fromARGB(255, 242, 71, 9),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                caribarang();
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futurebarang,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data found'));
                  } else {
                    final barangs = snapshot.data!;
                    return ListView.builder(
                      itemCount: barangs.length,
                      itemBuilder: (context, index) {
                        final barang = barangs[index];
                        return Column(
                          children: [
                            ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barang['nama_barang'],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Id Barang: ${barang['id_barang']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: SizedBox(
                                width: 110,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.update),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RestokBarang(idBarang: barang['id_barang'])),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () => editBarang(barang),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => confirmDelete(barang['id_barang'], context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                showDetailDialog(context, barang['id_barang']); // Memanggil dengan id_barang
                              },
                            ),
                            Divider(), // Add a divider for better UI separation
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahBarang()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
