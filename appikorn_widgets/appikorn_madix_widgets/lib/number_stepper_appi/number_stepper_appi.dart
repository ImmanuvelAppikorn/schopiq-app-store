library number_stepper_appi;

import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/utils/global_size.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class NumberStepperAppi extends StatelessWidget {
  const NumberStepperAppi({Key? key, required this.len, required this.currentPosition, required this.radius}) : super(key: key);

  final int len;
  final int currentPosition;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var k = 0; k < len; k++)
          Row(
            children: [
              Container(
                width: radius * 2,
                height: radius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPosition > k ? Theme.of(context).primaryColor.withOpacity(0.5) : Colors.transparent,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: Center(
                  child: TextAppi(
                    text: (k + 1).toString(),
                    textStyle: Style($text.style.fontSize(f1)),
                  ),
                ),
              ),
              if (k < len - 1)
                SizedBox(
                  width: 30,
                  child: Divider(
                    thickness: 2,
                    color: currentPosition > k + 1 ? Theme.of(context).primaryColor : Colors.grey.withOpacity(0.4),
                  ),
                )
            ],
          )
      ],
    );
  }
}
