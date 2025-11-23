import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/ui/manajemen_stok.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

const Color primaryColor = Variables.colorSecondary; // Ungu sesuai Figma (#8C00FF)
const Color stockManagementColor = Variables.colorPrimary; // Ungu Tua untuk Manajemen Stok (#450693)
const Color detailTextColor = Variables.colorMuted; // Abu-abu gelap (#888888)

class DetailObatScreen extends StatefulWidget {
  final Obat obat;

  const DetailObatScreen({super.key, required this.obat});

  @override
  State<DetailObatScreen> createState() => _DetailObatScreenState();
}

class _DetailObatScreenState extends State<DetailObatScreen> {
  final obatRepo = ObatRepository();
  late Obat obat;

  @override
  void initState() {
    obat = widget.obat;
    ambilData();
    super.initState();
  }

  Future<void> ambilData() async {
    final result = await obatRepo.getObatById(widget.obat.id!);
    setState(() {
      obat = result!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Detail Obat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              // UBAH: Sesuaikan padding di sini agar lebih rapat ke kiri dan atas
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: obat.foto != null
                        ? Image.file(obat.foto!)
                        : const Icon(
                            Icons.image_outlined,
                            size: 60,
                            color: Color(0xFFCCCCCC),
                          ),
                  ),
                  const SizedBox(
                    height: 16,
                  ), // UBAH: Kurangi jarak setelah gambar

                  Text(
                    obat.nama,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ), // UBAH: Kurangi jarak setelah nama obat
                  Text(
                    NumberHelper.formatHarga(obat.harga),
                    style: const TextStyle(
                      fontSize: 18,
                      color: detailTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ), // UBAH: Kurangi jarak sebelum "Stok"

                  const Text(
                    'Stok',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    obat.stok.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      color: detailTextColor,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ), // UBAH: Sesuaikan jarak sebelum "Deskripsi"

                  Text(
                    'Deskripsi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ), // UBAH: Kurangi jarak setelah "Deskripsi" title
                  Text(
                    obat.deskripsi ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      color: detailTextColor,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildFooterButtons(context),
        ],
      ),
    );
  }

  Widget _buildFooterButtons(BuildContext context) {
    return Container(
      // UBAH: Sesuaikan padding di footer agar konsisten dengan content
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 1.0)),
      ),
      child: Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    /* ... */
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primaryColor,
                    side: const BorderSide(color: primaryColor, width: 2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ), // UBAH: Sedikit kurangi padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Hapus',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    /* ... */
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ), // UBAH: Sedikit kurangi padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Ubah',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ManajemenStok(obat: obat)));
              ambilData();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: stockManagementColor,
              // UBAH: Sesuaikan minimumSize untuk tinggi tombol Manajemen Stok
              minimumSize: const Size(
                double.infinity,
                52,
              ), // Sedikit lebih tinggi dari 50
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ), // Sesuaikan padding internal
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Manajemen Stok',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
