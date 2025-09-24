library linear_progress_indicator_appi;

import 'dart:math' as math;

import 'package:appikorn_madix_widgets/utils/madix_global.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../text_appi/text_appi.dart';

class LinearProgressIndicatorAppi extends StatelessWidget {
  const LinearProgressIndicatorAppi({Key? key, required this.len, required this.current_position, required this.from_position, required this.icon, this.width, this.height}) : super(key: key);

  final double len;
  final double current_position;
  final double from_position;
  final double? width;
  final double? height;
  final String icon;

  Widget content(value) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.center,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [
                    const Color(0xFFF47D0F),
                    const Color(0xFFEED816),
                    Colors.grey.withOpacity(0.4)
                  ], stops: [
                    value / 2,
                    value,
                    value,
                  ])),
              child: const SizedBox(height: 20),
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(-6, 0),
          child: Align(
            alignment: Alignment.lerp(Alignment.topLeft, Alignment.topRight, value)!,
            child: SizedBox(
              height: height ?? 35,
              child: Image.asset(
                icon,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
        tween: Tween<double>(
          begin: from_position,
          end: double.parse(current_position.toString()),
        ),
        builder: (context, value, _) => Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MadixGlobal().get_rtl() ? Flexible(child: Transform(alignment: Alignment.center, transform: Matrix4.rotationY(math.pi), child: content(value))) : Flexible(child: content(value)),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 40,
              child: TextAppi(
                text: "${(value * 100).round()}%",
                textStyle: Style($text.style.fontSize(50), $text.maxLines(1)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
