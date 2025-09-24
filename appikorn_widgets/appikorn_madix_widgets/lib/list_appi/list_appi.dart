library list_appi;

import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../utils/global_size.dart';

class ListAppi extends StatelessWidget {
  const ListAppi({super.key, required this.child, required this.count, this.controller, this.reversed, this.shrink, this.physics, this.primary, this.padding, this.horizondal, this.defaultText});

  final child;
  final int count;
  final ScrollController? controller;
  final bool? reversed;
  final bool? primary;
  final bool? horizondal;
  final bool? shrink;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final String? defaultText;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Calculate the maximum height based on the available height
        final double maxHeight = constraints.maxHeight;

        // Calculate the total height needed by the children
        final double totalHeight = count * kMinInteractiveDimension;

        // Use the minimum value between the maxHeight and totalHeight
        final double scrollViewHeight = totalHeight > maxHeight ? maxHeight : totalHeight;

        return count == 0
            ? Center(
                child: TextAppi(
                text: defaultText ?? "Empty",
                textStyle: Style($text.style.fontSize(f1)),
              ))
            : MouseRegion(
                onEnter: (_) {},
                onExit: (_) {
                  // print("exit");
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: CustomScrollView(
                    primary: primary,
                    physics: physics,
                    controller: controller,
                    reverse: reversed ?? false,
                    shrinkWrap: shrink ?? false,
                    scrollDirection: (horizondal == null || horizondal == false) ? Axis.vertical : Axis.horizontal,
                    slivers: [
                      SliverPadding(
                        padding: padding ?? EdgeInsets.zero,
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, position) => Container(
                              child: child(index: position),
                            ),
                            childCount: count,
                          ),
                        ),
                      ),
                      if (scrollViewHeight < maxHeight)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Container(),
                        ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
