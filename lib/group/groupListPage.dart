import 'package:capstone/group/groupAddController.dart';
import 'package:capstone/group/groupListController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({super.key});

  @override
  State<GroupListPage> createState() => _GroupListPageState();
}

class _GroupListPageState extends State<GroupListPage> {
  final GroupAddController groupAddController = Get.put(GroupAddController());
  final GroupListController groupListController =
      Get.put(GroupListController());
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController membersController = TextEditingController();

  @override
  void dispose() {
    // 사용한 컨트롤러들을 정리합니다.
    categoryController.dispose();
    groupNameController.dispose();
    purposeController.dispose();
    membersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('그룹'),
        actions: [
          IconButton(
            onPressed: () {
              showAddGroupDialog(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: groupListController.groupsStream.value,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var group = snapshot.data!.docs[index];
              return ListTile(
                title: Text(group['groupName']), // groupName을 표시
              );
            },
          );
        },
      ),
    );
  }

  void showAddGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('그룹 추가'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    hintText: '분야',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: groupNameController,
                  decoration: const InputDecoration(
                    hintText: '그룹 이름',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: purposeController,
                  decoration: const InputDecoration(
                    hintText: '목적',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: membersController,
                  decoration: const InputDecoration(
                    hintText: '모집 인원',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('추가'),
              onPressed: () {
                groupAddController.addGroup(
                    categoryController.text,
                    groupNameController.text,
                    purposeController.text,
                    membersController.text.compareTo('') == 0
                        ? 0
                        : int.parse(membersController.text));
              },
            ),
          ],
        );
      },
    );
  }
}
