import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/model/models.dart';

class PenggunaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<int> insertPengguna(Pengguna p) async {
    final db = await _dbHelper.database;
    final map = {
      'nama': p.nama,
      'email': p.email,
      'password': p.password,
      'role': p.role,
    };
    return await db.insert('pengguna', map);
  }

  Future<Pengguna?> getPenggunaByEmail(String email) async {
    final db = await _dbHelper.database;
    final rows = await db.query(
      'pengguna',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (rows.isEmpty) return null;
    final r = rows.first;

    return Pengguna(
      id: r['id'] as int?,
      nama: r['nama'] as String,
      email: r['email'] as String,
      password: r['password'] as String,
      role: r['role'] as String?,
    );
  }

  Future<int> updatePengguna(int id, Pengguna p) async {
    final db = await _dbHelper.database;
    final map = {
      'nama': p.nama,
      'email': p.email,
      'password': p.password,
      'role': p.role,
    };
    return await db.update('pengguna', map, where: 'id = ?', whereArgs: [id]);
  }

  Future<Pengguna?> getPenggunaById(int id) async {
    final db = await _dbHelper.database;
    final rows = await db.query('pengguna', where: 'id = ?', whereArgs: [id]);

    if (rows.isEmpty) return null;
    final r = rows.first;

    return Pengguna(
      id: r['id'] as int?,
      nama: r['nama'] as String,
      email: r['email'] as String,
      password: r['password'] as String,
      role: r['role'] as String?,
    );
  }

  Future<int> deletePengguna(int id) async {
    final db = await _dbHelper.database;
    return await db.delete('pengguna', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Pengguna>> getAllPengguna({
    String? search,
    int? limit,
    int? offset,
  }) async {
    final db = await _dbHelper.database;

    // Jika tidak ada search
    if (search == null || search.trim().isEmpty) {
      final rows = await db.query(
        'pengguna',
        orderBy: 'nama ASC',
        limit: limit,
        offset: offset,
      );

      return rows.map((r) {
        return Pengguna(
          id: r['id'] as int?,
          nama: r['nama'] as String,
          email: r['email'] as String,
          password: r['password'] as String,
          role: r['role'] as String?,
        );
      }).toList();
    }

    // Jika ada search
    final pattern = '%${search.trim()}%';

    final rows = await db.query(
      'pengguna',
      where: 'nama LIKE ? OR email LIKE ?',
      whereArgs: [pattern, pattern],
      orderBy: 'nama ASC',
      limit: limit,
      offset: offset,
    );

    return rows.map((r) {
      return Pengguna(
        id: r['id'] as int?,
        nama: r['nama'] as String,
        email: r['email'] as String,
        password: r['password'] as String,
        role: r['role'] as String?,
      );
    }).toList();
  }

  Future<int> createAdminUserIfNeeded() async {
    final db = await _dbHelper.database;

    final existingAdmin = await db.query(
      'pengguna',
      where: 'email = ?',
      whereArgs: ['admin@mail.com'],
      limit: 1,
    );

    if (existingAdmin.isEmpty) {
      final newAdmin = Pengguna(
        nama: 'Admin User',
        email: 'admin@mail.com',
        password: 'password',
        role: 'Admin',
      );

      return await db.insert('pengguna', {
        'nama': newAdmin.nama,
        'email': newAdmin.email,
        'password': newAdmin.password,
        'role': newAdmin.role,
      });
    }

    return existingAdmin.first['id'] as int;
  }
}
