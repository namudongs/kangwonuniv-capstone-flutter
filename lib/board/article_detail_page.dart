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
  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  getArticle() async {
    var result = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.articleId)
        .get();

    return result.data();
  }

  Future<void> delete() async {
    await articles.doc(widget.articleId).delete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[300],
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          '질의응답 게시판',
          style: TextStyle(
            color: Colors.black,
          ),
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
      body: FutureBuilder(
          future: getArticle(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? ListView(
                    children: [
                      Column(
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
                            subtitle: Text((snapshot.data as Map)['created_at']
                                .toDate()
                                .toString()),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 5, 8, 3),
                            width: double.infinity,
                            child: Text(
                              (snapshot.data as Map)['title'],
                              //article['title'].toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              textScaleFactor: 1.4,
                              textAlign: TextAlign.start,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 5, 8, 3),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    (snapshot.data as Map)['content'],
                                  ) //article['content'].toString()),
                                  )),
                          const SizedBox(
                            height: 1,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    ],
                  )
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
