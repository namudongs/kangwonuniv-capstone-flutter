// ignore_for_file: avoid_print

import 'package:capstone/components/utils.dart';
import 'package:capstone/ans/ansController.dart';
import 'package:capstone/ans/ansDetailPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnsPage extends StatelessWidget {
  final AnsController controller = Get.put(AnsController());

  AnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('답변하기'),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.grey[50]),
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Obx(() {
                if (controller.articleList.value.isEmpty) {
                  return const Center(child: Text('등록된 질문이 없습니다.'));
                }
                return ListView.builder(
                  itemCount: controller.articleList.value.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        controller.articleList.value[index];
                    return GestureDetector(
                      onTap: () => Get.to(
                          () => AnsDetailPage(articleId: documentSnapshot.id)),
                      child: buildArticleItem(documentSnapshot, context),
                    );
                  },
                );
              }),
            ),
          ),
        ));
  }

  Widget buildArticleItem(DocumentSnapshot documentSnapshot, context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.0),
                blurRadius: 0.5,
                spreadRadius: 0.1,
                offset: Offset.zero,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(19, 102, 30, 30),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  documentSnapshot['category'],
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(200, 106, 0, 0),
                      fontFamily: 'NanumSquare'),
                ),
              ),
              const SizedBox(height: 5),
              if (documentSnapshot['title'].isNotEmpty)
                Text(documentSnapshot['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NanumSquare',
                    )),
              Visibility(
                visible: documentSnapshot['title'].isNotEmpty,
                replacement: Text(
                  documentSnapshot['content'].replaceAll('\n', ' '),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                child: Text(
                  documentSnapshot['content'].replaceAll('\n', ' '),
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Text(
                    '답변 ${documentSnapshot['answers_count']}개',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '﹒${documentSnapshot['user']['major']}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    '﹒${formatTimestamp(documentSnapshot['created_at'])}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ------------------------------------------ 답변 표시 ------------------------------------------
        // const Divider(
        //   height: 1,
        //   thickness: 0.1,
        //   color: Colors.grey,
        // ),
        // Container(
        //   height: 100,
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //   ),
        // ),
      ],
    );
  }
}
