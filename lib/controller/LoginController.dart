import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart'; // <-- import FlutterToast

import '../provider/login_provider.dart';

class LoginController {
  Future<void> handleSubmit(BuildContext context, WidgetRef ref) async {
    final formKey = ref.read(loginFormKeyProvider);
    final login = ref.read(loginModelProvider);
    final isAppikorn = login.email == "admin@appikorn";

    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();

      // Replace this with your real allowed credentials checking logic
      final allowedEmails = ["admin@appikorn", "admin@schopiq", "admin@anoud", "admin@fhcl"];
      final email = login.email.trim().toLowerCase();
      final password = login.password.trim();

      if (allowedEmails.contains(email) && password == "12345") {
        await Future.delayed(Duration(seconds: 2)); // placeholder, your API call here

        Fluttertoast.showToast(
          msg: "Login successful ✅",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
          textColor: Colors.white,
          webBgColor: isAppikorn ? "#9263b2" : "#2daba8",
          webPosition: "center",
          timeInSecForIosWeb: 2,
          fontSize: 14.0,
        );

        context.go("/main");
      } else {
        Fluttertoast.showToast(
          msg: "Invalid credentials ❌",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
          textColor: Colors.white,
          webBgColor: isAppikorn ? "#9263b2" : "#2daba8",
          webPosition: "center",
          timeInSecForIosWeb: 2,
          fontSize: 14.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please fill in all fields ⚠️",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: isAppikorn ? Color(0xff9263b2) : Color(0xff2daba8),
        textColor: Colors.white,
        webBgColor: isAppikorn ? "#9263b2" : "#2daba8",
        webPosition: "center",
        timeInSecForIosWeb: 2,
        fontSize: 14.0,
      );
    }
  }

  void validate({required WidgetRef ref}) {
    final formKey = ref.watch(loginFormKeyProvider);
    formKey.currentState?.save();
    var validationResult = formKey.currentState?.validate();

    if (validationResult ?? false) {
      validated();
    }
  }

  void validated() {
    print('Form validated');
  }
}
