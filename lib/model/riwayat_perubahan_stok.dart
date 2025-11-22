class RiwayatPerubahanStok {
  final int? id;
  final int idObat;
  final String jenisAksi;
  final int jumlah;
  final String? deskripsi;
  final DateTime tanggal;

  RiwayatPerubahanStok({
    this.id,
    required this.idObat,
    required this.jenisAksi,
    required this.jumlah,
    this.deskripsi,
    DateTime? tanggal,
  }) : tanggal = tanggal ?? DateTime.now();
}