import 'dart:io';
import 'package:apotek_flutter/model/obat.dart';
import 'package:flutter/material.dart';

class DetailObat extends StatefulWidget {
  final Obat obat; // Data obat dikirim lewat konstruktor

  const DetailObat({super.key, required this.obat});

  @override
  State<DetailObat> createState() => _DetailObatState();
}

class _DetailObatState extends State<DetailObat> {
  // Contoh data riwayat stok (nanti bisa diambil dari database lokal)
  List<Map<String, dynamic>> riwayatStok = [
    {'tanggal': '2025-10-10', 'perubahan': '+20', 'keterangan': 'Restock Gudang'},
    {'tanggal': '2025-10-12', 'perubahan': '-5', 'keterangan': 'Penjualan'},
    {'tanggal': '2025-10-14', 'perubahan': '+10', 'keterangan': 'Retur Pembelian'},
  ];

  void _editObat() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur Edit Obat diklik')),
    );
  }

  void _hapusObat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Obat'),
        content: const Text('Apakah kamu yakin ingin menghapus obat ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Obat berhasil dihapus')),
              );
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _manajemenStok() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur Manajemen Stok diklik')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final obat = widget.obat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Obat'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Foto Obat
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: obat.foto != null && File(obat.foto!).existsSync()
                    ? Image.file(File(obat.foto!), width: 150, height: 150, fit: BoxFit.cover)
                    : Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 60, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Nama, Harga, Stok
            Text(
              obat.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Harga: Rp ${obat.harga}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              "Stok Saat Ini: ${obat.stok}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.teal),
            ),
            const SizedBox(height: 20),

            // Tombol Aksi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _editObat,
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: _hapusObat,
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed: _manajemenStok,
                  icon: const Icon(Icons.inventory),
                  label: const Text('Manajemen Stok'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Riwayat Perubahan Stok
            const Text(
              'Riwayat Perubahan Stok',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),

            riwayatStok.isEmpty
                ? const Center(
                    child: Text('Belum ada riwayat stok'),
                  )
                : Column(
                    children: riwayatStok.map((item) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: Icon(
                            item['perubahan'].toString().startsWith('+')
                                ? Icons.add_circle_outline
                                : Icons.remove_circle_outline,
                            color: item['perubahan'].toString().startsWith('+')
                                ? Colors.green
                                : Colors.red,
                          ),
                          title: Text(item['perubahan']),
                          subtitle: Text(item['keterangan']),
                          trailing: Text(item['tanggal']),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }
}
