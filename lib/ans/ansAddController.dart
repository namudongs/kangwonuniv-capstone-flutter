import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

// 질문 문서에서 사용자 UID 조회
      DocumentSnapshot articleSnapshot = await articles.doc(articleId).get();
      String questionUserId = articleSnapshot['user']['uid'];
      print("질문자 UID: $questionUserId");

      // 푸시 알림 전송
      await sendPushNotification(questionUserId, "새로운 답변이 달렸습니다!");

      Get.back();
      snackBar('성공', '답변이 추가되었습니다.');
      content.value = '';
    } catch (e) {
      snackBar('오류', '답변 추가 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> sendPushNotification(String userId, String message) async {
    const String functionUrl =
        'https://us-central1-capstone-flutter-eb3c2.cloudfunctions.net/sendPushNotification'; // Firebase 함수 URL

    try {
      final response = await http.post(
        Uri.parse(functionUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'userId': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        print("알림 전송에 성공했습니다.");
      } else {
        print("알림 전송에 실패했습니다.");
      }
    } catch (e) {
      print("알림 전송 실패: $e");
    }
  }
}
