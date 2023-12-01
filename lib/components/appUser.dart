// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String userName;
  final String university;
  final int grade;
  final int qu;
  final String major;
  final Timestamp timestamp;
  final String avatar;
  List<Map<String, dynamic>> timetable;

  AppUser({
    required this.uid,
    required this.email,
    required this.userName,
    required this.university,
    required this.grade,
    required this.qu,
    required this.major,
    required this.timestamp,
    required this.avatar,
    required this.timetable,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'university': university,
      'grade': grade,
      'qu': qu,
      'major': major,
      'timestamp': timestamp,
      'avatar': avatar,
      'timetable': timetable,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      university: map['university'],
      grade: map['grade'],
      qu: map['qu'],
      major: map['major'],
      timestamp: Timestamp.now(),
      avatar: map['avatar'],
      timetable: List<Map<String, dynamic>>.from(map['timetable'] ?? []),
    );
  }
}
