import 'package:capstone/authentication/universityList.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:capstone/authentication/signUpController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final SignUpController controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              controller.emailController.clear();
              controller.passwordController.clear();
              controller.nameController.clear();
              Get.back();
            }),
        title: const Text('회원가입'),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(10),
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
                Obx(
                  () => controller.isEmailEmpty.value
                      ? const SizedBox.shrink()
                      : (controller.isEmailValid.value
                          ? _buildValidationMessage(
                              '이메일이 유효합니다.', true, context)
                          : _buildValidationMessage(
                              '유효하지 않은 이메일 주소입니다.', false, context)),
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
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: controller.passwordController,
                      focusNode: controller.passwordFocusNode,
                      style: const TextStyle(
                        fontFamily: 'NanumGothic',
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '비밀번호',
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => controller.isPasswordEmpty.value
                      ? const SizedBox.shrink()
                      : (controller.isPasswordValid.value
                          ? _buildValidationMessage(
                              '비밀번호가 유효합니다.', true, context)
                          : _buildValidationMessage(
                              '비밀번호는 8자리 이상으로 설정해주세요.', false, context)),
                ),
                Obx(
                  () => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.5,
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: controller.isNameFocused.value
                                  ? const Color.fromARGB(255, 157, 0, 0)
                                  : Colors.black.withOpacity(0.2),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            onChanged: (String value) {
                              controller.checkNameEmpty();
                              controller.isNameChecked.value = false;
                            },
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            controller: controller.nameController,
                            focusNode: controller.nameFocusNode,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              hintText: '닉네임',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.checkNameEmpty();
                            controller.checkNameValidity();
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(150, 157, 0, 0),
                              ),
                              onPressed: () {
                                controller.checkName();
                              },
                              child: const Text(
                                '중복확인',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(
                  () {
                    if (controller.isNameEmpty.value) {
                      return const SizedBox.shrink();
                    } else if (!controller.isNameChecked.value) {
                      return _buildValidationMessage(
                          '닉네임 중복확인을 해 주세요.', false, context);
                    } else if (!controller.isNameValid.value) {
                      return _buildValidationMessage(
                          '중복된 닉네임입니다.', false, context);
                    } else {
                      return _buildValidationMessage(
                          '중복되지 않은 닉네임입니다.', true, context);
                    }
                  },
                ),
                GestureDetector(
                  onTap: () => _showModal(context),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: controller.selectedInfo.toString() !=
                                  '대학교와 학과를 선택해주세요'
                              ? const Color.fromARGB(255, 157, 0, 0)
                              : Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 4),
                        Obx(
                          () => Text(
                            controller.selectedInfo.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.selectedInfo.toString() !=
                                      '대학교와 학과를 선택해주세요'
                                  ? const Color.fromARGB(255, 157, 0, 0)
                                  : Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showGrade(context),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 14,
                          color: controller.selectedGrade.toString() !=
                                  '학년을 선택해주세요'
                              ? const Color.fromARGB(255, 157, 0, 0)
                              : Theme.of(context).hintColor,
                        ),
                        const SizedBox(width: 4),
                        Obx(
                          () => Text(
                            controller.selectedGrade.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              color: controller.selectedGrade.toString() !=
                                      '학년을 선택해주세요'
                                  ? const Color.fromARGB(255, 157, 0, 0)
                                  : Theme.of(context).hintColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                    controller.registerUser();
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Text(
                      '회원가입',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showGrade(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              ...controller.gradeList
                  .map((selectedGrade) => ListTile(
                        title: Text(selectedGrade),
                        onTap: () {
                          Get.back();
                          controller.updatedGrade(selectedGrade);
                        },
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  void _showModal(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<String> filteredUniversities = [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: '대학 검색',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      filteredUniversities = UniversityList.universities
                          .where((university) => university
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      filteredUniversities = [];
                    }
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUniversities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(filteredUniversities[index]),
                      onTap: () => _showDepartments(
                          context, filteredUniversities[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDepartments(BuildContext context, String university) {
    Get.back();

    TextEditingController searchController = TextEditingController();
    List<String> filteredDepartments = [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: '학과 검색',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      filteredDepartments = UniversityList.departments
                          .where((department) => department
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      filteredDepartments = [];
                    }
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              Expanded(
                child: ListView(
                  children: filteredDepartments
                      .map((department) => ListTile(
                            title: Text(department),
                            onTap: () {
                              controller.selectedUniv = university;
                              controller.selectedMajor = department;
                              controller.updateSelectedInfo();
                              Get.back();
                            },
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildValidationMessage(String message, bool isValid, context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
