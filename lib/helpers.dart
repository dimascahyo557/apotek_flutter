import 'package:intl/intl.dart';

class Helpers {
  static String formatHarga(int harga) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(harga);
  }
}