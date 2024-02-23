import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextFormat extends TextInputFormatter {
  final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    final int value = formatter.parse(newValue.text.trim()).toInt();
    final String newText = formatter.format(value);

    return newValue.copyWith(
        text: newText.trim(),
        selection: TextSelection.collapsed(offset: newText.length - 1));

    throw UnimplementedError();
  }
}
