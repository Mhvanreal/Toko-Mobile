import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';


class KaryawanHome extends StatefulWidget {
  const KaryawanHome({super.key});

  @override
  State<KaryawanHome> createState() => _KaryawanHomeState();
}

class _KaryawanHomeState extends State<KaryawanHome> {
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
 Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
               onTap: () {
                _scaffoldKey.currentState!.openDrawer();
               },
               child: Icon(Icons.sort,
               color: Colors.black,
               size: 35,
               ),
            ),
            InkWell(
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              child: Icon(Icons.account_circle,
              color: Colors.black,
              size: 35),
            ),
          ],
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
         
        ),
      ),
      drawer: Drawer (
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 242, 71, 9),
              ),
              child: Text(
                'Nama',style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                // Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Profile()),
                // );
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar'),
              onTap: () => showLogoutDialog(context),
            )
          ],
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.topSlide,
      showCloseIcon: true,
      title: 'Warning',
      desc: 'Apakah Anda yakin ingin keluar?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        // logout();
      },
    )..show();
  }
}