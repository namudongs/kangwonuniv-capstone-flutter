import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>?>> getRecentArticlesStream() {
    return firestore
        .collection('articles')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id, // 문서 ID 추가
          ...doc.data()
        };
      }).toList();
    });
  }
}
