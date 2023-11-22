import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsEditPage extends StatefulWidget {
  const AnsEditPage({Key? key, required this.articleId}) : super(key: key);

  final String articleId;

  @override
  State<AnsEditPage> createState() => _AnsEditPageState();
}

class _AnsEditPageState extends State<AnsEditPage> {
  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  var title;
  var content;

  getArticle() async {
    var result = await FirebaseFirestore.instance
        .collection('articles')
        .doc(widget.articleId)
        .get();
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
    articles.doc(widget.articleId).update({"title": title, "content": content});
    titleController.text = "";
    contentController.text = "";
    Navigator.of(context).pop();
    // 수정 결과가 pop 되는 페이지에 반영되어야 함
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
                '질문 수정하기',
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
                ))
          ],
        ),
        body: FutureBuilder(
          future: getArticle(),
          builder: (context, snaphot) {
            return snaphot.hasData
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: titleController,
                              decoration:
                                  const InputDecoration(labelText: '제목'),
                            ),
                            TextField(
                              controller: contentController,
                              decoration:
                                  const InputDecoration(labelText: '내용'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
