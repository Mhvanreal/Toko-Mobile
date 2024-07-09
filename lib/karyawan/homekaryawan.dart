import 'package:flutter/material.dart';

class KaryawanHome extends StatefulWidget {
  const KaryawanHome({super.key});

  @override
  State<KaryawanHome> createState() => _KaryawanHomeState();
}

class _KaryawanHomeState extends State<KaryawanHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karyawan Home Page'),
      ),
      body: Center(
        child: Text(
          'Welcome Karyawan!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}