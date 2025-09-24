
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactUsModel {
  final String? name;
  final String? business_email;
  final String? phoneNumber;
  final String? service;
  final String? message;

  ContactUsModel({
    this.name,
    this.business_email,
    this.phoneNumber,
    this.service,
    this.message,
  });

  // Merge method
  ContactUsModel merge(ContactUsModel other) {
    return ContactUsModel(
      name: other.name ?? name,
      business_email: other.business_email ?? business_email,
      phoneNumber: other.phoneNumber ?? phoneNumber,
      service: other.service ?? service,
      message: other.message ?? message,
    );
  }
}
