import 'package:flutter/material.dart';
import 'group.dart'; // Group 모델 임포트
import 'group_details_page.dart'; // GroupDetailsPage 임포트

class StudyGroupListPage extends StatelessWidget {
  final List<Group> groups = [
    // Firestore에서 가져온 그룹 데이터로 초기화
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('가능한 스터디 그룹')),
      body: ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(groups[index].name),
            subtitle: Text(groups[index].category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupDetailsPage(group: groups[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}