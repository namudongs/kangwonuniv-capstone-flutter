import 'dart:io';

import 'package:capstone/authController.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AnsAddController extends GetxController {
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');
  final NotificationController notificationController =
      Get.find<NotificationController>();
  RxString content = ''.obs;
  String articleId;
  var isLoading = false.obs;
  var selectedImages = <XFile>[].obs;

  AnsAddController(this.articleId);

  void addImage(XFile image) {
    selectedImages.add(image);
  }

  void removeImage(XFile image) {
    selectedImages.remove(image);
  }

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
          'avatar': appUser!.avatar,
        },
      });

      await users.doc(appUser!.uid).update({
        'answers': FieldValue.arrayUnion([answerRef.id])
      });

      await articles.doc(articleId).update({
        'answers_count': FieldValue.increment(1),
        'user_answers_uids': FieldValue.arrayUnion([appUser!.uid])
      });

      // 선택된 이미지를 Firebase Storage에 업로드하고 URL을 가져옴
      List<Map<String, dynamic>> uploadedImages = [];
      for (var image in selectedImages) {
        Map<String, String> fileInfo = await uploadFile(image);
        if (fileInfo['url']!.isNotEmpty) {
          uploadedImages.add({
            'url': fileInfo['url']!,
            'fileName': fileInfo['fileName']!,
            // 여기에 추가 이미지 정보를 넣을 수 있습니다.
          });
        }
      }

      // Firestore 문서에 이미지 정보 업데이트
      if (uploadedImages.isNotEmpty) {
        await answerRef.update({'images': uploadedImages});
      }

      // 질문 문서에서 사용자 UID 조회
      DocumentSnapshot articleSnapshot = await articles.doc(articleId).get();
      String questionUserId = articleSnapshot['user']['uid'];
      print("질문자 UID: $questionUserId");

      // 푸시 알림 전송
      await notificationController.sendPushNotification(questionUserId,
          "답변이 달렸어요!", "도움이 되었다면 채택을 눌러주세요.", articleId, 'answer', '', '');

      print('알림 전송 성공');

      Get.back();
      snackBar('성공', '답변이 추가되었습니다.');
      AuthController authController = Get.find<AuthController>();
      authController.increaseUserQu(appUser!.uid, 40);
      authController.fetchUserData();
      notificationController.saveNotificationToFirestore(appUser!.uid,
          "답변을 등록하셨습니다.", "답변이 채택되면 알림을 드릴게요!", articleId, '', '');
      notificationController.updateNotifications(appUser!.uid);

      isLoading.value = false;
      content.value = '';
    } catch (e) {
      snackBar('오류', '답변 추가 중 오류가 발생했습니다: $e');
    }
  }

  Future<void> uploadFileToFirebaseStorage(String articleId, XFile file) async {
    String fileName = file.name;
    String filePath = 'articles/$articleId/$fileName';
    File fileToUpload = File(file.path);

    try {
      // 파일을 Firebase Storage에 업로드
      await FirebaseStorage.instance.ref(filePath).putFile(fileToUpload);

      // 업로드된 파일의 URL 가져오기
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      // Firestore에 파일 정보 저장
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .update({
        'files': FieldValue.arrayUnion([
          {'url': downloadURL, 'fileName': fileName, 'fileType': file.mimeType}
        ])
      });
    } catch (e) {
      print(e);
      // 오류 처리
    }
  }

  Future<Map<String, String>> uploadFile(XFile file) async {
    String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
    String filePath = 'uploads/$fileName';
    File fileToUpload = File(file.path);

    try {
      // 파일을 Firebase Storage에 업로드
      await FirebaseStorage.instance.ref(filePath).putFile(fileToUpload);

      // 업로드된 파일의 URL 가져오기
      String downloadURL =
          await FirebaseStorage.instance.ref(filePath).getDownloadURL();

      // fileName과 downloadURL 반환
      return {'fileName': fileName, 'url': downloadURL};
    } catch (e) {
      print('Error uploading file: $e');
      return {'fileName': '', 'url': ''};
    }
  }
}
