library toggle_switch_appi;

import 'package:flutter/material.dart';

class ToggleSwitchAppi extends StatelessWidget {
  const ToggleSwitchAppi({Key? key, required this.value, required this.onChanged, this.width, this.color}) : super(key: key);

  final bool value;
  final double? width;
  final Color? color;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 40,
      child: Switch(activeColor: color ?? Theme.of(context).primaryColor, value: value, onChanged: onChanged),
    );
  }
}
