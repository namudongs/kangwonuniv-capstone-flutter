// ignore_for_file: avoid_print

import 'package:capstone/board/article_add_page.dart';
import 'package:capstone/board/article_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({Key? key}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> _delete(String productId) async {
    await articles.doc(productId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 0, 123).withOpacity(1),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        flexibleSpace: Container(),
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 10),
              const Text(
                '답변하기',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ArticleAddPage()));
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[200]),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: StreamBuilder(
            stream:
                articles.orderBy('created_at', descending: true).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ArticleDetailPage(
                                    articleId: documentSnapshot.id,
                                  )));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(documentSnapshot['title'],
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black
                                        // fontWeight: FontWeight.bold,
                                        )),
                                Text(
                                  documentSnapshot['content'],
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                const Row(
                                  children: [
                                    Text(
                                      '답변 ${0}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '﹒컴퓨터공학과',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.black54),
                                    ),
                                    Text(
                                      '﹒11분 전',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(top: 10)),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('답변하기 버튼 클릭');
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.3), // 그림자의 색상
                                              spreadRadius: 0.1, // 그림자의 범위
                                              blurRadius: 3, // 그림자의 흐림 정도
                                              offset: const Offset(
                                                  0, 0), // 그림자의 위치 조정
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.edit_document,
                                              size: 9,
                                              color: Colors.black87,
                                            ),
                                            Text(
                                              ' 답변하기',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black87),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(left: 5)),
                                    GestureDetector(
                                      onTap: () {
                                        print('공유하기 버튼 클릭');
                                      },
                                      child: Container(
                                        width: 70,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.3), // 그림자의 색상
                                              spreadRadius: 0.1, // 그림자의 범위
                                              blurRadius: 3, // 그림자의 흐림 정도
                                              offset: const Offset(
                                                  0, 0), // 그림자의 위치 조정
                                            ),
                                          ],
                                        ),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.share_rounded,
                                              size: 9,
                                              color: Colors.black87,
                                            ),
                                            Text(
                                              ' 공유하기',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black87),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
