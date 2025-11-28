import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/pengguna_repository.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class UbahPenggunaPage extends StatefulWidget {
  final Pengguna pengguna;

  const UbahPenggunaPage({Key? key, required this.pengguna}) : super(key: key);

  @override
  _UbahPenggunaPageState createState() => _UbahPenggunaPageState();
}

class _UbahPenggunaPageState extends State<UbahPenggunaPage> {
  final _formKey = GlobalKey<FormState>();
  final penggunaRepository = PenggunaRepository();

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  String? selectedRole;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.pengguna.nama);
    emailController = TextEditingController(text: widget.pengguna.email);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    selectedRole = widget.pengguna.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Pengguna'),
        backgroundColor: Colors.white,
        foregroundColor: Variables.colorPrimary,
        elevation: 3,
        shadowColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nama Pengguna
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama pengguna',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Kolom ini tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              // Role Dropdown
              DropdownButtonFormField<String>(
                initialValue: selectedRole,
                items: ['Admin', 'Kasir']
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                decoration: InputDecoration(
                  labelText: 'Role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onChanged: (value) => setState(() => selectedRole = value),
                validator: (value) =>
                    value == null ? 'Pilih salah satu role' : null,
              ),
              const SizedBox(height: 12),

              // Email
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Kolom ini tidak boleh kosong' : null,
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Masukkan password baru' : null,
              ),
              const SizedBox(height: 12),

              // Konfirmasi Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Password tidak sama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Tombol Simpan Perubahan
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Variables.colorPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      penggunaRepository.updatePengguna(
                        widget.pengguna.id!,
                        Pengguna(
                          id: widget.pengguna.id,
                          nama: namaController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          role: selectedRole!,
                        ),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Perubahan berhasil disimpan')),
                      );

                      Navigator.pop(context);
                    }
                  },
                  child: Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
