import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../text_field_appi/text_field_appi.dart';

class TextFieldParamsAppi {
  final int? maxLines;
  final int? maxLength;
  final TextStyle? textStyle;
  final String? lable;
  final String? initialValue;
  final String? hint;
  final Color? fillColor;
  final bool? allCaps;
  final bool? noSpace;
  final bool? counter;
  final TextInputType? keyboardType;
  final TextInputAction? inputAction;
  final String? regx;
  final Function(String?)? onChanged;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final Function(String)? onCompleted;
  final Widget? suffixIcon;
  final Widget? preffixxicon;
  final bool? readOnly;
  final bool? noFocus;
  final bool? mandatory;
  final EdgeInsetsGeometry? contentPadding;
  final String? errorText;
  final String? heading;
  final MainAxisAlignment? headingAlignment;
  final double? headingPaddingDown;
  final Style? headingTextStyle;
  final double? height;
  final bool? autofocus;
  final bool? currency;
  final bool? mobile;
  final bool? email;
  final bool? password;
  final FocusNode? focus;
  final TextEditingController? troller;
  final String? Function(String?)? validator;
  final GlobalKey<FormFieldState<String>> widgetKey;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focussedBorder;
  final OutlineInputBorder? errorBorder;
  final FocusNode? nextFocus;
  final bool? shiftNewLine;
  final TextStyle? hintTextStyle;
  final TextStyle? floatingLabelStyle;
  final String? countryCode;
  final CurrencyCode? currencyCode;
  final String? helpText;

  const TextFieldParamsAppi({
    this.maxLines,
    this.maxLength,
    this.textStyle,
    this.lable,
    this.initialValue,
    this.hint,
    this.fillColor,
    this.allCaps,
    this.noSpace,
    this.counter,
    this.keyboardType,
    this.inputAction,
    this.regx,
    this.onChanged,
    this.onTap,
    this.onSaved,
    this.onCompleted,
    this.suffixIcon,
    this.preffixxicon,
    this.readOnly,
    this.noFocus,
    this.mandatory,
    this.contentPadding,
    this.errorText,
    this.heading,
    this.headingAlignment,
    this.headingPaddingDown,
    this.headingTextStyle,
    this.height,
    this.autofocus,
    this.currency,
    this.mobile,
    this.email,
    this.password,
    this.focus,
    this.troller,
    this.validator,
    required this.widgetKey,
    this.border,
    this.focussedBorder,
    this.errorBorder,
    this.nextFocus,
    this.shiftNewLine,
    this.hintTextStyle,
    this.floatingLabelStyle,
    this.countryCode,
    this.currencyCode,
    this.helpText,
  });

  // Method to create a copy of the instance with updated fields
  TextFieldParamsAppi copyWith({
    int? maxLines,
    int? maxLength,
    TextStyle? textStyle,
    String? lable,
    String? initialValue,
    String? hint,
    Color? fillColor,
    bool? allCaps,
    bool? noSpace,
    bool? counter,
    TextInputType? keyboardType,
    TextInputAction? inputAction,
    String? regx,
    Function(String?)? onChanged,
    Function()? onTap,
    Function(String?)? onSaved,
    Function(String)? onCompleted,
    Widget? suffixIcon,
    Widget? preffixxicon,
    bool? readOnly,
    bool? noFocus,
    bool? mandatory,
    EdgeInsetsGeometry? contentPadding,
    String? errorText,
    String? heading,
    MainAxisAlignment? headingAlignment,
    double? headingPaddingDown,
    Style? headingTextStyle,
    double? height,
    bool? autofocus,
    bool? currency,
    bool? mobile,
    bool? email,
    bool? password,
    FocusNode? focus,
    TextEditingController? troller,
    String? Function(String?)? validator,
    GlobalKey<FormFieldState<String>>? widgetKey,
    OutlineInputBorder? border,
    OutlineInputBorder? focussedBorder,
    OutlineInputBorder? errorBorder,
    FocusNode? nextFocus,
    bool? shiftNewLine,
    TextStyle? hintTextStyle,
    TextStyle? floatingLabelStyle,
    String? countryCode,
    CurrencyCode? currencyCode,
    String? helpText,
  }) {
    return TextFieldParamsAppi(
      maxLines: maxLines ?? this.maxLines,
      maxLength: maxLength ?? this.maxLength,
      textStyle: textStyle ?? this.textStyle,
      lable: lable ?? this.lable,
      initialValue: initialValue ?? this.initialValue,
      hint: hint ?? this.hint,
      fillColor: fillColor ?? this.fillColor,
      allCaps: allCaps ?? this.allCaps,
      noSpace: noSpace ?? this.noSpace,
      counter: counter ?? this.counter,
      keyboardType: keyboardType ?? this.keyboardType,
      inputAction: inputAction ?? this.inputAction,
      regx: regx ?? this.regx,
      onChanged: onChanged ?? this.onChanged,
      onTap: onTap ?? this.onTap,
      onSaved: onSaved ?? this.onSaved,
      onCompleted: onCompleted ?? this.onCompleted,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      preffixxicon: preffixxicon ?? this.preffixxicon,
      readOnly: readOnly ?? this.readOnly,
      noFocus: noFocus ?? this.noFocus,
      mandatory: mandatory ?? this.mandatory,
      contentPadding: contentPadding ?? this.contentPadding,
      errorText: errorText ?? this.errorText,
      heading: heading ?? this.heading,
      headingAlignment: headingAlignment ?? this.headingAlignment,
      headingPaddingDown: headingPaddingDown ?? this.headingPaddingDown,
      headingTextStyle: headingTextStyle ?? this.headingTextStyle,
      height: height ?? this.height,
      autofocus: autofocus ?? this.autofocus,
      currency: currency ?? this.currency,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      password: password ?? this.password,
      focus: focus ?? this.focus,
      troller: troller ?? this.troller,
      validator: validator ?? this.validator,
      widgetKey: widgetKey ?? this.widgetKey,
      border: border ?? this.border,
      focussedBorder: focussedBorder ?? this.focussedBorder,
      errorBorder: errorBorder ?? this.errorBorder,
      nextFocus: nextFocus ?? this.nextFocus,
      shiftNewLine: shiftNewLine ?? this.shiftNewLine,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
      floatingLabelStyle: floatingLabelStyle ?? this.floatingLabelStyle,
      countryCode: countryCode ?? this.countryCode,
      currencyCode: currencyCode ?? this.currencyCode,
      helpText: helpText ?? this.helpText,
    );
  }
}
