import 'package:capstone/ans/ansDetailController.dart';
import 'package:capstone/ans/ansDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/main.dart';
import 'package:get/get.dart';

class MyQuPage extends StatelessWidget {
  const MyQuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작성한 질문'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('articles')
            .where('user.uid', isEqualTo: appUser!.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data?.docs.isEmpty ?? true) {
            return const Center(child: Text('작성한 질문이 없습니다'));
          }
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return InkWell(
                onTap: () {
                  // 상세페이지 이동하기
                  Get.to(AnsDetailPage(articleId: doc.id));
                },
                child: ListTile(
                  title: Text(doc['title']),
                  subtitle: Text(doc['content']),
                  // 여기에 추가적인 UI 또는 기능을 구현
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
