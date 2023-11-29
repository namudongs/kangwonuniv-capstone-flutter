// ignore_for_file: avoid_print, file_names

import 'package:capstone/notfiy/notificationController.dart';
import 'package:flutter/material.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<NotifyPage> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  final NotificationController notificationController =
      NotificationController();

  @override
  void initState() {
    super.initState();
    notificationController.clearBadge();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
