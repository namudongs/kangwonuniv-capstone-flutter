// ignore_for_file: avoid_print, empty_catches

import 'dart:io';
import 'package:capstone/ans/detail/ansDetailPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationController extends GetxController {
  var badgeCount = 0.obs;
  var notifications = <Map<String, dynamic>>[].obs; // RxList로 알림 목록 관리

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  @override
  void onInit() async {
    await Firebase.initializeApp();
    requestPermission();
    _initializeNotification();
    _listenForTokenRefresh();

    if (Platform.isIOS) {
      // iOS 포어그라운드 알림 설정
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      print('iOS 포어그라운드 알림 설정');
    }

    var userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    await updateNotifications(userId);
    super.onInit();
  }

  void _initializeNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // 앱이 포어그라운드에 있을 때만 사용자 정의 알림 표시
      if (Platform.isAndroid) {
        if (message.notification != null &&
            message.notification!.title != null) {
          // FlutterLocalNotificationsPlugin을 사용하여 알림 표시
          flutterLocalNotificationsPlugin.show(
            message.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
              ),
              iOS: const DarwinNotificationDetails(),
            ),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 앱이 백그라운드에 있거나 포그라운드에 있을 때 알림 클릭
      _handleMessage(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          // 앱이 종료된 상태에서 알림 클릭으로 시작된 경우
          _handleMessage(message);
        }
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        if (message != null) {
          // 앱이 종료된 상태에서 알림 클릭으로 시작된 경우
          _handleMessage(message);
        }
      },
    );

    print('이제 푸시 알림을 받을 수 있습니다.');
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'answer') {
      String articleId = message.data['articleId'];
      print('답변 알림을 받았습니다: $articleId');
      incrementBadge();
      // 앱 내 해당 질문 페이지로 이동
      Get.offAll(() => BottomNavBar());
      BottomNavBarController bottomNavBarController =
          Get.put(BottomNavBarController());
      bottomNavBarController.goToAnsPage();
      Get.to(AnsDetailPage(articleId: articleId));
    } else if (message.data['type'] == 'adopted') {
      String articleId = message.data['articleId'];
      print('채택 알림을 받았습니다: $articleId');
      incrementBadge();
      // 앱 내 해당 질문 페이지로 이동
      Get.offAll(() => BottomNavBar());
      BottomNavBarController bottomNavBarController =
          Get.put(BottomNavBarController());
      bottomNavBarController.goToAnsPage();
      Get.to(AnsDetailPage(articleId: articleId));
    } else if (message.data['type'] == 'chat') {
      incrementBadge();
      // 앱 내 해당 질문 페이지로 이동
      print('알림 타입이 채팅입니다');
      Get.offAll(() => BottomNavBar());
      BottomNavBarController bottomNavBarController =
          Get.put(BottomNavBarController());
      bottomNavBarController.goToAnsPage();
    } else {
      print('알 수 없는 알림을 받았습니다: ${message.data}');
      incrementBadge();
    }
  }

  void _listenForTokenRefresh() {}

  Future<void> saveDeviceToken() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? currentUser = auth.currentUser;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    if (currentUser == null) {
      print("사용자가 로그인하지 않았습니다.");
      return;
    }

    try {
      // 현재 디바이스의 토큰 가져오기
      String? currentToken = await firebaseMessaging.getToken();
      if (currentToken == null) {
        print("현재 디바이스의 토큰을 가져올 수 없습니다.");
        return;
      }

      // Firestore에서 사용자의 토큰 문서 가져오기
      DocumentReference tokenRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('tokens')
          .doc('token');
      DocumentSnapshot tokenSnapshot = await tokenRef.get();

      if (tokenSnapshot.exists) {
        String? storedToken = tokenSnapshot['token'];
        // 현재 토큰과 저장된 토큰이 다른 경우 업데이트
        if (storedToken != currentToken) {
          await tokenRef.set({
            'token': currentToken,
            'createdAt': FieldValue.serverTimestamp(), // 토큰 생성 시간
            'platform': Platform.operatingSystem, // 플랫폼 정보
          });
          print("토큰이 업데이트되었습니다.");
        } else {
          print("토큰이 이미 최신 상태입니다.");
        }
      } else {
        print("토큰 문서가 존재하지 않습니다. 새로운 토큰을 저장합니다.");
        await tokenRef.set({
          'token': currentToken,
          'createdAt': FieldValue.serverTimestamp(),
          'platform': Platform.operatingSystem,
        });
      }
    } catch (e) {
      print("토큰 업데이트 중 오류 발생: $e");
    }
  }

  Future requestPermission() async {
    /// 첫 빌드시, 권한 확인하기
    /// 아이폰은 무조건 받아야 하고, 안드로이드는 상관 없음. 따로 유저가 설정하지 않는 한,
    /// 자동 권한 확보 상태
    // 한번 이걸 프린트해서 콘솔에서 확인해봐도 된다.
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('권한: ${settings.authorizationStatus}');
  }

  Future<void> sendPushNotification(String userId, String title, String message,
      String? id, String type, String? senderId, String? receiverId) async {
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
          'title': title,
          'message': message,
          'type': type,
          'articleId': id,
        }),
      );

      if (response.statusCode == 200) {
        print("알림 전송에 성공했습니다.");
        await saveNotificationToFirestore(
            userId, title, message, id, senderId, receiverId);
      } else {
        print("알림 전송에 실패했습니다.");
      }
    } catch (e) {
      print("알림 전송 실패: $e");
    }
  }

  Future<void> saveNotificationToFirestore(String userId, String title,
      String message, String? id, String? senderId, String? receiverId) async {
    String notificationId = DateTime.now().millisecondsSinceEpoch.toString();

    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .doc(notificationId)
          .set({
        'title': title,
        'message': message,
        'articleId': id,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("알림이 Firestore에 저장되었습니다.");
    } catch (e) {
      print("Firestore 저장 실패: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchNotifications(String userId) async {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();
    print('알림을 불러왔습니다.');
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  void incrementBadge() {
    badgeCount.value++; // 배지 카운트 증가
    FlutterAppBadger.updateBadgeCount(badgeCount.value); // 배지 업데이트
  }

  void clearBadge() {
    badgeCount.value = 0; // 배지 카운트 초기화
    FlutterAppBadger.removeBadge(); // 배지 제거
  }

  void deleteAllNotificationsWithTimestamp(
      String userId, Timestamp timeStamp) async {
    try {
      // 일치하는 타임스탬프를 가진 모든 문서를 조회합니다.
      var querySnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .where('timestamp', isEqualTo: timeStamp)
          .get();

      // 각 문서에 대해 삭제를 수행합니다.
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      await updateNotifications(userId);
      print("일치하는 모든 알림이 삭제되었습니다.");
    } catch (e) {
      print("알림 삭제 실패: $e");
    }
  }

  @override
  void dispose() {
    badgeCount.close();
    super.dispose();
  }

  Future<void> updateNotifications(String userId) async {
    if (userId.isNotEmpty) {
      // userId가 비어 있지 않은 경우에만 업데이트
      var updatedNotifications = await fetchNotifications(userId);
      notifications.assignAll(updatedNotifications); // RxList 업데이트
      print('알림을 업데이트했습니다.');
    } else {
      print('로그인 되어있지 않아 알림을 업데이트하지 못했습니다.');
    }
  }
}
