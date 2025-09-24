// library input_chip_appi;
//
// import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
// import 'package:appikorn_madix_widgets/utils/global_validations.dart';
// import 'package:flutter/material.dart';
//
// import '../searchable_text_field_appi/searchable_text_field_appi.dart';
// import '../utils/mode/text_field_params_appi.dart';
//
// class InputChipAppi extends StatefulWidget {
//   final void Function(List<String>) onChanged;
//   final List<String> list;
//   final List<String>? dropdownList;
//   // Text field params
//   final TextFieldParamsAppi textFieldStyle;
//
//   const InputChipAppi({
//     super.key,
//     required this.list,
//     this.dropdownList,
//     required this.textFieldStyle,
//     required this.onChanged,
//   });
//
//   @override
//   State<InputChipAppi> createState() => _InputChipAppiState();
// }
//
// class _InputChipAppiState extends State<InputChipAppi> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   addToList(dat) {
//     if (!widget.list.contains(dat)) {
//       widget.list.add(dat ?? "");
//       widget.onChanged(widget.list);
//     }
//   }
//
//   String? switchValidator(String? s) {
//     if (widget.textFieldStyle.validator != null) {
//       var res = widget.textFieldStyle.validator!(s);
//       return res;
//     } else {
//       if (widget.textFieldStyle.mandatory ?? false) {
//         var res = empty_validator(s, widget.textFieldStyle.lable ?? "");
//         return res;
//       }
//     }
//     return null;
//   }
//
//   Widget textTield({textFieldStyle}) {
//     final updatedTextFieldStyle = textFieldStyle.copyWith(
//       validator: switchValidator,
//       onSaved: (s) {
//         setState(() {
//           if (s == "") {
//             return;
//           }
//           addToList(s);
//         });
//       },
//     );
//     return TextFieldAppi.fromParams(updatedTextFieldStyle);
//   }
//
//   Widget dropdownField({textFieldStyle}) {
//     final updatedTextFieldStyle = textFieldStyle.copyWith(
//       validator: switchValidator,
//     );
//     return SearchableTextFieldAppi(
//       list: widget.dropdownList ?? [],
//       context: context,
//       onChanged: (s) {
//         setState(() {
//           if (s == "") {
//             return;
//           }
//           addToList(s);
//         });
//       },
//       textFieldStyle: updatedTextFieldStyle,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         widget.dropdownList == null ? textTield() : dropdownField(),
//         const SizedBox(
//           height: 5,
//         ),
//         ExcludeFocusTraversal(
//           child: Wrap(
//             alignment: WrapAlignment.start,
//             crossAxisAlignment: WrapCrossAlignment.start,
//             runAlignment: WrapAlignment.start,
//             runSpacing: 3,
//             spacing: 3,
//             children: [
//               for (var k in widget.list)
//                 InputChip(
//                   side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
//                   padding: const EdgeInsets.all(2),
//                   avatar: k != ""
//                       ? Padding(
//                           padding: const EdgeInsets.all(2.0),
//                           child: CircleAvatar(
//                             child: Text((k)[0]),
//                           ),
//                         )
//                       : null,
//                   onDeleted: () {
//                     setState(() {
//                       widget.onChanged(widget.list);
//                       widget.list.remove(k);
//                     });
//                   },
//                   deleteIcon: const Icon(
//                     Icons.cancel,
//                     color: Colors.red,
//                   ),
//                   label: Text(k),
//                 )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
