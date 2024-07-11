import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DtKaryawan extends StatefulWidget {
  const DtKaryawan({super.key});

  @override
  State<DtKaryawan> createState() => _DtKaryawanState();
}

class _DtKaryawanState extends State<DtKaryawan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Pengguna'),
      ),
      body: Center(
        child: Text(
          'Welcome profile!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}