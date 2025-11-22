import 'dart:io';
import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ObatRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Jika diberikan, akan dipakai sebagai folder simpan (berguna untuk test).
  final Directory? baseDir;

  ObatRepository({this.baseDir});

  Future<String> _getBasePath() async {
    if (baseDir != null) return baseDir!.path;
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> _saveFileToAppDir(File file) async {
    final basePath = await _getBasePath();
    final ext = p.extension(file.path);
    final filename = 'obat_${DateTime.now().millisecondsSinceEpoch}$ext';
    final savedPath = p.join(basePath, filename);
    await file.copy(savedPath);
    return savedPath;
  }

  // ---------------------------------------------------------------------
  // INSERT
  // ---------------------------------------------------------------------
  Future<int> insertObat(Obat obat) async {
    final db = await _dbHelper.database;

    String? fotoPath;
    if (obat.foto != null) {
      fotoPath = await _saveFileToAppDir(obat.foto!);
    }

    final map = {
      'nama': obat.nama,
      'harga': obat.harga,
      'stok': obat.stok,
      'satuan': obat.satuan,
      'deskripsi': obat.deskripsi,
      'foto': fotoPath,          // <-- simpan path, bukan file
    };

    return await db.insert('obat', map);
  }

  // ---------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------
  Future<int> updateObat(int id, Obat obat) async {
    final db = await _dbHelper.database;

    String? fotoPath;
    if (obat.foto != null) {
      fotoPath = await _saveFileToAppDir(obat.foto!);
    }

    final map = {
      'nama': obat.nama,
      'harga': obat.harga,
      'stok': obat.stok,
      'satuan': obat.satuan,
      'deskripsi': obat.deskripsi,
      'foto': fotoPath,
    };

    return await db.update(
      'obat',
      map,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------
  Future<int> deleteObat(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('obat', where: 'id = ?', whereArgs: [id]);
  }

  // ---------------------------------------------------------------------
  // GET BY ID
  // ---------------------------------------------------------------------
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
      foto: r['foto'] != null ? File(r['foto'] as String) : null,
    );
  }

  // ---------------------------------------------------------------------
  // GET ALL
  // ---------------------------------------------------------------------
  Future<List<Obat>> getAllObat({
    String? search,
    int? limit,
    int? offset,
  }) async {
    final db = await _dbHelper.database;

    List<Map<String, Object?>> rows;

    if (search == null || search.trim().isEmpty) {
      rows = await db.query(
        'obat',
        orderBy: 'nama ASC',
        limit: limit,
        offset: offset,
      );
    } else {
      final pattern = '%${search.trim()}%';
      rows = await db.query(
        'obat',
        where: '(nama LIKE ? OR deskripsi LIKE ?)',
        whereArgs: [pattern, pattern],
        orderBy: 'nama ASC',
        limit: limit,
        offset: offset,
      );
    }

    return rows.map((r) {
      return Obat(
        id: r['id'] as int?,
        nama: r['nama'] as String,
        harga: (r['harga'] as num).toInt(),
        stok: (r['stok'] as num).toInt(),
        satuan: r['satuan'] as String?,
        deskripsi: r['deskripsi'] as String?,
        foto: r['foto'] != null ? File(r['foto'] as String) : null,
      );
    }).toList();
  }

  // ---------------------------------------------------------------------
  // STOK HELPERS
  // ---------------------------------------------------------------------
  Future<int> reduceStockTx(Transaction txn, int idObat, int qty) async {
    final rows = await txn.query(
      'obat',
      columns: ['stok'],
      where: 'id = ?',
      whereArgs: [idObat],
    );

    if (rows.isEmpty) throw Exception('Obat tidak ditemukan');

    final current = (rows.first['stok'] as num).toInt();
    if (current < qty) throw Exception('Stok tidak mencukupi');

    final newStock = current - qty;

    await txn.update(
      'obat',
      {'stok': newStock},
      where: 'id = ?',
      whereArgs: [idObat],
    );

    return newStock;
  }
}
