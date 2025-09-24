import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/date_picker_appi/date_picker_appi.dart';
import 'package:appikorn_madix_widgets/drop_down_field_appi/drop_down_field_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_madix_widgets/utils/mode/text_field_params_appi.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:appikorn_software/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  String? selectedUserType;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: mediaQuery(context, 740) ? EdgeInsets.all(10) : EdgeInsets.zero,
              child: BoxAppi(
                  radius: 20,
                  // border: Border.all(color: Colors.black),
                  shadowBlur: 22,
                  shadowOffset: Offset(0, 10),
                  shadowSpreadRadius: 0,
                  shadowColor: Color(0xff292D88).withOpacity(0.15),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    child: Column(
                      spacing: 15,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/png/appikorn-logo.png",
                              height: 60,
                              width: 60,
                            ),
                            TextAppi(
                              text: "Sign Up",
                              textStyle: Style(
                                $text.style.fontSize(30),
                                $text.style.fontWeight(FontWeight.w600),
                              ),
                            ),
                            TextAppi(
                              text: "Enter your details below to create your account and get started.",
                              textStyle: Style(
                                $text.style.fontSize(14),
                                $text.textAlign(mediaQuery(context, 600) ? TextAlign.start : TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: mediaQuery(context, 600) ? 0 : 10,
                        ),
                        mediaQuery(context, 600)
                            ? Column(
                                spacing: 10,
                                children: [
                                  TextFieldAppi(
                                    widgetKey: GlobalKey<FormFieldState<String>>(),
                                    hint: "Enter Full Name",
                                    headingPaddingDown: 5,
                                    heading: "Full Name",
                                    initialValue: "",
                                    height: 30,
                                  ),
                                  TextFieldAppi(
                                    widgetKey: GlobalKey<FormFieldState<String>>(),
                                    hint: "example@gmail.com",
                                    heading: "Email",
                                    headingPaddingDown: 5,
                                    initialValue: "",
                                    height: 30,
                                  ),
                                ],
                              )
                            : Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "Enter Full Name",
                                      headingPaddingDown: 5,
                                      heading: "Full Name",
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "example@gmail.com",
                                      heading: "Email",
                                      headingPaddingDown: 5,
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                        mediaQuery(context, 600)
                            ? Column(
                                children: [
                                  Column(
                                    spacing: 5,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextAppi(
                                        text: "User Type",
                                        textStyle: Style($text.style.fontSize(13),
                                            $text.style.fontWeight(FontWeight.w500), $text.color(Colors.black)),
                                      ),
                                      DropDownFieldAppi(
                                          items: ["Admin", "Guest"],
                                          textFieldStyle: TextFieldParamsAppi(
                                              widgetKey: GlobalKey<FormFieldState<String>>(),
                                              hint: "Select User Type",
                                              heading: "User Type",
                                              headingPaddingDown: 5),
                                          onChanged: (e) {
                                            selectedUserType = e;
                                          }),
                                    ],
                                  ),
                                  TextFieldAppi(
                                    widgetKey: GlobalKey<FormFieldState<String>>(),
                                    hint: "Enter Organization Name",
                                    headingPaddingDown: 5,
                                    heading: "Qrganization Name",
                                    initialValue: "",
                                    height: 30,
                                    readOnly: selectedUserType == "Admin",
                                  ),
                                ],
                              )
                            : Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        TextAppi(
                                          text: "User Type",
                                          textStyle: Style($text.style.fontSize(13),
                                              $text.style.fontWeight(FontWeight.w500), $text.color(Colors.black)),
                                        ),
                                        DropDownFieldAppi(
                                            items: ["Admin", "Guest"],
                                            textFieldStyle: TextFieldParamsAppi(
                                                widgetKey: GlobalKey<FormFieldState<String>>(),
                                                hint: "Select User Type",
                                                heading: "User Type",
                                                headingPaddingDown: 5),
                                            onChanged: (e) {
                                              selectedUserType = e;
                                              print("---------selectedUserType $e");
                                            }
                                            ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "Enter Organization Name",
                                      headingPaddingDown: 5,
                                      heading: "Organization Name",
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                        mediaQuery(context, 600)
                            ? Column(
                                children: [
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "Enter Password",
                                      headingPaddingDown: 5,
                                      heading: "Password",
                                      password: true,
                                      maxLines: 1,
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "Enter Confirm Password",
                                      headingPaddingDown: 5,
                                      heading: "Confirm Password",
                                      // hintTextStyle: TextStyle(color: Colors.grey.shade500),
                                      password: true,
                                      maxLines: 1,
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                spacing: 10,
                                children: [
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "Enter Password",
                                      headingPaddingDown: 5,
                                      heading: "Password",
                                      password: true,
                                      maxLines: 1,
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFieldAppi(
                                      widgetKey: GlobalKey<FormFieldState<String>>(),
                                      hint: "Enter Confirm Password",
                                      headingPaddingDown: 5,
                                      heading: "Confirm Password",
                                      password: true,
                                      maxLines: 1,
                                      initialValue: "",
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                        BoxAppi(
                          fillColor: Color(0xff9263b2),
                          radius: 10,
                          height: 50,
                          child: Center(
                            child: TextAppi(
                              text: "Sign up",
                              textStyle: Style($text.style.fontSize(16), $text.style.color(Colors.white)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextAppi(
                              text: 'Already have an account? ',
                              textStyle: Style($text.style.fontSize(14), $text.style.color(Colors.black)),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  context.go("/");
                                },
                                child: TextAppi(
                                  text: 'Login',
                                  textStyle: Style(
                                    $text.style.fontSize(14),
                                    $text.style.color(
                                      Color(0xff895ca5),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      body: mediaQuery(context, 600)
          ? SingleChildScrollView(
              child: content,
            )
          : content,
    );
  }
}
