import 'package:appikorn_madix_widgets/box_appi/box_appi.dart';
import 'package:appikorn_madix_widgets/drop_down_field_appi/drop_down_field_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_madix_widgets/utils/mode/text_field_params_appi.dart';
import 'package:appikorn_software/controller/ContactUsController.dart';
import 'package:appikorn_software/core/common_functions.dart';
import 'package:appikorn_software/model/ContactUs.dart';
import 'package:appikorn_software/common_widgets/navBar.dart';
import 'package:appikorn_software/widgets/contact_us_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mix/mix.dart';

import '../model/UploadItem.dart';
import '../provider/contact_us_provider.dart';
import '../provider/login_provider.dart';
import '../provider/upload_provider.dart';
import '../provider/uploaded_items_provider.dart';
import '../widgets/upload_widgets.dart';

class Uploadscreen extends ConsumerWidget {
  const Uploadscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final login = ref.watch(loginModelProvider);
    final isAppikorn = login.email == "admin@appikorn";
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Navbar(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Consumer(builder: (context, ref, child) {
                  return Form(
                    // key: ref.watch(contactUsFormKey),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Padding(
                        padding: mediaQuery(context, 740) ? const EdgeInsets.all(10) : EdgeInsets.zero,
                        child: BoxAppi(
                          radius: 20,
                          shadowBlur: 22,
                          shadowOffset: const Offset(0, 10),
                          shadowSpreadRadius: 0,
                          shadowColor: const Color(0xff292D88).withOpacity(0.15),
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
                                      text: "Apk Upload",
                                      textStyle: Style(
                                        $text.style.fontSize(30),
                                        $text.style.fontWeight(FontWeight.w600),
                                      ),
                                    ),
                                    TextAppi(
                                      text: "Upload and manage your APK files easily",
                                      textStyle: Style(
                                        $text.style.fontSize(14),
                                        $text.textAlign(TextAlign.start),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                // Upload Fields
                                Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: UploadLinkInput(),
                                    ),
                                  ],
                                ),
                                // Image Fields
                                UploadImage(), // Title Fields
                                Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: UploadTitle(),
                                    ),
                                  ],
                                ),
                                // Description Field
                                UploadDescription(),
                                // Upload Button
                                Consumer(builder: (context, ref, child) {
                                  final isSending = ref.watch(isSendingProvider);
                                  return GestureDetector(
                                    onTap: isSending
                                        ? null
                                        : () async {
                                            // 1️⃣ Set loading
                                            // ref.read(isSendingProvider.notifier).state = true;
                                            //
                                            // // 2️⃣ Read uploaded data
                                            // final uploadData = ref.read(uploadProvider);
                                            //
                                            // // 3️⃣ Validate
                                            // if (uploadData.uploadlink == null ||
                                            //     uploadData.uploadImage == null ||
                                            //     uploadData.uploadTitle == null ||
                                            //     uploadData.uploadDescription == null) {
                                            //   ScaffoldMessenger.of(context).showSnackBar(
                                            //     const SnackBar(
                                            //       content: Text("Please fill all fields and upload files"),
                                            //     ),
                                            //   );
                                            //   ref.read(isSendingProvider.notifier).state = false;
                                            //   return;
                                            // }
                                            //
                                            // // 4️⃣ Create UploadedItem
                                            // final newItem = UploadedItem(
                                            //   title: uploadData.uploadTitle!,
                                            //   description: uploadData.uploadDescription!,
                                            //   apkLink: uploadData.uploadlink!,
                                            //   imageFileName: uploadData.uploadImage!,
                                            // );
                                            //
                                            // // 5️⃣ Add to provider
                                            // ref.read(uploadedItemsProvider.notifier).addItem(newItem);
                                            //
                                            // // 6️⃣ Optional: convert to JSON
                                            // final uploadedJson = newItem.toJson();
                                            // print("Uploaded JSON: $uploadedJson");
                                            //
                                            // // 7️⃣ Reset loading
                                            // ref.read(isSendingProvider.notifier).state = false;

                                            // 8️⃣ Navigate to main screen
                                            context.go("/main");
                                          },
                                    child: BoxAppi(
                                      fillColor: isAppikorn ? Color(0xff9263b2) : Color(0xff3faeb3),
                                      radius: 10,
                                      height: 50,
                                      child: Center(
                                        child: isSending
                                            ? CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              )
                                            : TextAppi(
                                                text: "Upload",
                                                textStyle:
                                                    Style($text.style.fontSize(16), $text.style.color(Colors.white)),
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
