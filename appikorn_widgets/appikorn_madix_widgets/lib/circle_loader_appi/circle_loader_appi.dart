library circle_loader_appi;

import 'package:flutter/material.dart';

class CircleLoaderAppi extends StatelessWidget {
  const CircleLoaderAppi({super.key, this.color, this.thickness, required this.size});

  final Color? color;
  final double? thickness;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RepaintBoundary(
            child:
                SizedBox(width: size, height: size, child: CircularProgressIndicator(strokeWidth: thickness ?? 2, valueColor: AlwaysStoppedAnimation<Color>(color ?? Theme.of(context).primaryColor)))),
      ],
    );
  }
}
