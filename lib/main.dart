// ignore_for_file: avoid_print, prefer_const_constructors
import 'package:capstone/authController.dart';
import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'firebase/firebase_options.dart';
import 'package:capstone/authentication/appUser.dart';

AppUser? appUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return GetMaterialApp(
      initialRoute: "/",
      navigatorKey: Get.key,
      routes: {
        "/MainPage": (context) => MainPage(),
        "/BottomNavBar": (context) => BottomNavBar(),
      },
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: Color.fromARGB(255, 106, 0, 0),
          secondary: Colors.black,
        ),
        fontFamily: 'NanumGothic',
        brightness: Brightness.light,
        // scaffoldBackgroundColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Obx(
        () {
          return authController.isUserLoggedIn ? BottomNavBar() : MainPage();
        },
      ),
    );
  }
}
