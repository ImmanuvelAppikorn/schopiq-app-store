import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'madix_global.dart';

String currentLang = 'en';

String? mobile_validator(String? s) {
  if ((s ?? "").isEmpty) {
    return currentLang == 'ar' ? 'يرجى إدخال رقم الجوال' : 'Please enter your mobile number';
  }
  return null;
}

String? email_validator(String? s) {
  if ((s ?? "").isEmpty) {
    return currentLang == 'ar' ? 'يرجى إدخال بريدك الإلكتروني' : 'Please enter your email';
  }

  if((s?.length ??0) > 80) {
    return currentLang == 'ar' ? 'الحد الأقصى المسموح به هو 80 حرفًا' : 'Max. 80 characters allowed';
  }

  // Updated email validation pattern that allows dots in the username part
  // and common special characters used in email addresses
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  if (!emailRegex.hasMatch(s ?? "")) {
    return currentLang == 'ar' ? 'الرجاء إدخال عنوان بريد إلكتروني صالح'  : 'Please enter a valid email address';
  }

  // Additional check for domain parts
  final parts = s!.split('@');
  final domainParts = parts[1].split('.');

  // Check domain parts have valid characters
  for (int i = 0; i < domainParts.length; i++) {
    // Domain parts should not be empty
    if (domainParts[i].isEmpty) {
      return currentLang == 'ar' ? 'الرجاء إدخال عنوان بريد إلكتروني صالح' : 'Please enter a valid email address';
    }

    // For the last part (TLD), only allow letters
    if (i == domainParts.length - 1) {
      if (!RegExp(r'^[a-zA-Z]{2,}$').hasMatch(domainParts[i])) {
        return currentLang == 'ar' ? 'يجب أن يحتوي النطاق الأعلى على أحرف فقط (حرفان أو أكثر)' : 'Top-level domain must contain only letters (2 or more)';
      }
    }
    // For other domain parts, allow letters, numbers, and hyphens
    else if (!RegExp(r'^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$').hasMatch(domainParts[i])) {
      return currentLang == 'ar' ? 'يمكن أن تحتوي أجزاء النطاق على أحرف وأرقام وشرطات فقط' : 'Domain parts can only contain letters, numbers, and hyphens';
    }
  }

  return null;
}

String? name_validator(String? s, String? lable) {
  if(s == null ) {
    return null;
  }

  if (s.trim().isEmpty) {
    return currentLang == "ar" ? " لا يمكن أن يكون فارغًا$lable" : "$lable can't be empty"; // Company Name/ Full Name / Insured Name/ Sponsor Name
  }

  if(s.length >= 101) {
    return currentLang == 'ar' ? 'الحد الأقصى المسموح به هو 100 حرف' : "Max. 100 characters allowed";
  }

  return null;
}


String? empty_validator(String? s, lable) {
  // print(lable);
  // print(currentLang);
  // print("333333333");
  if (s == null || s.isEmpty || s.trim().isEmpty) {
    // print("in $lable");
    return currentLang == "ar" ? " لا يمكن أن يكون فارغًا$lable" : "$lable can't be empty";
  }

  return null;
}

status_color({required String dat}) {
  if (dat.toLowerCase().contains("expired")) {
    return const Color(0xffF35E5E);
  } else if (dat.toLowerCase().contains("active")) {
    return const Color(0xff71AE62);
  } else if (dat.toLowerCase().contains("intimated")) {
    return const Color(0xff5E5E5E);
  } else if (dat.toLowerCase().contains("settled")) {
    return const Color(0xff71AE62);
  } else if (dat.toLowerCase().contains("partially approved ")) {
    return const Color(0xff71AE62);
  } else if (dat.toLowerCase().contains("registered")) {
    return const Color(0xff5E5E5E);
  } else {
    return Colors.red;
  }
}

validate_date({dat, major, minor, required content}) {
  print("validating age $dat");
  var symbol = MadixGlobal().dateFormat.contains("/") ? "/" : "-";
  if (dat == "") {
    return "$content can't be empty";
  } else if (dat.toString().replaceAll(symbol, "").trim().length < 8) {
    return "$content can't be empty";
  } else {
    if (major ?? false) {
      DateTime date = DateFormat(MadixGlobal().dateFormat).parse(dat);
      Duration difference = DateTime.now().difference(date);
      int years = (difference.inDays / 365).floor();
      if (years < 18) {
        return "$content Age can't less than 18";
      } else {
        return "";
      }
    }
    if (major ?? false) {
      DateTime date = DateFormat(MadixGlobal().dateFormat).parse(dat);
      Duration difference = DateTime.now().difference(date);
      int years = (difference.inDays / 365).floor();
      if (years > 65) {
        return "$content Age can't more than 65";
      } else {
        return "";
      }
    }
    if (minor ?? false) {
      DateTime date = DateFormat(MadixGlobal().dateFormat).parse(dat);
      Duration difference = DateTime.now().difference(date);
      int years = (difference.inDays / 365).floor();
      if (years > 17) {
        return "$content Age can't greater than 17";
      } else {
        return "";
      }
    }
    return "";
  }
}
