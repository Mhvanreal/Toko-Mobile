import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class KasirAdmin extends StatefulWidget {
  const KasirAdmin({super.key});

  @override
  State<KasirAdmin> createState() => _KasirAdminState();
}

class _KasirAdminState extends State<KasirAdmin> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kasir'),
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