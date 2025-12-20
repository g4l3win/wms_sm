import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }
    return newValue;
  }

  onFormatNumber({required int texInput}) {
    var formatter = NumberFormat('#,###,###,###');
    var newFormat = formatter.format(texInput);
    return newFormat;
  }
}
