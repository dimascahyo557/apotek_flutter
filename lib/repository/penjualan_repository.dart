import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/repository/riwayat_stok_repository.dart';

class PenjualanRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final ObatRepository _obatRepo = ObatRepository();
  final RiwayatStokRepository _riwayatRepo = RiwayatStokRepository();

  /// Jual obat: simpan Penjualan + ItemPenjualan, kurangi stok, catat riwayat.
  /// Menggunakan Transaction supaya atomic.
  Future<int> jualObat({
    required int idKasir,
    required List<ItemPenjualan> items,
    required int jumlahBayar,
  }) async {
    final db = await _dbHelper.database;

    // hitung total harga
    int totalHarga = items.fold(0, (sum, it) => sum + it.totalHarga);

    return await db.transaction<int>((txn) async {
      // insert penjualan
      final penjualanMap = {
        'id_kasir': idKasir,
        'tanggal_transaksi': DateTime.now().toIso8601String(),
        'total_harga': totalHarga,
        'jumlah_bayar': jumlahBayar,
      };
      final idPenjualan = await txn.insert('penjualan', penjualanMap);

      // insert item_penjualan & update stok & riwayat
      for (final it in items) {
        final itemMap = {
          'id_penjualan': idPenjualan,
          'id_obat': it.idObat,
          'jumlah_pembelian': it.jumlahPembelian,
          'harga_satuan': it.hargaSatuan,
          'total_harga': it.totalHarga,
        };
        await txn.insert('item_penjualan', itemMap);

        // update stok via obatRepo helper (transaction)
        await _obatRepo.reduceStockTx(txn, it.idObat, it.jumlahPembelian);

        // catat riwayat
        final riwayat = RiwayatPerubahanStok(
          idObat: it.idObat,
          jenisAksi: 'penjualan',
          jumlah: -it.jumlahPembelian,
          deskripsi: 'Penjualan id_penjualan: $idPenjualan',
        );
        await _riwayatRepo.insertRiwayatTx(txn, riwayat);
      }

      return idPenjualan;
    });
  }

  Future<List<Penjualan>> getAllPenjualan({
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    final db = await _dbHelper.database;

    // Jika tidak ada filter tanggal -> query biasa (dengan paging jika disediakan)
    if (startDate == null && endDate == null) {
      final rows = await db.query(
        'penjualan',
        orderBy: 'tanggal_transaksi DESC',
        limit: limit,
        offset: offset,
      );

      return rows.map((r) => Penjualan(
        id: r['id'] as int?,
        idKasir: r['id_kasir'] as int?,
        tanggalTransaksi: DateTime.parse(r['tanggal_transaksi'] as String),
        totalHarga: (r['total_harga'] as num).toInt(),
        jumlahBayar: (r['jumlah_bayar'] as num).toInt(),
      )).toList();
    }

    // Build where clause & args sesuai kombinasi start/end
    String where = '';
    final List<dynamic> whereArgs = [];

    if (startDate != null && endDate != null) {
      // gunakan BETWEEN (inklusif)
      where = 'tanggal_transaksi BETWEEN ? AND ?';
      whereArgs.addAll([startDate.toIso8601String(), endDate.toIso8601String()]);
    } else if (startDate != null) {
      where = 'tanggal_transaksi >= ?';
      whereArgs.add(startDate.toIso8601String());
    } else if (endDate != null) {
      where = 'tanggal_transaksi <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    final rows = await db.query(
      'penjualan',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'tanggal_transaksi DESC',
      limit: limit,
      offset: offset,
    );

    return rows.map((r) => Penjualan(
      id: r['id'] as int?,
      idKasir: r['id_kasir'] as int?,
      tanggalTransaksi: DateTime.parse(r['tanggal_transaksi'] as String),
      totalHarga: (r['total_harga'] as num).toInt(),
      jumlahBayar: (r['jumlah_bayar'] as num).toInt(),
    )).toList();
  }

  Future<List<ItemPenjualan>> getItemsByPenjualan(int idPenjualan) async {
    final db = await _dbHelper.database;
    final rows = await db.query('item_penjualan', where: 'id_penjualan = ?', whereArgs: [idPenjualan]);
    return rows.map((r) => ItemPenjualan(
      id: r['id'] as int?,
      idPenjualan: (r['id_penjualan'] as num).toInt(),
      idObat: (r['id_obat'] as num).toInt(),
      jumlahPembelian: (r['jumlah_pembelian'] as num).toInt(),
      hargaSatuan: (r['harga_satuan'] as num).toInt(),
      totalHarga: (r['total_harga'] as num).toInt(),
    )).toList();
  }
}
