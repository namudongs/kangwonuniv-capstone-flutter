// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:capstone/timetable/time_slot.dart';

Future<TimeSlot> loadRandomTimeSlot() async {
  // Load the data from the file
  String jsonString =
      await rootBundle.loadString('assets/tuning_lectureDB.json');

  // Decode the JSON string into a list of Dart maps
  List<dynamic> lecturesList = jsonDecode(jsonString);

  // Select a random index
  Random random = Random();
  int randomIndex = random.nextInt(lecturesList.length);

  // Convert the data at the random index into a TimeSlot object
  TimeSlot randomTimeSlot = TimeSlot.fromJson(lecturesList[randomIndex]);

  return randomTimeSlot;
}
