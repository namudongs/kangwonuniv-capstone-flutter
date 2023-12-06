// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:math';

import 'package:capstone/authController.dart';
import 'package:capstone/components/appUser.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpController extends GetxController {
  var isEmailFocused = false.obs;
  var isPasswordFocused = false.obs;
  var isNameFocused = false.obs;
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isNameValid = false.obs;
  var isNameChecked = false.obs;

  var isEmailEmpty = true.obs;
  var isPasswordEmpty = true.obs;
  var isNameEmpty = true.obs;

  String getRandomAvatar() {
    final random = Random();
    int avatarNumber = random.nextInt(12) + 1; // 1부터 12까지의 숫자를 생성
    return 'assets/avatars/avatar_$avatarNumber.png';
  }

  void checkEmailEmpty() {
    isEmailEmpty.value = emailController.text.isEmpty;
  }

  void checkPasswordEmpty() {
    isPasswordEmpty.value = passwordController.text.isEmpty;
  }

  void checkNameEmpty() {
    isNameEmpty.value = nameController.text.isEmpty;
  }

  bool checkEmailValidity() {
    String email = emailController.text;
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
      caseSensitive: false,
      multiLine: false,
    );
    return emailRegExp.hasMatch(email);
  }

  void checkPasswordValidity() {
    isPasswordValid.value = passwordController.text.length >= 8;
  }

  void checkNameValidity() {
    isNameValid.value = nameController.text.length >= 2;
  }

  void checkName() {
    if (nameController.text.isEmpty) {
      isNameEmpty.value = true;
      isNameChecked.value = false;
      snackBar('오류', '닉네임을 입력해주세요.');
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: nameController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        isNameValid.value = false;
      } else {
        isNameValid.value = true;
      }
      isNameChecked.value = true;
    });
  }

  Future<bool> checkEmail() {
    // 이메일 중복확인
    return FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    }, onError: (e) {
      return false; // or handle the error accordingly
    });
  }

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;
  late FocusNode nameFocusNode;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  var selectedUniv;
  var selectedMajor;
  var selectedGrade = '학년을 선택해주세요'.obs;
  var selectedInfo = '대학교와 학과를 선택해주세요'.obs;

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

  void updatedGrade(String grade) {
    selectedGrade.value = grade;
  }

  void updateSelectedInfo() {
    if (selectedUniv != null && selectedMajor != null) {
      selectedInfo.value = "$selectedUniv $selectedMajor";
    }
  }

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> registerUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');

    if (!isEmailValid.value) {
      snackBar('오류', '유효하지 않은 이메일입니다.');
      return;
    }
    if (!isPasswordValid.value) {
      snackBar('오류', '비밀번호는 8자리 이상이어야 합니다.');
      return;
    }
    if (isNameEmpty.value || !isNameChecked.value || !isNameValid.value) {
      snackBar('오류', '닉네임을 확인해주세요.');
      return;
    }

    if (selectedInfo.value == '대학교와 학과를 선택해주세요') {
      snackBar('오류', '대학교와 학과를 선택해주세요.');
      return;
    }

    if (selectedGrade.value == '학년을 선택해주세요') {
      snackBar('오류', '학년을 선택해주세요.');
      return;
    }

    if (await checkEmail() == false) {
      snackBar('오류', '이미 존재하는 이메일입니다.');
    }

    try {
      final NotificationController notificationController =
          NotificationController();

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String avatarUrl = getRandomAvatar();

      // Firestore에 사용자 정보 저장
      final AppUser appUser = AppUser(
        uid: userCredential.user!.uid,
        email: emailController.text,
        userName: nameController.text,
        university: selectedUniv,
        qu: 300,
        grade: convertGradeToInt(selectedGrade.value),
        major: selectedMajor,
        interesting: '설정안함',
        timestamp: Timestamp.now(),
        avatar: avatarUrl,
        timetable: [],
      );

      await users.doc(userCredential.user!.uid).set(appUser.toMap());
      snackBar('회원가입', '회원가입에 성공하였습니다.');
      notificationController.saveNotificationToFirestore(
          appUser.uid, '회원가입을 축하드려요!', '300QU를 적립해드렸어요.', '', '', '');
      notificationController.updateNotifications(appUser.uid);

      String? token = await _firebaseMessaging.getToken();
      print("토큰: $token");
      if (token != null) {
        var tokenRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .collection('tokens')
            .doc('token');

        await tokenRef.set({
          'token': token,
          'createdAt': FieldValue.serverTimestamp(), // 토큰 생성 시간
          'platform': Platform.operatingSystem // 플랫폼 정보
        });
      }

      auth.authStateChanges().listen((User? user) {
        if (user == null) {
          snackBar('로그아웃', '로그아웃 상태입니다.');
        } else {
          Get.offAll(() => BottomNavBar());
        }
      });
    } on FirebaseAuthException catch (e) {
      print('계정 생성 실패: $e');

      // FirebaseAuthException의 다양한 오류 코드에 따라 분기 처리
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 주소입니다.';
          break;
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다.';
          break;
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다.';
          break;
        case 'operation-not-allowed':
          errorMessage = '이메일 및 비밀번호 로그인이 비활성화 되어 있습니다.';
          break;
        case 'user-disabled':
          errorMessage = '사용자 계정이 비활성화 되었습니다.';
          break;
        default:
          errorMessage = '알 수 없는 오류가 발생했습니다. 다시 시도해주세요.';
      }
      snackBar('회원가입 오류', errorMessage);
    } catch (e) {
      print('오류 발생: $e');
      // 기타 오류 처리
      snackBar('오류', '알 수 없는 오류가 발생했습니다.');
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

    emailController.addListener(() {
      isEmailValid.value = checkEmailValidity();
      checkEmailEmpty(); // 이메일이 비어 있는지도 체크
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
