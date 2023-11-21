import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    var userData = await FirebaseFirestore.instance.collection('users').doc(user?.uid).get();
    setState(() {
      _nameController.text = userData['userName'];
      _gradeController.text = userData['grade'].toString();
      _majorController.text = userData['major'];
    });
  }

  void _updateUserProfile() async {
    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'userName': _nameController.text,
      'grade': int.parse(_gradeController.text),
      'major': _majorController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('프로필이 업데이트되었습니다.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
            TextField(
              controller: _gradeController,
              decoration: InputDecoration(labelText: '학년'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _majorController,
              decoration: InputDecoration(labelText: '전공'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}