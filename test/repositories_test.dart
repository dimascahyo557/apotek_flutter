import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as p;

import 'package:apotek_flutter/helper/database_helper.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/repository/riwayat_stok_repository.dart';
import 'package:apotek_flutter/repository/penjualan_repository.dart';
import 'package:apotek_flutter/repository/pengguna_repository.dart';
import 'package:apotek_flutter/model/models.dart';

void main() {
  setUpAll(() {
    // Initialize FFI implementation
    sqfliteFfiInit();
    // make the global databaseFactory point to ffi one, so openDatabase/getDatabasesPath works
    databaseFactory = databaseFactoryFfi;
  });

  late DatabaseHelper dbHelper;
  late ObatRepository obatRepo;
  late RiwayatStokRepository riwayatRepo;
  late PenjualanRepository penjualanRepo;
  late PenggunaRepository penggunaRepo;

  setUp(() async {
    // create fresh database for each test by deleting existing DB file (if any)
    final dbPath = await databaseFactory.getDatabasesPath();
    final testDbPath = p.join(dbPath, 'apotek.db');

    // delete existing test database to start clean
    if (await File(testDbPath).exists()) {
      await File(testDbPath).delete();
    }

    // init DatabaseHelper singleton (it should create DB + tables in onCreate)
    dbHelper = DatabaseHelper();
    await dbHelper.initDB(); // ensure DB & tables exist

    // instantiate repos
    obatRepo = ObatRepository();
    riwayatRepo = RiwayatStokRepository();
    penjualanRepo = PenjualanRepository();
    penggunaRepo = PenggunaRepository();
  });

  tearDown(() async {
    // close database after each test
    await dbHelper.close();
  });

  test('ObatRepository: insert, getAll, getById, update, delete', () async {
    final obat = Obat(
      nama: 'Paracetamol',
      harga: 15000,
      stok: 50,
      satuan: 'strip',
      deskripsi: 'Obat demam',
      foto: null,
    );

    final id = await obatRepo.insertObat(obat);
    expect(id, greaterThan(0));

    final all = await obatRepo.getAllObat();
    expect(all.length, equals(1));
    expect(all.first.nama, equals('Paracetamol'));

    final byId = await obatRepo.getObatById(id);
    expect(byId, isNotNull);
    expect(byId!.harga, equals(15000));

    // update stok
    final updatedObat = Obat(
      id: byId.id,
      nama: byId.nama,
      harga: byId.harga,
      stok: 40, // reduced
      satuan: byId.satuan,
      deskripsi: byId.deskripsi,
      foto: byId.foto,
    );
    final cnt = await obatRepo.updateObat(id, updatedObat);
    expect(cnt, equals(1));

    final afterUpdate = await obatRepo.getObatById(id);
    expect(afterUpdate!.stok, equals(40));

    // delete
    final deleted = await obatRepo.deleteObat(id);
    expect(deleted, equals(1));
    final afterDelete = await obatRepo.getAllObat();
    expect(afterDelete, isEmpty);
  });

  test('RiwayatStokRepository: insert and fetch', () async {
    // first insert an obat
    final idObat = await obatRepo.insertObat(Obat(nama: 'Amox', harga: 20000, stok: 10));
    expect(idObat, greaterThan(0));

    final r = RiwayatPerubahanStok(
      idObat: idObat,
      jenisAksi: 'restock',
      jumlah: 10,
      deskripsi: 'Restock awal',
    );

    final idRiwayat = await riwayatRepo.insertRiwayat(r);
    expect(idRiwayat, greaterThan(0));

    final list = await riwayatRepo.getRiwayatByObat(idObat);
    expect(list, isNotEmpty);
    expect(list.first.jenisAksi, equals('restock'));
  });

  test('PenjualanRepository: jualObat success reduces stock and creates riwayat', () async {
    // insert some obat
    final id1 = await obatRepo.insertObat(Obat(nama: 'ObatA', harga: 10000, stok: 5));
    final id2 = await obatRepo.insertObat(Obat(nama: 'ObatB', harga: 20000, stok: 3));

    final items = [
      ItemPenjualan(idObat: id1, jumlahPembelian: 2, hargaSatuan: 10000, totalHarga: 20000),
      ItemPenjualan(idObat: id2, jumlahPembelian: 1, hargaSatuan: 20000, totalHarga: 20000),
    ];

    final idPenjualan = await penjualanRepo.jualObat(idKasir: 1, items: items, jumlahBayar: 50000);
    expect(idPenjualan, greaterThan(0));

    // verify stok reduced
    final obat1 = await obatRepo.getObatById(id1);
    final obat2 = await obatRepo.getObatById(id2);
    expect(obat1!.stok, equals(3)); // 5 - 2
    expect(obat2!.stok, equals(2)); // 3 - 1

    // verify riwayat created for both
    final riwayat1 = await riwayatRepo.getRiwayatByObat(id1);
    final riwayat2 = await riwayatRepo.getRiwayatByObat(id2);
    expect(riwayat1.any((r) => r.jenisAksi == 'penjualan' && r.jumlah == -2), isTrue);
    expect(riwayat2.any((r) => r.jenisAksi == 'penjualan' && r.jumlah == -1), isTrue);

    // verify item_penjualan exists
    final itemsSaved = await penjualanRepo.getItemsByPenjualan(idPenjualan);
    expect(itemsSaved.length, equals(2));
    expect(itemsSaved.map((e) => e.idObat).toSet(), containsAll({id1, id2}));
  });

  test('PenjualanRepository: jualObat fails when stock insufficient (transaction rollback)', () async {
    final id1 = await obatRepo.insertObat(Obat(nama: 'ObatX', harga: 10000, stok: 1));
    final items = [
      ItemPenjualan(idObat: id1, jumlahPembelian: 2, hargaSatuan: 10000, totalHarga: 20000),
    ];

    // expect exception due to insufficient stock
    try {
      await penjualanRepo.jualObat(idKasir: 1, items: items, jumlahBayar: 20000);
      fail('Expected an exception due to insufficient stock');
    } catch (e) {
      // ok
    }

    // ensure stok remains unchanged (transaction should rollback)
    final obatAfter = await obatRepo.getObatById(id1);
    expect(obatAfter!.stok, equals(1));

    // ensure no penjualan record created
    final penjualanList = await penjualanRepo.getAllPenjualan();
    expect(penjualanList, isEmpty);
  });

  test('PenggunaRepository: insert and get by email', () async {
    final p = Pengguna(id: null, nama: 'Admin', email: 'admin@x.com', password: 'hashedpw', role: 'admin');
    final id = await penggunaRepo.insertPengguna(p);
    expect(id, greaterThan(0));

    final found = await penggunaRepo.getPenggunaByEmail('admin@x.com');
    expect(found, isNotNull);
    expect(found!.nama, equals('Admin'));
  });
}
