// ignore_for_file: avoid_print, prefer_const_constructors

import 'dart:io';

import 'package:capstone/authentication/loginPage.dart';
import 'package:capstone/components/makeInput.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/colorRoundButton.dart';
import 'package:capstone/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/authentication/appUser.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final List<String> _univList = [
    '강원대학교',
    '다른 대학교',
  ];
  final List<String> _gradeList = [
    '1학년',
    '2학년',
    '3학년',
    '4학년',
    '졸업생',
  ];
  String? _selectedUniv;
  String? _selectedCollege;
  String? _selectedMajor;
  String _selectedGrade = '1학년';
  Map<String, List<String>> collegeDepartmentMap = {
    'IT대학': ['컴퓨터공학과', '정보보호학과', '소프트웨어학과'],
    '공과대학': ['기계공학과', '전기전자공학과', '화학공학과'],
    // 다른 단과대학과 학과도 이곳에 추가
  };

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController pwconfirmController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

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
          scrolledUnderElevation: 0,
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
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
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
                      "재학중인 학교와 학과를 입력해 회원가입을 완료해주세요.",
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    MakeInput(
                        label: "닉네임",
                        obscureText: false,
                        controller: userNameController),
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
                    CustomDropdown<String>(
                      closedBorder:
                          Border.all(color: Colors.grey.withAlpha(400)),
                      closedBorderRadius: BorderRadius.circular(10),
                      hintText: '학교를 선택해주세요.',
                      items: _univList,
                      onChanged: (value) {
                        setState(() {
                          _selectedUniv = value;
                        });
                        print(_selectedUniv);
                      },
                    ),
                    Visibility(
                      visible: _selectedUniv == '강원대학교' ? true : false,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.32,
                            child: CustomDropdown<String>(
                              closedBorder:
                                  Border.all(color: Colors.grey.withAlpha(400)),
                              closedBorderRadius: BorderRadius.circular(10),
                              hintText: '단과대학',
                              items: collegeDepartmentMap.keys
                                  .map<String>((String value) {
                                return value;
                              }).toList(),
                              onChanged: (String newValue) {
                                setState(() {
                                  _selectedCollege = newValue;
                                  _selectedMajor = null;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: CustomDropdown<String>(
                              closedBorder:
                                  Border.all(color: Colors.grey.withAlpha(400)),
                              closedBorderRadius: BorderRadius.circular(10),
                              hintText: '전공',
                              items: _selectedCollege == null
                                  ? ['전공 미선택']
                                  : collegeDepartmentMap[_selectedCollege]
                                      ?.map<String>((String value) {
                                      return value;
                                    }).toList(),
                              onChanged: _selectedCollege == null
                                  ? null
                                  : (String newValue) {
                                      setState(() {
                                        _selectedMajor = newValue;
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _selectedUniv == '다른 대학교' ? true : false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: majorController,
                            obscureText: false,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withAlpha(400)),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey.withAlpha(400)),
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: '다른 대학교 학생은 전공을 입력해주세요.',
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    CustomDropdown<String>(
                      closedBorder:
                          Border.all(color: Colors.grey.withAlpha(400)),
                      closedBorderRadius: BorderRadius.circular(10),
                      hintText: '학년을 선택해주세요.',
                      items: _gradeList,
                      onChanged: (value) {
                        setState(() {
                          _selectedGrade = value;
                        });
                        print(_selectedGrade);
                      },
                    ),
                  ],
                ),
                ColorRoundButton(
                    tapFunc: () async {
                      String userName = userNameController.text;
                      String email = emailController.text;
                      String password = passwordController.text;
                      String pwconfirm = pwconfirmController.text;
                      final navigator = Navigator.of(context);

                      if (userName.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          pwconfirm.isEmpty) {
                        print('빈칸이 있습니다.');
                        return;
                      } else if (!email.contains('@')) {
                        print('이메일 형식이 올바르지 않습니다.');
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
                      } else if (_selectedUniv == null &&
                          _selectedMajor == null) {
                        print('학교와 학과를 선택해주세요.');
                        return;
                      } else if (_selectedUniv == '강원대학교' &&
                          _selectedCollege == null) {
                        print('단과대학을 선택해주세요.');
                        return;
                      } else if (_selectedUniv == '강원대학교' &&
                          _selectedMajor == null) {
                        print('전공을 선택해주세요.');
                        return;
                      } else if (_selectedUniv == '다른 대학교' &&
                          majorController.text.isEmpty) {
                        print('전공을 입력해주세요.');
                        return;
                      } else if (_selectedUniv == '다른 대학교' &&
                          majorController.text.isNotEmpty) {
                        _selectedMajor = majorController.text;
                      } else
                        print('회원가입 버튼 클릭');
                      // 회원가입 로직 시작
                      try {
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) async {
                          print('회원가입 성공');
                          createUserInFirestore(
                            email: email,
                            userName: userName,
                            grade: _selectedGrade == '1학년'
                                ? 1
                                : _selectedGrade == '2학년'
                                    ? 2
                                    : _selectedGrade == '3학년'
                                        ? 3
                                        : _selectedGrade == '4학년'
                                            ? 4
                                            : 5,
                            university: _selectedUniv!,
                            major: _selectedMajor!,
                            timetable: [],
                          );
                          await fetchUserData();

                          navigator.pushNamedAndRemoveUntil('/', (_) => false);
                          navigator.push(
                            MaterialPageRoute(builder: (_) => BottomNavBar()),
                          );
                        });
                      } catch (e) {
                        print(e);
                        sleep(Durations.medium1);
                      }
                      return;
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
  required String university,
  required List<dynamic> timetable,
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
      university: university,
      grade: grade,
      major: major,
      timetable: [],
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
