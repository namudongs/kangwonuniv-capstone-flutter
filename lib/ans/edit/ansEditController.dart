import 'package:capstone/components/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AnsEditController extends GetxController {
  final String articleId;
  final String answerId;
  RxString content = ''.obs;

  AnsEditController(this.articleId, this.answerId);

  @override
  void onInit() {
    super.onInit();
    getAnswer();
  }

  Future<void> getAnswer() async {
    final answerSnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('answer')
        .doc(answerId)
        .get();

    if (answerSnapshot.exists) {
      final data = answerSnapshot.data() as Map<String, dynamic>;
      content.value = data['content'];
    }
  }

  Future<void> saveForm() async {
    if (content.value.isEmpty) {
      snackBar(
        '답변 수정 실패',
        '답변을 입력해주세요.',
      );
      return;
    }
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .collection('answer')
        .doc(answerId)
        .update({'content': content.value});

    Get.back();
  }
}
