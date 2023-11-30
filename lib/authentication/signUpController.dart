// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:math';

import 'package:capstone/authController.dart';
import 'package:capstone/authentication/appUser.dart';
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
  var selectedCollege;
  var selectedMajor;
  var selectedGrade = '학년을 선택해주세요'.obs;
  var selectedInfo = '대학교와 학과를 선택해주세요'.obs;

  List<String> universities = [
    '서울대학교',
    '연세대학교',
    '고려대학교',
    '성균관대학교',
    '한양대학교',
    '서강대학교',
    '중앙대학교',
    '경희대학교',
    '한국외국어대학교',
    '이화여자대학교',
    '동국대학교',
    '서울시립대학교',
    '성신여자대학교',
    '중앙승가대학교',
    '숙명여자대학교',
    '건국대학교',
    '서울여자대학교',
    '한성대학교',
    '서울과학기술대학교',
    '동덕여자대학교',
    '백석대학교',
    '가톨릭대학교',
    '한국성서대학교',
    '세종대학교',
    '숭실대학교',
    '서울교육대학교',
    '서울기독대학교',
    '서울장신대학교',
    '한국체육대학교',
    '한국예술종합학교',
    '서울시립대학교',
    '서울과학기술대학교',
    '강원대학교',
    '강원대학교(삼척)',
    '강원대학교(도계)',
    '한림대학교',
    '춘천교육대학교',
    '한림성심대학교',
    '강릉원주대학교',
    '연세대학교(원주)',

    // ... 추가 대학교
  ];

  Map<String, List<String>> collegeDepartmentMap = {
    '경영대학': ['경영학과', '경제학과', '국제무역학과'],
    '인문대학': ['국어국문학과', '영어영문학과', '중어중문학과'],
    '사회과학대학': ['사회학과', '정치외교학과', '행정학과'],
    '자연과학대학': ['수학과', '물리학과', '화학과'],
    '예술대학': ['음악학과', '미술학과', '공예학과'],
    '체육대학': ['체육학과', '스포츠건강과학과', '레저스포츠학과'],
    '의과대학': ['의학과', '간호학과', '치의학과'],
    '약학대학': ['약학과'],
    '사범대학': ['국어교육과', '영어교육과', '수학교육과'],
    'IT대학': ['컴퓨터공학과', '정보보호학과', '소프트웨어학과'],
    '공과대학': ['기계공학과', '전기전자공학과', '화학공학과'],
    '교육대학': ['교육학과', '유아교육과', '특수교육과'],
    '자유전공학부': ['자유전공학부'],
    '생명과학대학': ['생명과학과', '식품영양학과', '바이오융합기술학과'],
    '문화예술대학': ['문화예술학과', '문화콘텐츠학과', '문화관광학과'],
    '사회복지대학': ['사회복지학과', '사회복지시스템학과', '사회복지정책학과'],
    '경영정보대학': ['경영정보학과', '경영정보시스템학과', '경영정보통계학과'],
    '법학대학': ['법학과'],
    '공공인재대학': ['공공인재학과', '공공인재경영학과', '공공인재정책학과'],
    '미디어커뮤니케이션대학': ['미디어커뮤니케이션학과', '미디어커뮤니케이션영상학과', '미디어커뮤니케이션광고홍보학과'],
    '융합과학대학': ['융합과학학과', '융합과학데이터사이언스학과', '융합과학데이터테크학과'],
    '국제어문대학': ['국제어문학과', '국제어문중국학과', '국제어문일본학과'],

    // 다른 단과대학과 학과도 이곳에 추가
  };

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
    if (selectedUniv != null &&
        selectedCollege != null &&
        selectedMajor != null) {
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
        timestamp: Timestamp.now(),
        avatar: avatarUrl,
      );

      await users.doc(userCredential.user!.uid).set(appUser.toMap());
      snackBar('회원가입', '회원가입에 성공하였습니다.');
      notificationController.saveNotificationToFirestore(
          appUser.uid, '회원가입을 축하드려요!', '300QU를 적립해드렸어요.', '');

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
