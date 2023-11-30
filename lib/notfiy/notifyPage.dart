// ignore_for_file: avoid_print, file_names

import 'package:capstone/ans/ansDetailPage.dart';
import 'package:capstone/main.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final NotificationController notificationController =
      NotificationController();

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    notificationController.clearBadge();
  }

  @override
  Widget build(BuildContext context) {
    // 여기서 사용자 ID를 어떻게 처리할지는 앱의 나머지 부분에 달려있습니다.
    String userId = appUser?.uid ?? '이름 없음';

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: notificationController.fetchNotifications(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('오류가 발생했습니다.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('알림이 없습니다.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var notification = snapshot.data![index];
                String formattedTime =
                    formatTimestamp(notification['timestamp']);
                return Container(
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
                      if (notification['articleId'] != '') {
                        Get.to(AnsDetailPage(
                            articleId: notification['articleId']));
                      } else {
                        return;
                      }
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
