import 'package:capstone/ans/ansDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/main.dart';
import 'package:get/get.dart';

class MyAnsPage extends StatelessWidget {
  const MyAnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작성한 답변'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .where('user_answers_uids', arrayContains: appUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('작성한 답변이 없습니다'));
          }

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              // 여기서 각 문서의 ID (질문 ID)를 사용하여 ListTile 생성
              return ListTile(
                title: Text('질문의 콘텐츠: ${doc['content']}'), // 질문의 제목을 표시
                onTap: () {
                  // 상세페이지 이동하기
                  Get.to(() => AnsDetailPage(articleId: doc.id));
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
