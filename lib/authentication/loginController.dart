import 'package:capstone/authController.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  var isEmailFocused = false.obs;
  var isPasswordFocused = false.obs;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());
  final NotificationController notificationController =
      Get.find<NotificationController>();

  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isEmailEmpty = true.obs;
  var isPasswordEmpty = true.obs;

  void checkEmailEmpty() {
    isEmailEmpty.value = emailController.text.isEmpty;
  }

  void checkPasswordEmpty() {
    isPasswordEmpty.value = passwordController.text.isEmpty;
  }

  void checkEmailValidity() {
    isEmailValid.value = emailController.text.length >= 6;
  }

  void checkPasswordValidity() {
    isPasswordValid.value = passwordController.text.length >= 6;
  }

  @override
  void onInit() {
    super.onInit();
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });

    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      snackBar('오류', '이메일 또는 비밀번호를 입력해주세요.');
      return;
    } else if (!email.contains('@')) {
      snackBar('오류', '이메일 형식이 올바르지 않습니다.');
      return;
    } else if (password.length < 6) {
      snackBar('오류', '비밀번호는 6자리 이상이어야 합니다.');
      return;
    } else if (password.contains(' ')) {
      snackBar('오류', '비밀번호에 공백이 포함되어 있습니다.');
      return;
    } else {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        print('로그인 성공\n이메일: $email, 비밀번호: $password');

        await authController.fetchUserData();
        await notificationController.saveDeviceToken();
        Get.offAll(() => BottomNavBar());
      }).catchError((e) {
        print('로그인 실패\n이메일: $email, 비밀번호: $password $e');
      });
    }
  }
}
