import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/model/pengguna.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/ui/detail_obat_screen.dart';
import 'package:apotek_flutter/ui/tambah_obat_screen.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/my_list_item.dart';
import 'package:flutter/material.dart';

class ListObat extends StatefulWidget {
  final Pengguna pengguna;
  const ListObat({super.key, required this.pengguna});

  @override
  State<ListObat> createState() => _ListObatState();
}

class _ListObatState extends State<ListObat> {
  List<Obat> listObat = [];

  void ambilData({String? cari}) async {
    final obatRepo = ObatRepository();
    listObat = await obatRepo.getAllObat(search: cari);
    setState(() {});
  }

  @override
  void initState() {
    ambilData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isPenggunaAdmin = widget.pengguna.role == 'Admin';
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Obat', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: isPenggunaAdmin
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TambahObatScreen()),
                );
                ambilData();
              },
              backgroundColor: Variables.colorSecondary,
              foregroundColor: Colors.white,
              child: Icon(Icons.add, size: 40),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (value) {
                ambilData(cari: value);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Variables.colorMuted,
                ),
                labelText: 'Cari obat',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Variables.colorMuted,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Variables.colorMuted,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'Daftar Obat',
              style: TextStyle(
                color: Variables.colorSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listObat.length,
                itemBuilder: (context, index) {
                  return MyListItem(
                    onTap: () async {
                      final obat = listObat[index];

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailObatScreen(
                            obat: obat,
                            pengguna: widget.pengguna,
                          ),
                        ),
                      );
                      ambilData();
                    },
                    title: listObat[index].nama,
                    subtitle: NumberHelper.formatHarga(listObat[index].harga),
                    trailing: 'Stok: ${listObat[index].stok}',
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
