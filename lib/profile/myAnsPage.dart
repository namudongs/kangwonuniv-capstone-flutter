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
              var article =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              return FutureBuilder<QuerySnapshot>(
                future: snapshot.data!.docs[index].reference
                    .collection('answer')
                    .where('user.uid', isEqualTo: appUser!.uid)
                    .get(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> answerSnapshot) {
                  if (answerSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }

                  if (!answerSnapshot.hasData ||
                      answerSnapshot.data!.docs.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  var answer = answerSnapshot.data!.docs.first.data()
                      as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: buildItem(article, answer, context),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget buildItem(
      Map<String, dynamic> article, Map<String, dynamic> answer, context) {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color.fromARGB(19, 102, 30, 30),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                '${article['category']} 질문', // 질문의 카테고리
                style: const TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(200, 106, 0, 0),
                    fontFamily: 'NanumSquare'),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${article['title']}', // 질문의 제목 혹은 내용
              style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(200, 106, 0, 0),
                  fontFamily: 'NanumSquare'),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color.fromARGB(19, 0, 0, 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '내가 쓴 답변', // 질문의 카테고리
                style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(198, 0, 0, 0),
                    fontFamily: 'NanumSquare'),
              ),
            ),
            const SizedBox(height: 3),
            if (answer['is_adopted'] == true)
              const Row(
                children: [
                  Icon(Icons.check_circle,
                      size: 13, color: Color.fromARGB(197, 140, 0, 0)),
                  SizedBox(width: 2),
                  Text(
                    '내가 쓴 답변이 채택되었습니다.', // 질문의 카테고리
                    style: TextStyle(
                        fontSize: 10,
                        color: Color.fromARGB(197, 121, 0, 0),
                        fontFamily: 'NanumSquare'),
                  ),
                ],
              ),
            Text(
              '${answer['content'].replaceAll('\n', ' ')}', // 답변의 내용
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ]);
  }
}
