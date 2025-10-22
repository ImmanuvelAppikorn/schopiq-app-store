import 'package:appikorn_software/provider/login_provider.dart';
import 'package:appikorn_software/screens/contactUsScreen.dart';
import 'package:appikorn_software/screens/loginScreen.dart';
import 'package:appikorn_software/screens/mainScreen.dart';
import 'package:appikorn_software/screens/uploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Ensures all platform plugins (like shared_preferences) are ready
  await SharedPreferences.getInstance();

  usePathUrlStrategy();
  await dotenv.load(fileName: "assets/env/.env");

  final container = ProviderContainer();
  await hydrateLoginProvider(container);
  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(routes: [
      GoRoute(path: "/", builder: (context, state) => Loginscreen()),
      GoRoute(path: "/main", builder: (context, state) => MainScreen()),
      GoRoute(path: "/contactus", builder: (context, state) => ContactUsScreen()),
      GoRoute(path: "/upload", builder: (context, state) => Uploadscreen()),
    ]);
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Axiforma',
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey.shade500),
          fillColor: Colors.white,
          filled: true,
          hoverColor: Colors.transparent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xffe9e9e9)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xffe9e9e9)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color(0xffe9e9e9)),
          ),
        ),
      ),
    );
  }
}

Future<void> hydrateLoginProvider(ProviderContainer container) async {
  final prefs = await SharedPreferences.getInstance();

  final email = prefs.getString('login_email') ?? '';
  final password = prefs.getString('login_password') ?? '';

  container.read(loginModelProvider.notifier).state = LoginModel(
    email: email,
    password: password,
  );
}

Future<void> saveLoginData(String email, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('login_email', email);
  await prefs.setString('login_password', password);
}

Future<void> clearLoginData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('login_email');
  await prefs.remove('login_password');
}
