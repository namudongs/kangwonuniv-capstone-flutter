import 'dart:io';

import 'package:capstone/components/chatMessage.dart';
import 'package:capstone/main.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var selectedImages = <XFile>[].obs;

  void addImage(XFile image) {
    selectedImages.add(image);
  }

  void removeImage(XFile image) {
    selectedImages.remove(image);
  }

  Stream<List<ChatMessage>> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  Future<void> sendChatMessage(String chatRoomId, ChatMessage message) async {
    try {
      List<String> imageUrls = [];

      for (var image in selectedImages) {
        Map<String, String> fileInfo = await uploadFile(image);
        if (fileInfo['url']!.isNotEmpty) {
          imageUrls.add(fileInfo['url']!);
        }
      }

      // 새로운 리스트를 생성하여 images 필드에 할당
      message = message.copyWith(images: imageUrls);

      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());

      NotificationController notificationController = Get.find();
      await notificationController.sendPushNotification(
        message.receiverId,
        '새 채팅 메세지',
        '채팅을 확인해 주세요.',
        chatRoomId,
        'chat',
      );
      selectedImages.clear();
    } catch (e) {
      print('Error sending chat message: $e');
    }
  }

  Future<void> createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfo) async {
    try {
      await _firestore.collection('chats').doc(chatRoomId).set(chatRoomInfo);
    } catch (e) {
      print('Error creating chat room: $e');
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
