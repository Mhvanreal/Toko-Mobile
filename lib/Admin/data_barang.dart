import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:toko/Admin/tambah_barang.dart';
import 'package:toko/Database_Sql/DB.dart'; // Import halaman form tambah_barang

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
    _futurebarang = DatabaseHelper().getDataBarang();
  }

  Future<void> DeleteBarang(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('barang', where: 'id_barang = ?', whereArgs: [id]);
    setState(() {
      _futurebarang = DatabaseHelper().getDataBarang();
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


  void editBarang(Map<String, dynamic> barang) {}

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
                                    'Id Barang: ${barang['id_barang'].toString() }',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                'Harga: ${barang['harga_jual']} \nStok: ${barang['stok']}',
                                style: TextStyle(
                                  fontSize: 16,
                                      color: Colors.black,
                                ),
                              ),
                              trailing: SizedBox(
                                width: 96, // Set width to fit two IconButtons
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => editBarang(barang),
                                    ),
                                   IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => confirmDelete(barang['id_barang'], context),
                                  ),

                                  ],
                                ),
                              ),
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
