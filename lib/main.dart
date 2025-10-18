import 'package:appikorn_software/screens/contactUsScreen.dart';
import 'package:appikorn_software/screens/loginScreen.dart';
import 'package:appikorn_software/screens/mainScreen.dart';
import 'package:appikorn_software/screens/uploadScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  usePathUrlStrategy();
  // Load .env file from assets (works for web)
  await dotenv.load(fileName: "assets/env/.env");
  runApp(ProviderScope(child: MyApp()));
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
