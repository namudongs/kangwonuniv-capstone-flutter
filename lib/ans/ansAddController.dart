import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsAddController extends GetxController {
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');
  final NotificationController notificationController =
      Get.find<NotificationController>();
  RxString content = ''.obs;
  String articleId;
  var isLoading = false.obs; // 상태 변수 (Observable)

  AnsAddController(this.articleId);

  Future<void> saveForm(String articleId) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    if (content.value.isEmpty) {
      Get.snackbar('오류', '답변 내용을 입력해주세요', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    try {
      if (isLoading.value) return;
      isLoading.value = true;

      DocumentReference answerRef = await FirebaseFirestore.instance
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

      await users.doc(appUser!.uid).update({
        'answers': FieldValue.arrayUnion([answerRef.id])
      });

      await articles.doc(articleId).update({
        'answers_count': FieldValue.increment(1),
        'user_answers_uids': FieldValue.arrayUnion([appUser!.uid])
      });

      // 질문 문서에서 사용자 UID 조회
      DocumentSnapshot articleSnapshot = await articles.doc(articleId).get();
      String questionUserId = articleSnapshot['user']['uid'];
      print("질문자 UID: $questionUserId");

      // 푸시 알림 전송
      await notificationController.sendPushNotification(
          questionUserId, "알림이 도착했어요", "새로운 답변이 달렸습니다!", articleId);

      print('알림 전송 성공');

      Get.back();
      snackBar('성공', '답변이 추가되었습니다.');
      isLoading.value = false;
      content.value = '';
    } catch (e) {
      snackBar('오류', '답변 추가 중 오류가 발생했습니다: $e');
    }
  }
}
