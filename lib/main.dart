import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:toko/Database_Sql/DB.dart';
import 'package:toko/Page/splash_screen.dart';
// import 'splash_screen.dart'; 

Future<void> main() async {
  runApp(MyApp());
  // configLoading();
  // await DatabaseHelper().deleteDatabaseFile();
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: const Color.fromARGB(255, 107, 241, 112),
        ),
      ),
      builder: EasyLoading.init(),
      home: SplashScreen(),
    );
  }
}
