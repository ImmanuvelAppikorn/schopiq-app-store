import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../model/ContactUs.dart';

class BackendEmailService {
  static Future<void> sendEmail(ContactUsModel contact, BuildContext context) async {
    final url = Uri.parse("http://localhost:5000/send-email"); // Change to your backend IP if testing on a device

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": contact.name ?? '',
          "email": contact.business_email ?? '',
          "phone": contact.phoneNumber ?? '',
          "service": contact.service ?? '',
          "message": contact.message ?? '',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Message sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to send message: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error sending message: $e')),
      );
    }
  }
}
