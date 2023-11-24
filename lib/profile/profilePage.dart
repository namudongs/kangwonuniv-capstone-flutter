import 'package:capstone/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: authController.signOut,
          child: const Text('로그아웃'),
        ),
      ),
    );
  }
}
