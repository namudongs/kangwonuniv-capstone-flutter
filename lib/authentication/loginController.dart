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

    emailController.addListener(() {
      isEmailValid.value = checkEmailValidity();
      checkEmailEmpty(); // 이메일이 비어 있는지도 체크
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
    } else if (checkEmailValidity() == false) {
      snackBar('오류', '이메일 형식이 유효하지 않습니다.');
      return;
    } else if (password.length < 6) {
      snackBar('오류', '비밀번호는 6자리 이상이어야 합니다.');
      return;
    } else if (password.contains(' ')) {
      snackBar('오류', '비밀번호에 공백이 포함되어 있습니다.');
      return;
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print('로그인 성공\n이메일: $email, 비밀번호: $password');

        await authController.fetchUserData();
        await notificationController.saveDeviceToken();
        Get.offAll(() => BottomNavBar());
      } on FirebaseAuthException catch (e) {
        String errorMessage = '로그인 중 오류가 발생했습니다.';
        if (e.code == 'user-not-found') {
          errorMessage = '해당 이메일로 등록된 사용자를 찾을 수 없습니다.';
        } else if (e.code == 'wrong-password') {
          errorMessage = '잘못된 비밀번호입니다.';
        } else if (e.code == 'user-disabled') {
          errorMessage = '이 사용자 계정은 비활성화되었습니다.';
        }
        snackBar('로그인 실패', errorMessage);
      } catch (e) {
        snackBar('로그인 실패', '알 수 없는 오류가 발생했습니다: $e');
      }
    }
  }
}
