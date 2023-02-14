import "dart:async";

import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";
import "package:totp_demo/screen/home_screen.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: GetMaterialApp(
        navigatorKey: Get.key,
        navigatorObservers: <NavigatorObserver>[GetObserver()],
        title: "Time-Based OTP Demo",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomeScreen(),
        enableLog: false,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
