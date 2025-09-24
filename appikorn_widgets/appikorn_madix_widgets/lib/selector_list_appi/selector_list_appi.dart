library selector_list_appi;

import 'package:appikorn_madix_widgets/button_appi/button_appi.dart';
import 'package:appikorn_madix_widgets/svg_appi/svg_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../utils/madix_global.dart';

class SelectorListAppi extends StatelessWidget {
  const SelectorListAppi(
      {Key? key,
      required this.selected,
      required this.dat,
      required this.onTap,
      this.minWidth,
      this.icons,
      this.heading,
      this.mandatory,
      this.chipHeight,
      this.spacing,
      this.iconPadding,
      this.iconHeight,
      this.iconWidth,
      this.crossAlignment,
      this.scrollable,
      this.unselectedTextColor,
      this.selectedTextColor})
      : super(key: key);

  final String selected;

  final List<String> dat;
  final List<String>? icons;
  final Function(String) onTap;
  final double? minWidth;
  final Color? unselectedTextColor;
  final Color? selectedTextColor;
  final double? chipHeight;
  final double? spacing;
  final String? heading;
  final bool? mandatory;
  final double? iconPadding;
  final double? iconHeight;
  final double? iconWidth;
  final CrossAxisAlignment? crossAlignment;
  final bool? scrollable;

  Widget iconWidget({dat, color, height, width, selected, required context}) {
    return Padding(
      padding: EdgeInsets.only(right: MadixGlobal().rtl ? 0 : (iconPadding ?? 14), left: MadixGlobal().get_rtl() ? (iconPadding ?? 14) : 0),
      child: SvgAppi(
        fit: BoxFit.contain,
        height: iconHeight ?? 20,
        width: iconWidth ?? 20,
        source: dat,
        color: selected ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }

  Widget content(context) {
    Widget btn(i) {
      return ButtonAppi(
        borderColor: selected == dat[i] ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.3),
        height: chipHeight ?? b1,
        mainAxisAlignment: MainAxisAlignment.start,
        width: minWidth ?? 100,
        onTap: () {
          onTap(dat[i]);
        },
        text: dat[i],
        textStyle: Style(
            $text.style.fontWeight(w500),
            $text.style.color(
              selected == dat[i] ? selectedTextColor ?? Theme.of(context).primaryColor : unselectedTextColor ?? Colors.black,
            )),
        padding: 4,
        hoveredTextColor: Colors.black,
        hoverBorder: true,
        prefixIcon: (icons != null && icons!.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: iconWidget(context: context, selected: selected == dat[i], dat: icons?[i], color: selected == dat[i] ? Colors.white : const Color(0xffBFBFBF)),
              )
            : null,
        color: Colors.transparent,
      );
    }

    return Row(
      crossAxisAlignment: crossAlignment ?? CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        for (var i = 0; i < dat.length; i++)
          if (scrollable != null && scrollable == false) ...[
            if (i == 0) ...[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(right: MadixGlobal().get_rtl() ? 0 : (spacing ?? hs1), left: MadixGlobal().get_rtl() ? spacing ?? hs1 : 0),
                  child: btn(i),
                ),
              )
            ] else ...[
              Flexible(child: btn(i))
            ]
          ] else ...[
            Padding(
              padding: EdgeInsets.only(right: MadixGlobal().get_rtl() ? 0 : (spacing ?? hs1), left: MadixGlobal().get_rtl() ? spacing ?? hs1 : 0),
              child: btn(i),
            )
          ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAlignment ?? CrossAxisAlignment.start,
      children: [
        if (heading != null && heading!.isNotEmpty)
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextAppi(
                    mandatory: mandatory ?? false,
                    text: heading!,
                    textStyle: Style(
                      $text.style.color(Theme.of(context).primaryColor),
                      $text.style.fontWeight(w400),
                      $text.maxLines(10),
                      $text.style.fontSize(f0),
                    ),
                  ),
                ),
              )
            ],
          ),
        if (scrollable ?? true) ...[
          SingleChildScrollView(scrollDirection: Axis.horizontal, child: content(context)),
        ] else ...[
          content(context)
        ]
      ],
    );
  }
}
