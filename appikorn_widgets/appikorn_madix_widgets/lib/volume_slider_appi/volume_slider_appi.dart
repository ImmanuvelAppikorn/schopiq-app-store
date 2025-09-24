library volume_slider_appi;

import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class VolumeSliderAppi extends StatefulWidget {
  const VolumeSliderAppi({
    Key? key,
    required this.min,
    required this.max,
    required this.current_position,
    this.onchanged,
  }) : super(key: key);

  final double min;
  final double max;
  final double current_position;
  final Function(double)? onchanged;

  @override
  State<VolumeSliderAppi> createState() => _VolumeSliderAppiState();
}

class _VolumeSliderAppiState extends State<VolumeSliderAppi> {
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    _value = widget.current_position;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
          child: SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Theme.of(context).primaryColor,
              trackHeight: 1.0,
              thumbColor: Colors.red,
              thumbShape: _CustomSliderThumbShape(),
              trackShape: RoundedSliderTrackShape(),
            ),
            child: Slider(
              value: _value,
              min: widget.min,
              max: widget.max,
              onChanged: (newValue) {
                setState(() {
                  _value = newValue;
                  if (widget.onchanged != null) {
                    widget.onchanged!(newValue);
                  }
                });
              },
              activeColor: Colors.blue,
              inactiveColor: Colors.grey,
              divisions: 100,
              label: _value.round().toString(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextAppi(
              text: widget.min.round().toString(),
              textStyle: Style($text.style.fontSize(f0)),
            ),
            TextAppi(
              text: widget.max.round().toString(),
              textStyle: Style($text.style.fontSize(f0)),
            )
          ],
        )
      ],
    );
  }
}

class RoundedSliderTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight!;
    final double trackLeft = offset.dx + 10;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2.0;
    final double trackWidth = parentBox.size.width - 2 * 10;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class _CustomSliderThumbShape extends SliderComponentShape {
  static const double _thumbSize = 16.0;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(_thumbSize, _thumbSize);
  }

  @override
  void paint(
    PaintingContext context,
    Offset thumbCenter, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    const double radius = _thumbSize / 2;

    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(thumbCenter, radius, paint);
  }
}
