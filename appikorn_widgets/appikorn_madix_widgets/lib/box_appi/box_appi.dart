library box_appi;

import 'package:flutter/material.dart';

class BoxAppi extends StatelessWidget {
  const BoxAppi({
    Key? key,
    this.height,
    this.radius,
    this.borderColor,
    this.fillColor,
    this.gradientColor,
    required this.child,
    this.elevation,
    this.borderThickness,
    this.border,
    this.borderRadius,
    this.shadowColor,
    this.shadowBlur,
    this.shadowSpreadRadius,
    this.shadowOffset,
    this.image,
    this.imgFit,
  }) : super(key: key);

  final double? height;
  final double? radius;
  final double? borderThickness;
  final double? elevation;
  final Color? borderColor;
  final Color? fillColor;
  final Color? shadowColor;
  final Gradient? gradientColor;
  final Widget child;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final double? shadowBlur;
  final double? shadowSpreadRadius;
  final Offset? shadowOffset;
  final String? image;
  final BoxFit? imgFit;

  @override
  Widget build(BuildContext context) {
    final BorderRadiusGeometry effectiveBorderRadius = borderRadius ?? BorderRadius.circular(radius ?? 0);

    final decoration = BoxDecoration(
      borderRadius: effectiveBorderRadius,
      gradient: gradientColor,
      color: fillColor ?? Colors.white,
      image: image != null
          ? DecorationImage(
              image: AssetImage(image!),
              fit: imgFit ?? BoxFit.cover,
            )
          : null,
      border: border ?? (borderThickness != null && borderThickness! > 0 ? Border.all(color: borderColor ?? Colors.transparent, width: borderThickness!) : null),
      boxShadow: shadowColor != null
          ? [
              BoxShadow(
                color: shadowColor!,
                blurRadius: shadowBlur ?? 7,
                spreadRadius: shadowSpreadRadius ?? 0,
                offset: shadowOffset ?? const Offset(0, 3),
              ),
            ]
          : [],
    );

    Widget container = Container(
      height: height,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: child,
      ),
    );

    return elevation != null && elevation! > 0
        ? Material(
            color: Colors.transparent,
            elevation: elevation!,
            borderRadius: effectiveBorderRadius,
            shadowColor: shadowColor,
            child: container,
          )
        : container;
  }
}
