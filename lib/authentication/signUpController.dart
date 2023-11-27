// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:capstone/authController.dart';
import 'package:capstone/authentication/appUser.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  var isEmailFocused = false.obs;
  var isPasswordFocused = false.obs;
  var isNameFocused = false.obs;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode nameFocusNode;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  var selectedUniv;
  var selectedCollege;
  var selectedMajor;
  var selectedGrade = '학년을 선택해주세요'.obs;
  var selectedInfo = '대학교와 학과를 선택해주세요'.obs;

  List<String> universities = [
    '강원대학교',
    '강원대학교(삼척)',
    '강원대학교(도계)',
    '한림대학교',
    '춘천교육대학교',
    '한림성심대학교',
    // ... 추가 대학교
  ];

  final List<String> gradeList = [
    '1학년',
    '2학년',
    '3학년',
    '4학년',
    '졸업생',
  ];

  Map<String, int> gradeToInt = {
    '1학년': 1,
    '2학년': 2,
    '3학년': 3,
    '4학년': 4,
    '졸업생': 5,
  };

  int convertGradeToInt(String grade) {
    return gradeToInt[grade] ?? 1; // 기본값을 1학년으로 설정
  }

  Map<String, List<String>> collegeDepartmentMap = {
    'IT대학': ['컴퓨터공학과', '정보보호학과', '소프트웨어학과'],
    '공과대학': ['기계공학과', '전기전자공학과', '화학공학과'],
    // 다른 단과대학과 학과도 이곳에 추가
  };

  void updatedGrade(String grade) {
    selectedGrade.value = grade;
  }

  void updateSelectedInfo() {
    if (selectedUniv != null &&
        selectedCollege != null &&
        selectedMajor != null) {
      selectedInfo.value = "$selectedUniv $selectedMajor";
    }
  }

  Future<void> registerUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    try {
      // Firebase Authentication을 사용하여 사용자 계정 생성
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Firestore에 사용자 정보 저장
      final AppUser appUser = AppUser(
        uid: userCredential.user!.uid,
        email: emailController.text,
        userName: nameController.text,
        university: selectedUniv,
        grade: convertGradeToInt(selectedGrade.value),
        major: selectedMajor,
        timestamp: Timestamp.now(),
      );

      await users.doc(userCredential.user!.uid).set(appUser.toMap());
      snackBar('회원가입', '회원가입에 성공하였습니다.');
      auth.authStateChanges().listen((User? user) {
        if (user == null) {
          snackBar('로그아웃', '로그아웃하였습니다.');
        } else {
          Get.offAll(() => BottomNavBar());
        }
      });
    } on FirebaseAuthException catch (e) {
      print('계정 생성 실패: $e');
      // 추가적인 에러 처리
    } catch (e) {
      print('오류 발생: $e');
      // 기타 오류 처리
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    nameFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });

    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });

    nameFocusNode.addListener(() {
      isNameFocused.value = nameFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }
}
