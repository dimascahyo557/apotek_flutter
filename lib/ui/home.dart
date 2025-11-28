import 'package:apotek_flutter/helper/date_helper.dart';
import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/repository/penjualan_repository.dart';
import 'package:apotek_flutter/ui/detail_penjualan_page.dart';
import 'package:apotek_flutter/ui/list_obat.dart';
import 'package:apotek_flutter/ui/list_penjualan.dart';
import 'package:apotek_flutter/ui/login.dart';
import 'package:apotek_flutter/ui/tentang_pembuat.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/my_list_item.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final Pengguna pengguna;
  const Home({super.key, required this.pengguna});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final penjualanRepo = PenjualanRepository();

  List<Map<String, dynamic>> listPenjualan = [];

  void ambilData() async {
    listPenjualan.clear();

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);

    final penjualan = await penjualanRepo.getAllPenjualan(
      startDate: startOfDay,
    );
    for (final penj in penjualan) {
      listPenjualan.add({
        'penjualan': penj,
        'item': await penjualanRepo.getItemsByPenjualan(penj.id!),
      });
    }
    setState(() {});
  }

  @override
  void initState() {
    ambilData();

    super.initState();
  }

  int _countTodayMedicineSale() {
    return listPenjualan.fold(0, (sum, mapPenjualan) {
      return sum + _countJumlahPembelian(mapPenjualan['item']);
    });
  }

  int _countJumlahPembelian(List<ItemPenjualan> itemPenjualan) {
    return itemPenjualan.fold(
      0,
      (itemSum, item) => itemSum + item.jumlahPembelian,
    );
  }

  int _countTodayIncome() {
    final totalIncome = listPenjualan.fold(
      0,
      (sum, mapPenjualan) => sum + mapPenjualan['penjualan'].totalHarga as int,
    );
    return totalIncome;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Obatin App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Variables.colorPrimary,
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(context, widget.pengguna),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) => TambahObatScreen()));
        },
        backgroundColor: Variables.colorPrimary,
        foregroundColor: Colors.white,
        child: Icon(Icons.point_of_sale, size: 35),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang',
              style: TextStyle(color: Variables.colorMuted, fontSize: 16),
            ),
            Text(
              widget.pengguna.nama,
              style: TextStyle(
                color: Variables.colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _summaryCard(
                  title: 'Obat terjual hari ini',
                  value: _countTodayMedicineSale().toString(),
                ),
                _summaryCard(
                  title: 'Pendapatan hari ini',
                  value: NumberHelper.formatHarga(_countTodayIncome()),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Penjualan hari ini',
              style: TextStyle(
                color: Variables.colorPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listPenjualan.isEmpty ? 1 : listPenjualan.length,
                itemBuilder: (context, index) {
                  // if emtpy list
                  if (listPenjualan.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Text(
                        'Belum ada penjualan',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Variables.colorMuted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  }

                  final penjualan = listPenjualan[index]['penjualan'];
                  final itemPenjualan = listPenjualan[index]['item'];

                  return MyListItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPenjualanPage(penjualan: penjualan),
                        ),
                      );
                    },
                    title: NumberHelper.formatHarga(penjualan.totalHarga),
                    subtitle: "${itemPenjualan.length} jenis obat",
                    trailing: DateHelper.formatTanggal(
                      penjualan.tanggalTransaksi,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _summaryCard({required String title, String? value}) {
    return Expanded(
      child: Card(
        color: Variables.colorAccent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(
                value ?? '-',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, Pengguna pengguna) {
    final isAdmin = pengguna.role == 'Admin';

    return Drawer(
      child: Column(
        children: [
          // custom header
          Container(
            width: double.infinity,
            color: Variables.colorPrimary,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pengguna.nama,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    pengguna.email,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 12),

                ListTile(
                  leading: Icon(
                    Icons.medical_services,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Data Obat',
                    style: TextStyle(color: Color(0xFF555555)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigasi ke halaman Data Obat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ListObat(pengguna: pengguna),
                      ),
                    );
                  },
                ),

                ListTile(
                  leading: Icon(Icons.point_of_sale, color: Color(0xFF555555)),
                  title: const Text(
                    'Penjualan',
                    style: TextStyle(color: Color(0xFF555555)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ListPenjualan()),
                    );
                  },
                ),

                if (isAdmin)
                  ListTile(
                    leading: Icon(Icons.person, color: Color(0xFF555555)),
                    title: const Text(
                      'Pengguna',
                      style: TextStyle(color: Color(0xFF555555)),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => PenggunaScreen()));
                    },
                  ),

                const Divider(height: 24),

                ListTile(
                  leading: Icon(
                    Icons.power_settings_new,
                    color: Color(0xFF555555),
                  ),
                  title: const Text(
                    'Keluar',
                    style: TextStyle(color: Color(0xFF555555)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // logout app
                    Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 450),
                        pageBuilder: (_, animation, secondaryAnimation) =>
                            Login(),
                        transitionsBuilder: (_, animation, __, child) {
                          final tween = Tween(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).chain(CurveTween(curve: Curves.easeOut));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: TextButton.icon(
                icon: Icon(Icons.info_outline),
                label: Text('Tentang Pembuat'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TentangPembuat()),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
