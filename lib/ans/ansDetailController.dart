import 'package:capstone/main.dart';
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
      var answers = snapshot.docs.map((doc) {
        return {
          ...doc.data(),
          'id': doc.id,
        };
      }).toList();

      // 채택된 답변을 맨 위로 올립니다
      answers.sort((a, b) {
        if (a['is_adopted'] == true) {
          return -1;
        } else if (b['is_adopted'] == true) {
          return 1;
        }
        return 0;
      });

      return answers;
    });
  }

  Future<void> is_adopted(String articleId, String answerId) async {
    final DocumentReference articleRef = articles.doc(articleId);
    final DocumentReference answerRef =
        articles.doc(articleId).collection('answer').doc(answerId);

    try {
      final DocumentSnapshot articleSnapshot = await articleRef.get();
      final Map<String, dynamic> articleData =
          articleSnapshot.data() as Map<String, dynamic>? ?? {};
      final String? currentUserId = appUser?.uid;
      final String? writerId = articleData['user']['uid'];

      if (currentUserId == null) {
        Get.snackbar('오류', '사용자 정보를 찾을 수 없습니다.');
        return;
      }

      if (currentUserId == writerId) {
        await articleRef.update({'is_adopted': true});
        await answerRef.update({'is_adopted': true});
        Get.snackbar('성공', '채택되었습니다.');
      }
    } catch (e) {
      Get.snackbar('오류', '채택 중 오류가 발생했습니다: $e');
    }

    print('채택버튼클릭');
  }

  Future<void> updateLike(String articleId) async {
    final String? currentUserId = appUser?.uid;
    if (currentUserId == null) {
      Get.snackbar('오류', '사용자 정보를 찾을 수 없습니다.');
      return;
    }

    final DocumentReference articleRef = articles.doc(articleId);

    try {
      final DocumentSnapshot articleSnapshot = await articleRef.get();
      final Map<String, dynamic> articleData =
          articleSnapshot.data() as Map<String, dynamic>? ?? {};
      final List<dynamic> likesUid = articleData['likes_uid'] ?? [];

      if (likesUid.contains(currentUserId)) {
        // 좋아요 취소
        await articleRef.update({'like': FieldValue.increment(-1)});
        await articleRef.update({
          'likes_uid': FieldValue.arrayRemove([currentUserId])
        });
      } else {
        // 좋아요
        await articleRef.update({'like': FieldValue.increment(1)});
        await articleRef.update({
          'likes_uid': FieldValue.arrayUnion([currentUserId])
        });
      }
    } catch (e) {
      Get.snackbar('오류', '좋아요 처리 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> quDelete(String articleId) async {
    final WriteBatch batch = firestore.batch();

    try {
      final CollectionReference answersRef =
          articles.doc(articleId).collection('answer');
      final QuerySnapshot answersSnapshot = await answersRef.get();
      for (var doc in answersSnapshot.docs) {
        batch.delete(doc.reference);
      }

      batch.delete(articles.doc(articleId));
      await batch.commit();
      Get.back();
      Get.snackbar('성공', '질문과 모든 답변이 삭제되었습니다.');
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
      Get.snackbar('성공', '답변이 삭제되었습니다.', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('오류', '답변 삭제 중 오류 발생: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
