// Login Verify Providers
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login.dart';
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

// final emailProvider = StateProvider<String>((ref) => "");
// final passwordProvider = StateProvider<String>((ref) => "");
// final loginVerifyProvider = StateProvider<String?>((ref) => null);
//
//
// final isSendingProviderLogin = StateProvider<bool>((ref) => false);
//
// final loginFormKey = Provider((ref) {
//   return GlobalKey<FormState>();
// });


final loginModelProvider = StateNotifierProvider<LoginModelNotifier, LoginModel>((ref) {
  return LoginModelNotifier();
});

final isSendingLoginProvider = StateProvider<bool>((ref) => false);

final loginFormKeyProvider = Provider<GlobalKey<FormState>>((ref) {
  return GlobalKey<FormState>();
});

final loginVerifyProvider = StateProvider<String>((ref) => "");


class LoginModelNotifier extends StateNotifier<LoginModel> {
  LoginModelNotifier() : super(LoginModel(email: '', password: '')) {
    _loadFromPrefs(); // Auto-hydrate when created
  }

  // Update full model and persist
  void update(LoginModel data) {
    state = state.merge(data);
    _saveToPrefs();
  }

  // Update individual fields
  void updateEmail(String email) {
    state = state.copyWith(email: email);
    _saveToPrefs();
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
    _saveToPrefs();
  }


  // Load login data from SharedPreferences
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('login_email') ?? '';
    final password = prefs.getString('login_password') ?? '';
    state = state.copyWith(email: email, password: password);
  }

  // Save login data to SharedPreferences
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_email', state.email);
    await prefs.setString('login_password', state.password);
  }

  // Clear login data (for logout)
  Future<void> clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('login_email');
    await prefs.remove('login_password');
    state = LoginModel(email: '', password: '');
  }
}








