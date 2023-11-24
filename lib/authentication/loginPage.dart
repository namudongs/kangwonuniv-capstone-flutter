// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors
// ignore_for_file: avoid_print

import 'dart:io';

import 'package:capstone/authController.dart';
import 'package:capstone/components/makeInput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:capstone/authentication/signupPage.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/colorRoundButton.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          const Text(
                            "로그인",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "재학중인 학교의 이메일로 로그인하세요.",
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            MakeInput(
                                label: "이메일",
                                obscureText: false,
                                controller: emailController),
                            MakeInput(
                              label: "비밀번호",
                              obscureText: true,
                              controller: passwordController,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ColorRoundButton(
                              tapFunc: () async {
                                String email = emailController.text;
                                String password = passwordController.text;

                                final navigator = Navigator.of(context);

                                if (email.isEmpty || password.isEmpty) {
                                  print('이메일 또는 비밀번호를 입력해주세요.');
                                  return;
                                } else if (!email.contains('@')) {
                                  print('이메일 형식이 올바르지 않습니다.');
                                  return;
                                } else if (password.length < 6) {
                                  print('비밀번호는 6자리 이상이어야 합니다.');
                                  return;
                                } else if (password.contains(' ')) {
                                  print('비밀번호에 공백이 포함되어 있습니다.');
                                  return;
                                } else {
                                  await FirebaseAuth.instance
                                      .signInWithEmailAndPassword(
                                          email: email, password: password)
                                      .then((value) async {
                                    print(
                                        '로그인 성공\n이메일: $email, 비밀번호: $password');
                                    await authController.fetchUserData();

                                    navigator.pushNamedAndRemoveUntil(
                                        '/', (_) => false);
                                    navigator.push(
                                      MaterialPageRoute(
                                          builder: (_) => BottomNavBar()),
                                    );
                                  }).catchError((e) {
                                    print(
                                        '로그인 실패\n이메일: $email, 비밀번호: $password');
                                    print(e);
                                    sleep(Durations.medium1);
                                  });
                                }
                              },
                              title: "로그인",
                              color: Colors.lightBlueAccent,
                              buttonWidth: double.infinity,
                              buttonHeight: 60,
                              fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("아직 계정이 없으신가요? "),
                            GestureDetector(
                              onTap: () {
                                print('회원가입 버튼 클릭');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignupPage()));
                              },
                              child: const Text(
                                "회원가입",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: Lottie.asset(
                      'assets/lottie/animation_lkij23o3.json',
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
