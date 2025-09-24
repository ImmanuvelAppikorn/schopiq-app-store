

import 'package:appikorn_software/model/ContactUs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final contactUsProvider = StateNotifierProvider<ContactUsModelNotifier, ContactUsModel>((ref){
  return ContactUsModelNotifier(ContactUsModel());
});

class ContactUsModelNotifier extends StateNotifier<ContactUsModel> {
  ContactUsModelNotifier(super.state);

  void update(ContactUsModel data) {
    state = state.merge(data);
  }
}

final isSendingProvider = StateProvider<bool>((ref) => false);

// Form Key Provider
final contactUsFormKey = Provider((ref) {
  return GlobalKey<FormState>();
});
