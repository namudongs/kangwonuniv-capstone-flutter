// ignore_for_file: avoid_print

import 'package:capstone/components/utils.dart';
import 'package:capstone/ans/ansController.dart';
import 'package:capstone/ans/ansDetailPage.dart';
import 'package:capstone/main.dart';
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
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.02)),
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
            border: Border(
              top: BorderSide(
                color: Colors.black.withOpacity(0.1),
                width: 1,
              ),
            ),
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
                    )),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: CircleAvatar(
                      radius: 30, // 원하는 반지름 크기
                      backgroundImage: AssetImage(
                          documentSnapshot['user']['avatar']), // 이미지 경로
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${documentSnapshot['user']['name']}﹒${documentSnapshot['user']['university']} ${documentSnapshot['user']['major']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
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
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: documentSnapshot['likes_uid']
                            .contains(appUser?.uid ?? 'uid'),
                        replacement: Icon(
                          Icons.favorite_border_outlined,
                          size: 16,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: Icon(
                          Icons.favorite,
                          size: 16,
                          color: Colors.red.withOpacity(1),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${documentSnapshot['like']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.mode_comment_outlined,
                        size: 16,
                        color: Colors.black54,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${documentSnapshot['answers_count']}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    formatTimestamp(documentSnapshot['created_at']),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // ------------------------------------------ 답변 표시 ------------------------------------------

        Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: const BoxDecoration(color: Colors.white),
          child: Obx(() {
            var answer = controller.acceptedAnswers.value[documentSnapshot.id];
            if (answer != null && documentSnapshot['is_adopted'] == true) {
              return buildAcceptedAnswerWidget(answer);
            } else if (answer != null &&
                documentSnapshot['is_adopted'] == false) {
              return buildNoAdoptedAnswerWidget(answer);
            } else {
              return buildNoAnswerWidget();
            }
          }),
        ),
      ],
    );
  }
}

Widget buildAcceptedAnswerWidget(DocumentSnapshot acceptedAnswer) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color.fromARGB(35, 157, 0, 0),
      border: Border.all(
        color: Colors.black.withOpacity(0.1),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 17,
                    color: Color.fromARGB(255, 157, 0, 0),
                  ),
                  SizedBox(width: 3),
                  Text(
                    '채택된 답변입니다.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 157, 0, 0),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: CircleAvatar(
                      radius: 30, // 원하는 반지름 크기
                      backgroundImage: AssetImage(
                          acceptedAnswer['user']['avatar']), // 이미지 경로
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${acceptedAnswer['user']['name']}﹒${acceptedAnswer['user']['university']} ${acceptedAnswer['user']['major']}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(
                acceptedAnswer['content'].replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildNoAnswerWidget() {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 255, 255, 255),
      border: Border.all(
        color: Colors.black.withOpacity(0.1),
        width: 1,
      ),
    ),
    child: const Row(
      children: [
        Icon(Icons.check_circle_outline, color: Color.fromARGB(255, 106, 0, 0)),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '답변을 작성해주세요.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 5),
              Text(
                '질문자에게 도움이 되는 답변을 작성해주세요.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildNoAdoptedAnswerWidget(DocumentSnapshot documentSnapshot) {
  return Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.1),
      border: Border.all(
        color: Colors.black.withOpacity(0.1),
        width: 1,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.check,
                    size: 17,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '채택을 기다리고 있는 답변입니다.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                    child: CircleAvatar(
                      radius: 30, // 원하는 반지름 크기
                      backgroundImage: AssetImage(
                          documentSnapshot['user']['avatar']), // 이미지 경로
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${documentSnapshot['user']['name']}﹒${documentSnapshot['user']['university']} ${documentSnapshot['user']['major']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Text(
                documentSnapshot['content'].replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
