// ignore_for_file: avoid_print
import 'package:capstone/ans/AnsPage.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/notfiy/notifyPage.dart';
import 'package:capstone/qu/quAddPage.dart';
import 'package:flutter/material.dart';

import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController controller = PageController(initialPage: 0);
  var selected = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: const [
          HomePage(),
          AnsPage(),
          AnsPage(),
          NotifyPage(),
        ],
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 20,
          iconStyle: IconStyle.Default,
        ),
        currentIndex: selected,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => const QuAddPage(),
              ),
            );
          } else {
            setState(() {
              selected = index;
              controller.jumpToPage(index);
            });
          }
        },
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home_rounded),
            title: const Text(
              '홈',
              style: TextStyle(fontSize: 10),
            ),
            selectedColor: const Color.fromARGB(255, 106, 0, 0),
          ),
          BottomBarItem(
            icon: const Icon(Icons.question_mark),
            title: const Text(
              '질문하기',
              style: TextStyle(fontSize: 10),
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.article_outlined),
            selectedIcon: const Icon(Icons.article_rounded),
            title: const Text(
              '답변하기',
              style: TextStyle(fontSize: 10),
            ),
            selectedColor: const Color.fromARGB(255, 106, 0, 0),
          ),
          BottomBarItem(
            icon: const Icon(Icons.notifications_none),
            selectedIcon: const Icon(Icons.notifications_rounded),
            title: const Text(
              '알림',
              style: TextStyle(fontSize: 10),
            ),
            selectedColor: const Color.fromARGB(255, 106, 0, 0),
          ),
        ],
      ),
    );
  }
}
