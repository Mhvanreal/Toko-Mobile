import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataSuplayer extends StatefulWidget {
  const DataSuplayer({super.key});

  @override
  State<DataSuplayer> createState() => _DataSuplayerState();
}

class _DataSuplayerState extends State<DataSuplayer> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Suplayer'),
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