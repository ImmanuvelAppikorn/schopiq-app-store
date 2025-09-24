import 'package:appikorn_software/screens/contactUsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../model/ContactUs.dart';
import '../provider/contact_us_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../model/ContactUs.dart';
import 'BackendEmailService.dart';

class ContactUsController {

//   Future<void> sendEmail({
//     required BuildContext context,
//     required ContactUsModel contact,
//   }) async {
//
//     final smtpServer = gmail(
//       dotenv.env['SMTP_EMAIL']!,  // 👈 Now it works
//       dotenv.env['SMTP_PASS']!,
//     );
//
//     final emailMessage = Message()
//       ..from = Address(dotenv.env['SMTP_EMAIL']!, 'MadX Contact Form')
//       ..recipients.add('immanvj077@gmail.com') // receiver (your inbox)
//       ..subject = 'New Contact Us Message from ${contact.name}'
//       ..text = '''
// Name: ${contact.name}
// Email: ${contact.business_email}
// Phone: ${contact.phoneNumber}
// Service: ${contact.service}
// Message: ${contact.message}
// ''';
//
//     try {
//       final sendReport = await send(emailMessage, smtpServer);
//       print('Message sent: $sendReport');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Message sent successfully!')),
//       );
//     } on MailerException catch (e) {
//       print('Message not sent: $e');
//       for (var p in e.problems) {
//         print('Problem: ${p.code}: ${p.msg}');
//       }
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('❌ Failed to send message')),
//       );
//     }
//   }

  Future<void> handleSubmit(BuildContext context, WidgetRef ref) async {
    final formKey = ref.read(contactUsFormKey);
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      final contact = ref.read(contactUsProvider);

      // Send email via backend
      await BackendEmailService.sendEmail(contact, context);
    }
  }

  void validate({required WidgetRef ref}) {
    final value = ref.watch(contactUsFormKey);
    value.currentState?.save();
    var validationResult = value.currentState?.validate();

    if (validationResult ?? false) {
      validated();
    }
  }

  void validated() {
    print('we are validated....');
  }
}
