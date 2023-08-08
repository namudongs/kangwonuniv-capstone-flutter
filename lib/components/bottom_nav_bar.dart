// ignore_for_file: avoid_print

import 'package:capstone/home/home_page.dart';
import 'package:capstone/mypage/my_page.dart';
import 'package:capstone/timetable/time_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List _pages = [
    const HomePage(),
    const TimePage(),
    const Text(
      "질의응답 페이지 만들어서 연결하기",
      style: TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    ),
    const Text(
      "그룹페이지 만들어서 연결하기",
      style: TextStyle(fontSize: 15),
      textAlign: TextAlign.center,
    ),
    const MyPage()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_currentIndex], // 페이지와 연결
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
              icon: const Icon(Icons.home),
              title: const Text("홈"),
              selectedColor: Colors.purple),
          SalomonBottomBarItem(
              icon: const Icon(Icons.calendar_today_rounded),
              title: const Text("시간표"),
              selectedColor: Colors.pink),
          SalomonBottomBarItem(
              icon: const Icon(Icons.question_answer_rounded),
              title: const Text("질의응답"),
              selectedColor: Colors.orange),
          SalomonBottomBarItem(
              icon: const Icon(Icons.group),
              title: const Text("스터디그룹"),
              selectedColor: Colors.teal),
          SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("마이페이지"),
              selectedColor: Colors.blueGrey)
        ],
      ),
    );
  }
}
