import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class UbahObatScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  UbahObatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Variables.colorSecondary,
        title: const Text(
          'Ubah Obat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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
                        ),
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
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
                          // nanti di sini bisa ditambahkan fungsi pilih foto
                        },
                        child: const Text(
                          'Pilih Foto',
                           style: TextStyle(color:Color(0xFF8C00FF),
                           fontWeight: FontWeight.w600,
                         ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const CustomTextField(labelText: "Nama obat"),
                const SizedBox(height: 15),
                const CustomTextField(labelText: "Harga obat"),
                const SizedBox(height: 15),
                const CustomTextField(labelText: "Stok awal"),
                const SizedBox(height: 15),
                const CustomTextField(labelText: "Satuan"),
                const SizedBox(height: 15),

                TextFormField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Deskripsi obat (opsional)",
                    labelStyle: const TextStyle(color: Colors.grey),
                    alignLabelWithHint: true,
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Perubahan disimpan')),
                        );
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
  const CustomTextField({super.key, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
          borderSide: const BorderSide(color: Variables.colorDanger, width: 1.5),
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