library quill_input_pop_appi;

import 'dart:convert';

import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:flutter/material.dart';

import '../quill_editor_appi/quill_editor_appi.dart';
import '../utils/mode/text_field_params_appi.dart';

class QuillInputPopAppi extends StatelessWidget {
  final String? quillTitle;
  final void Function(String?)? onChanged;
  final Map<String, dynamic>? prefillJson;
  final String? prefillString;

  final OutputType outputType; // Use the enum as a parameter

  // Text field params
  final TextFieldParamsAppi textFieldStyle;

  const QuillInputPopAppi({
    super.key,
    required this.onChanged,
    this.quillTitle,
    required this.outputType,
    this.prefillJson,
    this.prefillString,
    required this.textFieldStyle,
  });

  Widget body(context, updatedTextFieldStyle, localDat) {
    return RepaintBoundary(
      child: Material(child: TextFieldAppi.fromParams(updatedTextFieldStyle)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var localDat = "";
    String? switchValidator(String? s) {
      if (textFieldStyle.mandatory ?? false) {
        try {
          if (outputType == OutputType.text) {
            if (localDat.isEmpty) {
              return "${textFieldStyle.lable} can't be empty";
            }
          } else {
            var parsedOutput = json.decode(localDat);
            if (parsedOutput.containsKey("ops") &&
                parsedOutput["ops"] is List &&
                parsedOutput["ops"].isNotEmpty &&
                parsedOutput["ops"][0] is Map &&
                parsedOutput["ops"][0].containsKey("insert") &&
                parsedOutput["ops"][0]["insert"] == "\n") {
              return "${textFieldStyle.lable} can't be empty";
            }
          }
        } catch (e) {
          return "${textFieldStyle.lable} can't be empty";
        }
      }
      return null;
    }

    final updatedTextFieldStyle = textFieldStyle.copyWith(
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(quillTitle ?? "Title"),
                content: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: BoxAppi(
                    borderColor: Theme.of(context).primaryColor,
                    borderThickness: 1,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1,
                      child: QuillEditorAppi(
                        onChanged: (s) {
                          localDat = s.toString();
                          if (onChanged != null) {
                            onChanged!(s);
                          }
                          final FormFieldState<String>? firstTextFieldState = textFieldStyle.widgetKey.currentState;
                          firstTextFieldState?.validate();
                        },
                        prefillJson: prefillJson,
                        prefillString: prefillString,
                        outputType: outputType,
                      ),
                    ),
                  ),
                ),
                actions: <Widget>[
                  FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: const Icon(Icons.save),
                  ),
                ],
              );
            },
          );
        },
        validator: switchValidator);
    return (updatedTextFieldStyle.noFocus ?? false) ? ExcludeFocusTraversal(child: body(context, updatedTextFieldStyle, localDat)) : body(context, updatedTextFieldStyle, localDat);
  }
}
