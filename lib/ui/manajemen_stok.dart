import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/helper/date_helper.dart';
import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/repository/penjualan_repository.dart';
import 'package:apotek_flutter/repository/riwayat_stok_repository.dart';
import 'package:apotek_flutter/ui/list_obat.dart';
import 'package:apotek_flutter/ui/login.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/app_outlined_button.dart';
import 'package:apotek_flutter/widget/app_text_button.dart';
import 'package:apotek_flutter/widget/my_list_item.dart';
import 'package:apotek_flutter/widget/my_text_form_field.dart';
import 'package:flutter/material.dart';

class ManajemenStok extends StatefulWidget {
  final Obat obat;
  const ManajemenStok({super.key, required this.obat});

  @override
  State<ManajemenStok> createState() => _ManajemenStokState();
}

class _ManajemenStokState extends State<ManajemenStok> {
  final databaseHelper = DatabaseHelper();
  final riwayatStokRepo = RiwayatStokRepository();
  final obatRepo = ObatRepository();

  late int stokObat;

  List<RiwayatPerubahanStok> listRiwayatStok = [];

  void ambilData() async {
    listRiwayatStok = await riwayatStokRepo.getRiwayatByObat(widget.obat.id!);
    setState(() {});
  }

  @override
  void initState() {
    stokObat = widget.obat.stok;
    ambilData();
    super.initState();
  }

  Future<void> _tambahStok(BuildContext context) async {
    final result = await showStokDialog(
      context: context,
      title: "Tambah Stok",
      stokSekarang: stokObat,
      satuan: widget.obat.satuan ?? "",
    );

    if (result == null) return; // user cancel

    final jumlah = result['jumlah'] as int;
    final deskripsi = result['deskripsi'];

    final db = await databaseHelper.database;

    await db.transaction((txn) {
      obatRepo.increaseStockTx(txn, widget.obat.id!, jumlah);

      final riwayat = RiwayatPerubahanStok(
        idObat: widget.obat.id!,
        jenisAksi: 'restok',
        jumlah: jumlah,
        deskripsi: deskripsi,
      );

      return riwayatStokRepo.insertRiwayatTx(txn, riwayat);
    });

    setState(() {
      stokObat += jumlah;
      ambilData();
    });
  }

  Future<void> _kurangiStok(BuildContext context) async {
    final result = await showStokDialog(
      context: context,
      title: "Kurangi Stok",
      stokSekarang: stokObat,
      satuan: widget.obat.satuan ?? "",
    );

    if (result == null) return; // user cancel

    final jumlah = result['jumlah'] as int;
    final deskripsi = result['deskripsi'];

    if (jumlah > stokObat) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Jumlah yang dikurangi melebihi stok'), backgroundColor: Variables.colorDanger,),
      );
      return;
    }

    final db = await databaseHelper.database;

    await db.transaction((txn) {
      obatRepo.reduceStockTx(txn, widget.obat.id!, jumlah);

      final riwayat = RiwayatPerubahanStok(
        idObat: widget.obat.id!,
        jenisAksi: 'pengurangan',
        jumlah: -jumlah,
        deskripsi: deskripsi,
      );

      return riwayatStokRepo.insertRiwayatTx(txn, riwayat);
    });

    setState(() {
      stokObat -= jumlah;
      ambilData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Stok', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppOutlinedButton(
                    onPressed: () => _kurangiStok(context),
                    label: 'Kurangi',
                    borderColor: Variables.colorSecondary,
                    foregroundColor: Variables.colorSecondary,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: AppTextButton(
                    onPressed: () => _tambahStok(context),
                    label: 'Tambah',
                    backgroundColor: Variables.colorSecondary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Riwayat perubahan stok',
              style: TextStyle(
                color: Variables.colorSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listRiwayatStok.isEmpty ? 1 : listRiwayatStok.length,
                itemBuilder: (context, index) {
                  // if emtpy list
                  if (listRiwayatStok.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Belum ada riwayat',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Variables.colorMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }

                  final riwayatStok = listRiwayatStok[index];

                  return _riwayatStokItemList(
                    riwayatStok,
                  );
                },

              )
            ),
          ],
        ),
      ),
    );
  }

  Widget _riwayatStokItemList(RiwayatPerubahanStok riwayatStok) {
    return Card(
      color: Variables.colorCardGray,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        title: Text(
          "${riwayatStok.jumlah} ${widget.obat.satuan ?? ''}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateHelper.formatTanggal(riwayatStok.tanggal),
              style: TextStyle(
                color: Variables.colorMuted,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8,),
            Text(
              'Deskripsi: ${riwayatStok.deskripsi}',
              style: TextStyle(
                color: Variables.colorMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: riwayatStok.jumlah > 0
          ? Icon(Icons.add_circle, color: Variables.colorSuccess,)
          : Icon(Icons.remove_circle, color: Variables.colorDanger,),
      ),
    );
  }
}

Future<Map<String, dynamic>?> showStokDialog({
  required BuildContext context,
  required String title,
  required int stokSekarang,
  required String satuan,
}) async {
  final formKey = GlobalKey<FormState>();
  final jumlahCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  return await showDialog<Map<String, dynamic>?>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                    ),
                  ),
                  Text(
                    "Stok saat ini: $stokSekarang $satuan",
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
              
                  // jumlah
                  MyTextFormField(
                    controller: jumlahCtrl,
                    labelText: 'Jumlah',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah tidak boleh kosong';
                      }
                      if (int.tryParse(value) == null || int.parse(value) <= 0) {
                        return 'Jumlah harus lebih dari 0';
                      }
                    },
                  ),
                  const SizedBox(height: 16),
              
                  // deskripsi
                  MyTextFormField(
                    controller: descCtrl,
                    labelText: 'Deskripsi',
                  ),
                  const SizedBox(height: 16),
              
                  // tombol
                  Row(
                    children: [
                      Expanded(
                        child: AppOutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(null); // user cancel
                          },
                          borderColor: Variables.colorSecondary,
                          foregroundColor: Variables.colorSecondary,
                          label: 'Batal',
                        )
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final jumlahText = jumlahCtrl.text.trim();
                              final jumlah = int.tryParse(jumlahText);

                              Navigator.of(context).pop({
                                'jumlah': jumlah,
                                'deskripsi': descCtrl.text.trim(),
                              });
                            }
                          },
                          backgroundColor: Variables.colorSecondary,
                          foregroundColor: Colors.white,
                          label: 'Simpan',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
