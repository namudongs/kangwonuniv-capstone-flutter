// ignore_for_file: prefer_const_constructors

import 'package:capstone/ans/AnsPage.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/notfiy/notifyPage.dart';
import 'package:capstone/profile/profilePage.dart';
import 'package:capstone/qu/quAddPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';

class BottomNavBarController extends GetxController {
  var selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void goToAnsPage() {
    changeTab(1);
  }

  void goToHomePage() {
    changeTab(0);
  }
}

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final BottomNavBarController bottomNavBarController =
      Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: bottomNavBarController.selectedIndex.value,
          children: [
            HomePage(),
            AnsPage(),
            QuAddPage(),
            NotifyPage(),
            ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => StylishBottomBar(
            option: AnimatedBarOptions(
              iconSize: 20,
              iconStyle: IconStyle.Default,
            ),
            currentIndex: bottomNavBarController.selectedIndex.value,
            onTap: (index) {
              if (index == 2) {
                Get.to(() => const QuAddPage(), fullscreenDialog: true);
              } else {
                bottomNavBarController.changeTab(index);
              }
            },
            items: _buildBottomBarItems(),
          )),
    );
  }

  List<BottomBarItem> _buildBottomBarItems() {
    return [
      BottomBarItem(
        icon: const Icon(Icons.home_rounded),
        title: const Text('홈', style: TextStyle(fontSize: 10)),
        selectedColor: const Color.fromARGB(255, 106, 0, 0),
      ),
      BottomBarItem(
        icon: const Icon(Icons.article_outlined),
        selectedIcon: const Icon(Icons.article_rounded),
        title: const Text('답변하기', style: TextStyle(fontSize: 10)),
        selectedColor: const Color.fromARGB(255, 106, 0, 0),
      ),
      BottomBarItem(
        icon: const Icon(Icons.question_mark),
        title: const Text('질문하기', style: TextStyle(fontSize: 10)),
        selectedColor: const Color.fromARGB(255, 106, 0, 0),
      ),
      BottomBarItem(
        icon: const Icon(Icons.notifications_none),
        selectedIcon: const Icon(Icons.notifications_rounded),
        title: const Text('알림', style: TextStyle(fontSize: 10)),
        selectedColor: const Color.fromARGB(255, 106, 0, 0),
      ),
      BottomBarItem(
        icon: const Icon(CupertinoIcons.person),
        selectedIcon: const Icon(CupertinoIcons.person_fill),
        title: const Text('프로필', style: TextStyle(fontSize: 10)),
        selectedColor: const Color.fromARGB(255, 106, 0, 0),
      ),
    ];
  }
}
