// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String email;
  final String userName;
  final String university;
  final int grade;
  final String major;
  final Timestamp timestamp;

  AppUser({
    required this.uid,
    required this.email,
    required this.userName,
    required this.university,
    required this.grade,
    required this.major,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'university': university,
      'grade': grade,
      'major': major,
      'timestamp': timestamp,
    };
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      university: map['university'],
      grade: map['grade'],
      major: map['major'],
      timestamp: Timestamp.now(),
    );
  }
}
