// ignore_for_file: avoid_print, file_names

import 'package:capstone/ans/detail/ansDetailPage.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final NotificationController notificationController =
      Get.put(NotificationController());

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: Obx(() {
        // 알림 목록이 비어있는지 체크
        if (notificationController.notifications.isEmpty) {
          return const Center(child: Text('알림이 없습니다.'));
        } else {
          return ListView.builder(
            itemCount: notificationController.notifications.length,
            itemBuilder: (context, index) {
              var notification = notificationController.notifications[index];
              if (notification['timestamp'] == null) {
                return const SizedBox.shrink();
              }
              String formattedTime = formatTimestamp(notification['timestamp']);
              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    notificationController.deleteAllNotificationsWithTimestamp(
                        userId, notification['timestamp']);
                    notificationController.fetchNotifications(userId);
                    snackBar('알림 삭제', '알림이 삭제되었습니다.');
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListTile(
                    leading: const Icon(Icons.notifications,
                        color: Color.fromARGB(255, 157, 0, 0)), // 아이콘 추가
                    title: Text(
                      notification['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14), // 제목 스타일 조정
                    ),
                    subtitle: Text(
                      notification['message'],
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(formattedTime,
                        style:
                            const TextStyle(color: Colors.grey)), // 날짜 스타일 조정
                    onTap: () {
                      if (notification['articleId'] != '' ||
                          notification['articleId'] == 'answer') {
                        Get.to(AnsDetailPage(
                            articleId: notification['articleId']));
                      } else {
                        return;
                      }
                    },
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
