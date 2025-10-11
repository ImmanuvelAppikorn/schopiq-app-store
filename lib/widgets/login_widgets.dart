import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/login_provider.dart';

class LoginEmailWdg extends ConsumerWidget {
  const LoginEmailWdg({super.key});

  static final GlobalKey<FormFieldState<String>> emailKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFieldAppi(
      widgetKey: emailKey,
      hint: "Enter Email",
      headingPaddingDown: 5,
      heading: "Email",
      mandatory: true,
      email: true,
      initialValue: ref.watch(emailProvider),
      validator: (s) {
        if ((s ?? '').isEmpty) {
          return "Email can't be empty";
        }
        return null;
      },
      height: 30,
      maxLines: 1,
      onSaved: (val) => ref.read(emailProvider.notifier).state = val ?? "",
    );
  }
}

class LoginPasswordWdg extends ConsumerWidget {
  const LoginPasswordWdg({super.key});

  static final GlobalKey<FormFieldState<String>> passwordKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextFieldAppi(
      widgetKey: passwordKey,
      hint: "Enter Password",
      heading: "Password",
      mandatory: true,
      headingPaddingDown: 5,
      initialValue: ref.watch(passwordProvider),
      height: 30,
      password: true,
      maxLines: 1,
      validator: (s) {
        if ((s ?? '').isEmpty) {
          return "Password can't be empty";
        }
        return null;
      },
      onChanged: (val) => ref.read(passwordProvider.notifier).state = val ?? "",
    );
  }
}

// class LoginOrganizationNameWdg extends ConsumerWidget {
//   const LoginOrganizationNameWdg({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Column(
//       spacing: 5,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextAppi(
//           text: "Organization Name",
//           mandatory: true,
//           textStyle:
//               Style($text.style.fontSize(13), $text.style.fontWeight(FontWeight.w500), $text.color(Colors.black)),
//         ),
//         DropDownFieldAppi(
//             items: ["Schopiq(Admin)", "Appikorn", "Anoud", "Fresh&Honest"],
//             textFieldStyle: TextFieldParamsAppi(
//                 widgetKey: GlobalKey<FormFieldState<String>>(),
//                 hint: "Select Organization Name",
//                 heading: "Organization Name",
//                 initialValue: ref.read(organisationNameProvider),
//                 mandatory: true,
//                 headingPaddingDown: 5),
//             onChanged: (val) {
//               ref.read(organisationNameProvider.notifier).state = val ?? "";
//
//               // ✅ Prefill Password
//               if (val == "Schopiq(Admin)") {
//                 ref.read(passwordProvider.notifier).state = "2222";
//                 ref.read(emailProvider.notifier).state = "a@gmail.com";
//               } else {
//                 ref.read(passwordProvider.notifier).state = "1111";
//                 ref.read(emailProvider.notifier).state = "a@gmail.com";
//               }
//             }),
//       ],
//     );
//   }
// }
