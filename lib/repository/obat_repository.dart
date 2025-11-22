import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:sqflite/sqflite.dart';

class ObatRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertObat(Obat obat) async {
    final db = await _dbHelper.database;
    final map = {
      'nama': obat.nama,
      'harga': obat.harga,
      'stok': obat.stok,
      'satuan': obat.satuan,
      'deskripsi': obat.deskripsi,
      'foto': obat.foto,
    };
    return await db.insert('obat', map);
  }

  Future<int> updateObat(int id, Obat obat) async {
    final db = await _dbHelper.database;
    final map = {
      'nama': obat.nama,
      'harga': obat.harga,
      'stok': obat.stok,
      'satuan': obat.satuan,
      'deskripsi': obat.deskripsi,
      'foto': obat.foto,
    };
    return await db.update('obat', map, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteObat(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('obat', where: 'id = ?', whereArgs: [id]);
  }

  Future<Obat?> getObatById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query('obat', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    final r = rows.first;
    return Obat(
      id: r['id'] as int?,
      nama: r['nama'] as String,
      harga: (r['harga'] as num).toInt(),
      stok: (r['stok'] as num).toInt(),
      satuan: r['satuan'] as String?,
      deskripsi: r['deskripsi'] as String?,
      foto: r['foto'] as String?,
    );
  }

  Future<List<Obat>> getAllObat() async {
    final db = await _dbHelper.database;
    final rows = await db.query('obat', orderBy: 'nama ASC');
    return rows.map((r) => Obat(
      id: r['id'] as int?,
      nama: r['nama'] as String,
      harga: (r['harga'] as num).toInt(),
      stok: (r['stok'] as num).toInt(),
      satuan: r['satuan'] as String?,
      deskripsi: r['deskripsi'] as String?,
      foto: r['foto'] as String?,
    )).toList();
  }

  // stok helpers (dipakai oleh penjualan)
  Future<int> reduceStockTx(Transaction txn, int idObat, int qty) async {
    final rows = await txn.query('obat', columns: ['stok'], where: 'id = ?', whereArgs: [idObat]);
    if (rows.isEmpty) throw Exception('Obat tidak ditemukan');
    final current = (rows.first['stok'] as num).toInt();
    if (current < qty) throw Exception('Stok tidak mencukupi');
    final newStock = current - qty;
    await txn.update('obat', {'stok': newStock}, where: 'id = ?', whereArgs: [idObat]);
    return newStock;
  }
}
