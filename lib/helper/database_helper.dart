import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'apotek.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE obat (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            harga INTEGER,
            stok INTEGER,
            satuan TEXT,
            deskripsi TEXT,
            foto TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE penjualan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_kasir INTEGER,
            tanggal_transaksi TEXT,
            total_harga INTEGER,
            jumlah_bayar INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE item_penjualan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_penjualan INTEGER,
            id_obat INTEGER,
            jumlah_pembelian INTEGER,
            harga_satuan INTEGER,
            total_harga INTEGER
          );
        ''');

        await db.execute('''
          CREATE TABLE riwayat_perubahan_stok (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            id_obat INTEGER,
            jenis_aksi TEXT,
            jumlah INTEGER,
            deskripsi TEXT,
            tanggal TEXT
          );
        ''');

        await db.execute('''
          CREATE TABLE pengguna (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT,
            email TEXT,
            password TEXT,
            role TEXT
          );
        ''');
      },
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
    _db = null;
  }
}
