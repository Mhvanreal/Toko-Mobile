import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toko/Admin/tambah_suplayer.dart';
import 'package:toko/Database_Sql/DB.dart';

class DataSuplayer extends StatefulWidget {
  const DataSuplayer({super.key});

  @override
  State<DataSuplayer> createState() => _DataSuplayerState();
}

class _DataSuplayerState extends State<DataSuplayer> {

  TextEditingController searchSuplayer = TextEditingController();
  late Future<List<Map<String, dynamic>>> FutureSup;

  Future<void> Deletesup(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('suplyer', where: 'id_sup = ?', whereArgs: [id]);
    setState(() {
      FutureSup = DatabaseHelper().getDatasuplayer();
    });
  }

  void editsuplayer(Map<String, dynamic> suplayer){

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
        await Deletesup(id);
      },
    )..show();
  }

  void editBarang(Map<String, dynamic> barang) {
  }

  void carisuplayer(){
    setState(() {
      FutureSup = DatabaseHelper().searchSuplayer(
        keyword: searchSuplayer.text,
      );
    });
  }



  @override
  void dispose() {
    searchSuplayer.dispose();
    super.dispose();
  }
  @override
  void initState(){
    super.initState();
    FutureSup = DatabaseHelper().getDatasuplayer();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Suplayer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            controller: searchSuplayer,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Color.fromARGB(255, 242, 71, 9),
              prefixIcon: Icon(Icons.search, color: Colors.white,),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              )
            ),
            onChanged: (value) {
              carisuplayer();
            }
          ),
          SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: FutureSup,
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }else if(snapshot.hasError){
                  return Center(child: Text('Eror: ${snapshot.error}'));
                }else if(!snapshot.hasData || snapshot.data!.isEmpty){
                  return Center(child: Text('No found data'));
                }else{
                  final suplayers = snapshot.data!;
                  return ListView.builder(
                    itemCount: suplayers.length,
                    itemBuilder: (context, index) {
                      final suplayer = suplayers[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  suplayer['nama_sup'],
                                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  suplayer['no_telp'],
                                  style: TextStyle(fontSize: 16, color: Colors.black,),
                                ),
                                Text(
                                  'Alamat: ${suplayer['alamat']}',
                                  style: TextStyle(fontSize: 16, color: Colors.black,),
                                ),
                              ]
                            ),
                            trailing: SizedBox(
                              width: 96,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () => editsuplayer,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => confirmDelete(suplayer['id_sup'], context),
                                      ),
                                ],
                              ),
                            ),
                          ),
                           Divider(),
                        ],
                      );
                    }
                  );
                }
              },
            ),
            )
        ],
      ), 
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddSuplayer()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}