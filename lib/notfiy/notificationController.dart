// ignore_for_file: avoid_print, empty_catches

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationController extends GetxController {
  // 메시징 서비스 기본 객체 생성
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  @override
  void onInit() async {
    // TODO: implement onInit
    /// 첫 빌드시, 권한 확인하기
    /// 아이폰은 무조건 받아야 하고, 안드로이드는 상관 없음. 따로 유저가 설정하지 않는 한,
    /// 자동 권한 확보 상태
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // 한번 이걸 프린트해서 콘솔에서 확인해봐도 된다.
    print(settings.authorizationStatus);
    // _getToken();
    // _onMessage();
    super.onInit();
  }

  /// 디바이스 고유 토큰을 얻기 위한 메소드, 처음 한번만 사용해서 토큰을 확보하자.
  /// 이는 파이어베이스 콘솔에서 손쉽게 디바이스에 테스팅을 할 때 쓰인다.
  void _getToken() async {
    String? token = await _messaging.getToken();
    try {
      print(token);
    } catch (e) {}
  }

  void saveDeviceToken(String userId) async {
    String? token = await _messaging.getToken();
    print("토큰이 변경되었습니다: $token");
    var tokenRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tokens')
        .doc('token');

    await tokenRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(), // 토큰 생성 시간
      'platform': Platform.operatingSystem // 플랫폼 정보
    });
  }
}
