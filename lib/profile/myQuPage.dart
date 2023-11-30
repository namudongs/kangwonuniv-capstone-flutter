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
          var articleDoc =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return InkWell(
                onTap: () {
                  // 상세페이지 이동하기
                  Get.to(AnsDetailPage(articleId: doc.id));
                },
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: buildItem(articleDoc, context),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildItem(Map<String, dynamic> article, context) {
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
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: article['answers_count'] > 0
                    ? (article['is_adopted'] == true
                        ? const Color.fromARGB(114, 140, 0, 0)
                        : const Color.fromARGB(21, 0, 47, 255))
                    : const Color.fromARGB(19, 0, 0, 0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                article['answers_count'] > 0
                    ? (article['is_adopted'] == true
                        ? '답변을 채택했습니다'
                        : '답변을 채택해주세요')
                    : '아직 답변이 달리지 않았습니다.',
                style: TextStyle(
                    fontSize: 12,
                    color: article['answers_count'] > 0
                        ? (article['is_adopted'] == true
                            ? const Color.fromARGB(200, 255, 0, 0)
                            : const Color.fromARGB(200, 38, 0, 255))
                        : const Color.fromARGB(198, 0, 0, 0),
                    fontFamily: 'NanumSquare'),
              ),
            ),

            const SizedBox(height: 3),
            // if (answer['is_adopted'] == true)
            //   const Row(
            //     children: [
            //       Icon(Icons.check_circle,
            //           size: 13, color: Color.fromARGB(197, 140, 0, 0)),
            //       SizedBox(width: 2),
            //       Text(
            //         '내가 쓴 답변이 채택되었습니다.', // 질문의 카테고리
            //         style: TextStyle(
            //             fontSize: 10,
            //             color: Color.fromARGB(197, 121, 0, 0),
            //             fontFamily: 'NanumSquare'),
            //       ),
            //     ],
            //   ),
            // Text(
            //   '${answer['content'].replaceAll('\n', ' ')}', // 답변의 내용
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: Colors.black.withOpacity(0.8),
            //   ),
            //   maxLines: 2,
            //   overflow: TextOverflow.ellipsis,
            // ),
          ],
        ),
      ),
    ]);
  }
}