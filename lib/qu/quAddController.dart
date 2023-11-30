// ignore_for_file: file_names

import 'package:capstone/ans/ansDetailPage.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/qu/categoryController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuAddController extends GetxController {
  var title = ''.obs;
  var content = ''.obs;
  var tag = ''.obs;
  var category = '카테고리'.obs;
  var isLoading = false.obs;

  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final CategoryController categoryController = Get.find<CategoryController>();

  void updateCategory(String newCategory) {
    category.value = newCategory;
  }

  Future<void> saveForm() async {
    if (isLoading.value) return;
    isLoading.value = true;

    if (content.value.isEmpty) {
      snackBar('오류', '질문 내용을 입력해주세요');
      return;
    } else if (category.value == categoryController.selectedCategory.value) {
      snackBar('오류', '카테고리를 선택해주세요');
      return;
    } else {
      try {
        DocumentReference docRef = await articles.add({
          'title': title.value,
          'content': content.value,
          'tag': tag.value,
          'created_at': Timestamp.now(),
          'answers_count': 0,
          'category': categoryController.selectedCategory.value,
          'like': 0,
          'likes_uid': [],
          'is_adopted': false,
          'qu': 0,
          'user': {
            'uid': appUser!.uid,
            'name': appUser!.userName,
            'university': appUser!.university,
            'major': appUser!.major,
            'grade': appUser!.grade,
            'avatar': appUser!.avatar,
          },
        });

        categoryController.updateCategory('카테고리');
        title.value = '';
        content.value = '';
        tag.value = '';

        Get.back();
        BottomNavBarController bottomNavBarController =
            Get.find<BottomNavBarController>();
        bottomNavBarController.goToAnsPage();
        Get.to(() => AnsDetailPage(articleId: docRef.id));

        snackBar('성공', '질문이 등록되었습니다.');
        isLoading.value = false;
      } catch (e) {
        snackBar('실패', '오류가 발생했습니다. $e');
      }
    }
  }
}
