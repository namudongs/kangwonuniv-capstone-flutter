import 'dart:io';
import 'package:capstone/components/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class QuEditController extends GetxController {
  final String articleId;
  RxString title = ''.obs;
  RxString content = ''.obs;
  RxString category = ''.obs;
  var selectedImages = <XFile>[].obs;
  var existingImages = <Map<String, dynamic>>[].obs;

  QuEditController(this.articleId);

  @override
  void onInit() {
    super.onInit();
    getArticle();
  }

  // 이미지 추가 함수
  void addImage(XFile image) {
    selectedImages.add(image);
  }

  // 이미지 제거 함수
  void removeImage(XFile image) {
    selectedImages.remove(image);
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
      existingImages.value =
          List<Map<String, dynamic>>.from(data['images'] ?? []);
    }
  }

  Future<void> saveForm() async {
    if (content.value.isEmpty) {
      snackBar('질문 수정 실패', '내용을 입력해주세요.');
      return;
    }

    // 새로운 이미지 업로드 및 URL 목록 생성
    List<Map<String, dynamic>> newImageUrls = [];
    for (XFile image in selectedImages) {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
      String imageUrl = await uploadImage(image, fileName); // 수정된 부분
      newImageUrls.add({'url': imageUrl, 'fileName': fileName}); // 수정된 부분
    }

    // Firestore 문서 업데이트
    await FirebaseFirestore.instance
        .collection('articles')
        .doc(articleId)
        .update({
      'title': title.value,
      'content': content.value,
      'images': FieldValue.arrayUnion(newImageUrls) // 기존 이미지 목록에 새로운 이미지 추가
    });

    Get.back();
  }

  Future<String> uploadImage(XFile image, String fileName) async {
    String filePath = 'uploads/$fileName';
    File fileToUpload = File(image.path);

    try {
      // Firebase Storage에 업로드
      await FirebaseStorage.instance.ref(filePath).putFile(fileToUpload);

      // 업로드된 파일의 URL 가져오기
      return await FirebaseStorage.instance.ref(filePath).getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<void> removeExistingImage(Map<String, dynamic> image) async {
    try {
      // Firebase Storage에서 이미지 삭제
      await FirebaseStorage.instance
          .ref('uploads/${image['fileName']}')
          .delete();

      // Firestore 문서에서 이미지 정보 제거
      await FirebaseFirestore.instance
          .collection('articles')
          .doc(articleId)
          .update({
        'images': FieldValue.arrayRemove([image])
      });

      // 로컬 목록에서 이미지 제거
      existingImages.remove(image);
    } catch (e) {
      print('Error removing image: $e');
    }
  }
}
