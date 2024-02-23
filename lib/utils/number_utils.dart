
import 'package:intl/intl.dart';

class NumberUtils {
  static final _formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
  static final _formatterNotSymbol = NumberFormat.currency(locale: 'vi_VN', symbol: '');
  static final _formatterVND = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');

  static String formatCurrency(int input) {
    return _formatter.format(input).trim();
  }

  static String formatCurrencyNotSymbol(int input) {
    return _formatterNotSymbol.format(input).trim();
  }

  static String formatCurrencyVND(int input) {
    return _formatterVND.format(input).trim();
  }

  static int parse(String input) {
    return _formatter.parse(input).toInt();
  }
}