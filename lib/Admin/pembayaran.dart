import 'package:flutter/material.dart';

class PembayaranPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems; // Data keranjang

  PembayaranPage({required this.cartItems});

  @override
  _PembayaranPageState createState() => _PembayaranPageState();
}

class _PembayaranPageState extends State<PembayaranPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _tunaiController;
  int _totalHarga = 0;
  int _totalQty = 0;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _tunaiController = TextEditingController();
    _calculateTotals();
  }

  void _calculateTotals() {
    _totalHarga = widget.cartItems.fold(
      0,
      (sum, item) => sum + (item['total_harga'] as int? ?? 0),
    );

    _totalQty = widget.cartItems.fold(
      0,
      (sum, item) => sum + ((item['jumlahPcs'] as int? ?? 0) + (item['jumlahPax'] as int? ?? 0)),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _tunaiController.dispose();
    super.dispose();
  }

  void _submitTransaction() {
    if (_formKey.currentState?.validate() ?? false) {
      // Simpan data transaksi ke database
      _checkout();
    }
  }

  Future<void> _checkout() async {
    // Simpan transaksi ke database
    // Panggil metode untuk menyimpan data transaksi
    // Misalnya: await _saveTransaction();
    Navigator.pop(context); // Kembali ke halaman sebelumnya setelah transaksi selesai
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pembayaran'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Daftar Barang:',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.cartItems[index];
                    final itemName = item['nama'] ?? 'Nama Tidak Tersedia';
                    final itemQuantityPcs = item['jumlahPcs']?.toString() ?? '0';
                    final itemQuantityPax = item['jumlahPax']?.toString() ?? '0';
                    final itemTotalHarga = item['total_harga']?.toString() ?? '0';

                    return ListTile(
                      title: Text(itemName),
                      subtitle: Text('Jumlah: $itemQuantityPcs pcs, $itemQuantityPax pax'),
                      trailing: Text('Total: Rp$itemTotalHarga'),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Pembeli'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tunaiController,
                decoration: InputDecoration(labelText: 'Tunai'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tunai harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Total Harga: Rp$_totalHarga',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                'Total Qty: $_totalQty',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitTransaction,
                child: Text('Selesaikan Pembayaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
