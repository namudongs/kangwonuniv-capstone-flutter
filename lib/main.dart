// ignore_for_file: avoid_print

import 'package:capstone/authentication/main_page.dart';
import 'package:capstone/components/bottom_nav_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/authentication/app_user.dart';

// 전역 변수 추가
AppUser? appUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase에서 사용자 데이터 가져오기
  await fetchUserData();

  runApp(const MyApp());
}

Future<void> fetchUserData() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? currentUser = auth.currentUser;

  if (currentUser != null) {
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    DocumentSnapshot userSnapshot = await userRef.get();

    if (userSnapshot.exists) {
      appUser = AppUser.fromMap(userSnapshot.data()! as Map<String, dynamic>);
    }
  }
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
          if (snapshot.hasError) {
            print('Error in authStateChanges stream: ${snapshot.error}');
            return const Center(child: Text('에러가 발생했습니다!'));
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              return const BottomNavBar();
            } else {
              return const MainPage();
            }
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
