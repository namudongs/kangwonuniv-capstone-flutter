import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleAddPage extends StatefulWidget {
  const ArticleAddPage({Key? key}) : super(key: key);

  @override
  State<ArticleAddPage> createState() => _ArticleAddPageState();
}

class _ArticleAddPageState extends State<ArticleAddPage> {
  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> saveForm() async {
    final String title = titleController.text;
    final String content = contentController.text;
    await articles.add(
        {'title': title, 'content': content, 'created_at': Timestamp.now()});

    titleController.text = "";
    contentController.text = "";

    // ignore: use_build_context_synchronously
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
        centerTitle: true,
        title: const Text(
          '글 작성',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: const Icon(
              Icons.check,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: '제목을 입력하세요.'),
                ),
                TextField(
                  controller: contentController,
                  decoration: const InputDecoration(labelText: '내용을 입력하세요.'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
