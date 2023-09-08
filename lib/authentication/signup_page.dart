// ignore_for_file: avoid_print

import 'package:capstone/authentication/login_page.dart';
import 'package:capstone/components/make_input.dart';
import 'package:capstone/components/bottom_nav_bar.dart';
import 'package:capstone/components/color_round_button.dart';
import 'package:capstone/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/authentication/app_user.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pwconfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            height: MediaQuery.of(context).size.height - 150,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "회원가입",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "재학중인 학교의 이메일로 회원가입할 수 있습니다.",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    MakeInput(
                        label: "이메일",
                        obscureText: false,
                        controller: emailController),
                    MakeInput(
                        label: "비밀번호",
                        obscureText: true,
                        controller: passwordController),
                    MakeInput(
                        label: "비밀번호 확인",
                        obscureText: true,
                        controller: pwconfirmController),
                  ],
                ),
                ColorRoundButton(
                    tapFunc: () async {
                      String email = emailController.text;
                      String password = passwordController.text;
                      String pwconfirm = pwconfirmController.text;

                      if (email.isEmpty ||
                          password.isEmpty ||
                          pwconfirm.isEmpty) {
                        print('빈칸이 있습니다.');
                        return;
                      } else if (!email.contains('@')) {
                        print('이메일 형식이 올바르지 않습니다.');
                        return;
                      } else if (!email.contains('.ac.kr')) {
                        print('재학중인 학교의 이메일을 입력해 주세요.');
                        return;
                      } else if (password.length < 6) {
                        print('비밀번호는 6자리 이상이어야 합니다.');
                        return;
                      } else if (password.contains(' ') &&
                          pwconfirm.contains(' ')) {
                        print('비밀번호에 공백이 포함되어 있습니다.');
                        return;
                      } else if (password != pwconfirm) {
                        print('비밀번호가 일치하지 않습니다.');
                        return;
                      } else {
                        print('회원가입 버튼 클릭');
                        // 회원가입 로직 시작
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) {
                            print('회원가입 성공');
                            createUserInFirestore(
                                email: email,
                                userName: 'man9aji',
                                grade: 4,
                                major: '컴퓨터공학과');
                            fetchUserData();

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (_) => false);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavBar()),
                            );
                          });
                        } catch (e) {
                          print(e);
                        }
                        return;
                      }
                    },
                    title: "회원가입",
                    color: Colors.blue,
                    buttonWidth: double.infinity,
                    buttonHeight: 60,
                    fontSize: 18),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text("이미 계정이 있으신가요? "),
                      GestureDetector(
                        onTap: () {
                          print('로그인 버튼 클릭');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: const Text(
                          "로그인",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> createUserInFirestore({
  required String email,
  required String userName,
  required int grade,
  required String major,
}) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  final User? currentUser = auth.currentUser;

  if (currentUser != null) {
    final AppUser appUser = AppUser(
      uid: currentUser.uid,
      email: email,
      userName: userName,
      grade: grade,
      major: major,
    );

    try {
      await users.doc(currentUser.uid).set(appUser.toMap());
      print('유저 정보 저장 성공');
    } catch (e) {
      print('유저 저장 실패: $e');
    }
  } else {
    print('로그인된 사용자가 없음');
  }
}
