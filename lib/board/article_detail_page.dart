import 'dart:convert';

import 'package:capstone/board/article_edit_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleDetailPage extends StatefulWidget {
  const ArticleDetailPage({required this.articleId, Key? key}) : super(key: key);

  final String articleId;

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  CollectionReference articles = FirebaseFirestore.instance.collection('articles');

  getArticle() async {
    var result = await FirebaseFirestore.instance.collection('articles').doc(widget.articleId).get();

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
        title: Text('질의응답 게시판'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ArticleEditPage(articleId: widget.articleId,)));
            },
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: delete,
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: FutureBuilder(
        future: getArticle(),
        builder: (context, snapshot) {
          return
          snapshot.hasData?
            ListView(children: [
              Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        backgroundColor: Color(0xffE6E6E6),
                        child: Icon(
                          Icons.person,
                          color: Color(0xffCCCCCC),
                        ),
                      ),
                    ),
                    title: Text('익명이'),
                    subtitle: Text((snapshot.data as Map)['created_at'].toDate().toString()),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 8, 3),
                    width: double.infinity,
                    child: Text(
                      (snapshot.data as Map)['title'],
                      //article['title'].toString(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textScaleFactor: 1.4,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 8, 3),
                      child: Align (
                        alignment: Alignment.topLeft,
                        child: Text((snapshot.data as Map)['content'],)//article['content'].toString()),
                      )
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Divider(
                    thickness: 1,
                  ),

                ],
              ),
            ],
          )
          : Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}
