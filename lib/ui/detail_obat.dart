import 'package:apotek_flutter/helpers.dart';
import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class DetailObat extends StatefulWidget {
  final Obat obat;

  const DetailObat({super.key, required this.obat});

  @override
  State<DetailObat> createState() => _DetailObatState();
}

class _DetailObatState extends State<DetailObat> {
  @override
  Widget build(BuildContext context) {
    final obat = widget.obat;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Obat', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              clipBehavior: Clip.antiAlias,
              child: Icon(Icons.image, size: 50, color: Colors.grey)
            ),
            SizedBox(height: 16),

            Text(
              obat.nama,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Variables.colorSecondary,
              ),
            ),
            Text(
              Helpers.formatHarga(obat.harga),
              style: TextStyle(
                fontSize: 18,
                color: Variables.colorMuted,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Stok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Variables.colorSecondary,
              ),
            ),
            Text(
              '${obat.stok} ${obat.satuan}',
              style: TextStyle(
                fontSize: 16,
                color: Variables.colorMuted,
              ),
            ),
            SizedBox(height: 16),

            Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Variables.colorSecondary,
              ),
            ),
            Text(
              '${obat.deskripsi}',
              style: TextStyle(
                fontSize: 16,
                color: Variables.colorMuted,
              ),
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
                      side: BorderSide(color: Variables.colorSecondary, width: 2), // warna border
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        color: Variables.colorSecondary, // warna teks
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                  
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 13),
                      backgroundColor: Variables.colorSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Ubah',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8,),

            ElevatedButton(
              onPressed: () {
            
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 13),
                backgroundColor: Variables.colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'Manajemen Stok',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}