import 'package:capstone/authentication/appUser.dart';
import 'package:capstone/authentication/mainPage.dart';
import 'package:capstone/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      Get.snackbar('성공', '${appUser?.userName}님 환영합니다!',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('실패', '사용자 정보를 불러오는데에 오류가 발생했습니다. $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    fetchUserData();
  }

  void signOut() async {
    await _auth.signOut();
    Get.offAll(() => const MainPage());
  }

  bool get isUserLoggedIn => firebaseUser.value != null;
}
