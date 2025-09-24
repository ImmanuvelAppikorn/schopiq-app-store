library time_picker_appi;

import 'package:flutter/material.dart';

import '../text_field_appi/text_field_appi.dart';
import '../utils/mode/text_field_params_appi.dart';

class TimePickerAppi extends StatelessWidget {
  const TimePickerAppi({super.key, required this.textFieldStyle, required this.onChange, this.initialTime});

  // Text field params
  final TextFieldParamsAppi textFieldStyle;

  // Picker params
  final Function(String) onChange;
  final TimeOfDay? initialTime;

  @override
  Widget build(BuildContext context) {
    // Create an updated instance of textFieldStyle with time picker logic
    final updatedTextFieldStyle = textFieldStyle.copyWith(
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: initialTime ?? TimeOfDay.now(),
        ).then((pickedTime) {
          if (pickedTime != null) {
            final formattedTime = "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
            onChange(formattedTime);
          }
        });
      },
      initialValue: initialTime != null ? "${initialTime!.hour.toString().padLeft(2, '0')}:${initialTime!.minute.toString().padLeft(2, '0')}" : "",
    );

    return TextFieldAppi.fromParams(updatedTextFieldStyle);
  }
}
