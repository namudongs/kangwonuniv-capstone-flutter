// ignore_for_file: avoid_print, empty_catches

import 'dart:io';
import 'dart:ui';

import 'package:capstone/ans/ansDetailPage.dart';
import 'package:capstone/components/bottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationController extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  @override
  void onInit() async {
    requestPermission();
    _initializeNotification();
    _listenForTokenRefresh();
    super.onInit();
  }

  void _initializeNotification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (Platform.isAndroid) {
        // 앱이 포어그라운드에 있을 때만 사용자 정의 알림 표시
        // 안드로이드의 경우 포어그라운드 알림이 자동으로 표시되지 않음
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
      print('앱이 백그라운드에 있을 때, 알림을 탭하여 앱을 열었습니다!');

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

    print('이제 푸시 알림을 받을 수 있습니다.');
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'answer') {
      String articleId = message.data['articleId'];
      print('답변 알림을 받았습니다: $articleId');
      // 앱 내 해당 질문 페이지로 이동
      Get.offAll(() => BottomNavBar());
      BottomNavBarController bottomNavBarController =
          Get.put(BottomNavBarController());
      bottomNavBarController.goToAnsPage();
      Get.to(AnsDetailPage(articleId: articleId));
    } else if (message.data['type'] == 'adopted') {
      String articleId = message.data['articleId'];
      print('채택 알림을 받았습니다: $articleId');
      // 앱 내 해당 질문 페이지로 이동
      Get.offAll(() => BottomNavBar());
      BottomNavBarController bottomNavBarController =
          Get.put(BottomNavBarController());
      bottomNavBarController.goToAnsPage();
      Get.to(AnsDetailPage(articleId: articleId));
    } else {
      print('알 수 없는 알림을 받았습니다: ${message.data}');
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

  Future<void> sendPushNotification(
      String userId, String title, String message, String id) async {
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
          'type': 'answer',
          'articleId': id,
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
