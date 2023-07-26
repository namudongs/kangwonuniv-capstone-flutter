// ignore_for_file: avoid_print

import 'package:capstone_flutter/view/authentication/main_page.dart';
import 'package:capstone_flutter/view/navbar/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    theme: ThemeData(scaffoldBackgroundColor: Colors.white),
    debugShowCheckedModeBanner: false,
    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const BottomNavBar();
        } else {
          return const MainPage();
        }
      },
    ),
  ));
}
