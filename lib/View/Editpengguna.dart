


import 'package:flutter/material.dart';
import 'package:toko/Database_Sql/DB.dart';

class EditUserPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const EditUserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: user['name']);
    final TextEditingController emailController = TextEditingController(text: user['email']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pengguna'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () async {
                final db = await DatabaseHelper().database;
                await db.update(
                  'user',
                  {
                    'name': nameController.text,
                    'email': emailController.text,
                  },
                  where: 'id = ?',
                  whereArgs: [user['id']],
                );
                Navigator.pop(context); // Kembali ke halaman sebelumnya setelah edit
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}