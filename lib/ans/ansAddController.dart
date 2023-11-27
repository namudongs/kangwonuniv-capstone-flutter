import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsAddController extends GetxController {
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');
  RxString content = ''.obs;
  String articleId;

  AnsAddController(this.articleId);

  Future<void> saveForm(String articleId) async {
    if (content.value.isEmpty) {
      Get.snackbar('오류', '답변 내용을 입력해주세요', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .collection('answer')
          .add({
        'content': content.value,
        'created_at': Timestamp.now(),
        'is_adopted': false,
        'like': 0,
        'user': {
          'uid': appUser!.uid,
          'name': appUser!.userName,
          'university': appUser!.university,
          'major': appUser!.major,
          'grade': appUser!.grade,
        },
      });

      await articles.doc(articleId).update({
        'answers_count': FieldValue.increment(1),
      });
      Get.back();
      snackBar('성공', '답변이 추가되었습니다.');
      content.value = '';
    } catch (e) {
      snackBar('오류', '답변 추가 중 오류가 발생했습니다: $e');
    }
  }
}
