// ignore_for_file: use_build_context_synchronously

import 'package:capstone/ans/ansAddPage.dart';
import 'package:capstone/ans/ansEditPage.dart';
import 'package:capstone/qu/quEditPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsDetailPage extends StatefulWidget {
  const AnsDetailPage({required this.articleId, Key? key}) : super(key: key);

  final String articleId;

  @override
  State<AnsDetailPage> createState() => _AnsDetailPageState();
}

class _AnsDetailPageState extends State<AnsDetailPage> {
  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  getArticle() async {
    var result = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.articleId)
        .get();

    return result.data();
  }

  Future<Map<String, dynamic>> getArticleAndAnswers() async {
    var articleSnapshot = await articles.doc(widget.articleId).get();
    var articleData = articleSnapshot.data() as Map<String, dynamic>;

    var answersSnapshot = await articles
        .doc(widget.articleId)
        .collection('answer')
        .orderBy('created_at', descending: false)
        .get();
    var answersData =
        answersSnapshot.docs.map((doc) => doc.data()..['id'] = doc.id).toList();

    return {'article': articleData, 'answers': answersData};
  }

  Future<void> quDelete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('질문 삭제'),
          content: const Text('이 질문을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('삭제'),
              onPressed: () async {
                await articles.doc(widget.articleId).delete();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> ansDelete(String answerId) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('답변 삭제'),
          content: const Text('이 답변을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('삭제'),
              onPressed: () async {
                await articles
                    .doc(widget.articleId)
                    .collection('answer')
                    .doc(answerId)
                    .delete();

                await articles.doc(widget.articleId).update({
                  'answers_count': FieldValue.increment(-1),
                });
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset.zero,
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/images/background_1.png'),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => AnsAddPage(
                      articleId: widget.articleId,
                    )));
          },
          label: const Row(
            children: [
              Icon(Icons.add, color: Colors.white),
              SizedBox(width: 4),
              Text(
                '답변하기',
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // 위치 중앙 하단 설정
      appBar: AppBar(
        title: const Text('상세보기'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
          future: getArticleAndAnswers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('에러: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('데이터가 유효하지 않습니다.'));
            }

            var articleData = snapshot.data!['article'];
            var answersData = snapshot.data!['answers'] as List;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffE6E6E6),
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xffCCCCCC),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${articleData['user']['name']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                        '${articleData['user']['major']}﹒${articleData['user']['university']}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 15)),
                            Text(
                              articleData['content'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) => QuEditPage(
                                                  articleId: widget.articleId,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text(
                                      '수정',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    quDelete();
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(top: 10, left: 5),
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text(
                                      '삭제',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '답변',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (var answer in answersData)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: CircleAvatar(
                                      backgroundColor: Color(0xffE6E6E6),
                                      child: Icon(
                                        Icons.person,
                                        color: Color(0xffCCCCCC),
                                      ),
                                    ),
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(left: 10)),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${answer['user']['name']}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                          '${answer['user']['major']}﹒${answer['user']['university']}',
                                          style: const TextStyle(
                                            fontSize: 11,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 15)),
                              Text(
                                answer['content'],
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // 답변의 수정 로직 여기서 설정
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => AnsEditPage(
                                                    articleId: widget.articleId,
                                                    answerId: answer[
                                                        'id'], // 답변 ID 전달
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: const Text(
                                        '수정',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      ansDelete(answer['id']);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, left: 5),
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: const Text(
                                        '삭제',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                ],
              ),
            );
          }),
    );
  }
}
