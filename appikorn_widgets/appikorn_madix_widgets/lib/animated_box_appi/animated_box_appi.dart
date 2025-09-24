library animated_box_appi;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedBoxAppi extends StatefulWidget {
  const AnimatedBoxAppi(
      {Key? key,
      this.animationDuration,
      required this.child,
      required this.fromHeight,
      this.toHeight,
      this.fromWidth,
      this.toWidth,
      this.fromRadius,
      this.toRadius,
      this.fromColor,
      this.toColor,
      this.fromElevation,
      this.toElevation,
      this.ontap,
      this.onHovered,
      this.decorationImg,
      this.borderColor,
      this.borderWidth,
      this.borderRadius,
      this.childFromColor,
      this.childToColor})
      : super(key: key);

  final Duration? animationDuration;
  final double fromHeight;
  final child;
  final Function? ontap;
  final Function? onHovered;
  final double? toHeight;
  final double? fromWidth;
  final double? toWidth;
  final double? fromRadius;
  final double? toRadius;
  final Color? fromColor;
  final Color? toColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final double? fromElevation;
  final double? toElevation;
  final DecorationImage? decorationImg;
  final Color? childFromColor;
  final Color? childToColor;

  @override
  State<AnimatedBoxAppi> createState() => _AnimatedBoxAppiState();
}

class _AnimatedBoxAppiState extends State<AnimatedBoxAppi> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (s) {
        setState(() {
          isHovered = true;
        });

        if (widget.onHovered != null) {
          widget.onHovered!();
        }
      },
      onExit: (s) {
        setState(() {
          isHovered = false;
        });
      },
      onEnter: (s) {
        // print("this is enter event $s");
      },
      child: InkWell(
          focusNode: FocusNode(skipTraversal: true),
          onTap: () {
            // print("ontap");

            try {
              widget.ontap!();

              setState(() {});
            } catch (e) {
              if (kDebugMode) {
                print(e);
              }
            }
          },
          onTapDown: (s) {
            if (widget.ontap != null) {
              try {
                widget.ontap!();

                setState(() {});
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
            }
          },
          child: RepaintBoundary(
            child: AnimatedContainer(
              height: isHovered ? widget.toHeight ?? widget.fromHeight : widget.fromHeight,
              width: isHovered ? widget.toWidth ?? widget.fromWidth : widget.fromWidth,
              duration: widget.animationDuration ?? const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                image: widget.decorationImg,
                border: Border.all(color: widget.borderColor ?? Colors.transparent, width: widget.borderWidth ?? 0.0),
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 0.0), // Adjust the radius as needed
              ),
              child: RepaintBoundary(
                child: Material(
                  color: isHovered ? widget.toColor ?? widget.fromColor : widget.fromColor,
                  borderRadius: BorderRadius.all(Radius.circular(isHovered ? widget.toRadius ?? widget.fromRadius ?? 5 : widget.fromRadius ?? 5)),
                  elevation: isHovered ? widget.toElevation ?? widget.fromElevation ?? 0.0 : (widget.fromElevation ?? 0.0).toDouble(),
                  child: widget.child(hovered: isHovered),
                ),
              ),
            ),
          )),
    );
  }
}
