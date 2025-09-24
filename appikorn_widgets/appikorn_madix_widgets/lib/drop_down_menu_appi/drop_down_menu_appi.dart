library drop_down_menu_appi;

import 'package:appikorn_madix_widgets/animated_box_appi/animated_box_appi.dart';
import 'package:flutter/material.dart';

import '../../drop_down_menu_appi/dependancy.dart' as dp;

class DropDownMenuAppi extends StatelessWidget {
  const DropDownMenuAppi(
      {super.key,
      this.fromColor,
      this.toColor,
      this.fromHeight,
      this.toHeight,
      this.fromWidth,
      this.toWidth,
      required this.parentWidget,
      this.children,
      required this.offset,
      this.dropdownColor,
      this.dropdownElevation,
      this.dropdownRadius,
      this.itemHeight,
      this.dropdownWidth,
      this.dropdownHeight,
      this.fromRadius,
      this.tooltip,
      this.toRadius,
      this.onChanged,
      this.child});

  final Widget parentWidget;
  final List<Widget>? children;
  final Offset offset;
  final Color? dropdownColor;
  final double? dropdownRadius;
  final double? dropdownWidth;
  final double? dropdownHeight;
  final double? itemHeight;
  final int? dropdownElevation;
  final Color? fromColor;
  final Color? toColor;
  final double? fromHeight;
  final double? toHeight;
  final double? fromRadius;
  final double? toRadius;
  final double? fromWidth;
  final double? toWidth;
  final String? tooltip;
  final void Function(int)? onChanged;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBoxAppi(
      fromHeight: fromHeight ?? 30,
      fromWidth: fromWidth ?? 30,
      toHeight: toHeight,
      toWidth: toWidth,
      fromColor: fromColor ?? Colors.transparent,
      fromRadius: fromRadius ?? 100,
      toRadius: toRadius,
      toColor: toColor,
      child: ({hovered}) => Center(
        child: Tooltip(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          ),
          message: tooltip ?? "",
          child: DropdownButtonHideUnderline(
            child: dp.DropdownMenu(
              barrierColor: Colors.transparent,
              buttonHighlightColor: Colors.transparent,
              buttonSplashColor: Colors.transparent,
              buttonOverlayColor: WidgetStateProperty.all(Colors.transparent),
              buttonDecoration: const BoxDecoration(color: Colors.transparent),
              itemHeight: itemHeight ?? 36,
              isExpanded: true,
              customButton: parentWidget,
              focusColor: Colors.transparent,
              itemSplashColor: Colors.transparent,
              itemHighlightColor: Colors.transparent,
              items: child != null
                  ? [DropdownMenuItem<Widget>(value: child, child: child!)]
                  : (children ?? [])
                      .map((item) => DropdownMenuItem<Widget>(
                            value: item,
                            child: Container(
                              color: Colors.transparent,
                              child: item,
                            ),
                          ))
                      .toList(),
              onChanged: (value) {
                if (onChanged != null) {
                  if (child != null) {
                    onChanged!(0);
                  } else {
                    onChanged!((children ?? []).indexOf(value ?? Container()));
                  }
                }
              },
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
              ),
              dropdownMaxHeight: child == null ? dropdownHeight : null,
              dropdownWidth: child == null ? dropdownWidth : null,
              dropdownDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(dropdownRadius ?? 10),
                color: dropdownColor ?? Colors.white,
              ),
              dropdownElevation: dropdownElevation ?? 2,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 2,
              scrollbarAlwaysShow: true,
              offset: offset,
            ),
          ),
        ),
      ),
    );
  }
}
