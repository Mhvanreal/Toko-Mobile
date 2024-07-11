import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataBarang extends StatefulWidget {
  const DataBarang({super.key});

  @override
  State<DataBarang> createState() => _DataBarangState();
}

class _DataBarangState extends State<DataBarang> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Barang'),
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