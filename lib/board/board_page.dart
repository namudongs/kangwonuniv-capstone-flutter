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
  CollectionReference articles = FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> _delete(String productId) async {
    await articles.doc(productId).delete();
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
                  builder: (context) => ArticleAddPage()));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: articles.orderBy('created_at', descending: true).snapshots(),
        builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if(streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                    child: ListTile(
                      title: Text(documentSnapshot['title']),
                      subtitle: Text(documentSnapshot['content']),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(articleId: documentSnapshot.id,)));
                      },
                    ),
                  );
                }
              );
            }
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
