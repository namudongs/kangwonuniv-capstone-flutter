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

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];

              return FutureBuilder<QuerySnapshot>(
                future: doc.reference
                    .collection('answer')
                    .where('user.uid', isEqualTo: appUser!.uid)
                    .get(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> answerSnapshot) {
                  if (answerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox.shrink(); // 로딩 위젯을 표시할 수 있습니다.
                  }

                  if (!answerSnapshot.hasData ||
                      answerSnapshot.data!.docs.isEmpty) {
                    return const SizedBox.shrink(); // 답변이 없는 경우
                  }

                  var answerContent =
                      answerSnapshot.data!.docs.first.get('content');
                  return ListTile(
                    title: Text('답변 내용: $answerContent'),
                    onTap: () {
                      Get.to(() => AnsDetailPage(articleId: doc.id));
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
