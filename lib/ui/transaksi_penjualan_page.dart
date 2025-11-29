import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/penjualan_repository.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/app_outlined_button.dart';
import 'package:apotek_flutter/widget/app_text_button.dart';
import 'package:apotek_flutter/widget/my_text_form_field.dart';
import 'package:flutter/material.dart';

class TransaksiPenjualanPage extends StatefulWidget {
  final Pengguna kasir;
  const TransaksiPenjualanPage({super.key, required this.kasir});

  @override
  State<TransaksiPenjualanPage> createState() => _TransaksiPenjualanPageState();
}

class _TransaksiPenjualanPageState extends State<TransaksiPenjualanPage> {
  final penjualanRepo = PenjualanRepository();
  List<List<dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    // TODO: delete this (just a dummy data)
    items = [
      [
        ItemPenjualan(
          idObat: 1,
          jumlahPembelian: 2,
          hargaSatuan: 10000,
          totalHarga: 20000,
        ),
        Obat(id: 1, nama: 'Obat 1', harga: 10000, stok: 10, satuan: 'Botol'),
      ],
    ];
  }

  Future<void> _pilihObat() async {
    // final obat = await Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => const ObatListPage()),
    // );
    // if (obat != null) {
    //   setState(() {
    //     items.add([
    //       ItemPenjualan(
    //         idObat: obat.id,
    //         jumlahPembelian: 1,
    //         hargaSatuan: obat.harga,
    //         totalHarga: obat.harga,
    //       ),
    //       obat,
    //     ]);
    //   });
    // }
  }

  void _hapusObat(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  int _hitungTotalHarga() {
    int totalHarga = 0;
    for (var item in items) {
      totalHarga += item[0].totalHarga as int;
    }
    return totalHarga;
  }

  void _bayar() {
    showDialog(
      context: context,
      builder: (context) => _PembayaranDialog(
        totalHarga: _hitungTotalHarga(),
        onBayar: (ctx, jumlahBayar) {
          if (jumlahBayar < _hitungTotalHarga()) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text('Jumlah bayar tidak mencukupi'),
                backgroundColor: Variables.colorDanger,
              ),
            );
            return;
          }

          final listItems = items
              .map<ItemPenjualan>((item) => item[0])
              .toList();
          penjualanRepo.jualObat(
            idKasir: widget.kasir.id!,
            items: listItems,
            jumlahBayar: jumlahBayar,
          );

          Navigator.pop(ctx);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jual Obat', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Variables.colorPrimary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _summaryCard(
              title: 'Total Harga',
              value: NumberHelper.formatHarga(_hitungTotalHarga()),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppOutlinedButton(
                borderColor: Variables.colorSecondary,
                foregroundColor: Variables.colorSecondary,
                label: 'Pilih Obat',
                onPressed: _pilihObat,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _listObat(
                    obat: items[index][1],
                    item: items[index][0],
                    onDelete: () => _hapusObat(index),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: AppTextButton(
                backgroundColor: Variables.colorPrimary,
                foregroundColor: Colors.white,
                label: 'Bayar',
                onPressed: _bayar,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({required String title, String? value}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Variables.colorAccent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(
                value ?? '-',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listObat({
    required Obat obat,
    required ItemPenjualan item,
    VoidCallback? onDelete,
  }) {
    return Card(
      color: Variables.colorCardGray,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: Text(
            obat.nama,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "Jumlah",
                      style: TextStyle(
                        color: Variables.colorMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    ": ",
                    style: TextStyle(color: Variables.colorMuted, fontSize: 14),
                  ),
                  Text(
                    item.jumlahPembelian.toString(),
                    style: TextStyle(
                      color: Variables.colorMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "Harga satuan",
                      style: TextStyle(
                        color: Variables.colorMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    ": ",
                    style: TextStyle(color: Variables.colorMuted, fontSize: 14),
                  ),
                  Text(
                    NumberHelper.formatHarga(item.hargaSatuan),
                    style: TextStyle(
                      color: Variables.colorMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      "Total harga",
                      style: TextStyle(
                        color: Variables.colorMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    ": ",
                    style: TextStyle(color: Variables.colorMuted, fontSize: 14),
                  ),
                  Text(
                    NumberHelper.formatHarga(item.totalHarga),
                    style: TextStyle(
                      color: Variables.colorMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_forever,
              color: Variables.colorDanger,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _PembayaranDialog extends StatefulWidget {
  final int totalHarga;
  final Function(BuildContext, int) onBayar;
  const _PembayaranDialog({
    super.key,
    required this.totalHarga,
    required this.onBayar,
  });

  @override
  State<_PembayaranDialog> createState() => __PembayaranDialogState();
}

class __PembayaranDialogState extends State<_PembayaranDialog> {
  final TextEditingController _jumlahBayarController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total harga', style: TextStyle(color: Variables.colorMuted)),
            Text(
              NumberHelper.formatHarga(widget.totalHarga),
              style: TextStyle(
                color: Variables.colorPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            Text('Jumlah bayar', style: TextStyle(color: Variables.colorMuted)),
            Text(
              NumberHelper.formatHarga(
                int.tryParse(_jumlahBayarController.text) ?? 0,
              ),
              style: TextStyle(
                color: Variables.colorPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            Text('Kembalian', style: TextStyle(color: Variables.colorMuted)),
            Text(
              NumberHelper.formatHarga(
                (int.tryParse(_jumlahBayarController.text) ?? 0) -
                    widget.totalHarga,
              ),
              style: TextStyle(
                color: Variables.colorPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            Divider(color: Variables.colorMuted),
            SizedBox(height: 8),

            MyTextFormField(
              labelText: 'Jumlah bayar',
              controller: _jumlahBayarController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    borderColor: Variables.colorPrimary,
                    foregroundColor: Variables.colorPrimary,
                    label: 'Batal',
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: AppTextButton(
                    backgroundColor: Variables.colorPrimary,
                    foregroundColor: Colors.white,
                    label: 'Bayar',
                    onPressed: () => widget.onBayar(
                      context,
                      int.tryParse(_jumlahBayarController.text) ?? 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
