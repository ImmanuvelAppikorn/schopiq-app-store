import 'package:appikorn_madix_widgets/drop_down_field_appi/drop_down_field_appi.dart';
import 'package:appikorn_madix_widgets/text_appi/text_appi.dart';
import 'package:appikorn_madix_widgets/text_field_appi/text_field_appi.dart';
import 'package:appikorn_madix_widgets/utils/mode/text_field_params_appi.dart';
import 'package:appikorn_madix_widgets/utils/regx.dart';
import 'package:appikorn_software/model/ContactUs.dart';
import 'package:appikorn_software/provider/contact_us_provider.dart';
import 'package:appikorn_software/provider/upload_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mix/mix.dart';

import '../model/Upload.dart';
import '../provider/login_provider.dart';

class UploadLinkInput extends ConsumerWidget {
  const UploadLinkInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current value from provider
    final currentLink = ref.watch(uploadProvider.select((el) => el.uploadlink));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter APK Link",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Paste APK link here",
            // Show current provider value as placeholder if needed
            // hintText: currentLink ?? "Paste APK link here",
          ),
          // Update provider on every change
          onChanged: (value) {
            ref.read(uploadProvider.notifier).update(
              UploadModel(uploadlink: value),
            );
            print("-----Apk Link is Done");
          },
          // Show current value directly in the TextField
          controller: TextEditingController(text: currentLink),
        ),
      ],
    );
  }
}



class UploadTitle extends ConsumerStatefulWidget {
  const UploadTitle({super.key});

  @override
  ConsumerState createState() => _UploadTitleState();
}

class _UploadTitleState extends ConsumerState<UploadTitle> {
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(uploadProvider.select((el) => el.uploadTitle));
    return TextFieldAppi(
      widgetKey: GlobalKey(),
      initialValue: value,
      onSaved: (val){
        ref.read(uploadProvider.notifier).update(
          UploadModel(uploadTitle: val),
        );
        print("-----Apk Title is Done");
      },
      hint: "Enter the Upload Title",
      heading: "Upload Title",
      headingPaddingDown: 5,
    );
  }
}

class UploadDescription extends ConsumerWidget {
  const UploadDescription({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(uploadProvider.select((el) => el.uploadDescription));
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextAppi(
          text: "Upload Description",
          mandatory: true,
          textStyle:
          Style($text.style.fontSize(14), $text.style.fontWeight(FontWeight.w500), $text.color(Colors.black)),
        ),
        TextFormField(
          // controller: messageController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter the Upload Description",
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          initialValue: value,
          keyboardType: TextInputType.multiline,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (s) {
            if ((s ?? '').isEmpty) {
              return "Upload Description can't be empty";
            }
            return null;
          },
          onChanged: (val) {
            ref.read(uploadProvider.notifier).update(
              UploadModel(uploadDescription: val),
            );
            print("-----Upload Description updated: $val");
          },
        ),
      ],
    );
  }
}


class UploadImage extends ConsumerStatefulWidget {
  const UploadImage({super.key});

  @override
  ConsumerState createState() => _UploadImageState();
}

class _UploadImageState extends ConsumerState<UploadImage> {
  String? fileName;
  Future<void> pickPngFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'], // ✅ only allow PNG
    );

    if (result != null) {
      final pickedFileName = result.files.single.name;

      setState(() {
        fileName = pickedFileName; // Update local state for UI
      });

      // Update provider so other widgets can access the file name
      ref.read(uploadProvider.notifier).update(
        UploadModel(uploadImage: pickedFileName),
      );

      print("Picked PNG: $pickedFileName");
    } else {
      print("No file selected");
    }
  }
  @override
  Widget build(BuildContext context) {
    final value = ref.watch(uploadProvider.select((el) => el.uploadImage));
    return GestureDetector(
      onTap: pickPngFile,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade400, width: 2),
          color: Colors.grey.shade100,
        ),
        child: Center(
          child: value == null
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Icon(Icons.image, size: 40, color: ref.watch(organisationNameProvider) == "Appikorn" ? Color(0xff9263b2) : Color(0xff3faeb3)),
              SizedBox(height: 8),
              Text("Click to upload PNG image", style: TextStyle(fontSize: 16, color: Colors.black)),
              Text("(Only .png files allowed)", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 40, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                "Uploaded: $value",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
