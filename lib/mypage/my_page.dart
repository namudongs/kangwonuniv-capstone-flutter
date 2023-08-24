// ignore_for_file: avoid_print

import 'package:capstone/components/color_round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ColorRoundButton(
          tapFunc: () {
            FirebaseAuth.instance.signOut();
            print('로그아웃 버튼 클릭');
          },
          title: '로그아웃',
          color: Colors.orangeAccent,
          buttonWidth: 200,
          buttonHeight: 50,
          fontSize: 15,
        ),
      ),
    );
  }
}
