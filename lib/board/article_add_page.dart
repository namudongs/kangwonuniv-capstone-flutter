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
              '질문하기',
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
