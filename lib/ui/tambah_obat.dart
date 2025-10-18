import 'dart:io';
import 'package:apotek_flutter/model/obat.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahObat extends StatefulWidget {
  const TambahObat({super.key});

  @override
  State<TambahObat> createState() => _TambahObatState();
}

class _TambahObatState extends State<TambahObat> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input teks
  final TextEditingController namaController = TextEditingController();
  final TextEditingController hargaController = TextEditingController();
  final TextEditingController stokController = TextEditingController();
  final TextEditingController satuanController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _simpanObat() {
    if (_formKey.currentState!.validate()) {
      final obat = Obat(
        nama: namaController.text,
        harga: int.parse(hargaController.text),
        stok: int.parse(stokController.text),
        satuan: satuanController.text,
        deskripsi: deskripsiController.text,
        // TODO: simpan foto
      );

      // TODO: simpan data ke database

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data obat berhasil disimpan',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          backgroundColor: Variables.colorSuccess,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Obat', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: Variables.colorSecondary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _image == null
                      ? Icon(Icons.image, size: 50, color: Colors.grey)
                      : Image.file(
                        _image!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Variables.colorAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Pilih Foto',
                      style: TextStyle(
                        color: Variables.colorPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              MyTextFormField(
                labelText: 'Nama obat',
                controller: namaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama obat tidak boleh kosong';
                  } else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 16),

              MyTextFormField(
                labelText: 'Harga obat',
                controller: hargaController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga obat tidak boleh kosong';
                  }
                  else if (int.tryParse(value) == null) {
                    return 'Harga obat harus berupa angka';
                  }
                  else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 16),

              MyTextFormField(
                labelText: 'Stok awal',
                controller: stokController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok awal tidak boleh kosong';
                  }
                  else if (int.tryParse(value) == null) {
                    return 'Stok awal harus berupa angka';
                  }
                  else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 16),

              MyTextFormField(
                labelText: 'Satuan',
                controller: satuanController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Satuan tidak boleh kosong';
                  }
                  else {
                    return null;
                  }
                }
              ),
              const SizedBox(height: 16),

              MyTextFormField(
                labelText: 'Deskripsi',
                controller: deskripsiController,
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 16),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _simpanObat,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  backgroundColor: Variables.colorSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Simpan',
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
      ),
    );
  }
}
