// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:capstone/timetable/time_slot.dart';

Future<TimeSlot> loadRandomTimeSlot() async {
  // 파일에서 데이터를 읽습니다.
  String jsonString = await rootBundle.loadString('assets/lectureDB.json');

  // JSON 문자열을 Dart 맵의 리스트로 변환합니다.
  List<dynamic> lecturesList = jsonDecode(jsonString);

  // 랜덤한 인덱스를 선택합니다.
  Random random = Random();
  int randomIndex = random.nextInt(lecturesList.length);

  // 랜덤한 인덱스에 해당하는 데이터를 TimeSlot 객체로 변환합니다.
  TimeSlot randomTimeSlot = TimeSlot.fromJson(lecturesList[randomIndex]);

  return randomTimeSlot;
}
