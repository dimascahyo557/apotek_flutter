import 'package:apotek_flutter/variables.dart';
import 'package:apotek_flutter/widget/app_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TentangPembuat extends StatefulWidget {
  const TentangPembuat({super.key});

  @override
  State<TentangPembuat> createState() => _TentangPembuatState();
}

class _TentangPembuatState extends State<TentangPembuat> {
  final List<Map<String, String>> _authors = [
    {
      'nama': 'Dimas Cahyo Nugroho',
      'nim': '19232509',
      'role': 'Ketua',
      'photo': 'assets/images/authors/Dimas Cahyo Nugroho.jpeg',
    },
    {
      'nama': 'Amelia Dwi Agustina',
      'nim': '19231437',
      'role': 'Anggota',
      'photo': 'assets/images/authors/Amelia Dwi Agustina.jpg',
    },
    {
      'nama': 'Bagas Maulana',
      'nim': '19232249',
      'role': 'Anggota',
      'photo': 'assets/images/authors/Bagas Maulana.jpg',
    },
    {
      'nama': 'Firmansyah Darussalam',
      'nim': '19230068',
      'role': 'Anggota',
      'photo': 'assets/images/authors/Firmansyah Darussalam.jpg',
    },
    {
      'nama': 'Muhammad Asyraf',
      'nim': '19230137',
      'role': 'Anggota',
      'photo': 'assets/images/authors/Muhammad Asyraf.jpg',
    },
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height / 2.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Variables.colorPrimary.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 16.0),
                    child: Column(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                          child: Column(
                            key: ValueKey<int>(
                              _currentIndex,
                            ), // Key for animation
                            children: [
                              Center(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.asset(
                                    _authors[_currentIndex]['photo']!,
                                    width: size.width / 2,
                                    height: size.width / 2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _authors[_currentIndex]['nama']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(${_authors[_currentIndex]['nim']})',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 32),
                              const Text(
                                'Sebagai',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Variables.colorMuted,
                                ),
                              ),
                              Text(
                                '${_authors[_currentIndex]['role']} Kelompok 1',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: size.width / 3,
                                child: const Divider(thickness: 2),
                              ),
                              const Text(
                                'Mahasiswa Universitas Bina Sarana Informatika',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(
                              _authors.length,
                              (index) => Container(
                                width: 15,
                                height: 15,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _currentIndex == index
                                      ? Variables.colorPrimary
                                      : Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: AppOutlinedButton(
                                borderColor: Variables.colorPrimary,
                                foregroundColor: Variables.colorPrimary,
                                leftIcon: const Icon(Icons.arrow_back),
                                label: 'Sebelumnya',
                                onPressed: () {
                                  setState(() {
                                    _currentIndex =
                                        (_currentIndex - 1 + _authors.length) %
                                        _authors.length;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppOutlinedButton(
                                borderColor: Variables.colorPrimary,
                                foregroundColor: Variables.colorPrimary,
                                rightIcon: const Icon(Icons.arrow_forward),
                                label: 'Selanjutnya',
                                onPressed: () {
                                  setState(() {
                                    _currentIndex =
                                        (_currentIndex + 1) % _authors.length;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Text(
                          'Aplikasi ini dibuat sebagai salah satu bentuk pemenuhan tugas mata kuliah Mobile Programming II',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Variables.colorMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
