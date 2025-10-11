import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_software/controller/ContactUsController.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:appikorn_software/common_widgets/navBar.dart';
import 'package:appikorn_software/widgets/contact_us_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';
import '../provider/contact_us_provider.dart';
import '../provider/login_provider.dart';

class ContactUsScreen extends ConsumerWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactController = ContactUsController();
    print('main body....');
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Navbar(),
            // SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Consumer(builder: (context, ref, child) {
                  return Form(
                    key: ref.watch(contactUsFormKey),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Padding(
                        padding: mediaQuery(context, 740)
                            ? const EdgeInsets.all(10)
                            : EdgeInsets.zero,
                        child: BoxAppi(
                          radius: 20,
                          shadowBlur: 22,
                          shadowOffset: const Offset(0, 10),
                          shadowSpreadRadius: 0,
                          shadowColor:
                              const Color(0xff292D88).withOpacity(0.15),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            child: Column(
                              spacing: 15,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ref.watch(emailProvider) ==
                                            "admin@appikorn.com"
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
                                      text: "Help & Support",
                                      textStyle: Style(
                                        $text.style.fontSize(30),
                                        $text.style.fontWeight(FontWeight.w600),
                                      ),
                                    ),
                                    TextAppi(
                                      text:
                                          "Share your feedback or questions about the MadX app, and our team will reach out to you soon.",
                                      textStyle: Style(
                                        $text.style.fontSize(14),
                                        $text.textAlign(TextAlign.start),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Name and Email Fields
                                mediaQuery(context, 600)
                                    ? Column(
                                        children: [
                                          FullNameWdg(),
                                          BusinessEmailWdg(),
                                        ],
                                      )
                                    : Row(
                                        spacing: 10,
                                        children: [
                                          Expanded(
                                            child: FullNameWdg(),
                                          ),
                                          Expanded(
                                            child: BusinessEmailWdg(),
                                          ),
                                        ],
                                      ),

                                // Phone and Service Fields
                                mediaQuery(context, 600)
                                    ? Column(
                                        children: [
                                          PhoneNumberWdg(),
                                          ServiceWdg(),
                                        ],
                                      )
                                    : Row(
                                        spacing: 10,
                                        children: [
                                          Expanded(
                                            child: PhoneNumberWdg(),
                                          ),
                                          Expanded(
                                            child: ServiceWdg(),
                                          ),
                                        ],
                                      ),
                                // Message Field
                                MessageWdg(),
                                // Submit Button
                                Consumer(builder: (context, ref, child) {
                                  final isSending =
                                      ref.watch(isSendingProvider);
                                  return GestureDetector(
                                    onTap: isSending
                                        ? null
                                        : () async {
                                            // Set loading true
                                            ref
                                                .read(
                                                    isSendingProvider.notifier)
                                                .state = true;

                                            contactController.validate(
                                                ref: ref);
                                            await contactController
                                                .handleSubmit(context,
                                                    ref); // ✅ await here

                                            // Set loading false after sending
                                            ref
                                                .read(
                                                    isSendingProvider.notifier)
                                                .state = false;
                                          },
                                    child: BoxAppi(
                                      fillColor: ref.watch(emailProvider) == "admin@appikorn.com" ? Color(0xff9263b2) : Color(0xff3faeb3),
                                      radius: 10,
                                      height: 50,
                                      child: Center(
                                        child: isSending
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : TextAppi(
                                                text: "Submit",
                                                textStyle: Style(
                                                    $text.style.fontSize(16),
                                                    $text.style
                                                        .color(Colors.white)),
                                              ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
