library svg_appi;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgAppi extends StatelessWidget {
  const SvgAppi({Key? key, this.height, this.width, required this.source, this.fit, this.color, this.defaultColor}) : super(key: key);

  final double? height;
  final double? width;
  final String source;
  final BoxFit? fit;
  final Color? color;
  final bool? defaultColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: Center(
          child: RepaintBoundary(
            child: SvgPicture.asset(source, fit: fit ?? BoxFit.contain, colorFilter: (defaultColor ?? false) == true ? null : ColorFilter.mode(color ?? Colors.grey, BlendMode.srcIn)),
          ),
        ));
  }
}
