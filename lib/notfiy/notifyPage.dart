// ignore_for_file: avoid_print, file_names

import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/components/colorRoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  Future<void> _checkState() async {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        centerTitle: false,
      ),
      body: Center(
        child: ColorRoundButton(
          tapFunc: () {
            FirebaseAuth.instance.signOut();
            _checkState();
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
