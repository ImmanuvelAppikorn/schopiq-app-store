import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:html' as html;
import 'package:url_launcher/url_launcher.dart';

bool mediaQuery(BuildContext context, double width){
  return MediaQuery.of(context).size.width < width;
}


// Download a File
Future<void> downloadFile(String url, String fileName) async {
  try {
    // Get app's document directory
    Directory dir = await getApplicationDocumentsDirectory();
    String savePath = "${dir.path}/$fileName";

    // Download file
    Dio dio = Dio();
    await dio.download(url, savePath,
        onReceiveProgress: (count, total) {
          print("Progress: ${(count / total * 100).toStringAsFixed(0)}%");
        });

    print("File saved at $savePath");

    // Optionally open it
    await OpenFilex.open(savePath);
  } catch (e) {
    print("Download error: $e");
  }
}

// Future<void> downloadFileWeb(String url, String fileName) async {
//   try {
//     // Fetch the file bytes
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       // Convert bytes into a Blob
//       final blob = html.Blob([response.bodyBytes]);
//
//       // Create an object URL for the Blob
//       final urlObject = html.Url.createObjectUrlFromBlob(blob);
//
//       // Create a hidden anchor tag & trigger download
//       final anchor = html.AnchorElement(href: urlObject)
//         ..download = fileName
//         ..click();
//
//       // Clean up the object URL to free memory
//       html.Url.revokeObjectUrl(urlObject);
//     } else {
//       print("Error: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Download error: $e");
//   }
// }


Future<void> downloadFileWeb(String url, String fileName) async {
  try {
    final anchor = html.AnchorElement(href: url)
      ..download = fileName
      ..target = "_blank"
      ..style.display = 'none';

    html.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
  } catch (e) {
    print("Download error: $e");
  }
}

Future<void> downloadApk(String url) async {
  try {
    // Web version
    if (kIsWeb) {
      final anchor = html.AnchorElement(href: url)
        ..download = "app.apk"
        ..target = "blank"
        ..click();
      return;
    }

    // Mobile/Desktop version
    final dir = await getApplicationDocumentsDirectory();
    final savePath = "${dir.path}/app.apk";

    await Dio().download(
      url,
      savePath,
      onReceiveProgress: (count, total) {
        print("Progress: ${(count / total * 100).toStringAsFixed(0)}%");
      },
    );

    print("APK downloaded to: $savePath");
  } catch (e) {
    print("Download error: $e");
  }
}

void openUrl(String url) async {
  final uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Opens in browser or external app
    );
  } else {
    print("Could not launch $url");
  }
}

