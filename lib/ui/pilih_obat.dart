import 'package:apotek_flutter/helper/number_helper.dart';
import 'package:apotek_flutter/model/models.dart';
import 'package:apotek_flutter/repository/obat_repository.dart';
import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/app_outlined_button.dart';
import 'package:apotek_flutter/widget/app_text_button.dart';
import 'package:apotek_flutter/widget/my_list_item.dart';
import 'package:apotek_flutter/widget/my_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PilihObat extends StatefulWidget {
  final List<ItemPenjualan> itemPenjualan;
  const PilihObat({super.key, required this.itemPenjualan});

  @override
  State<PilihObat> createState() => _PilihObatState();
}

class _PilihObatState extends State<PilihObat> {
  final _obatRepo = ObatRepository();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _jumlahController = TextEditingController(
    text: '1',
  );

  List<Obat> _listObat = [];

  @override
  void initState() {
    super.initState();
    _ambilDataObat();
  }

  void _ambilDataObat() async {
    final data = await _obatRepo.getAllObat(search: _searchController.text);
    setState(() {
      _listObat = data;
    });
  }

  void _filterObat(String query) {
    setState(() {
      _ambilDataObat();
    });
  }

  int _hitungStokTersedia(Obat obat) {
    int stokTersedia = obat.stok;
    for (var itemPenjualan in widget.itemPenjualan) {
      if (itemPenjualan.idObat == obat.id) {
        stokTersedia -= itemPenjualan.jumlahPembelian;
      }
    }
    return stokTersedia;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Variables.colorPrimary,
        elevation: 0,
        toolbarHeight: 56,
        leadingWidth: 56,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          splashRadius: 24,
        ),
        title: const Text(
          'Pilih Obat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
        titleSpacing: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: _filterObat,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: 'Cari obat',
                hintStyle: const TextStyle(
                  color: Color(0xFFBDBDBD),
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
                    color: Variables.colorPrimary,
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

          // Label "Daftar Obat"
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              'Daftar Obat',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Variables.colorPrimary,
                letterSpacing: 0,
              ),
            ),
          ),

          // List Obat
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _listObat.length,
              itemBuilder: (context, index) {
                return MyListItem(
                  title: _listObat[index].nama,
                  subtitle: NumberHelper.formatHarga(_listObat[index].harga),
                  trailing: "Stok: ${_hitungStokTersedia(_listObat[index])}",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _listObat[index].nama,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Variables.colorPrimary,
                                    letterSpacing: 0,
                                  ),
                                ),
                                Text(
                                  NumberHelper.formatHarga(
                                    _listObat[index].harga,
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Variables.colorMuted,
                                    letterSpacing: 0,
                                  ),
                                ),
                                Text(
                                  'Stok: ${_hitungStokTersedia(_listObat[index])}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Variables.colorMuted,
                                    letterSpacing: 0,
                                  ),
                                ),
                                SizedBox(height: 16),

                                MyTextFormField(
                                  labelText: 'Jumlah',
                                  controller: _jumlahController,
                                  keyboardType: TextInputType.number,
                                ),
                                SizedBox(height: 16),

                                Row(
                                  children: [
                                    Expanded(
                                      child: AppOutlinedButton(
                                        label: 'Batal',
                                        borderColor: Variables.colorPrimary,
                                        foregroundColor: Variables.colorPrimary,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: AppTextButton(
                                        label: 'Simpan',
                                        backgroundColor: Variables.colorPrimary,
                                        foregroundColor: Colors.white,
                                        onPressed: () {
                                          if (_jumlahController.text.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Jumlah tidak boleh kosong',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Variables.colorDanger,
                                              ),
                                            );
                                            return;
                                          }

                                          if (int.parse(
                                                _jumlahController.text,
                                              ) <
                                              1) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Jumlah tidak boleh kurang dari 1',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Variables.colorDanger,
                                              ),
                                            );
                                            return;
                                          }

                                          if (int.parse(
                                                _jumlahController.text,
                                              ) >
                                              _hitungStokTersedia(
                                                _listObat[index],
                                              )) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Stok tidak mencukupi',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Variables.colorDanger,
                                              ),
                                            );
                                            return;
                                          }

                                          Navigator.pop(context);

                                          Navigator.pop(context, {
                                            'obat': _listObat[index],
                                            'jumlah': _jumlahController.text,
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
