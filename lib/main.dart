// ignore_for_file: avoid_print
import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/components/bottomBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/authentication/appUser.dart';

AppUser? appUser;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
        fontFamily: 'NanumGothic',
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
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
