import 'package:apotek_flutter/variables.dart';
import 'package:flutter/material.dart';

class UbahPenggunaPage extends StatefulWidget {
  // Misalnya kita ingin ubah data pengguna yang sudah ada
  final String namaAwal;
  final String emailAwal;
  final String roleAwal;

  const UbahPenggunaPage({
    Key? key,
    required this.namaAwal,
    required this.emailAwal,
    required this.roleAwal,
  }) : super(key: key);

  @override
  _UbahPenggunaPageState createState() => _UbahPenggunaPageState();
}

class _UbahPenggunaPageState extends State<UbahPenggunaPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  String? selectedRole;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.namaAwal);
    emailController = TextEditingController(text: widget.emailAwal);
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    selectedRole = widget.roleAwal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Pengguna'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        elevation: 1,
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
                value: selectedRole,
                items: ['Admin', 'User', 'Kasir']
                    .map((role) => DropdownMenuItem(
                          value: role,
                          child: Text(role),
                        ))
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
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Perubahan berhasil disimpan')),
                      );
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
