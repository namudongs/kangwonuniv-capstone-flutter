import 'package:capstone/components/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class QuEditController extends GetxController {
  final String articleId;
  RxString title = ''.obs;
  RxString content = ''.obs;
  RxString category = ''.obs;

  QuEditController(this.articleId);

  @override
  void onInit() {
    super.onInit();
    getArticle();
  }

  Future<void> getArticle() async {
    final articleSnapshot = await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .get();

    if (articleSnapshot.exists) {
      final data = articleSnapshot.data() as Map<String, dynamic>;
      title.value = data['title'];
      content.value = data['content'];
      category.value = data['category'];
    }
  }

  Future<void> saveForm() async {
    if (title.value.isEmpty) {
      snackBar(
        '질문 수정 실패',
        '제목을 입력해주세요.',
      );
      return;
    }
    if (content.value.isEmpty) {
      snackBar(
        '질문 수정 실패',
        '내용을 입력해주세요.',
      );
      return;
    }
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .update({'title': title.value, 'content': content.value});

    Get.back();
  }
}
