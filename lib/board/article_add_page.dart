import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleAddPage extends StatefulWidget {
  const ArticleAddPage({Key? key}) : super(key: key);

  @override
  State<ArticleAddPage> createState() => _ArticleAddPageState();
}

class _ArticleAddPageState extends State<ArticleAddPage> {
  CollectionReference articles = FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> saveForm() async {
    final String title = titleController.text;
    final String content = contentController.text;
    await articles.add({'title': title, 'content': content, 'created_at': Timestamp.now()});

    titleController.text = "";
    contentController.text = "";
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 작성'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.check),
          )
        ],
      ),
      body: Padding(
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
      ),
    );
  }
}
