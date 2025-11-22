import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPenjualanPage extends StatelessWidget {
  const DetailPenjualanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Penjualan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Variables.colorPrimary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tanggal Transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Variables.colorPrimary,
              ),
            ),
            Text(
              '15 Oktober 2025 09.41',
              style: TextStyle(
                color: Variables.colorMuted,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Total Harga',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Variables.colorPrimary,
              ),
            ),
            Text(
              'Rp 90000',
              style: TextStyle(
                color: Variables.colorMuted,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Kasir',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Variables.colorPrimary,
              ),
            ),
            Text(
              'Muhammad Asyraf',
              style: TextStyle(
                color: Variables.colorMuted,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Obat Terjual',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Variables.colorPrimary,
              ),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panadol',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text('Jumlah: 2 strip'),
                          Text('Harga satuan: Rp 15000'),
                          Text(
                            'Total: Rp 30000',
                            style: const TextStyle(color: Variables.colorPrimary),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
