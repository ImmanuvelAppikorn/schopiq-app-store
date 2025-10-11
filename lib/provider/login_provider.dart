// Login Verify Providers
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class LoginModel {
//   final String? organizationName;
//   final String? email;
//   final String? password;
//
//   LoginModel({required this.organizationName, required this.email, required this.password});
//
//   LoginModel copyWith({
//     String? organizationName,
//     String? email,
//     String? password,
//   }) {
//     return LoginModel(
//         organizationName: organizationName ?? this.organizationName,
//         email: email ?? this.email,
//         password: password ?? this.password);
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailProvider = StateProvider<String>((ref) => "");
final passwordProvider = StateProvider<String>((ref) => "");
final loginVerifyProvider = StateProvider<String?>((ref) => null);
final organisationNameProvider = StateProvider<String>((ref) => "");

final isSendingProviderLogin = StateProvider<bool>((ref) => false);

final loginFormKey = Provider((ref) {
  return GlobalKey<FormState>();
});
