// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:capstone_flutter/view/login.dart';
import 'package:capstone_flutter/view/signup.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 100,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "환영합니다!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "실시간 질의응답 어플리케이션을 통해 대학생활을 더욱 즐겁게!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: Lottie.asset('assets/lottie/animation_lkiiozif.json'),
              ),
              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "로그인",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignupPage()));
                      },
                      color: Colors.lightBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: const Text(
                        "회원가입",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
