import 'package:apotek_flutter/helpers.dart';
import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/ui/detail_obat.dart';
import 'package:apotek_flutter/ui/tambah_obat.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class ListObat extends StatefulWidget {
  const ListObat({super.key});

  @override
  State<ListObat> createState() => _ListObatState();
}

class _ListObatState extends State<ListObat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Obat', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TambahObat()));
        },
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 40,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Variables.colorMuted),
                labelText: 'Cari obat',
                labelStyle: TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Variables.colorMuted, width: 1.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Variables.colorMuted, width: 2),
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
                itemCount: 15,
                itemBuilder: (context, index) {
                  final obat = Obat(
                    nama: 'Panadol Biru',
                    harga: 14500,
                    stok: 15,
                    satuan: 'Strip',
                    deskripsi: 'Ini obat pusing',
                    // foto: 'assets/medicine.jpg',
                  );

                  return Card(
                    color: Variables.colorCardGray,
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailObat(obat: obat)));
                      },
                      title: Text(
                        obat.nama,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        Helpers.formatHarga(obat.harga),
                        style: TextStyle(
                          color: Variables.colorMuted,
                          fontSize: 14,
                        ),
                      ),
                      trailing: Text(
                        'Stok: ${obat.stok}',
                        style: TextStyle(
                          color: Variables.colorMuted,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  );
                },
              )
            ),
          ],
        ),
      ),
    );
  }
}
