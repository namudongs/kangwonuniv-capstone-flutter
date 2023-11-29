// ignore_for_file: avoid_print, prefer_const_constructors, unused_local_variable
import 'package:capstone/authController.dart';
import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:capstone/authentication/appUser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

AppUser? appUser;
NotificationController notificationController =
    Get.put(NotificationController());

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Firebase 메시징 백그라운드 핸들러 초기화
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // 토큰 리프레시 리스너 설정
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  firebaseMessaging.onTokenRefresh.listen((newToken) {
    if (FirebaseAuth.instance.currentUser != null) {
      // 새 토큰을 Firestore에 저장
      notificationController.saveDeviceToken();
      print('토큰이 변경되었습니다: $newToken');
      return;
    }
  });

  notificationController.saveDeviceToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.put(AuthController());
    return GetMaterialApp(
      initialBinding:
          BindingsBuilder.put(() => NotificationController(), permanent: true),
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

        fontFamily: 'NanumSquare',
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
