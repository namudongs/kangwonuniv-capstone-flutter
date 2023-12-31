// ignore_for_file: file_names

import 'dart:io';

import 'package:capstone/ans/detail/ansDetailPage.dart';
import 'package:capstone/authController.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/qu/categoryController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class QuAddController extends GetxController {
  var usedQu = 0.obs;
  var title = ''.obs;
  var content = ''.obs;
  var tag = ''.obs;
  var category = '카테고리'.obs;
  var isLoading = false.obs;
  var selectedImages = <XFile>[].obs;

  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final CategoryController categoryController = Get.find<CategoryController>();
  final AuthController authController = Get.find<AuthController>();

  void setSelectedQu(int value) {
    usedQu.value = value;
    print('컨트롤러의 QU값: ${usedQu.value}');
    Get.back();
  }

  void updateCategory(String newCategory) {
    category.value = newCategory;
  }

  // 이미지 추가 함수
  void addImage(XFile image) {
    selectedImages.add(image);
  }

  // 이미지 제거 함수
  void removeImage(XFile image) {
    selectedImages.remove(image);
  }

  Future<void> saveForm() async {
    if (isLoading.value) return;
    isLoading.value = true;

    if (appUser!.qu < 50) {
      snackBar('실패', 'QU가 부족합니다. 질문을 등록할 수 없습니다.');
      return;
    } else if (usedQu > 0 && appUser!.qu < 50 + usedQu.value) {
      snackBar('실패', 'QU가 부족합니다. 질문을 등록할 수 없습니다.');
      return;
    }

    if (content.value.isEmpty) {
      snackBar('오류', '질문 내용을 입력해주세요');
      return;
    } else if (category.value == categoryController.selectedCategory.value) {
      snackBar('오류', '카테고리를 선택해주세요');
      return;
    } else {
      try {
        DocumentReference docRef = await articles.add({
          'title': title.value,
          'content': content.value,
          'tag': tag.value,
          'created_at': Timestamp.now(),
          'answers_count': 0,
          'category': categoryController.selectedCategory.value,
          'like': 0,
          'likes_uid': [],
          'is_adopted': false,
          'qu': usedQu.value,
          'images': [],
          'user': {
            'uid': appUser!.uid,
            'name': appUser!.userName,
            'university': appUser!.university,
            'major': appUser!.major,
            'grade': appUser!.grade,
            'avatar': appUser!.avatar,
          },
        });

        // 선택된 이미지를 Firebase Storage에 업로드하고 URL을 가져옴
        List<Map<String, dynamic>> uploadedImages = [];
        if (selectedImages.isNotEmpty) {
          // 이미지가 선택된 경우에만 실행
          for (var image in selectedImages) {
            Map<String, String> fileInfo = await uploadFile(image);
            if (fileInfo['url']!.isNotEmpty) {
              uploadedImages.add({
                'url': fileInfo['url']!,
                'fileName': fileInfo['fileName']!,
                // 추가 이미지 정보...
              });
            }
          }
        }

        // Firestore 문서에 이미지 정보 업데이트
        if (uploadedImages.isNotEmpty) {
          await docRef.update({'images': uploadedImages});
        }
        await authController.decreaseUserQu(appUser?.uid ?? '', 50);
        await authController.decreaseUserQu(appUser?.uid ?? '', usedQu.value);
        await authController.fetchUserData();
        notificationController.saveNotificationToFirestore(appUser?.uid ?? '',
            '질문을 등록하셨습니다.', '답변이 등록되면 알림을 드릴게요!', docRef.id, '', '');

        notificationController.updateNotifications(appUser!.uid);

        if (title.value.isEmpty || title.value == '') {
          notificationController.notifyInterestedUsers(
              categoryController.selectedCategory.value,
              docRef.id,
              content.value);
        }

        notificationController.notifyInterestedUsers(
            categoryController.selectedCategory.value, docRef.id, title.value);

        categoryController.updateCategory('카테고리');
        title.value = '';
        content.value = '';
        tag.value = '';
        selectedImages.clear();

        Get.offAll(() => BottomNavBar());
        BottomNavBarController bottomNavBarController =
            Get.find<BottomNavBarController>();
        bottomNavBarController.goToAnsPage();
        Get.to(() => AnsDetailPage(articleId: docRef.id));

        snackBar('성공', '질문이 등록되었습니다.');

        isLoading.value = false;
      } catch (e) {
        snackBar('실패', '오류가 발생했습니다. $e');
        isLoading.value = false;
      }
    }
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
  // 파일 이름이 null이면 대체 이름 사용
  String fileName =
      file.name ?? 'default_${DateTime.now().millisecondsSinceEpoch}';
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
