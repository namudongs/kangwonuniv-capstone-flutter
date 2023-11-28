import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>?>> getRecentArticlesStream() {
    return firestore
      .collection('articles')
      .orderBy('created_at', descending: true) // 내림차순 정렬
      .snapshots()
      .map((snapshot) {
        return snapshot.docs.map((doc) {
          return doc.data() as Map<String, dynamic>?;
        }).toList();
      });
  }
}
