import 'package:apotek_flutter/helper/date_helper.dart';
import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/item_penjualan.dart';
import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/model/penjualan.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/repository/pengguna_repository.dart';
import 'package:apotek_flutter/repository/penjualan_repository.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailPenjualanPage extends StatefulWidget {
  final Penjualan penjualan;
  const DetailPenjualanPage({super.key, required this.penjualan});

  @override
  State<DetailPenjualanPage> createState() => _DetailPenjualanPageState();
}

class _DetailPenjualanPageState extends State<DetailPenjualanPage> {
  final penjualanRepo = PenjualanRepository();
  final obatRepo = ObatRepository();
  final penggunaRepo = PenggunaRepository();

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
              DateHelper.formatTanggal(widget.penjualan.tanggalTransaksi),
              style: TextStyle(color: Variables.colorMuted, fontSize: 16),
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
              NumberHelper.formatHarga(widget.penjualan.totalHarga),
              style: TextStyle(color: Variables.colorMuted, fontSize: 16),
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
            FutureBuilder(
              future: penggunaRepo.getPenggunaById(widget.penjualan.idKasir!),
              builder: (context, asyncSnapshot) {
                return Text(
                  asyncSnapshot.data?.nama ?? '-',
                  style: TextStyle(color: Variables.colorMuted, fontSize: 16),
                );
              },
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
              child: FutureBuilder(
                future: penjualanRepo.getItemsByPenjualan(widget.penjualan.id!),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: asyncSnapshot.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = asyncSnapshot.data![index];
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
                              FutureBuilder(
                                future: obatRepo.getObatById(item.idObat),
                                builder: (context, asyncSnapshot) {
                                  return Text(
                                    asyncSnapshot.data?.nama ?? '-',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  );
                                },
                              ),
                              Text('Jumlah: ${item.jumlahPembelian} strip'),
                              Text(
                                'Harga satuan: ${NumberHelper.formatHarga(item.hargaSatuan)}',
                              ),
                              Text(
                                'Total: ${NumberHelper.formatHarga(item.totalHarga)}',
                                style: const TextStyle(
                                  color: Variables.colorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
