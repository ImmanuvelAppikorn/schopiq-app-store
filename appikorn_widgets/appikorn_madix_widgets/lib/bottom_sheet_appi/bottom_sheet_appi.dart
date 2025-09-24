library bottom_sheet_appi;

import 'dart:ui';

import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/circle_loader_appi/circle_loader_appi.dart';
import 'package:flutter/material.dart';

import '../../utils/global_size.dart';

void bottomSheetAppi({title, required double height, titleColor, required Widget child, required load, popup, required context}) {
  Widget bodyWidget() {
    return Material(
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: (s2 - 6),
            ),
            const SizedBox(
              height: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    child: Divider(
                      thickness: 3,
                      color: Colors.black26,
                    ),
                  )
                ],
              ),
            ),
            child,
          ],
        ));
  }

  Widget dat() {
    return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Stack(
          children: [
            Positioned.fill(
              child: RepaintBoundary(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 3), // Adjust the sigma values as per your preference
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            load.value
                ? const Center(child: CircleLoaderAppi(size: 30))
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                          height: height,
                          width: double.infinity,
                          child: BoxAppi(
                              borderThickness: 0, fillColor: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)), child: bodyWidget()))
                    ],
                  )
          ],
        ));
  }

  if (popup ?? false) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(child: SizedBox(width: 370, height: 350, child: BoxAppi(fillColor: Colors.white, radius: 15, child: bodyWidget())));
        });
  } else {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return dat();
        });
  }
}
