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

  String get kodePenjualan {
    final year = tanggalTransaksi.year;
    final month = tanggalTransaksi.month.toString().padLeft(2, '0');
    final day = tanggalTransaksi.day.toString().padLeft(2, '0');
    return 'PNJ-$year$month$day-${id ?? 0}';
  }
}
