import 'package:flutter/material.dart';
import 'group.dart'; // Group 모델 임포트

class GroupDetailsPage extends StatelessWidget {
  final Group group;

  GroupDetailsPage({required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(group.name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('그룹 이름: ${group.name}', style: TextStyle(fontSize: 20)),
            Text('카테고리: ${group.category}', style: TextStyle(fontSize: 18)),
            Text('목표 공부 시간: ${group.targetTime}시간', style: TextStyle(fontSize: 18)),
            Text('멤버 수: ${group.members.length}', style: TextStyle(fontSize: 18)),
            Text('관리자: ${group.adminName}', style: TextStyle(fontSize: 18)),
            // 여기에 추가 정보를 표시하는 위젯을 추가할 수 있습니다.
          ],
        ),
      ),
    );
  }
}