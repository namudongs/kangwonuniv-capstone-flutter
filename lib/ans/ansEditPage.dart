import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnsEditPage extends StatefulWidget {
  const AnsEditPage({Key? key, required this.articleId, required this.answerId})
      : super(key: key);

  final String articleId;
  final String answerId; // Added answerId

  @override
  State<AnsEditPage> createState() => _AnsEditPageState();
}

class _AnsEditPageState extends State<AnsEditPage> {
  final TextEditingController _contentController = TextEditingController();

  CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  Future<void> getAnswer() async {
    DocumentSnapshot answerSnapshot = await articles
        .doc(widget.articleId)
        .collection('answer')
        .doc(widget.answerId)
        .get();

    if (answerSnapshot.exists) {
      Map<String, dynamic> data = answerSnapshot.data() as Map<String, dynamic>;
      _contentController.text = data['content'];
    }
  }

  Future<void> saveForm() async {
    await articles
        .doc(widget.articleId)
        .collection('answer')
        .doc(widget.answerId)
        .update({'content': _contentController.text});

    Navigator.of(context).pop(); // Pop back to the previous page
  }

  @override
  void initState() {
    super.initState();
    getAnswer(); // Load the answer when the page initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('답변 수정하기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: saveForm, // Save the updated answer
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          decoration: const InputDecoration(labelText: '내용'),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
      ),
    );
  }
}
