library radio_button_appi;

import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../utils/global_size.dart';

/// A customizable radio button widget.
///
/// The [radioSize] property controls the overall size of the radio button.
class RadioButtonAppi extends StatefulWidget {
  const RadioButtonAppi({
    Key? key,
    required this.onchange,
    required this.lst,
    this.heading,
    this.mandatory,
    this.headingTextStyle,
    this.selected,
    this.radioActiveColor,
    this.innerDotColor,
    this.innerDotGradient,
    this.outerCircleGradient,
    this.outerCircleThickness,
    this.radioFillColor,
    this.radioShape,
    this.radioSize,
    this.optionTextStyle,
    this.spacing = 16.0,
    this.direction = Axis.horizontal,
    this.wrap = false,
    this.optionPadding,
  }) : super(key: key);

  final Function(String) onchange;
  final List<String> lst;
  final String? heading;
  final bool? mandatory;
  final Style? headingTextStyle;
  final String? selected;

  final Color? radioActiveColor;
  final Color? innerDotColor;
  final Gradient? innerDotGradient;
  final Gradient? outerCircleGradient;
  final double? outerCircleThickness;
  final MaterialStateProperty<Color?>? radioFillColor;
  final OutlinedBorder? radioShape;
  final double? radioSize;
  final Style? optionTextStyle;
  final double spacing;
  final Axis direction;
  final bool wrap;
  final EdgeInsetsGeometry? optionPadding;

  @override
  State<RadioButtonAppi> createState() => _RadioButtonAppiState();
}

class _RadioButtonAppiState extends State<RadioButtonAppi> {
  String _selectedOption = "";

  @override
  void initState() {
    _selectedOption = widget.selected ?? "";
    super.initState();
  }

  Widget _buildRadioOption(String k) {
    final bool isSelected = _selectedOption == k;
    final double baseSize = 48.0 * (widget.radioSize ?? 1.0); // outer circle diameter
    final double borderWidth = (widget.outerCircleThickness ?? 5.0) * (widget.radioSize ?? 1.0); // thicker border
    final double whiteGap = baseSize * 0.18; // white gap between border and dot
    final double innerDotSize = baseSize * 0.46; // larger inner dot
    return Padding(
      padding: widget.optionPadding ?? const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              widget.onchange(k);
              setState(() {
                _selectedOption = k;
              });
            },
            child: SizedBox(
              width: baseSize,
              height: baseSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Gradient border for outer circle
                  if (widget.outerCircleGradient != null)
                    CustomPaint(
                      size: Size(baseSize, baseSize),
                      painter: _GradientCirclePainter(
                        gradient: widget.outerCircleGradient!,
                        strokeWidth: borderWidth,
                      ),
                    ),
                  if (widget.outerCircleGradient == null)
                    Container(
                      width: baseSize,
                      height: baseSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: borderWidth,
                        ),
                      ),
                    ),
                  // White center (gap) for both selected and unselected
                  Container(
                    width: baseSize - borderWidth * 2,
                    height: baseSize - borderWidth * 2,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  // Gradient inner dot for selected only
                  if (isSelected)
                    Container(
                      width: innerDotSize,
                      height: innerDotSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: widget.innerDotGradient,
                        color: widget.innerDotGradient == null ? widget.innerDotColor ?? widget.radioActiveColor : null,
                      ),
                    ),
                  // Transparent Radio for hit area and accessibility
                  Opacity(
                    opacity: 0.01, // keep for tap and accessibility
                    child: Radio<String>(
                      value: k,
                      groupValue: _selectedOption,
                      activeColor: Colors.transparent,
                      fillColor: widget.radioFillColor,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        if (value != null) {
                          widget.onchange(value);
                          setState(() {
                            _selectedOption = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          TextAppi(
            text: k,
            textStyle: (widget.optionTextStyle ?? Style($text.style.fontSize(f1))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.lst.map((k) => _buildRadioOption(k)).toList();

    Widget optionsWidget;
    if (widget.wrap) {
      optionsWidget = Wrap(
        direction: widget.direction,
        spacing: widget.spacing,
        children: children,
      );
    } else {
      optionsWidget = Flex(
        direction: widget.direction,
        children: children
            .expand((child) => [child, SizedBox(width: widget.direction == Axis.horizontal ? widget.spacing : 0, height: widget.direction == Axis.vertical ? widget.spacing : 0)])
            .toList()
            .sublist(0, children.length * 2 - 1),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.heading != null && widget.heading!.isNotEmpty)
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextAppi(
                      mandatory: widget.mandatory ?? false,
                      text: widget.heading!,
                      textStyle: Style.combine([
                        Style(
                          $text.style.fontWeight(w400),
                          $text.maxLines(10),
                          $text.style.fontSize(f1),
                        ),
                      ]).merge(widget.headingTextStyle ?? const Style.empty())),
                ),
              ),
            ],
          ),
        SizedBox(height: 5),
        optionsWidget,
      ],
    );
  }
}

// Custom painter for gradient border
class _GradientCirclePainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  _GradientCirclePainter({required this.gradient, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(size.center(Offset.zero), (size.width - strokeWidth) / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
