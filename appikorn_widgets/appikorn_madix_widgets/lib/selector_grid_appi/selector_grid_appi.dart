library selector_grid_appi;

import 'package:appikorn_madix_widgets/button_appi/button_appi.dart';
import 'package:appikorn_madix_widgets/svg_appi/svg_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/wrap_appi/wrap_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class SelectorGridAppi extends StatelessWidget {
  const SelectorGridAppi(
      {Key? key,
      required this.selected,
      required this.dat,
      required this.onTap,
      this.chipMinWidth,
      this.icons,
      required this.height,
      this.chipHeight,
      this.runningHeight,
      this.heading,
      this.mandatory})
      : super(key: key);

  final String selected;
  final String? heading;
  final List<String> dat;
  final List<String>? icons;
  final Function(String) onTap;
  final double? chipMinWidth;
  final double height;
  final double? chipHeight;
  final double? runningHeight;
  final bool? mandatory;

  Widget iconWidgtet({dat, color, height, width, required context}) {
    return Padding(
      padding: const EdgeInsets.only(right: 14.0),
      child: SvgAppi(
        fit: BoxFit.contain,
        height: height ?? 30,
        width: width ?? 30,
        source: dat,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (heading != null && heading!.isNotEmpty)
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextAppi(
                    mandatory: mandatory ?? false,
                    text: heading!,
                    textStyle: Style(
                      $text.style.fontWeight(w400),
                      $text.maxLines(10),
                      $text.style.fontSize(f1),
                    ),
                  ),
                ),
              )
            ],
          ),
        SizedBox(
          height: height,
          child: WrapAppi(
            runSpacing: runningHeight ?? 10,
            spacing: 5,
            controller: ScrollController(),
            children: [
              for (var i = 0; i < dat.length; i++)
                ButtonAppi(
                  height: chipHeight ?? b1,
                  width: chipMinWidth ?? 100,
                  onTap: () {
                    onTap(dat[i]);
                  },
                  text: dat[i],
                  textStyle: Style.combine([
                    if (selected == dat[i])
                      Style(
                        $text.style.color(Theme.of(context).primaryColor),
                        $text.style.fontWeight(w500),
                      ),
                    Style(
                      $text.style.fontSize(10),
                    )
                  ]),
                  padding: 3,
                  hoveredTextColor: Colors.black,
                  hoverBorder: true,
                  borderColor: selected == dat[i] ? Theme.of(context).primaryColor : const Color(0xffE6E8EB),
                  prefixIcon: (icons != null && icons!.isNotEmpty) ? iconWidgtet(context: context, dat: icons![i], color: selected == dat[i] ? Colors.white : null) : null,
                  color: Colors.transparent,
                )
            ],
          ),
        ),
      ],
    );
  }
}
//P110910123000317
