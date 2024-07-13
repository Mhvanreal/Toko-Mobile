import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:toko/Database_Sql/DB.dart';
import 'package:toko/View/Editpengguna.dart';

class DtKaryawan extends StatefulWidget {
  const DtKaryawan({super.key});

  @override
  State<DtKaryawan> createState() => _DtKaryawanState();
}

class _DtKaryawanState extends State<DtKaryawan> {
  late Future<List<Map<String, dynamic>>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = DatabaseHelper().getKaryawanUsers();
  }

  

  Future<void> _deleteUser(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('user', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _futureUsers = DatabaseHelper().getKaryawanUsers();
    });
  }

  Future<void> confirmDeleteUser(int id)async{
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: "Hapus Data Pengguna!!",
      desc: 'Apakah Anda Yakin ingin menghapus User ini ?',
      btnCancelOnPress: () {
        
      },
      btnOkOnPress:() => _deleteUser(id),
      )..show();
  }

  void _editUser(Map<String, dynamic> user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditUserPage(user: user)),
    ).then((_) {
      setState(() {
        _futureUsers = DatabaseHelper().getKaryawanUsers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pengguna'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            final users = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: List.generate(users.length, (index) {
                  final user = users[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: ()
                               => _editUser(user),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: ()
                               => confirmDeleteUser(user['id']),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
