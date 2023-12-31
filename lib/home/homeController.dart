// ignore_for_file: avoid_print

import 'package:capstone/main.dart';
import 'package:capstone/qu/categoryController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CategoryController categoryController = Get.find();

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

  void selectCategory(String category) {
    saveCategory(category);
    Get.back(result: category);
  }

  void saveCategory(String category) async {
    String? uid = appUser?.uid;

    print(category);

    if (uid != null) {
      await firestore
          .collection('users')
          .doc(uid)
          .update({
            'interesting': category,
          })
          .then((_) => print("관심분야를 설정했습니다."))
          .catchError((error) => print("Failed to update category: $error"));
    }
  }
}
