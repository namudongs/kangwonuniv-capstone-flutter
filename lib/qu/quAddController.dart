import 'package:capstone/main.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuAddController extends GetxController {
  var title = ''.obs;
  var content = ''.obs;
  var tag = ''.obs;
  var category = '카테고리'.obs;

  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  void updateCategory(String newCategory) {
    category.value = newCategory;
  }

  Future<void> saveForm() async {
    // Firestore에 데이터 저장하는 로직
    try {
      await articles.add({
        'title': title.value,
        'content': content.value,
        'tag': tag.value, // 필요한 경우
        'created_at': Timestamp.now(),
        'answers_count': 0,
        'category': category.value,
        'user': {
          'uid': appUser!.uid,
          'name': appUser!.userName,
          'university': appUser!.university,
          'major': appUser!.major,
          'grade': appUser!.grade,
        },
      });
      // 성공적으로 저장되었을 때의 로직, 예를 들어 알림 표시
      print('성공적으로 저장되었습니다.');
      Get.back();
    } catch (e) {
      print('에러가 발생했습니다.');
    }
  }
}
