import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/ui/detail_obat.dart';
import 'package:apotek_flutter/ui/tambah_obat.dart';
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
        title: Text('Daftar Obat'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TambahObat()));
        },
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Cari obat...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    final obat = Obat('Panadol', 14000, 15, null);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailObat(obat: obat,)),
                    );
                  },
                  leading: Image.asset('assets/medicine.jpg'),
                  title: Text('Obat ${index + 1}'),
                  subtitle: Text('Stok: Medicine Stock'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
