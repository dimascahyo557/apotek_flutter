class Obat {
  String nama;
  int harga;
  int stok;
  String satuan;
  String? deskripsi;
  String? foto;

  Obat({
    required this.nama,
    required this.harga,
    required this.stok,
    required this.satuan,
    this.deskripsi,
    this.foto,
  });
}