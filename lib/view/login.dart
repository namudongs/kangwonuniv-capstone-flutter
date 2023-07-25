// ignore_for_file: avoid_print

import 'package:capstone_flutter/view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
                          height: 20,
                        ),
                        Text(
                          "재학중인 학교의 이메일로 로그인하세요.",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: <Widget>[
                          makeInput(label: "이메일", controller: emailController),
                          makeInput(
                            label: "비밀번호",
                            obscureText: true,
                            controller: passwordController,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: const EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            String email = emailController.text;
                            String password = passwordController.text;
                            print('로그인 버튼 클릭');
                            print('이메일: $email, 비밀번호: $password');

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeNavBar()));
                          },
                          color: Colors.lightBlueAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: const Text(
                            "로그인",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("아직 계정이 없으신가요? "),
                          GestureDetector(
                            onTap: () {
                              print('회원가입 버튼 클릭');
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
    );
  }

  Widget makeInput(
      {label, obscureText = false, required TextEditingController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(400))),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withAlpha(400))),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
