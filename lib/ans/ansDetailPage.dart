// ignore_for_file: use_build_context_synchronously

import 'package:capstone/ans/ansAddPage.dart';
import 'package:capstone/ans/ansEditPage.dart';
import 'package:capstone/main.dart';
import 'package:capstone/qu/quEditPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:capstone/ans/ansDetailController.dart';

class AnsDetailPage extends StatelessWidget {
  final String articleId;

  AnsDetailPage({super.key, required this.articleId});
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnsDetailController(articleId));
    return Scaffold(
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset.zero,
            ),
          ],
          image: const DecorationImage(
              image: AssetImage('assets/images/background_1.png'),
              fit: BoxFit.cover,
              opacity: 0.9),
        ),
        width: MediaQuery.of(context).size.width / 4 + 10,
        height: 35,
        child: FloatingActionButton.extended(
          onPressed: () {
            Get.to(
                fullscreenDialog: true, () => AnsAddPage(articleId: articleId));
          },
          label: const Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
                size: 17,
              ),
              SizedBox(width: 4),
              Text(
                '답변하기',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat, // 위치 중앙 하단 설정
      appBar: AppBar(
        title: const Text('상세보기'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.articleData.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            var articleData = controller.articleData.value!;
            var answersData = controller.answersData;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundColor: Color(0xffE6E6E6),
                                  child: Icon(
                                    Icons.person,
                                    color: Color(0xffCCCCCC),
                                  ),
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${articleData['user']['name']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                    ),
                                  ),
                                  Text(
                                      '${articleData['user']['major']}﹒${articleData['user']['university']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                      )),
                                ],
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 8)),
                          Visibility(
                            visible: articleData['title'].isNotEmpty,
                            child: Text(
                              articleData['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            articleData['content'],
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          if (articleData['user']['uid'] == appUser?.uid)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) => QuEditPage(
                                                  articleId: articleId,
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text(
                                      '수정',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.quDelete(articleId);
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.only(top: 10, left: 5),
                                    width: 40,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      border: Border.all(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    child: const Text(
                                      '삭제',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ]),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '답변',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                for (var answer in answersData)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    backgroundColor: Color(0xffE6E6E6),
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xffCCCCCC),
                                    ),
                                  ),
                                ),
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${answer['user']['name']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                      ),
                                    ),
                                    Text(
                                        '${answer['user']['major']}﹒${answer['user']['university']}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                        )),
                                  ],
                                ),
                              ],
                            ),
                            const Padding(padding: EdgeInsets.only(top: 15)),
                            Text(
                              answer['content'],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            if (answer['user']['uid'] == appUser?.uid)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // 답변의 수정 로직 여기서 설정
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => AnsEditPage(
                                                    articleId: articleId,
                                                    answerId: answer[
                                                        'id'], // 답변 ID 전달
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: const Text(
                                        '수정',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.ansDelete(
                                          articleId, answer['id']);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          top: 10, left: 5),
                                      width: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[50],
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: const Text(
                                        '삭제',
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ]),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
