import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final String symbol;
  final String thousandsSeparator;

  CurrencyInputFormatter({
    required this.symbol,
    required this.thousandsSeparator,
  });

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // If the new value contains non-numeric characters (except commas), reject the change
    // and keep the old value instead of replacing with 0
    final containsInvalidChars = RegExp(r'[^\d,]').hasMatch(newValue.text);
    if (containsInvalidChars) {
      return oldValue;
    }

    String sanitizedText = newValue.text.replaceAll(thousandsSeparator, '');
    double value = double.tryParse(sanitizedText) ?? 0.0;

    String formattedText = NumberFormat("#,##0").format(value);

    String newText = formattedText.isEmpty ? '' : symbol + formattedText;

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
