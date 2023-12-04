import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  Future<void> deleteUserAccount() async {
    // Firebase Authentication 인스턴스 가져오기
    final FirebaseAuth auth = FirebaseAuth.instance;
    // Firestore 인스턴스 가져오기
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 현재 로그인된 사용자 가져오기
    User? user = auth.currentUser;
    if (user != null) {
      // Firestore에서 사용자 문서 삭제
      await firestore.collection('users').doc(user.uid).delete();

      // Firebase Authentication에서 사용자 탈퇴
      await user.delete();
    }
  }
}
