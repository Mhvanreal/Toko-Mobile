import 'package:flutter/material.dart';
import 'package:toko/Database_Sql/DB.dart';
// Ganti dengan path ke database_helper Anda

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _pertanyaanController = TextEditingController();
  TextEditingController _jawabanController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> user = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'role': _roleController.text,
        'pertanyaan': _pertanyaanController.text,
        'jawaban': _jawabanController.text,
      };

      await DatabaseHelper().insertUser(user);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully')));
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: InputDecoration(labelText: 'Role'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your role';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pertanyaanController,
                decoration: InputDecoration(labelText: 'Pertanyaan'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your pertanyaan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jawabanController,
                decoration: InputDecoration(labelText: 'Jawaban'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your jawaban';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
