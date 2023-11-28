import 'package:capstone/authentication/loginController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: controller.isEmailFocused.value
                          ? const Color.fromARGB(255, 157, 0, 0)
                          : Colors.black.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: (String value) {
                      controller.checkEmailValidity();
                      controller.checkEmailEmpty();
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: controller.emailController,
                    focusNode: controller.emailFocusNode,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: '이메일',
                    ),
                  ),
                ),
              ),
              Obx(() => controller.isEmailEmpty.value
                  ? const SizedBox.shrink()
                  : (controller.isEmailValid.value
                      ? _buildValidationMessage('이메일이 유효합니다.', true, context)
                      : _buildValidationMessage(
                          '이메일이 유효하지 않습니다.', false, context))),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () => Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: controller.isPasswordFocused.value
                          ? const Color.fromARGB(255, 157, 0, 0)
                          : Colors.black.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    onChanged: (String value) {
                      controller.checkPasswordValidity();
                      controller.checkPasswordEmpty();
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onSubmitted: (value) {
                      controller.login();
                    },
                    textInputAction: TextInputAction.done,
                    controller: controller.passwordController,
                    focusNode: controller.passwordFocusNode,
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'NanumGothic',
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: '비밀번호',
                    ),
                  ),
                ),
              ),
              Obx(() => controller.isPasswordEmpty.value
                  ? const SizedBox.shrink()
                  : (controller.isPasswordValid.value
                      ? _buildValidationMessage('비밀번호가 유효합니다.', true, context)
                      : _buildValidationMessage(
                          '비밀번호가 유효하지 않습니다.', false, context))),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(150, 157, 0, 0),
                ),
                onPressed: () {
                  controller.login();
                },
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    '로그인',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationMessage(String message, bool isValid, context) {
    return SizedBox(
      height: 20,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            size: 17,
            color: const Color.fromARGB(255, 157, 0, 0),
          ),
          const SizedBox(width: 3),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'NanumSquare',
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 157, 0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
