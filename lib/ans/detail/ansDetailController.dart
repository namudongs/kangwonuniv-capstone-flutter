import 'package:capstone/authController.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsDetailController extends GetxController {
  final String articleId;
  var articleData = Rxn<Map<String, dynamic>>();
  var answersData = RxList<dynamic>([]);
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final NotificationController notificationController =
      Get.find<NotificationController>();
  final AuthController authController = Get.find<AuthController>();

  AnsDetailController(this.articleId);

  @override
  void onInit() {
    super.onInit();
    articleData.bindStream(getArticleStream(articleId)); // 실시간으로 글 데이터를 바인딩합니다
    answersData.bindStream(getAnswersStream(articleId)); // 실시간으로 답변 데이터를 바인딩합니다
  }

  Stream<Map<String, dynamic>?> getArticleStream(String articleId) {
    return articles.doc(articleId).snapshots().map((snapshot) {
      var data = snapshot.data() as Map<String, dynamic>?;
      // 이미지 URL을 포함하는 'images' 필드를 처리 (필드가 없다면 빈 배열로 초기화)
      data?['images'] = data['images'] ?? [];
      return data;
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

  // ignore: non_constant_identifier_names
  Future<void> is_adopted(String articleId, String answerId) async {
    final DocumentReference articleRef = articles.doc(articleId);
    final DocumentReference answerRef =
        articles.doc(articleId).collection('answer').doc(answerId);

    try {
      final DocumentSnapshot articleSnapshot = await articleRef.get();
      final Map<String, dynamic> articleData =
          articleSnapshot.data() as Map<String, dynamic>? ?? {};
      final Map<String, dynamic> answerData =
          (await answerRef.get()).data() as Map<String, dynamic>? ?? {};

      final String? currentUserId = appUser?.uid;
      final String? writerId = articleData['user']['uid'];
      final String? answerWriterId = answerData['user']['uid'];

      if (currentUserId == null) {
        snackBar('오류', '사용자 정보를 찾을 수 없습니다.');
        return;
      }

      if (currentUserId == writerId) {
        await articleRef.update({'is_adopted': true});
        await answerRef.update({'is_adopted': true});

        notificationController.sendPushNotification(answerWriterId!,
            "답변이 채택되었습니다!", "보상으로 50QU를 적립해드렸어요.", articleId, 'answer', '', '');
        notificationController.updateNotifications(appUser!.uid);
        AuthController authController = Get.find<AuthController>();
        authController.increaseUserQu(answerWriterId, 50);

        snackBar('성공', '채택되었습니다.');
      }
    } catch (e) {
      snackBar('오류', '채택 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> updateLike(String articleId) async {
    final String? currentUserId = appUser?.uid;
    if (currentUserId == null) {
      snackBar('오류', '사용자 정보를 찾을 수 없습니다.');
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
      snackBar('오류', '좋아요 처리 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> quDelete(String articleId) async {
    final WriteBatch batch = firestore.batch();

    try {
      // Firestore에서 질문 문서를 가져옴
      DocumentSnapshot questionSnapshot = await articles.doc(articleId).get();
      Map<String, dynamic>? data =
          questionSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        if (data['qu'] > 0) {
          var increaseAmount = data['qu'] * 1;
          authController.increaseUserQu(appUser!.uid, increaseAmount);
        }
        // 질문의 이미지 삭제
        List<dynamic> questionImages = data['images'] ?? [];
        await _deleteImagesFromStorage(questionImages);

        // Firestore에서 답변들을 삭제하며 각 답변의 이미지도 삭제
        final CollectionReference answersRef =
            articles.doc(articleId).collection('answer');
        final QuerySnapshot answersSnapshot = await answersRef.get();

        for (var answerDoc in answersSnapshot.docs) {
          // 답변 문서에서 이미지 정보 가져오기
          Map<String, dynamic>? answerData =
              answerDoc.data() as Map<String, dynamic>?;
          List<dynamic> answerImages = answerData?['images'] ?? [];
          await _deleteImagesFromStorage(answerImages);

          // 답변 문서 삭제
          batch.delete(answerDoc.reference);
        }

        // 질문 문서 삭제
        batch.delete(articles.doc(articleId));
        await batch.commit();
      }

      authController.increaseUserQu(appUser?.uid ?? '', 50);

      snackBar('성공', '질문과 모든 답변이 삭제되었습니다.');
      Get.offAll(() => BottomNavBar());
      BottomNavBarController bottomNavBarController =
          Get.find<BottomNavBarController>();
      Get.find<AuthController>().fetchUserData();
      bottomNavBarController.goToAnsPage();
    } catch (e) {
      // 예외 처리
      snackBar('오류', '질문 삭제 중 오류 발생: $e');
      print(e);
    }
  }

  Future<void> ansDelete(String articleId, String answerId) async {
    try {
      // 답변 문서 가져오기
      DocumentSnapshot answerSnapshot = await firestore
          .collection('articles')
          .doc(articleId)
          .collection('answer')
          .doc(answerId)
          .get();

      Map<String, dynamic>? data =
          answerSnapshot.data() as Map<String, dynamic>?;
      if (data != null) {
        // 이미지 삭제
        List<dynamic> images = data['images'] ?? [];
        await _deleteImagesFromStorage(images);
      }

      // 답변 문서 삭제
      await firestore
          .collection('articles')
          .doc(articleId)
          .collection('answer')
          .doc(answerId)
          .delete();

      // 답변 카운트 감소
      await firestore
          .collection('articles')
          .doc(articleId)
          .update({'answers_count': FieldValue.increment(-1)});

      answersData.removeWhere((answer) => answer['id'] == answerId);
      snackBar('성공', '답변이 삭제되었습니다.');
      AuthController authController = Get.find<AuthController>();
      await authController.decreaseUserQu(appUser?.uid ?? '', 40);
      await authController.fetchUserData();
    } catch (e) {
      snackBar('오류', '답변 삭제 중 오류 발생: $e');
    }
  }

  Future<void> _deleteImagesFromStorage(List<dynamic> images) async {
    for (var img in images) {
      if (img is Map<String, dynamic>) {
        String? filePath = img['fileName'];
        if (filePath != null) {
          try {
            await FirebaseStorage.instance.ref('uploads/$filePath').delete();
          } catch (e) {
            print('Error deleting file: $e');
          }
        }
      }
    }
  }
}
