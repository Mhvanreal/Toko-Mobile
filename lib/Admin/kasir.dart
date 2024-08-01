import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:toko/Admin/pembayaran.dart';
import 'package:toko/Database_Sql/DB.dart';

class KasirAdmin extends StatefulWidget {
  const KasirAdmin({super.key});

  @override
  State<KasirAdmin> createState() => _KasirAdminState();
}

class _KasirAdminState extends State<KasirAdmin> {
  List<Map<String, dynamic>> cartItems = [];
  late Future<List<Map<String, dynamic>>> _futurebarang;
  TextEditingController cariBarangkasir = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futurebarang = DatabaseHelper().getAllBarang();
  }

  void _showCartDialog() {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    borderSide: BorderSide(color: Colors.green, width: 2),
    width: MediaQuery.of(context).size.width * 12, // Adjust width to a reasonable size
    buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Keranjang Barang',
    desc: 'Berikut adalah barang-barang yang ingin Anda beli:',
    body: _buildCartItems(), // Use _buildCartItems directly
    btnOkOnPress: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PembayaranPage(cartItems: cartItems),
        ),
      );
    },
  )..show();
}


void showDetailBarang(BuildContext context, int idBarang, Function addToCart) async {
  Map<String, dynamic> barang = await DatabaseHelper().getBarangDetail(idBarang);
  int jumlahBeliPcs = 0;
  int jumlahBeliPax = 0;

  void incrementPcs(StateSetter updateState) {
    if (jumlahBeliPcs < barang['stok_biji']) {
      updateState(() {
        jumlahBeliPcs++;
      });
    }
  }

  void decrementPcs(StateSetter updateState) {
    if (jumlahBeliPcs > 0) {
      updateState(() {
        jumlahBeliPcs--;
      });
    }
  }

  void incrementPax(StateSetter updateState) {
    if (jumlahBeliPax < barang['stok_pax']) {
      updateState(() {
        jumlahBeliPax++;
      });
    }
  }

  void decrementPax(StateSetter updateState) {
    if (jumlahBeliPax > 0) {
      updateState(() {
        jumlahBeliPax--;
      });
    }
  }

  AwesomeDialog(
    context: context,
    dialogType: DialogType.noHeader,
    borderSide: BorderSide(color: Color.fromARGB(255, 242, 71, 9)),
    width: MediaQuery.of(context).size.width * 18,
    buttonsBorderRadius: BorderRadius.all(Radius.circular(5)),
    headerAnimationLoop: false,
    animType: AnimType.bottomSlide,
    title: 'Shop',
    desc: '',
    body: StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        num totalHarga = (jumlahBeliPcs * barang['harga_jual']) + (jumlahBeliPax * barang['harga_per_pax']);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                '${barang['nama_barang']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stok pcs: ${barang['stok_biji']}',
                  style: TextStyle(fontSize: 15),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => decrementPcs(setState),
                    ),
                    Text(
                      '$jumlahBeliPcs pcs',
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => incrementPcs(setState),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stok Pax: ${barang['stok_pax']}',
                  style: TextStyle(fontSize: 15),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => decrementPax(setState),
                    ),
                    Text(
                      '$jumlahBeliPax pax',
                      style: TextStyle(fontSize: 15),
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => incrementPax(setState),
                    ),
                  ],
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Text(
              'Total harga: Rp$totalHarga',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: ElevatedButton(
                onPressed: () {
                  addToCart({
                    'id': idBarang,
                    'nama': barang['nama_barang'],
                    'jumlahPcs': jumlahBeliPcs,
                    'jumlahPax': jumlahBeliPax,
                    'total_harga': totalHarga,
                  });
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 30),
                  backgroundColor: Colors.indigo,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag, color: Colors.yellow),
                    SizedBox(width: 7),
                    Text("Tambah Ke Keranjang", style: TextStyle(fontSize: 12, color: Colors.yellow))
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  )..show();
}



Widget _buildCartItems() {
  if (cartItems.isEmpty) {
    return Center(child: Text('Keranjang belanja kosong'));
  }
  num totalHarga = cartItems.fold(0, (sum, item) => sum + item['total_harga']);
   return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final item = cartItems[index];
            return Dismissible(
              key: Key(item['id'].toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  cartItems.removeAt(index);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item['nama']} dihapus dari keranjang')),
                );
              },
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(item['nama']),
                subtitle: Text('Jumlah: ${item['jumlahPcs']} pcs, ${item['jumlahPax']} pax'),
                trailing: Text('Rp ${item['total_harga']}'),
              ),
            );
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Total harga: Rp ${totalHarga}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}


void _addToCart(Map<String, dynamic> item) {
  setState(() {
    cartItems.add(item);
  });
}


  void _checkout() {

  }

  void cariBarang() {
  setState(() {
    _futurebarang = DatabaseHelper().searchbarang(
      keyword: cariBarangkasir.text,
    );
  });
}


  @override
  void dispose() {
    cariBarangkasir.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Kasir Admin'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: cariBarangkasir,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: Color.fromARGB(255, 242, 71, 9),
              prefixIcon: Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              cariBarang();
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futurebarang,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Tidak ada data'));
                } else {
                  final barangs = snapshot.data!;
                  return ListView.builder(
                    itemCount: barangs.length,
                    itemBuilder: (context, index) {
                      final barang = barangs[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  barang['nama_barang'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Id Barang: ${barang['id_barang']}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  'Harga Per Pcs: ${barang['harga_jual']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 7, 6, 6),
                                  ),
                                ),
                                Text(
                                  'Harga Per Pax: ${barang['harga_per_pax']}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 89,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.shopping_bag),
                                    onPressed: () {
                                      showDetailBarang(
                                        context,
                                        barang['id_barang'],
                                        (item) {
                                          _addToCart(item);
                                        }
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              showDetailBarang(
                                context,
                                barang['id_barang'],
                                (item) {
                                  _addToCart(item);
                                }
                              );
                            },
                          ),
                          Divider(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: _showCartDialog,
      child: Icon(Icons.shopping_cart),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: Container(
      margin: EdgeInsets.only(bottom: 1),
      child: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 12.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(width: 50),
            SizedBox(width: 50),
          ],
        ),
      ),
    ),
  );
}
}
