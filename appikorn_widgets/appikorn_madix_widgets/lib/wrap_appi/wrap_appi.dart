library wrap_appi;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WrapAppi extends StatelessWidget {
  const WrapAppi({Key? key, required this.children, this.alignment, this.spacing, this.runSpacing, required this.controller}) : super(key: key);

  final List<Widget> children;
  final WrapAlignment? alignment;
  final double? spacing;
  final double? runSpacing;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Wrap(
                alignment: alignment ?? WrapAlignment.start,
                spacing: spacing ?? 0.0, // space between the widgets
                runSpacing: runSpacing ?? 0.0,
                children: children),
          ]),
        ),
      ],
    );
  }
}

//Selvam@gmail.com
