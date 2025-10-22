import 'package:appikorn_madix_widgets/drop_down_field_appi/drop_down_field_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_madix_widgets/utils/mode/text_field_params_appi.dart';
import 'package:appikorn_madix_widgets/utils/regx.dart';
import 'package:appikorn_software/model/ContactUs.dart';
import 'package:appikorn_software/provider/contact_us_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

class FullNameWdg extends ConsumerWidget { 
  const FullNameWdg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(contactUsProvider.select((el) => el.name));

    return TextFieldAppi(
      widgetKey: GlobalKey<FormFieldState<String>>(),
      hint: "Enter Full Name",
      headingPaddingDown: 5,
      heading: "Full Name",
      regx: stringRegx,
      mandatory: true,
      initialValue: value,
      height: 30,
      onSaved: (s) {
        if ((s ?? '').isNotEmpty) {
          ref.read(contactUsProvider.notifier).update(ContactUsModel(name: s));
        }
      },
      validator: (s) {
        if ((s ?? '').isEmpty) {
          return "Name can't be empty";
        }
        return null;
      },
    );
  }
}

class BusinessEmailWdg extends ConsumerWidget {
  const BusinessEmailWdg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(contactUsProvider.select((el) => el.business_email));

    return TextFieldAppi(
      widgetKey: GlobalKey<FormFieldState<String>>(),
      hint: "example@gmail.com",
      heading: "Business Email",
      // troller: emailController,
      email: true,
      mandatory: true,
      headingPaddingDown: 5,
      initialValue: value,
      height: 30,
      validator: (s) {
        if ((s ?? '').isEmpty) {
          return "Business Email can't be empty";
        }
        return null;
      },
      onSaved: (s) {
        if ((s ?? '').isNotEmpty) {
          ref.read(contactUsProvider.notifier).update(ContactUsModel(business_email: s));
        }
      },
    );
  }
}

class PhoneNumberWdg extends ConsumerWidget {
  const PhoneNumberWdg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var value = ref.watch(contactUsProvider.select((el) => el.phoneNumber));

    return TextFieldAppi(
      widgetKey: GlobalKey<FormFieldState<String>>(),
      hint: "Enter Phone Number",
      headingPaddingDown: 5,
      heading: "Phone Number",
      // troller: phoneController,
      maxLength: 10,
      mobile: true,
      maxLines: 1,
      mandatory: true,
      initialValue: value,
      height: 30,
      validator: (s) {
        if ((s ?? '').isEmpty) {
          return "Phone Number can't be empty";
        }
        return null;
      },
      onSaved: (s) {
        if ((s ?? '').isNotEmpty) {
          ref.read(contactUsProvider.notifier).update(ContactUsModel(phoneNumber: s));
        }
      },
    );
  }
}

class ServiceWdg extends ConsumerStatefulWidget {
  const ServiceWdg({super.key});

  @override
  ConsumerState<ServiceWdg> createState() => _ServiceWdgState();
}

class _ServiceWdgState extends ConsumerState<ServiceWdg> {
  final GlobalKey<FormFieldState<String>> serviceFieldKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    var value = ref.watch(contactUsProvider.select((el) => el.service));

    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextAppi(
          text: " ",
          // mandatory: true,
          textStyle:
          Style($text.style.fontSize(14), $text.style.fontWeight(FontWeight.w500), $text.color(Colors.black)),
        ),
        DropDownFieldAppi(
          key: serviceFieldKey,
          items: ["Web Development", "UI/UX Design", "Consulting", "iOS Application", "Cloud Service"],
          textFieldStyle: TextFieldParamsAppi(
            lable: "Service",
            widgetKey: serviceFieldKey, // Use same key instance here
            validator: (s) {
              if ((s ?? '').isEmpty) {
                return "Service can't be empty";
              }
              return null;
            },
            hint: "Select Service",
            mandatory: true,
            heading: "Service",
            initialValue: value,
            headingPaddingDown: 5,
          ),
          onChanged: (s) {
            ref.read(contactUsProvider.notifier).update(ContactUsModel(service: s));
            serviceFieldKey.currentState?.validate(); // force validation on change (optional)
          },
        ),
      ],
    );
  }
}


class MessageWdg extends ConsumerWidget {
  const MessageWdg({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var value = ref.watch(contactUsProvider.select((el) => el.message));
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextAppi(
          text: "Message",
          mandatory: true,
          textStyle:
              Style($text.style.fontSize(14), $text.style.fontWeight(FontWeight.w500), $text.color(Colors.black)),
        ),
        TextFormField(
          // controller: messageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Please enter your message",
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          initialValue: value,
          keyboardType: TextInputType.multiline,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (s) {
            if ((s ?? '').isEmpty) {
              return "Message can't be empty";
            }
            return null;
          },
          onSaved: (value) {
            ref.read(contactUsProvider.notifier).update(ContactUsModel(message: value));
          },
        ),
      ],
    );
  }
}
