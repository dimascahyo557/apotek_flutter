import 'package:apotek_flutter/helper/date_helper.dart';
import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/item_penjualan.dart';
import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/model/penjualan.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/repository/penjualan_repository.dart';
import 'package:apotek_flutter/ui/detail_obat_screen.dart';
import 'package:apotek_flutter/ui/detail_penjualan_page.dart';
import 'package:apotek_flutter/ui/tambah_obat_screen.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/my_list_item.dart';
import 'package:flutter/material.dart';

class ListPenjualan extends StatefulWidget {
  const ListPenjualan({super.key});

  @override
  State<ListPenjualan> createState() => _ListPenjualanState();
}

class _ListPenjualanState extends State<ListPenjualan> {
  final penjualanRepo = PenjualanRepository();

  List<Map<String, dynamic>> listPenjualan = [];

  void ambilData() async {
    listPenjualan.clear();
    final penjualan = await penjualanRepo.getAllPenjualan();
    for (final penj in penjualan) {
      listPenjualan.add({
        'penjualan': penj,
        'item': await penjualanRepo.getItemsByPenjualan(penj.id!),
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    ambilData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data Penjualan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Variables.colorPrimary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await Navigator.push(context, MaterialPageRoute(builder: (context) => TambahPenjualanScreen()));
          ambilData();
        },
        backgroundColor: Variables.colorPrimary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daftar Penjualan',
              style: TextStyle(
                color: Variables.colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listPenjualan.length,
                itemBuilder: (context, index) {
                  // if emtpy list
                  if (listPenjualan.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Belum ada penjualan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Variables.colorMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }

                  final penjualan = listPenjualan[index]['penjualan'];
                  final itemPenjualan = listPenjualan[index]['item'];

                  return MyListItem(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPenjualanPage(penjualan: penjualan),
                        ),
                      );
                      ambilData();
                    },
                    title: NumberHelper.formatHarga(penjualan.totalHarga),
                    subtitle: "${itemPenjualan.length} jenis obat",
                    trailing: DateHelper.formatTanggal(
                      penjualan.tanggalTransaksi,
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
