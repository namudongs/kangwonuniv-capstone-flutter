// ignore_for_file: avoid_print

import 'package:capstone/components/color_round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'store_page.dart';
import 'profile_edit_page.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 프로필 수정 버튼
            ColorRoundButton(
              tapFunc: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileEditPage()),
                );
              },
              title: '프로필 수정',
              color: Colors.blueAccent,
              buttonWidth: 200,
              buttonHeight: 50,
              fontSize: 15,
            ),
            SizedBox(height: 20), // 버튼 간격

            // 상점으로 이동 버튼
            ColorRoundButton(
              tapFunc: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StorePage()),
                );
              },
              title: '상점으로 이동',
              color: Colors.greenAccent,
              buttonWidth: 200,
              buttonHeight: 50,
              fontSize: 15,
            ),
            SizedBox(height: 20), // 버튼 간격

            // 로그아웃 버튼
            ColorRoundButton(
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
          ],
        ),
      ),
    );
  }
}