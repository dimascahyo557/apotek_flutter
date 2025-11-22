import 'package:apotek_flutter/ui/detail_obat_screen.dart';
import 'package:apotek_flutter/ui/tambah_obat_screen.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/my_list_item.dart';
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => TambahObatScreen()));
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
                  return MyListItem(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailObatScreen()));
                    },
                    title: 'Panadol Biru',
                    subtitle: 'RP 14.500',
                    trailing: 'Stok: 15',
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
