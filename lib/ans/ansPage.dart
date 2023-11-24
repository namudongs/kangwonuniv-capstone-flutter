// ignore_for_file: avoid_print

import 'package:capstone/ans/ansDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AnsPage extends StatefulWidget {
  const AnsPage({Key? key}) : super(key: key);

  @override
  State<AnsPage> createState() => _AnsPageState();
}

class _AnsPageState extends State<AnsPage> {
  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('답변하기'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.grey[100]),
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
                              builder: (context) => AnsDetailPage(
                                    articleId: documentSnapshot.id,
                                  )));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 3, 0, 3),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 0.5,
                                spreadRadius: 0.1,
                                offset: Offset.zero,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(documentSnapshot['title'],
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black
                                        // fontWeight: FontWeight.bold,
                                        )),
                                Text(
                                  documentSnapshot['content']
                                      .replaceAll('\n', ' '),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '답변 ${documentSnapshot['answers_count']}개',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '﹒${documentSnapshot['user']['major']}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                    Text(
                                      '﹒${formatTimestamp(documentSnapshot['created_at'])}',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const Padding(padding: EdgeInsets.only(top: 5)),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print('관심질문 버튼 클릭');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          border: Border(
                                            bottom: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              width: 1,
                                            ),
                                            top: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              width: 1,
                                            ),
                                            left: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              width: 1,
                                            ),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                12,
                                        height: 30,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '관심질문',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print('공유하기 버튼 클릭');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          border: Border.all(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            width: 1,
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 -
                                                11,
                                        height: 30,
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '공유하기',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87),
                                            ),
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

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    DateTime now = DateTime.now();
    Duration diff = now.difference(dateTime);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}년 전';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}개월 전';
    } else if (diff.inDays > 7) {
      return '${(diff.inDays / 7).floor()}주 전';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}일 전';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}시간 전';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}분 전';
    } else {
      return '${diff.inSeconds}초 전';
    }
  }
}
