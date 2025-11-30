import 'package:apotek_flutter/model/pengguna.dart';
import 'package:apotek_flutter/repository/pengguna_repository.dart';
import 'package:apotek_flutter/ui/ubah_pengguna_page.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';
import 'package:apotek_flutter/widget/konfirmasi_hapus_popup.dart';

class DetailPenggunaPage extends StatefulWidget {
  final Pengguna pengguna;
  const DetailPenggunaPage({super.key, required this.pengguna});

  @override
  State<DetailPenggunaPage> createState() => _DetailPenggunaPageState();
}

class _DetailPenggunaPageState extends State<DetailPenggunaPage> {
  final penggunaRepo = PenggunaRepository();

  String? namaPengguna;
  String? emailPengguna;
  String? rolePengguna;

  bool hapusPressed = false;
  bool ubahPressed = false;

  @override
  void initState() {
    ambilData();
    super.initState();
  }

  void ambilData() async {
    final pengguna = await penggunaRepo.getPenggunaById(widget.pengguna.id!);
    setState(() {
      namaPengguna = pengguna?.nama ?? widget.pengguna.nama;
      emailPengguna = pengguna?.email ?? widget.pengguna.email;
      rolePengguna = pengguna?.role ?? widget.pengguna.role!;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color purple = Variables.colorPrimary;
    const Color appbarBg = Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: appbarBg,
        foregroundColor: purple,
        title: const Text(
          "Detail Pengguna",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 3,
        shadowColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              namaPengguna ?? '-',
              style: TextStyle(
                color: purple,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 6),
            Text(
              rolePengguna ?? '-',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),

            const SizedBox(height: 18),
            Text(
              "Email",
              style: TextStyle(
                color: purple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(emailPengguna ?? '-', style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 18),
            const Text(
              "Password",
              style: TextStyle(
                color: purple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            const Text("•••••", style: TextStyle(color: Colors.black54)),

            const SizedBox(height: 28),

            Row(
              children: [
                // ====================== TOMBOL HAPUS ======================
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => KonfirmasiHapusPopup(
                          onHapus: () {
                            penggunaRepo.deletePengguna(widget.pengguna.id!);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    onHover: (_) {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return purple; // warna ketika ditekan
                        }
                        return Colors.white; // default
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white;
                        }
                        return purple;
                      }),
                      side: const WidgetStatePropertyAll(
                        BorderSide(color: purple, width: 2),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                    child: const Text(
                      "Hapus",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ====================== TOMBOL UBAH ======================
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UbahPenggunaPage(pengguna: widget.pengguna),
                        ),
                      );

                      ambilData();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return purple;
                        }
                        return Colors.white;
                      }),
                      foregroundColor: WidgetStateProperty.resolveWith((
                        states,
                      ) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.white;
                        }
                        return purple;
                      }),
                      side: const WidgetStatePropertyAll(
                        BorderSide(color: purple, width: 2),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                    ),
                    child: const Text(
                      "Ubah",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
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
