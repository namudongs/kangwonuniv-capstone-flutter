// ignore_for_file: file_names

import 'package:capstone/main.dart';
import 'package:capstone/qu/categoryController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuAddController extends GetxController {
  var title = ''.obs;
  var content = ''.obs;
  var tag = ''.obs;
  var category = '카테고리'.obs;

  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final CategoryController categoryController = Get.find<CategoryController>();

  void updateCategory(String newCategory) {
    category.value = newCategory;
  }

  Future<void> saveForm() async {
    if (content.value.isEmpty) {
      Get.snackbar('오류', '질문 내용을 입력해주세요', snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      await articles.add({
        'title': title.value,
        'content': content.value,
        'tag': tag.value,
        'created_at': Timestamp.now(),
        'answers_count': 0,
        'category': categoryController.selectedCategory.value,
        'like': 0,
        'likes_uid': [],
        'is_adopted': false,
        'user': {
          'uid': appUser!.uid,
          'name': appUser!.userName,
          'university': appUser!.university,
          'major': appUser!.major,
          'grade': appUser!.grade,
        },
      });

      categoryController.updateCategory('카테고리');
      title.value = '';
      content.value = '';
      tag.value = '';

      Get.back();
      Get.snackbar('성공', '질문이 등록되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('실패', '오류가 발생했습니다. $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
