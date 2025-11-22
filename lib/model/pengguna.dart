class Pengguna {
  final int? id;
  final String nama;
  final String email;
  final String password;
  final String? role;

  Pengguna({
    this.id,
    required this.nama,
    required this.email,
    required this.password,
    this.role,
  });
}