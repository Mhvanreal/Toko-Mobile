import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BrgExpiyer extends StatefulWidget {
  const BrgExpiyer({super.key});

  @override
  State<BrgExpiyer> createState() => _BrgExpiyerState();
}

class _BrgExpiyerState extends State<BrgExpiyer> {
  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data expiyer'),
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