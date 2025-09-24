library json_input_field_appi;

import 'dart:convert';

import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:flutter/material.dart';
import 'package:json_editor/json_editor.dart';

class JsonInputFieldAppi extends StatelessWidget {
  JsonInputFieldAppi(
      {super.key,
      this.mandatory,
      required this.widgetKey,
      required this.formKey,
      this.hint,
      this.lable,
      this.onChanged,
      this.initialValue,
      this.suffixIcon,
      this.preffixIcon,
      this.title,
      this.initialString,
      this.onChangedString,
      this.stringData,
      this.textStyle});

  final bool? mandatory;
  final GlobalKey<FormFieldState<String>> widgetKey;
  final GlobalKey<FormState> formKey;
  final String? hint;
  final String? title;
  final String? lable;
  final TextStyle? textStyle;
  final void Function(Map<String, dynamic>)? onChanged;
  final void Function(String)? onChangedString;
  final Map<String, dynamic>? initialValue;
  final String? initialString;
  final Widget? suffixIcon;
  final Widget? preffixIcon;
  final bool? stringData;

  final JsonEditorThemeData dartThemeData = JsonEditorThemeData(
    lightTheme: JsonTheme(
      defaultStyle: const TextStyle(
        color: Colors.yellow,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      // Default style
      bracketStyle: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.w600),
      // Bracket style
      numberStyle: const TextStyle(color: Colors.red),
      // Number style
      stringStyle: const TextStyle(color: Colors.orange),
      // String style
      boolStyle: const TextStyle(color: Colors.purple),
      // Boolean style
      keyStyle: const TextStyle(color: Colors.white),
      // Key style
      commentStyle: const TextStyle(color: Colors.grey),
      // Comment style
      errorStyle: const TextStyle(color: Colors.red), // Error style
    ),
  );

  @override
  Widget build(BuildContext context) {
    Map<dynamic, dynamic> localDat = {};
    showAlert({required context}) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title ?? "Title"),
            content: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: BoxAppi(
                radius: 10,
                borderColor: Theme.of(context).primaryColor,
                fillColor: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: JsonEditorTheme(
                        themeData: dartThemeData,
                        child: (stringData ?? false)
                            ? TextField(
                                onChanged: (s) {
                                  if (onChangedString != null) {
                                    onChangedString!(s);
                                  }
                                },
                                controller: TextEditingController(text: initialString ?? ""),
                                style: const TextStyle(
                                  color: Colors.yellow, // Text color to match screenshot
                                  fontFamily: 'monospace', // Optional: makes it look like code editor
                                ),
                                maxLines: null, // Allows infinite lines
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  hintText: "Start typing...",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none, // Removes default border
                                ),
                                cursorColor: Colors.yellow, // Matching cursor color
                              )
                            : JsonEditor.object(
                                object: initialValue ?? {},
                                onValueChanged: (value) {
                                  // print("onchanged $value");
                                  try {
                                    if (value.toString() == "{}") {
                                      localDat = {};
                                      if (onChanged != null) {
                                        onChanged!({});
                                      }
                                    } else {
                                      final res = json.decode(json.encode(value.toObject()));
                                      localDat = res;
                                      if (onChanged != null) {
                                        onChanged!(res);
                                      }
                                      Future.delayed(const Duration(milliseconds: 300), () {
                                        final FormFieldState<String>? firstTextFieldState = widgetKey.currentState;
                                        firstTextFieldState?.validate();
                                      });
                                    }
                                  } catch (e) {
                                    final FormFieldState<String>? firstTextFieldState = widgetKey.currentState;
                                    firstTextFieldState?.validate();
                                  }
                                },
                              ),
                      )),
                ),
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }

    String? validator(String? s) {
      if (mandatory ?? false) {
        if (localDat.toString() == "{}" && (initialValue == null || initialValue.toString() == "{}")) {
          return "$lable can't be empty";
        }
      } else {
        return null;
      }
      return null;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: TextFieldAppi(
          textStyle: textStyle,
          troller: TextEditingController(text: (localDat.toString() == "{}" && (initialValue == null || initialValue.toString() == "{}")) ? "" : "Filled"),
          mandatory: true,
          suffixIcon: suffixIcon,
          preffixxicon: preffixIcon,
          widgetKey: widgetKey,
          validator: validator,
          hint: hint,
          lable: lable,
          onTap: () {
            showAlert(context: context);
          }),
    );
  }
}
