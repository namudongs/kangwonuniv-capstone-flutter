import 'dart:io';

import 'package:capstone/components/chatMessage.dart';
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
      // 이미지 URL을 저장할 리스트
      List<String> imageUrls = [];

      // 선택된 모든 이미지를 업로드하고 URL을 가져옴
      for (var image in selectedImages) {
        Map<String, String> fileInfo = await uploadFile(image);
        if (fileInfo['url']!.isNotEmpty) {
          imageUrls.add(fileInfo['url']!); // 이미지 URL을 리스트에 추가
        }
      }

      // 메시지 객체에 이미지 URL 리스트 추가
      message.images.addAll(imageUrls);

      // Firestore에 메시지 저장
      await _firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(message.toMap());

      String receiverId = message.receiverId;
      NotificationController notificationController = Get.find();
      await notificationController.sendPushNotification(
          receiverId, "새 채팅 메시지", "메시지가 도착했습니다", chatRoomId);

      // 선택된 이미지 리스트 초기화
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
