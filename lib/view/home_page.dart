// ignore_for_file: avoid_print

import 'package:capstone_flutter/view/authentication/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseAuth.instance.signOut();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainPage()));
      },
      child: const Scaffold(
        body: Center(
          child: Text(
            "@logout\n홈페이지 만들어서 연결하기",
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
