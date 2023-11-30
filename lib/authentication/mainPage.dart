import 'package:capstone/authentication/loginPage.dart';
import 'package:capstone/authentication/signUpPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Placeholder(
              fallbackHeight: 600,
            ), // 이 위젯을 웰컴 스크린으로 사용
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(left: 10, right: 10),
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(150, 157, 0, 0),
                  ),
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                  child: const Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            Container(
              height: 50,
              // margin: const EdgeInsets.only(bottom: 50),
              padding: const EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width * 0.9,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(150, 0, 0, 0),
                ),
                onPressed: () {
                  Get.to(SignUpPage());
                },
                child: const Text(
                  '회원가입',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
