// ignore_for_file: prefer_const_constructors
import 'package:capstone/components/appUser.dart';
import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());

    // 사용자의 로그인 상태가 변경될 때마다 fetchUserData 호출
    ever(firebaseUser, handleAuthChanged);
  }

  void handleAuthChanged(User? user) {
    if (user != null) {
      // 사용자가 로그인한 경우, 사용자 데이터를 가져옵니다.
      fetchUserData();
      print('사용자 로그인됨');
    } else {
      // 사용자가 로그아웃한 경우, 관련 로직을 처리합니다.
      // 예: 상태 초기화, 다른 화면으로 이동 등
      print('사용자 로그아웃됨');
    }
  }

  Future<void> fetchUserData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    try {
      if (currentUser != null) {
        DocumentReference userRef =
            FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        DocumentSnapshot userSnapshot = await userRef.get();

        if (userSnapshot.exists) {
          appUser =
              AppUser.fromMap(userSnapshot.data()! as Map<String, dynamic>);
        }
      }
    } catch (e) {
      snackBar('실패', '사용자 정보를 불러오는데 오류가 발생했습니다. $e');
    }
  }

  Future<void> decreaseUserQu(String userId, int decreaseAmount) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'qu': FieldValue.increment(-decreaseAmount)});

      print('유저의 QU가 $decreaseAmount만큼 감소되었습니다.');
    } catch (e) {
      print('유저 큐 감소 실패: $e');
    }
  }

  Future<void> increaseUserQu(String userid, int increaseAmount) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userid)
          .update({'qu': FieldValue.increment(increaseAmount)});

      print('유저의 QU가 $increaseAmount만큼 증가되었습니다.');
    } catch (e) {
      print('유저 큐 증가 실패: $e');
    }
  }

  void signOut() async {
    await _auth.signOut();
    BottomNavBarController().goToHomePage();
    Get.offAll(() => MainPage());
  }

  bool get isUserLoggedIn => firebaseUser.value != null;
}
