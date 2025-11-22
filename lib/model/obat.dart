class Obat {
  final int? id;
  final String nama;
  final int harga;
  final int stok;
  final String? satuan;
  final String? deskripsi;
  final String? foto;

  Obat({
    this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    this.satuan,
    this.deskripsi,
    this.foto,
  });
}