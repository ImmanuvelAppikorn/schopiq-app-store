import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:appikorn_software/provider/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mix/mix.dart';
import '../controller/LoginController.dart';
import '../widgets/login_widgets.dart';

class Loginscreen extends ConsumerStatefulWidget {
  const Loginscreen({super.key});

  @override
  ConsumerState createState() => _LoginscreenState();
}

class _LoginscreenState extends ConsumerState<Loginscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    final login = ref.watch(loginModelProvider);
    final isAppikorn = login.email == "admin@appikorn";
    final loginController = LoginController();
    final formKey = ref.watch(loginFormKeyProvider);



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
                                  isAppikorn
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
                              Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      LoginEmailWdg(),
                                      // Password
                                      LoginPasswordWdg(),
                                      // Login Button
                                      Consumer(builder: (context, ref, child) {
                                        final isSending = ref.watch(isSendingLoginProvider);

                                        return GestureDetector(
                                          onTap: isSending
                                              ? null
                                              : () async {
                                                  ref.read(isSendingLoginProvider.notifier).state = true;

                                                  await loginController.handleSubmit(context, ref);

                                                  ref.read(isSendingLoginProvider.notifier).state = false;
                                                },
                                          child: BoxAppi(
                                            fillColor: isAppikorn ? Color(0xff9263b2) : Color(0xff3faeb3),
                                            // customize color conditionally if needed
                                            radius: 10,
                                            height: 50,
                                            child: Center(
                                              child: isSending
                                                  ? CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    )
                                                  : TextAppi(
                                                      text: "Login",
                                                      textStyle: Style(
                                                          $text.style.fontSize(16), $text.style.color(Colors.white)),
                                                    ),
                                            ),
                                          ),
                                        );
                                      })
                                    ],
                                  ))
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
