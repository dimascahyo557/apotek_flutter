import 'dart:io';

import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UbahObatScreen extends StatefulWidget {
  final Obat obat;
  const UbahObatScreen({super.key, required this.obat});

  @override
  State<UbahObatScreen> createState() => _UbahObatScreenState();
}

class _UbahObatScreenState extends State<UbahObatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaObatController = TextEditingController();
  final _hargaObatController = TextEditingController();
  final _satuanController = TextEditingController();
  final _deskripsiObatController = TextEditingController();
  File? _fotoObat;

  @override
  void initState() {
    super.initState();
    _namaObatController.text = widget.obat.nama;
    _hargaObatController.text = widget.obat.harga.toString();
    _satuanController.text = widget.obat.satuan ?? '';
    _deskripsiObatController.text = widget.obat.deskripsi ?? '';
    _fotoObat = widget.obat.foto;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _fotoObat = File(pickedFile.path);
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
          'Ubah Obat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          image: _fotoObat != null
                              ? DecorationImage(
                                  image: FileImage(_fotoObat!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _fotoObat == null
                            ? const Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
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
                        child: Text(
                          'Pilih Foto',
                          style: TextStyle(
                            color: Variables.colorSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  labelText: "Nama obat",
                  controller: _namaObatController,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  labelText: "Harga obat",
                  controller: _hargaObatController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  labelText: "Satuan",
                  controller: _satuanController,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _deskripsiObatController,
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
                      backgroundColor: const Color(0xFF8C00FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await ObatRepository().updateObat(
                          widget.obat.id!,
                          Obat(
                            id: widget.obat.id,
                            nama: _namaObatController.text,
                            harga: int.parse(_hargaObatController.text),
                            satuan: _satuanController.text,
                            deskripsi: _deskripsiObatController.text,
                            foto: _fotoObat,
                            stok: widget.obat.stok,
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Perubahan disimpan')),
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Simpan Perubahan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
  final TextEditingController controller;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Variables.colorMuted, width: 1.5),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Variables.colorMuted, width: 2),
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
          borderSide: const BorderSide(color: Variables.colorDanger, width: 2),
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
