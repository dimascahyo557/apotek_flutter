import 'dart:io';

import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahObatScreen extends StatefulWidget {

  TambahObatScreen({super.key});

  @override
  State<TambahObatScreen> createState() => _TambahObatScreenState();
}

class _TambahObatScreenState extends State<TambahObatScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();

  TextEditingController hargaController = TextEditingController();

  TextEditingController stokController = TextEditingController();

  TextEditingController satuanController = TextEditingController();

  TextEditingController deskripsiController = TextEditingController();

  File? foto;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        foto = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
        title: const Text(
          'Tambah Obat',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          pickImage();
                        },
                        child: const Text(
                          'Pilih Foto',
                          style: TextStyle(color:  Variables.colorSecondary,
                          fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                CustomTextField(labelText: "Nama obat", controller: namaController,),
                const SizedBox(height: 15),
                CustomTextField(labelText: "Harga obat", controller: hargaController,),
                const SizedBox(height: 15),
                CustomTextField(labelText: "Stok awal", controller: stokController,),
                const SizedBox(height: 15),
                CustomTextField(labelText: "Satuan", controller: satuanController,),
                const SizedBox(height: 15),

                TextFormField(
                  controller: deskripsiController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Deskripsi obat (opsional)",
                    labelStyle: const TextStyle(color: Colors.grey),
                    alignLabelWithHint: true,
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

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Variables.colorSecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {

                        // simpan data obat
                        final obat = Obat(
                          nama: namaController.text,
                          harga: int.parse(hargaController.text),
                          stok: int.parse(stokController.text),
                          satuan: satuanController.text,
                          deskripsi: deskripsiController.text,
                          foto: foto,
                        );
                        final obatRepo = ObatRepository();
                        obatRepo.insertObat(obat);

                        // tampil pesan sukses
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data obat disimpan'),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  const CustomTextField({super.key, required this.labelText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
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
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Variables.colorDanger,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Variables.colorDanger,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kolom ini tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
