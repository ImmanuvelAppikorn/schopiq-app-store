library checkbox_appi;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckboxAppi extends StatelessWidget {
  const CheckboxAppi({Key? key, required this.value, required this.onChanged, this.width, this.color, this.checkColor}) : super(key: key);

  final bool value;
  final double? width;
  final Color? color;
  final Color? checkColor;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 40,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.enter) {
              onChanged(!value);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          side: WidgetStateBorderSide.resolveWith(
            (states) => const BorderSide(
              width: 1.0,
            ),
          ),
          activeColor: color ?? Colors.white,
          value: value,
          checkColor: checkColor ?? const Color(0xff71AE62),
          onChanged: (s) {
            onChanged(s);
          },
        ),
      ),
    );
  }
}
