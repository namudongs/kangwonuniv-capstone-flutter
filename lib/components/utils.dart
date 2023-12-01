import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  DateTime now = DateTime.now();
  Duration diff = now.difference(dateTime);

  if (diff.inDays > 365) {
    return '${(diff.inDays / 365).floor()}년 전';
  } else if (diff.inDays > 30) {
    return '${(diff.inDays / 30).floor()}개월 전';
  } else if (diff.inDays > 7) {
    return '${(diff.inDays / 7).floor()}주 전';
  } else if (diff.inDays > 0) {
    return '${diff.inDays}일 전';
  } else if (diff.inHours > 0) {
    return '${diff.inHours}시간 전';
  } else if (diff.inMinutes > 0) {
    return '${diff.inMinutes}분 전';
  } else {
    return '방금 전';
  }
}

snackBar(String title, String message) {
  return Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.black.withOpacity(0.8),
    colorText: Colors.white,
    margin: const EdgeInsets.all(10),
    borderRadius: 10,
    duration: const Duration(milliseconds: 1000),
  );
}
