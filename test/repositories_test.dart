import 'dart:io';
import 'dart:typed_data';
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

  Directory tempBaseDir;

  late DatabaseHelper dbHelper;
  late ObatRepository obatRepo;
  late RiwayatStokRepository riwayatRepo;
  late PenjualanRepository penjualanRepo;
  late PenggunaRepository penggunaRepo;

  setUp(() async {
    tempBaseDir = await Directory.systemTemp.createTemp('apotek_test_');

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
    obatRepo = ObatRepository(baseDir: tempBaseDir);
    riwayatRepo = RiwayatStokRepository();
    penjualanRepo = PenjualanRepository();
    penggunaRepo = PenggunaRepository();
  });

  tearDown(() async {
    // close database after each test
    await dbHelper.close();
  });

  test('ObatRepository: insert, getAll, getAll with search, getById, update, delete', () async {
    final obat = Obat(
      nama: 'Paracetamol',
      harga: 15000,
      stok: 50,
      satuan: 'strip',
      deskripsi: 'Obat demam',
      foto: null,
    );

    // insert
    final id = await obatRepo.insertObat(obat);
    expect(id, greaterThan(0));

    // get all tanpa search
    final all = await obatRepo.getAllObat();
    expect(all.length, equals(1));
    expect(all.first.nama, equals('Paracetamol'));

    // get all dengan search (harus menemukan)
    final searchHit = await obatRepo.getAllObat(search: 'para'); // partial, case-insensitive expectation
    expect(searchHit.length, equals(1));
    expect(searchHit.first.nama, equals('Paracetamol'));

    // get all dengan search yang tidak ada (harus kosong)
    final searchMiss = await obatRepo.getAllObat(search: 'ibuprofen');
    expect(searchMiss, isEmpty);

    // get by id
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

  test('insert/get with foto using injected baseDir', () async {
    final tmp = File(p.join(Directory.systemTemp.path, 'dummy.png'));
    await tmp.writeAsBytes(Uint8List.fromList(List<int>.generate(10, (i) => i)));

    final obat = Obat(
      nama: 'Tst',
      harga: 1000,
      stok: 5,
      satuan: 'pcs',
      deskripsi: 'd',
      foto: tmp,
    );

    final id = await obatRepo.insertObat(obat);
    expect(id, greaterThan(0));

    final fetched = await obatRepo.getObatById(id);
    expect(fetched, isNotNull);
    expect(fetched!.foto, isNotNull);
    expect((fetched.foto as File).existsSync(), isTrue);

    // cleanup temporary source
    if (await tmp.exists()) await tmp.delete();
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

  test('PenjualanRepository: filter by startDate and endDate', () async {
    // Insert obat
    final idA = await obatRepo.insertObat(Obat(nama: 'Obat Filter A', harga: 10000, stok: 10));
    final idB = await obatRepo.insertObat(Obat(nama: 'Obat Filter B', harga: 20000, stok: 10));

    // Helper function untuk membuat transaksi dengan tanggal custom
    Future<int> createSale(DateTime date) async {
      final items = [
        ItemPenjualan(idObat: idA, jumlahPembelian: 1, hargaSatuan: 10000, totalHarga: 10000),
      ];

      // Jalankan penjualan
      final id = await penjualanRepo.jualObat(
        idKasir: 1,
        items: items,
        jumlahBayar: 10000,
      );

      // Update tanggal transaksi secara langsung supaya bisa diuji
      final db = await dbHelper.database;
      await db.update(
        'penjualan',
        {'tanggal_transaksi': date.toIso8601String()},
        where: 'id = ?',
        whereArgs: [id],
      );

      return id;
    }

    // Buat 3 transaksi pada tanggal yang berbeda
    final idT1 = await createSale(DateTime(2025, 1, 1, 10, 0, 0));
    final idT2 = await createSale(DateTime(2025, 1, 5, 12, 0, 0));
    final idT3 = await createSale(DateTime(2025, 1, 10, 18, 0, 0));

    // -------------------------------
    // 1) Filter: startDate saja (>= 5 Jan 2025)
    // -------------------------------
    final startOnly = await penjualanRepo.getAllPenjualan(
      startDate: DateTime(2025, 1, 5),
    );

    expect(startOnly.length, equals(2));
    final idsStartOnly = startOnly.map((e) => e.id).toSet();
    expect(idsStartOnly, containsAll([idT2, idT3]));

    // -------------------------------
    // 2) Filter: endDate saja (<= 5 Jan 2025)
    // -------------------------------
    final endOnly = await penjualanRepo.getAllPenjualan(
      endDate: DateTime(2025, 1, 5, 23, 59, 59),
    );

    expect(endOnly.length, equals(2));
    final idsEndOnly = endOnly.map((e) => e.id).toSet();
    expect(idsEndOnly, containsAll([idT1, idT2]));

    // -------------------------------
    // 3) Filter range: 2 Jan → 9 Jan
    // -------------------------------
    final range = await penjualanRepo.getAllPenjualan(
      startDate: DateTime(2025, 1, 2),
      endDate: DateTime(2025, 1, 9, 23, 59, 59),
    );

    expect(range.length, equals(1));
    expect(range.first.id, equals(idT2)); // hanya transaksi tanggal 5 Jan
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

  test('PenggunaRepository: insert, getById, getByEmail, update, search, getAll, delete', () async {
    // Insert pertama
    final p1 = Pengguna(
      nama: 'Dimas Cahyo',
      email: 'dimas@example.com',
      password: '123456',
      role: 'admin',
    );

    final id1 = await penggunaRepo.insertPengguna(p1);
    expect(id1, greaterThan(0));

    // Insert kedua
    final p2 = Pengguna(
      nama: 'Ayu Lestari',
      email: 'ayu@example.com',
      password: 'abcdef',
      role: 'kasir',
    );

    final id2 = await penggunaRepo.insertPengguna(p2);
    expect(id2, greaterThan(id1));

    // ---- getPenggunaById ----
    final byId = await penggunaRepo.getPenggunaById(id1);
    expect(byId, isNotNull);
    expect(byId!.nama, equals('Dimas Cahyo'));

    // ---- getPenggunaByEmail ----
    final byEmail = await penggunaRepo.getPenggunaByEmail('ayu@example.com');
    expect(byEmail, isNotNull);
    expect(byEmail!.nama, equals('Ayu Lestari'));

    // ---- getAllPengguna tanpa search ----
    final all = await penggunaRepo.getAllPengguna();
    expect(all.length, equals(2));

    // ---- getAllPengguna dengan search ----
    final search1 = await penggunaRepo.getAllPengguna(search: 'dimas');
    expect(search1.length, equals(1));
    expect(search1.first.email, equals('dimas@example.com'));

    final search2 = await penggunaRepo.getAllPengguna(search: 'example.com');
    expect(search2.length, equals(2)); // keduanya match

    final searchMiss = await penggunaRepo.getAllPengguna(search: 'tidakadadata');
    expect(searchMiss, isEmpty);

    // ---- getAllPengguna dengan limit ----
    final limited = await penggunaRepo.getAllPengguna(limit: 1);
    expect(limited.length, equals(1));

    // ---- updatePengguna ----
    final updateData = Pengguna(
      id: id1,
      nama: 'Dimas Updated',
      email: 'dimas@example.com',
      password: 'newpass',
      role: 'admin',
    );

    final updateCount = await penggunaRepo.updatePengguna(id1, updateData);
    expect(updateCount, equals(1));

    final afterUpdate = await penggunaRepo.getPenggunaById(id1);
    expect(afterUpdate!.nama, equals('Dimas Updated'));

    // ---- deletePengguna ----
    final deleteCount = await penggunaRepo.deletePengguna(id2);
    expect(deleteCount, equals(1));

    final afterDelete = await penggunaRepo.getPenggunaById(id2);
    expect(afterDelete, isNull);

    final allAfterDelete = await penggunaRepo.getAllPengguna();
    expect(allAfterDelete.length, equals(1));
  });
}
