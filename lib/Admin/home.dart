import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:toko/Admin/data_barang.dart';
import 'package:toko/Admin/data_brg_Expiyer.dart';
import 'package:toko/Admin/data_karyawan.dart';
import 'package:toko/Admin/data_suplayer.dart';
import 'package:toko/Admin/kasir.dart';
import 'package:toko/Admin/profile.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => __AdminHomeState();
}

class __AdminHomeState extends State<AdminHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late double height, width;

   List imgData = [
    "images/img_barang.png",
    "images/img_karyawan.png",
    "images/img_shop.png",
    "images/img_barang.png",
    "images/img_barang.png",
    "images/img_shop.png",
  ];

   List titles = [
    "Data Barang",
    "Kasir",
    "Data Karyawan",
    "Data Suplayer",
    "Barang Expiyer",
    "Data Utang"
  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    print('Image Data: $imgData');
    print('Titles: $titles');

    return Scaffold(
      key: _scaffoldKey,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.indigo,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: height * 0.25,
                width: width,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 35,
                        left: 15,
                        right: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Icon(Icons.sort, color: Colors.white, size: 40),
                          ),
                          ClipRRect(
                            child: Icon(Icons.account_circle, color: Colors.white, size: 40),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        right: 15,
                        left: 15,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Dashboard",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1,
                            ),
                          ),
                          Text(
                            "Last Update 20 Jul 2024",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white54,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  width: width,
                  padding: EdgeInsets.only(bottom: 20),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 25,
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: imgData.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (index == 0){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DataBarang()),);
                          }else if (index == 1){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => KasirAdmin()),);
                          }else if (index == 2){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => DtKaryawan()),);
                          }else if (index == 3){
                             Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => DataSuplayer()),);
                          }else if (index == 4){
                             Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => BrgExpiyer()),);
                          }
                          //else if (index == 5){
                          //    Navigator.push(
                          //     context, 
                          //     MaterialPageRoute(builder: (context) => DtKaryawan()),);
                          // }
                          

                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                imgData[index],
                                width: 100,
                              ),
                              Text(
                                titles[index],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 242, 71, 9),
              ),
              child: Text(
                'Nama',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar'),
              onTap: () => showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

void showLogoutDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,
    headerAnimationLoop: false,
    animType: AnimType.topSlide,
    title: 'Keluar',
    desc: 'Apakah Anda yakin ingin keluar?',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      Navigator.of(context).pop();
    },
  )..show();
}
