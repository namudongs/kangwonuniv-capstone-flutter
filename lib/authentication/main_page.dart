import 'package:capstone/components/color_round_button.dart';
import 'package:flutter/material.dart';
import 'package:capstone/authentication/login_page.dart';
import 'package:capstone/authentication/signup_page.dart';
import 'package:lottie/lottie.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const Text(
                      "환영합니다!",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "실시간 질의응답으로 대학생활을 더 즐겁게",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 15),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Lottie.asset('assets/lottie/animation_lkiiozif.json'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      ColorRoundButton(
                          tapFunc: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                          title: "로그인",
                          color: Colors.white,
                          buttonWidth: double.infinity,
                          buttonHeight: 60,
                          fontSize: 18),
                      const SizedBox(
                        height: 10,
                      ),
                      ColorRoundButton(
                          tapFunc: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignupPage()));
                          },
                          title: "회원가입",
                          color: Colors.lightBlue,
                          buttonWidth: double.infinity,
                          buttonHeight: 60,
                          fontSize: 18)
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
