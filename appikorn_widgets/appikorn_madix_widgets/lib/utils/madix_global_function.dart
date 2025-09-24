import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'madix_global.dart';

class MadixGlobalFunction {
  calculateDateFromString({dat, datetime}) {
    print("asiehflb $dat");
    if (dat != null || dat != "") {
      var d1 = DateFormat(MadixGlobal().dateFormat).parse(dat);

      var d2 = DateFormat(MadixGlobal().dateFormat).format(d1);

      if (datetime != null && datetime) {
        return d1;
      } else {
        return d2;
      }
    } else {
      return "";
    }
  }

  calculateTimeFromTimeOfDay({required TimeOfDay dat}) {
    var d1 = dat;

    var d2 = "${dat.hour}:${dat.minute}";

    return d2;
  }

  calculateDateFromDate({dat}) {
    if (dat != null) {
      var d1 = dat;

      var d2 = DateFormat(MadixGlobal().dateFormat).format(d1);

      return d2;
    } else {
      return "";
    }
  }

  snakbar({type, msg, short}) {
    switch (type) {
      case "SUCCESS":
        // Get.snackbar(
        //   "SUCCESS",
        //   msg,
        //   icon: Padding(
        //     padding: const EdgeInsets.only(right: 30.0),
        //     child: Container(
        //         height: 80,
        //         width: 2,
        //         decoration: const BoxDecoration(
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(3),
        //             ),
        //             color: Colors.orangeAccent)),
        //   ),
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.green,
        //   borderRadius: 10,
        //   margin: const EdgeInsets.all(15),
        //   colorText: Colors.white,
        //   duration: const Duration(seconds: 3),
        //   isDismissible: true,
        //   forwardAnimationCurve: Curves.bounceIn,
        // );
        break;

      case "ERROR":
        // Get.snackbar(
        //   "Error",
        //   msg.toString(),
        //   maxWidth: 400,
        //   icon: Padding(
        //     padding: const EdgeInsets.only(right: 30.0),
        //     child: Container(
        //         height: 80,
        //         width: 2,
        //         decoration: const BoxDecoration(
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(3),
        //             ),
        //             color: Colors.orangeAccent)),
        //   ),
        //   snackPosition: SnackPosition.BOTTOM,
        //   borderRadius: 10,
        //   margin: const EdgeInsets.all(15),
        //   colorText: Colors.white,
        //   duration: const Duration(seconds: 3),
        //   isDismissible: true,
        //   forwardAnimationCurve: Curves.bounceIn,
        // );
        break;
    }
  }

  String? calculateDateToString({
    required DateTime? date,
  }) {
    if (date == null) {
      return null; // Return null if no date is provided
    }

    try {
      // Use the provided format or default
      return DateFormat(MadixGlobal().dateFormat).format(date);
    } catch (e) {
      print("Error formatting date: $e");
      return null;
    }
  }
}
