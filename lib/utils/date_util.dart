import 'package:intl/intl.dart';

class DateUtil {
  static final DateFormat _format = DateFormat('dd/MM/yyyy');
  static final DateFormat _format2 = DateFormat('ddMMyy');
  static final DateFormat _format3 = DateFormat('yyyy-MM-dd');

  static String formatDate(DateTime date) {
    return _format.format(date);
  }

  static String formatDateFromString(String string) {
    if (string.isEmpty) return '';
    DateTime date = DateTime.parse(string);
    return _format.format(date);
  }

  static String formatDateYYYYMMdd(DateTime date) {
    return _format3.format(date);
  }

  static String formatDateYYYYMMddFromString(String string) {
    if (string.isEmpty) return '';
    DateTime date = DateTime.parse(string);
    return _format3.format(date);
  }

  static String formatDateFromStringBase(String string) {
    if (string.isEmpty) return '';
    DateTime date = _parse2(string);
    return _format.format(date);
  }

  static DateTime parse(String string) {
    return _format.parse(string);
  }

  static DateTime _parse2(String string) {
    return _format2.parse(string);
  }
}
