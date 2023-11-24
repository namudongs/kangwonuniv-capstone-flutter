import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/components/colorRoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: const Text('프로필'),
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
