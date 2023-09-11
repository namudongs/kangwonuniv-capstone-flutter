import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleEditPage extends StatefulWidget {
  const ArticleEditPage({Key? key, required this.articleId}) : super(key: key);

  final String articleId;

  @override
  State<ArticleEditPage> createState() => _ArticleEditPageState();
}

class _ArticleEditPageState extends State<ArticleEditPage> {
  CollectionReference articles = FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  var title;
  var content;

  getArticle() async {
    var result = await FirebaseFirestore.instance.collection('articles').doc(widget.articleId).get();
    print(result);
    title = result['title'];
    content = result['content'];
    contentController.text = content;
    titleController.text = title;
    return result.data();
  }

  Future<void> saveForm() async {
    final String title = titleController.text;
    final String content = contentController.text;
    articles
        .doc(widget.articleId)
        .update({"title": title, "content": content});
    titleController.text = "";
    contentController.text = "";
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 수정'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.check)
          )
        ],
      ),
      body: FutureBuilder(
        future: getArticle(),
        builder: (context, snaphot) {
          return
          snaphot.hasData?
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                            labelText: 'Title'
                        ),
                      ),
                      TextField(
                        controller: contentController,
                        decoration: InputDecoration(
                            labelText: 'Content'
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            : Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}
