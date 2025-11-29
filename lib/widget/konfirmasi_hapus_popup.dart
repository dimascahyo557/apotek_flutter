import 'package:flutter/material.dart';

class KonfirmasiHapusPopup extends StatelessWidget {
  final VoidCallback? onHapus;
  const KonfirmasiHapusPopup({super.key, this.onHapus});

  @override
  Widget build(BuildContext context) {
    const Color purple = Color(0xFF4A0EB3);

    // ✔ Perbaikan: gunakan ValueNotifier agar state tidak hilang
    final ValueNotifier<bool> batalPressed = ValueNotifier(false);
    final ValueNotifier<bool> hapusPressed = ValueNotifier(false);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 200),
      child: StatefulBuilder(
        builder: (context, setState) {
          return Material(
            // ✔ FIX tombol bisa ditekan
            color: Colors.transparent,
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.12 * 255).round()),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // JUDUL
                  const Text(
                    "Hapus Data",
                    style: TextStyle(
                      fontSize: 20,
                      color: purple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // SUBTEXT
                  const Text(
                    "Yakin ingin menghapus data?",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 26),

                  // ================= TOMBOL ==================
                  Row(
                    children: [
                      // ================= BATAL =================
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: batalPressed,
                          builder: (_, isPressed, __) {
                            return OutlinedButton(
                              onPressed: () {
                                batalPressed.value = true;

                                Future.delayed(
                                  const Duration(milliseconds: 130),
                                  () {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isPressed
                                    ? purple
                                    : Colors.white,
                                side: const BorderSide(color: purple, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                "Batal",
                                style: TextStyle(
                                  color: isPressed ? Colors.white : purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 8),

                      // ================= HAPUS =================
                      Expanded(
                        child: ValueListenableBuilder(
                          valueListenable: hapusPressed,
                          builder: (_, isPressed, __) {
                            return OutlinedButton(
                              onPressed: () {
                                hapusPressed.value = true;

                                Navigator.pop(context);
                                onHapus?.call();
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: isPressed
                                    ? purple
                                    : Colors.white,
                                side: const BorderSide(color: purple, width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              child: Text(
                                "Hapus",
                                style: TextStyle(
                                  color: isPressed ? Colors.white : purple,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
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
      ),
    );
  }
}
