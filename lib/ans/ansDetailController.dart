import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsDetailController extends GetxController {
  final String articleId;
  var articleData = Rxn<Map<String, dynamic>>();
  var answersData = RxList<dynamic>([]);
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  AnsDetailController(this.articleId);

  @override
  void onInit() {
    super.onInit();
    articleData.bindStream(getArticleStream(articleId)); // 실시간으로 글 데이터를 바인딩합니다
    answersData.bindStream(getAnswersStream(articleId)); // 실시간으로 답변 데이터를 바인딩합니다
  }

  Stream<Map<String, dynamic>?> getArticleStream(String articleId) {
    return articles.doc(articleId).snapshots().map((snapshot) {
      return snapshot.data() as Map<String, dynamic>?;
    });
  }

  Stream<List<dynamic>> getAnswersStream(String articleId) {
    return articles
        .doc(articleId)
        .collection('answer')
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();
    });
  }

  Future<void> quDelete(String articleId) async {
    try {
      await firestore.collection('articles').doc(articleId).delete();
      Get.back();
    } catch (e) {
      Get.snackbar('오류', '질문 삭제 중 오류 발생: $e');
    }
  }

  Future<void> ansDelete(String articleId, String answerId) async {
    try {
      await firestore
          .collection('articles')
          .doc(articleId)
          .collection('answer')
          .doc(answerId)
          .delete();

      await firestore
          .collection('articles')
          .doc(articleId)
          .update({'answers_count': FieldValue.increment(-1)});

      answersData.removeWhere((answer) => answer['id'] == answerId);
      Get.snackbar('성공', '답변이 삭제되었습니다.');
    } catch (e) {
      Get.snackbar('오류', '답변 삭제 중 오류 발생: $e');
    }
  }
}
