import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:sqflite/sqflite.dart';

class RiwayatStokRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertRiwayatTx(Transaction txn, RiwayatPerubahanStok r) async {
    final map = {
      'id_obat': r.idObat,
      'jenis_aksi': r.jenisAksi,
      'jumlah': r.jumlah,
      'deskripsi': r.deskripsi,
      'tanggal': r.tanggal.toIso8601String(),
    };
    return await txn.insert('riwayat_perubahan_stok', map);
  }

  Future<int> insertRiwayat(RiwayatPerubahanStok r) async {
    final db = await _dbHelper.database;
    final map = {
      'id_obat': r.idObat,
      'jenis_aksi': r.jenisAksi,
      'jumlah': r.jumlah,
      'deskripsi': r.deskripsi,
      'tanggal': r.tanggal.toIso8601String(),
    };
    return await db.insert('riwayat_perubahan_stok', map);
  }

  Future<List<RiwayatPerubahanStok>> getRiwayatByObat(int idObat) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'riwayat_perubahan_stok',
      where: 'id_obat = ?',
      whereArgs: [idObat],
      orderBy: 'tanggal DESC',
    );
    return rows.map((r) => RiwayatPerubahanStok(
      id: r['id'] as int?,
      idObat: (r['id_obat'] as num).toInt(),
      jenisAksi: r['jenis_aksi'] as String,
      jumlah: (r['jumlah'] as num).toInt(),
      deskripsi: r['deskripsi'] as String?,
      tanggal: DateTime.parse(r['tanggal'] as String),
    )).toList();
  }
}
