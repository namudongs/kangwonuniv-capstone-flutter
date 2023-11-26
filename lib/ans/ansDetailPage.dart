// ignore_for_file: use_build_context_synchronously

import 'package:capstone/ans/ansAddPage.dart';
import 'package:capstone/ans/ansEditPage.dart';
import 'package:capstone/main.dart';
import 'package:capstone/qu/quEditPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:capstone/ans/ansDetailController.dart';
import 'package:intl/intl.dart';

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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Q.',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 106, 0, 0),
                                ),
                              ),
                              Text(articleData['category'],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(158, 106, 0, 0),
                                  )),
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
                              const Padding(padding: EdgeInsets.only(top: 5)),
                              Row(
                                children: [
                                  Text(
                                      '${articleData['user']['name']}﹒10분 전﹒${articleData['user']['university']} ${articleData['user']['major']}',
                                      style: const TextStyle(
                                        fontSize: 9,
                                      )),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(top: 8)),
                              Text(
                                articleData['content'],
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              if (articleData['user']['uid'] == appUser?.uid)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                fullscreenDialog: true,
                                                builder: (context) =>
                                                    QuEditPage(
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
                      Divider(
                        color: Colors.black.withOpacity(0.1),
                        height: 0,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 15,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${answersData.length}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.favorite_border,
                              size: 15,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${articleData['like'] ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Icon(
                              Icons.remove_red_eye_outlined,
                              size: 15,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${articleData['view'] ?? 0}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black.withOpacity(0.1),
                        height: 0,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // 답변
                      for (var answer in answersData)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 30,
                              child: CircleAvatar(
                                backgroundColor: Color(0xffE6E6E6),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 20),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  border: Border.all(
                                    color: Colors.grey[100]!,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${answer['user']['name']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      '1분 전',
                                      style: TextStyle(fontSize: 9),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      answer['content'],
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
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
