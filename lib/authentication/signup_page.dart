// ignore_for_file: avoid_print

import 'package:capstone_flutter/authentication/login_page.dart';
import 'package:capstone_flutter/components/make_input.dart';
import 'package:capstone_flutter/components/bottom_nav_bar.dart';
import 'package:capstone_flutter/components/color_round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pwconfirmController = TextEditingController();
  SignupPage({super.key});

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
          backgroundColor: Colors.white,
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
          systemOverlayStyle: SystemUiOverlayStyle.light,
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
                    tapFunc: () {
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
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) {
                          print('회원가입 성공');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavBar()));
                        }).catchError((err) {
                          print(err);
                        });
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

  // Widget makeInput(
  //     {label, obscureText = false, required TextEditingController controller}) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       Text(
  //         label,
  //         style: const TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.normal,
  //             color: Colors.black87),
  //       ),
  //       const SizedBox(
  //         height: 5,
  //       ),
  //       TextField(
  //         controller: controller,
  //         obscureText: obscureText,
  //         decoration: InputDecoration(
  //           contentPadding:
  //               const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
  //           enabledBorder: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.grey.withAlpha(400))),
  //           border: OutlineInputBorder(
  //               borderSide: BorderSide(color: Colors.grey.withAlpha(400))),
  //         ),
  //       ),
  //       const SizedBox(
  //         height: 30,
  //       ),
  //     ],
  //   );
  // }
}
