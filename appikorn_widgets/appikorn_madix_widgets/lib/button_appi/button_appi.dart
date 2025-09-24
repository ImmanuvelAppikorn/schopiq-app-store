library button_appi;

import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';

class ButtonAppi extends StatelessWidget {
  const ButtonAppi({
    Key? key,
    // this.textSize,
    // this.textColor,
    // this.textWeight,
    this.child,
    this.border,
    this.borderThickness,
    this.borderColor,
    this.suffixIcon,
    this.prefixIcon,
    this.hoverElevation,
    this.height,
    required this.width,
    this.radius,
    required this.onTap,
    this.text,
    this.color,
    this.splashColor,
    this.focus,
    this.nextFocus,
    this.load,
    this.hoverBorder,
    this.hoveredTextColor,
    this.hoveredColor,
    this.mainAxisAlignment,
    this.padding,
    this.textStyle,
  }) : super(key: key);

  final double? hoverElevation;
  final Widget? suffixIcon;
  final Widget? child;
  final Widget? prefixIcon;
  final MainAxisAlignment? mainAxisAlignment;
  final double? height;
  final double? width;
  final double? borderThickness;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final double? radius;
  final Function() onTap;
  final String? text;
  // final double? textSize;
  final double? padding;
  // final FontWeight? textWeight;
  // final Color? textColor;
  final Style? textStyle;
  final Color? hoveredTextColor;
  final Color? color;
  final Color? splashColor;
  final Color? hoveredColor;
  final bool? load;
  final bool? border;
  final bool? hoverBorder;
  final Color? borderColor;

  childWidget(context) {
    if (text != null) {
      return GestureDetector(
        onTap: onTap(),
        child: TextAppi(
          selectable: false,
          text: text ?? "",
          textStyle: textStyle ?? const Style.empty(),
        ),
      );
    }

    if (child != null) {
      return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = color ?? Theme.of(context).primaryColor;
    final defaultRadius = radius ?? (Theme.of(context).outlinedButtonTheme.style?.shape?.resolve({}) as RoundedRectangleBorder?)?.borderRadius.resolve(TextDirection.ltr).topLeft.x ?? 10;
    final ButtonStyle? outlinedButtonStyle = Theme.of(context).outlinedButtonTheme.style;
    final BorderSide? defaultBorderSide = outlinedButtonStyle?.side?.resolve(<WidgetState>{});
    final Color borderColorShade = defaultBorderSide?.color ?? Colors.black;
    final double borderWidth = defaultBorderSide?.width ?? 1.0;
    final BorderStyle borderStyle = defaultBorderSide?.style ?? BorderStyle.solid;

    Widget buildButtonContent() {
      if (load ?? false) {
        return const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        );
      }

      return Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            SizedBox(width: padding ?? 8),
          ],
          childWidget(context) ?? const SizedBox(),
          if (suffixIcon != null) ...[
            SizedBox(width: padding ?? 8),
            suffixIcon!,
          ],
        ],
      );
    }

    return FocusableActionDetector(
      focusNode: focus,
      autofocus: false,
      enabled: !(load ?? false),
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
          if (!(load ?? false)) {
            onTap();
            if (nextFocus != null) {
              nextFocus!.requestFocus();
            }
          }
          return null;
        }),
      },
      onShowFocusHighlight: (focused) {
        // This will rebuild when focus changes
      },
      child: Builder(builder: (context) {
        final bool isFocused = Focus.of(context).hasFocus;
        return SizedBox(
          height: height ?? b1,
          width: width,
          child: OutlinedButton(
            style: ButtonStyle(
              side: WidgetStateProperty.all(BorderSide(
                  color: isFocused ? primaryColor : (borderColor ?? borderColorShade),
                  width: isFocused ? (borderThickness ?? borderWidth) + 1 : borderThickness ?? borderWidth,
                  style: (border ?? true) ? borderStyle : BorderStyle.none)),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered) || isFocused) {
                    return hoveredColor ?? primaryColor.withOpacity(0.1);
                  }
                  return primaryColor;
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered) || isFocused) {
                    return hoveredTextColor ?? primaryColor;
                  }
                  return Colors.white;
                },
              ),
              elevation: WidgetStateProperty.resolveWith<double?>(
                (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered) || isFocused) {
                    return hoverElevation ?? 2.0;
                  }
                  return 0.0;
                },
              ),
              shape: WidgetStateProperty.resolveWith<RoundedRectangleBorder>(
                (Set<WidgetState> states) {
                  return RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(defaultRadius),
                  );
                },
              ),
            ),
            onPressed: (load ?? false)
                ? null
                : () {
                    onTap();
                    if (nextFocus != null) {
                      nextFocus!.requestFocus();
                    }
                  },
            child: buildButtonContent(),
          ),
        );
      }),
    );
  }
}

class ButtonMadx extends StatelessWidget {
  final Style? style;
  final bool? outlinedButton;
  final bool? textButton;
  final bool? loading;
  final Function onTap;
  final String? lable;
  const ButtonMadx({
    super.key,
    this.style,
    this.outlinedButton = false,
    this.textButton = false,
    this.loading = false,
    this.lable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).colorScheme.primary;
    var secondaryColor = Theme.of(context).colorScheme.secondary;
    var textSize = Theme.of(context).primaryTextTheme.bodyLarge?.fontSize;
    var textWeight = Theme.of(context).primaryTextTheme.bodyLarge?.fontWeight;
    var primaryTextColor = Theme.of(context).colorScheme.onPrimary;
    var secondaryTextColor = Theme.of(context).colorScheme.onSecondary;

    Style widgetStyle = Style.combine([
      Style(
          $box.height(50),
          $box.width(200),
          $box.color(outlinedButton! ? Colors.white : primaryColor),
          $box.border.color(outlinedButton! ? primaryColor : Colors.white),
          $box.border.width(outlinedButton! ? 2 : 0),
          $box.alignment.center(),
          $box.borderRadius.all(10),
          $box.elevation(3),
          $text.style.fontSize(textSize ?? 5),
          $text.style.fontWeight(textWeight!),
          $text.style.color(primaryTextColor), $on.hover.event((event) {
        if (event == null || (event.position.x == 0 && event.position.y == 0) || loading!) return const Style.empty();
        return Style(
          $box.color(secondaryColor),
          $text.style.color(secondaryTextColor),
          $box.elevation(12),
        );
      })),
      if (!loading!) ...[
        Style(
          $on.press(
            $with.scale(0.95), // Scale down slightly on press
            $box.color(secondaryColor),
          ),
        )
      ]
    ]);

    Style styleApply = widgetStyle.merge(style ?? const Style.empty());

    return PressableBox(
        style: styleApply.animate(),
        onPress: loading! ? null : () => onTap(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lable != null && !loading!) ...[
              StyledText(
                lable!,
              ),
            ],
            if (loading!) ...const [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: FittedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              )
            ]
          ],
        ));
  }
}
