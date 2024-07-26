import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';

class TambahBarang extends StatefulWidget {
  const TambahBarang({super.key});

  @override
  State<TambahBarang> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  TextEditingController _namaBarangController = TextEditingController();
  TextEditingController _hargaJualpcsController = TextEditingController();
  TextEditingController _hargaPerPaxController = TextEditingController();
  TextEditingController _stokBijiController = TextEditingController();
  TextEditingController _stokPaxController = TextEditingController();
  TextEditingController _jumlahPerPaxController = TextEditingController();
  TextEditingController _tglExpController = TextEditingController();
  int? selectedSuplayerId;
  String? selectedSuplayerName;

  List<Map<String, dynamic>> suplayerList = [];

  @override
  void initState() {
    super.initState();
    _fetchSuplayerData();
  }

  Future<void> _fetchSuplayerData() async {
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    final List<Map<String, dynamic>> suplayers = await database.rawQuery('SELECT * FROM suplyer');
    setState(() {
      suplayerList = suplayers;
    });
  }

  int generateRandomId() {
    var rng = Random();
    return rng.nextInt(1000000000);
  }

  Future<void> _simpanData(BuildContext context) async {
    try{
    if (selectedSuplayerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pilih Suplayer terlebih dahulu'),
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }
    final database = await openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      version: 1,
    );

    int idBarang = generateRandomId();

    await database.rawInsert('''
      INSERT INTO barang (
        id_barang, 
        nama_barang, 
        harga_jual, 
        harga_per_pax, 
        stok_biji, 
        stok_pax, 
        jumlah_per_pax, 
        tgl_exp
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      idBarang,
      _namaBarangController.text,
      int.parse(_hargaJualpcsController.text),
      int.parse(_hargaPerPaxController.text),
      int.parse(_stokBijiController.text),
      int.parse(_stokPaxController.text),
      int.parse(_jumlahPerPaxController.text),
      _tglExpController.text,
    ]);

    await database.rawInsert('''
      INSERT INTO dtl_suply (
        id_sup, 
        id_barang,  
        reStok, 
        reStok_pax,
        tgl_reStok, 
        total_harga
      ) VALUES (?, ?, ?, ?, ?, ?)
    ''', [
      selectedSuplayerId,
      idBarang,
      int.parse(_stokBijiController.text),
      int.parse(_stokPaxController.text),
      DateTime.now().toIso8601String(),
      int.parse(_jumlahPerPaxController.text),


      // int.parse(_hargaJualpcsController.text),
      // // int.parse(_hargaPerPaxController.text),
      // int.parse(_stokBijiController.text) + (int.parse(_stokPaxController.text) * int.parse(_jumlahPerPaxController.text)),
      // DateTime.now().toIso8601String(),
      // // (int.parse(_stokBijiController.text) + (int.parse(_stokPaxController.text) * int.parse(_jumlahPerPaxController.text))) * int.parse(_hargaJualpcsController.text),
    ]);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data Barang berhasil ditambahkan'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
    Navigator.of(context).pop();
  }catch (e){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal menambahkan barang: $e '),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
      ),
    );
  }
}

  void _showSuplayerDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      body: Container(
        height: 300,
        child: Column(
          children: [
            Text('Pilih Suplayer', style: Theme.of(context).textTheme.headlineSmall),
            Expanded(
              child: ListView.builder(
                itemCount: suplayerList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text(suplayerList[index]['nama_sup']),
                        onTap: () {
                          setState(() {
                            selectedSuplayerId = suplayerList[index]['id_sup'];
                            selectedSuplayerName = suplayerList[index]['nama_sup'];
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ).show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang', style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromARGB(255, 242, 71, 9),
      ),
      body: SingleChildScrollView(  
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
              Text('Nama Barang', style: TextStyle(color: Colors.black, fontSize: 16),),       
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _namaBarangController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan Nama Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Nama barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Harga jual perPcs', style: TextStyle(color: Colors.black, fontSize: 16),),
              
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _hargaJualpcsController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan harga Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'harga barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Harga jual PerPax', style: TextStyle(color: Colors.black, fontSize: 16),),
              
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _hargaPerPaxController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan harga Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'harga barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Stok Perpcs', style: TextStyle(color: Colors.black, fontSize: 16),),
              
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _stokBijiController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan stok Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'stok barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Stok Pax', style: TextStyle(color: Colors.black, fontSize: 16),),
              
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _stokPaxController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan Stok Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Stok barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Jumlah Barang Perpax', style: TextStyle(color: Colors.black, fontSize: 16),),
              
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _jumlahPerPaxController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan Stok Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Stok barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              Text('Tanggal Exp Barang', style: TextStyle(color: Colors.black, fontSize: 16),),                    
              SizedBox(height: 8,),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: TextFormField(
                  controller: _tglExpController,
                  readOnly: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Masukan Tgl Exp Barang',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _tglExpController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format tanggal sesuai kebutuhan Anda
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tgl Exp barang harus diisi';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
             ElevatedButton(
              onPressed: () => _showSuplayerDialog(context),
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
            // Warna teks
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Radius border
                ),
              ),
              child: Text(selectedSuplayerName ?? 'Pilih Suplayer',  style: TextStyle(fontSize: 16, color: Colors.yellow),
            ),
             ),
              SizedBox(height: 16.0),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 2),
                child: ElevatedButton(
                  onPressed: () async {
                  await _simpanData(context);
                  Navigator.of(context).pop();
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Data Barang berhasil ditambahkan'),
                  //     duration: Duration(seconds: 4),
                  //     )
                  //   );
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
                      Icons.inventory_2,
                      color: Colors.yellow,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      'Tambah Barang',
                      style: TextStyle(fontSize: 20, color: Colors.yellow),
                    ),
                   ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      
    );
  }
}
