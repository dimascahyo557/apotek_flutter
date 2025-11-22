class Penjualan {
  final int? id;
  final int? idKasir;
  final DateTime tanggalTransaksi;
  final int totalHarga;
  final int jumlahBayar;

  Penjualan({
    this.id,
    this.idKasir,
    DateTime? tanggalTransaksi,
    required this.totalHarga,
    required this.jumlahBayar,
  }) : tanggalTransaksi = tanggalTransaksi ?? DateTime.now();
}