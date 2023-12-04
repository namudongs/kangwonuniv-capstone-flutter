import 'package:capstone/authController.dart';
import 'package:capstone/main.dart';
import 'package:capstone/profile/myAnsPage.dart';
import 'package:capstone/profile/myQuPage.dart';
import 'package:capstone/profile/profileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final ProfileController controller = Get.put(ProfileController());

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
              '${appUser?.qu ?? 0} QU',
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
                  leading: const Icon(Icons.settings),
                  title: const Text('설정'),
                  onTap: () {
                    // 설정 탭 동작
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('공지사항'),
                  onTap: () {
                    // 공지사항 탭 동작
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('도움말'),
                  onTap: () {
                    // 도움말 탭 동작
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.article),
                  title: const Text('약관'),
                  onTap: () {
                    // 도움말 탭 동작
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('서비스 정보'),
                  onTap: () {
                    // 도움말 탭 동작
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('로그아웃'),
                    onTap: () {
                      showLogoutDidalog(context);
                    }),
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('회원탈퇴'),
                  onTap: () {
                    // 회원탈퇴 탭 동작
                    showDeleteConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    // AlertDialog를 보여주는 showDialog 함수
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('계정 삭제'),
          content: const Text('계정을 삭제하시겠습니까?\n이 작업은 되돌릴 수 없습니다.'),
          actions: <Widget>[
            // '취소' 버튼
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
              },
            ),
            // '삭제' 버튼
            TextButton(
              child: const Text('삭제'),
              onPressed: () {
                // 여기에 계정 삭제 로직을 넣습니다.
                controller.deleteUserAccount();
                Navigator.of(context).pop(); // Dialog 닫기
              },
            ),
          ],
        );
      },
    );
  }

  void showLogoutDidalog(BuildContext context) {
    // AlertDialog를 보여주는 showDialog 함수
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('로그아웃 하시겠습니까?'),
          actions: <Widget>[
            // '취소' 버튼
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // Dialog 닫기
              },
            ),
            // '로그아웃' 버튼
            TextButton(
              child: const Text('로그아웃'),
              onPressed: () {
                // 여기에 로그아웃 로직을 넣습니다.
                authController.signOut();
                Navigator.of(context).pop(); // Dialog 닫기
              },
            ),
          ],
        );
      },
    );
  }
}
