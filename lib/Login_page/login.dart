import 'package:flutter/material.dart';
import 'package:toko/Admin/home.dart';
import 'package:toko/Database_Sql/DB.dart';
import 'package:toko/Login_page/Register.dart';
import 'package:get/get.dart';
import 'package:toko/karyawan/homekaryawan.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  void auth() async {
    final dbHelper = DatabaseHelper();
    final db = await dbHelper.database;

    final user = await db.query(
      'user',
      where: 'email = ? AND password = ?',
      whereArgs: [email.text, password.text],
    );

    if (user.isNotEmpty) {
      final role = user.first['role'];
      if (role == 'admin') {
        Get.to(AdminHome());
      } else if (role == 'karyawan') {
        Get.to(KaryawanHome());
      }
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Invalid email or password'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Login Page",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign _formKey to the Form widget
            child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Toko Kita',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    'images/background1.jpg',
                    width: 200,
                    height: 200,
                  ),
                ),
                SizedBox(height: 50),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: "Masukan email Anda",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(255, 242, 71, 9),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "email harus diisi";
                    }
                    if (!value.contains('@')) {
                      return "email tidak valid";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: password,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "Masukan Password Anda",
                    hintStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color.fromARGB(255, 242, 71, 9),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password Harus Diisi';
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      auth();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => Get.to(Register()),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}