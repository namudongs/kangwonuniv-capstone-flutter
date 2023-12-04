import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  // 사용자 계정 삭제
  Future<void> deleteUserAccount() async {
    // Firebase Authentication 인스턴스 가져오기
    final FirebaseAuth auth = FirebaseAuth.instance;
    // Firestore 인스턴스 가져오기
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // 현재 로그인된 사용자 가져오기
    User? user = auth.currentUser;
    if (user != null) {
      // 사용자 문서 참조
      DocumentReference userDocRef =
          firestore.collection('users').doc(user.uid);

      // 'tokens' 콜렉션 삭제
      await deleteCollection(userDocRef.collection('tokens'));

      // 'notifications' 콜렉션이 존재하는지 확인 후 삭제
      var notificationsCollection = userDocRef.collection('notifications');
      var notificationsExist = await collectionExists(notificationsCollection);
      if (notificationsExist) {
        await deleteCollection(notificationsCollection);
      }

      // 사용자 문서 삭제
      await userDocRef.delete();

      // Firebase Authentication에서 사용자 탈퇴
      await user.delete();
    }
  }

// 특정 콜렉션의 모든 문서를 삭제하는 함수
  Future<void> deleteCollection(CollectionReference collection) async {
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

// 콜렉션이 존재하는지 확인하는 함수
  Future<bool> collectionExists(CollectionReference collection) async {
    var querySnapshot = await collection.limit(1).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // SignOut
  Future<void> signOut() async {
    // Firebase Authentication 인스턴스 가져오기
    final FirebaseAuth auth = FirebaseAuth.instance;
    // 현재 로그인된 사용자 가져오기
    User? user = auth.currentUser;
    if (user != null) {
      // Firebase Authentication에서 사용자 로그아웃
      await auth.signOut();
    }

    // 파이어스토어에서 사용자 문서 삭제
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(user!.uid).delete();
  }
}
