import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/pengguna_repository.dart';
import 'package:apotek_flutter/ui/detail_pengguna_page.dart';
import 'package:apotek_flutter/ui/tambah_pengguna_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ListPengguna extends StatefulWidget {
  const ListPengguna({super.key});

  @override
  State<ListPengguna> createState() => _ListPenggunaState();
}

class _ListPenggunaState extends State<ListPengguna> {
  final penggunaRepo = PenggunaRepository();
  final TextEditingController _searchController = TextEditingController();

  List<Pengguna> _listPengguna = [];

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  void _ambilData() async {
    final pengguna = await penggunaRepo.getAllPengguna(
      search: _searchController.text,
    );
    setState(() {
      _listPengguna = pengguna;
    });
  }

  void _filterPengguna(String query) {
    _ambilData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 56,
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF450693),
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          splashRadius: 24,
        ),
        title: const Text(
          'Pengguna',
          style: TextStyle(
            color: Color(0xFF450693),
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        titleSpacing: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterPengguna,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Cari pengguna',
                hintStyle: const TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0E0E0),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF212121),
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                isDense: true,
              ),
            ),
          ),

          // Label "Daftar Pengguna"
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              'Daftar Pengguna',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF450693),
                letterSpacing: 0,
              ),
            ),
          ),

          // List Pengguna
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _listPengguna.length,
              itemBuilder: (context, index) {
                return PenggunaCard(
                  pengguna: _listPengguna[index],
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPenggunaPage(pengguna: _listPengguna[index]),
                      ),
                    );
                    _ambilData();
                  },
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TambahPenggunaPage()),
          );
          _ambilData();
        },
        backgroundColor: const Color(0xFF450693),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Widget Card untuk setiap pengguna
class PenggunaCard extends StatelessWidget {
  final Pengguna pengguna;
  final Function() onTap;

  const PenggunaCard({super.key, required this.pengguna, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Nama dan Email
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pengguna.nama,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                      letterSpacing: 0,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    pengguna.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // Badge Role
            Text(
              pengguna.role!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF757575),
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
