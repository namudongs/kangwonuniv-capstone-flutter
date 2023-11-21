// ignore_for_file: use_build_context_synchronously

import 'package:capstone/board/article_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({required this.articleId, Key? key})
      : super(key: key);

  final String articleId;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  bool isCommentAccepted = false; // 채택된 댓글이 있는지 상태 관리
  final TextEditingController _commentController = TextEditingController();
  CollectionReference articles =
  FirebaseFirestore.instance.collection('articles');

  Future<Map<String, dynamic>?> getArticle() async {
    var result = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.articleId)
        .get();
    return result.data() as Map<String, dynamic>?;
  }

  // delete 함수 추가
  Future<void> delete() async {
    await articles.doc(widget.articleId).delete();
    Navigator.of(context).pop();
  }

  Future<void> addComment() async {
    if (_commentController.text.isNotEmpty) {
      await articles
          .doc(widget.articleId)
          .collection('comments')
          .add({
        'content': _commentController.text,
        'author_id': 'user123', // 예시 사용자 ID, 실제로는 인증된 사용자 ID를 사용
        'created_at': Timestamp.now(),
        'is_accepted': false,
      });
      _commentController.clear();
    }
  }

  Future<void> acceptComment(String commentId) async {
    if (!isCommentAccepted) {
      await articles
          .doc(widget.articleId)
          .collection('comments')
          .doc(commentId)
          .update({'is_accepted': true});

      setState(() {
        isCommentAccepted = true; // 채택 상태 업데이트
      });

      // 마일리지 부여 로직 (추가 구현 필요)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Column(
          children: [
            Text(
              '강원대학교',
              style: TextStyle(
                color: Color.fromARGB(255, 255, 98, 0),
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              '질문과 답변',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArticleEditPage(
                    articleId: widget.articleId,
                  )));
            },
            icon: const Icon(
              Icons.edit,
            ),
          ),
          IconButton(
            onPressed: delete,
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>?>(
              future: getArticle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData) {
                  return Column(
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundColor: Color(0xffE6E6E6),
                            child: Icon(
                              Icons.person,
                              color: Color(0xffCCCCCC),
                            ),
                          ),
                        ),
                        title: const Text('익명이'),
                        subtitle: Text(
                          (snapshot.data as Map)['created_at']
                              .toDate()
                              .toString(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 5, 8, 3),
                        width: double.infinity,
                        child: Text(
                          (snapshot.data as Map)['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 5, 8, 3),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text((snapshot.data as Map)['content']),
                        ),
                      ),
                      const SizedBox(
                        height: 1,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  );
                }

                return const Text('게시글을 불러오는 데 문제가 발생했습니다.');
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: articles
                  .doc(widget.articleId)
                  .collection('comments')
                  .orderBy('created_at', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }

                // 채택된 댓글이 있는지 확인
                isCommentAccepted = snapshot.data!.docs.any((doc) => doc['is_accepted']);

                return ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> comment = document.data()! as Map<String, dynamic>;
                    return ListTile(
                      title: Text(comment['content']),
                      subtitle: Text(comment['author_id']),
                      trailing: comment['is_accepted']
                          ? Icon(Icons.check, color: Colors.green)
                          : (!isCommentAccepted)
                          ? ElevatedButton(
                        child: Text('채택'),
                        onPressed: () => acceptComment(document.id),
                      )
                          : SizedBox.shrink(), // 이미 채택된 댓글이 있으면 다른 채택 버튼 숨김
                    );
                  }).toList(),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(labelText: '댓글 추가'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: addComment,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
