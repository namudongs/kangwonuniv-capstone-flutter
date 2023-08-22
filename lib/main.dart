// ignore_for_file: avoid_print

import 'package:capstone/authentication/main_page.dart';
import 'package:capstone/components/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

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
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Error handling
          if (snapshot.hasError) {
            print('Error in authStateChanges stream: ${snapshot.error}');
            return const Center(child: Text('에러가 발생했습니다!'));
          }

          // Checking connection state
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const BottomNavBar();
            } else {
              return const MainPage();
            }
          }

          // If connection is still waiting, show a loading spinner
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
