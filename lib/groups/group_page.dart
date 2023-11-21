import 'package:flutter/material.dart';
import 'group.dart'; // Group 클래스 임포트
import 'study_group_list_page.dart'; // StudyGroupListPage 임포트
import 'group_chat_page.dart'; // GroupChatPage 임포트
import 'timer_page.dart'; // TimerPage 임포트
import 'group_details_page.dart'; // GroupDetailsPage 임포트

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  List<Group> _groupList = [
    Group(id: "1", name: "스터디 그룹 1", category: "수업", targetTime: "3", members: ["User1", "User2"], adminName: "Admin1", recruitment: 20),
    Group(id: "2", name: "스터디 그룹 2", category: "편입", targetTime: "2", members: ["User3", "User4"], adminName: "Admin2", recruitment: 4),
    Group(id: "3", name: "스터디 그룹 3", category: "공무원", targetTime: "4", members: ["User5", "User6"], adminName: "Admin3", recruitment: 7),
    Group(id: "4", name: "스터디 그룹 4", category: "기타", targetTime: "2", members: ["User7", "User8"], adminName: "Admin4", recruitment: 10),
    // ... 다른 그룹 추가
  ];

  @override
  Widget build(BuildContext context) {
    // 사용자 설정에 따라 다크 모드 여부를 판단
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '강원대학교', // 여기에 '강원대학교' 추가
                style: TextStyle(
                  color: Color.fromARGB(255, 255, 98, 0), // 강원대학교 텍스트 색상
                  fontSize: 13, // 텍스트 크기
                ),
              ),
              Text(
                '📚내 스터디 그룹', // 이모지와 함께 제목 설정
                style: TextStyle(
                  fontSize: 20, // 폰트 크기
                  fontWeight: FontWeight.bold, // 글씨 굵기
                  color: Colors.black, // 글자 색상
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // 글자 색상을 사용자 설정에 따라 동적으로 변경
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
      ),
      body: ListView.builder(
        itemCount: _groupList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(_groupList[index].name),
                subtitle: Text(
                    "${_groupList[index].category}\t|\t"
                        "${_groupList[index].targetTime}시간\t|\t"
                        "${_groupList[index].members.length}/${_groupList[index].recruitment}명\t|\t"
                        "${_groupList[index].adminName}" // 그룹 관리자 이름
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chat_bubble), // 채팅 아이콘
                      onPressed: () {
                        // 그룹 내 채팅 페이지로 이동하는 코드
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupChatPage(group: _groupList[index]),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // 그룹 정보 조회 페이지로 이동하는 코드
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupDetailsPage(group: _groupList[index]),
                    ),
                  );
                },
                // ... 탈퇴 기능 추가
              ),
              Divider(), // 선 추가
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // 타이머 페이지로 이동하는 코드
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TimerPage(),
                ),
              );
            },
            child: Icon(Icons.play_arrow),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              // 가입할 수 있는 스터디그룹 리스트 페이지로 이동하는 코드
              // 예시로는 빈 페이지를 만들어 이동하도록 설정합니다.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StudyGroupListPage(),
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}