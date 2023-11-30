import 'package:capstone/authController.dart';
import 'package:capstone/main.dart';
import 'package:capstone/profile/myAnsPage.dart';
import 'package:capstone/profile/myQuPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = appUser?.userName ?? '이름 없음';
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage:
                AssetImage(appUser?.avatar ?? 'assets/avatars/avatar_1.png'),
          ),
          const SizedBox(height: 10),
          Text(
            userName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${appUser?.qu ?? 0}QU',
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 43, 21, 21),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey,
          ),
          Row(
            children: [
              InkWell(
                onTap: () {
                  // 내가 한 질문보기 탭 동작
                  Get.to(const MyQuPage());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 65,
                  decoration: const BoxDecoration(
                    // color: Colors.amber,
                    border: Border(
                      right: BorderSide(
                        width: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text('작성한 질문보기'),
                ),
              ),
              InkWell(
                onTap: () {
                  // 내가 한 답변보기 탭 동작
                  Get.to(const MyAnsPage());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 65,
                  child: const Text('작성한 답변보기'),
                ),
              ),
            ],
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.announcement),
                  title: const Text('공지사항'),
                  onTap: () {
                    // 공지사항 탭 동작
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('설정'),
                  onTap: () {
                    // 설정 탭 동작
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app),
                  title: const Text('로그아웃'),
                  onTap: authController.signOut,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
