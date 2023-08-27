// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:capstone/timetable/lecture_slot.dart';

Future<List<LectureSlot>> loadAllTimeSlots() async {
  String jsonString =
      await rootBundle.loadString('assets/tuning_lectureDB.json');

  List<dynamic> lecturesList = jsonDecode(jsonString);

  List<LectureSlot> allTimeSlots =
      lecturesList.map((lecture) => LectureSlot.fromJson(lecture)).toList();

  return allTimeSlots;
}

List<String> convertSubjectTime(
    List<double> startTimes, List<double> endTimes) {
  List<String> result = [];

  for (int i = 0; i < startTimes.length; i++) {
    double start = startTimes[i];
    double end = endTimes[i];
    List<String> gyosiList = [];

    Map<String, List<double>> relevantMap;
    if (end % 1 != 0) {
      relevantMap = Map.fromEntries(
          convertTimeMap.entries.where((e) => e.key.contains('A')));
    } else {
      relevantMap = Map.fromEntries(
          convertTimeMap.entries.where((e) => !e.key.contains('A')));
    }

    String startGyosi = relevantMap.entries
        .firstWhere(
            (entry) => entry.value[0] <= start && start < entry.value[1])
        .key;
    String endGyosi = relevantMap.entries
        .firstWhere((entry) => entry.value[0] < end && end <= entry.value[1])
        .key;

    int startIndex = relevantMap.keys.toList().indexOf(startGyosi);
    int endIndex = relevantMap.keys.toList().indexOf(endGyosi);
    gyosiList = relevantMap.keys.toList().sublist(startIndex, endIndex + 1);

    result.add(gyosiList.join(', '));
  }

  return result;
}
