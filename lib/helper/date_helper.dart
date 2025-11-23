import 'package:intl/intl.dart';

class DateHelper {
  static String formatTanggal(DateTime tanggal) {
    return DateFormat('d MMMM y').format(tanggal);
  }
}