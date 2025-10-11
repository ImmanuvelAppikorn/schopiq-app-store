import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/drop_down_field_appi/drop_down_field_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:appikorn_software/provider/login_provider.dart';
import 'package:appikorn_software/screens/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';

import '../widgets/login_widgets.dart';
import 'mainScreen.dart';

class Loginscreen extends ConsumerStatefulWidget {
  const Loginscreen({super.key});

  @override
  ConsumerState createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  void verifyLogin(BuildContext context) {
    final email = ref.read(emailProvider);
    final password = ref.read(passwordProvider);
    // final organizationName = ref.read(organisationNameProvider);

    print("----------verify state---1 ---email :  $email --- password :  $password ");

    if (email.trim().isEmpty || password.trim().isEmpty) {
      ref.read(loginVerifyProvider.notifier).state = "notempty";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields ⚠️")),
      );
      return; // stop here
    }

    // ✅ Set default password based on organization
    // if (organizationName == "Schopiq(Admin)") {
    //   ref.read(passwordProvider.notifier).update((_) => "2222");
    // } else {
    //   ref.read(passwordProvider.notifier).update((_) => "1111");
    // }

    // Check for Appikorn(Admin)
    // if (organizationName == "Schopiq(Admin)") {
    //   if (password == "2222") {
    //     ref.read(loginVerifyProvider.notifier).state = "success";
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Login Successful ✅")),
    //     );
    //     context.push("/main"); // redirect to UploadScreen
    //   } else {
    //     ref.read(loginVerifyProvider.notifier).state = "failed";
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(content: Text("Invalid Credentials for Schopiq(Admin) ❌")),
    //     );
    //   }
    //   return; // stop further checks
    // }

    final emailTrimmed = email.trim().toLowerCase();
    final passwordTrimmed = password.trim();

    final allowedEmails = ["admin@appikorn.com", "admin@schopiq.com", "admin@anoud.com", "fresh&honest@appikorn.com"];

    // Check for normal user email login
    if (allowedEmails.contains(emailTrimmed) && passwordTrimmed == "12345") {
      ref.read(loginVerifyProvider.notifier).state = "success";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login Successful ✅")),
      );
      context.go("/main");
    } else {
      ref.read(loginVerifyProvider.notifier).state = "failed";
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials ❌")),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ref.read(emailProvider.notifier).update((el) {
    //     return "";
    //   });
    //   ref.read(passwordProvider.notifier).update((el) {
    //     return "";
    //   });
      // ref.read(organisationNameProvider.notifier).update((el) {
      //   return "";
      // });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // lets Scaffold resize for keyboard
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            reverse: true, // scrolls to bottom when keyboard opens
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight, // ensures it fills the screen
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Padding(
                    padding: mediaQuery(context, 480) ? EdgeInsets.all(10) : EdgeInsets.zero,
                    child: BoxAppi(
                        radius: 20,
                        // border: Border.all(color: Colors.black),
                        shadowBlur: 22,
                        shadowOffset: Offset(0, 10),
                        shadowSpreadRadius: 0,
                        shadowColor: Color(0xff292D88).withOpacity(0.15),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: mediaQuery(context, 480) ? 20 : 40),
                          child: Column(
                            spacing: 15,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  ref.watch(emailProvider) == "admin@appikorn.com"
                                      ? Image.asset(
                                          "assets/png/appikorn-logo.png",
                                          height: 60,
                                          width: 60,
                                        )
                                      : Image.asset(
                                          "assets/png/schopiq_logo.png",
                                          height: 60,
                                          width: 60,
                                        ),
                                  TextAppi(
                                    text: "Welcome Guest!",
                                    textStyle: Style(
                                      $text.style.fontSize(30),
                                      $text.style.fontWeight(FontWeight.w600),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  TextAppi(
                                    text: "Glad to see you again👋",
                                    textStyle: Style(
                                      $text.style.fontSize(14),
                                    ),
                                  ),
                                  TextAppi(
                                    text: "Login to your account below",
                                    textStyle: Style(
                                      $text.style.fontSize(14),
                                    ),
                                  ),
                                ],
                              ),
                              // Organization Name
                              // LoginOrganizationNameWdg(),
                              // Email
                              LoginEmailWdg(),
                              // Password
                              LoginPasswordWdg(),
                              // Login Button
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => verifyLogin(context),
                                  child: BoxAppi(
                                    fillColor: ref.watch(emailProvider) == "admin@appikorn.com"
                                        ? Color(0xff9263b2)
                                        : Color(0xff3faeb3),
                                    radius: 10,
                                    height: 50,
                                    child: Center(
                                      child: TextAppi(
                                        text: "Login",
                                        textStyle: Style($text.style.fontSize(16), $text.style.color(Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
