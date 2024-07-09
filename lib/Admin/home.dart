import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => __AdminHomeState();
}

class __AdminHomeState extends State<AdminHome> {
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
      ),
      body: Center(
        child: Text(
          'Welcome Admin!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}