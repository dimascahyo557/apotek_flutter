class ItemPenjualan {
  final int? id;
  final int? idPenjualan;
  final int idObat;
  final int jumlahPembelian;
  final int hargaSatuan;
  final int totalHarga;

  ItemPenjualan({
    this.id,
    this.idPenjualan,
    required this.idObat,
    required this.jumlahPembelian,
    required this.hargaSatuan,
    required this.totalHarga,
  });

  ItemPenjualan copyWith({int? id, int? idPenjualan}) {
    return ItemPenjualan(
      id: id ?? this.id,
      idPenjualan: idPenjualan ?? this.idPenjualan,
      idObat: idObat,
      jumlahPembelian: jumlahPembelian,
      hargaSatuan: hargaSatuan,
      totalHarga: totalHarga,
    );
  }
}