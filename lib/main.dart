import 'package:apotek_flutter/model/pengguna.dart';
import 'package:apotek_flutter/ui/detail_pengguna_page.dart';
import 'package:apotek_flutter/ui/list_obat.dart';
import 'package:apotek_flutter/ui/splash_screen.dart';
import 'package:apotek_flutter/ui/tambah_obat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Obatin App',
      theme: ThemeData(
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF444444)),
          bodyMedium: TextStyle(color: Color(0xFF444444)),
          bodySmall: TextStyle(color: Color(0xFF444444)),
        ),
      ),
      home: DetailPenggunaPage(
        pengguna: Pengguna(
          id: 10,
          nama: "Dimas Cahyo Nugroho",
          email: "dimas@gmail.com",
          password: "dimas",
          role: "Admin",
        ),
      ),
    );
  }
}
