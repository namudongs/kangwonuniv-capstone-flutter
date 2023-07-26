// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Text(
            "@previous_page",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
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
