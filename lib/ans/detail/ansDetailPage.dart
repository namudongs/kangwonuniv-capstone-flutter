// ignore_for_file: use_build_context_synchronously

import 'package:capstone/ans/add/ansAddPage.dart';
import 'package:capstone/ans/detail/ansDetailController.dart';
import 'package:capstone/ans/edit/ansEditPage.dart';
import 'package:capstone/chat/chatPage.dart';
import 'package:capstone/components/imageViewer.dart';
import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/qu/quEditPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AnsDetailPage extends StatelessWidget {
  final String articleId;

  AnsDetailPage({super.key, required this.articleId});
  final CollectionReference articles =
      FirebaseFirestore.instance.collection('articles');

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnsDetailController(articleId));
    return Scaffold(
      floatingActionButton: Obx(() {
        return Visibility(
          // visible: controller.articleData.value?['is_adopted'] == false,
          visible: controller.articleData.value?['user']['uid'] != appUser?.uid,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
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
                    fullscreenDialog: true,
                    () => AnsAddPage(articleId: articleId));
              },
              label: const Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.pencil,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 3),
                  Text(
                    '답변하기',
                    style: TextStyle(
                        fontFamily: 'NanumSquare',
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
        );
      }),
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
            var articleImages = articleData['images'] ?? [];
            var answersData = controller.answersData;

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
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
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 106, 0, 0),
                                ),
                              ),
                              Text(articleData['category'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(158, 106, 0, 0),
                                  )),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: articleData['title'].isNotEmpty,
                                child: Text(
                                  articleData['title'],
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 1, right: 10, bottom: 15),
                                    width: 30,
                                    height: 30,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      width: 30.0, // 원하는 폭
                                      height: 30.0, // 원하는 높이
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill, // 원하는 BoxFit 설정
                                          image: AssetImage(
                                              articleData['user']['avatar']),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                      '${articleData['user']['name']}﹒${formatTimestamp(articleData['created_at'])}\n${articleData['user']['university']} ${articleData['user']['major']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                      )),
                                ],
                              ),
                              _buildImageList(context, articleImages, 0.8, 0.6),
                              const SizedBox(height: 10),
                              Text(
                                articleData['content'],
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              if (articleData['user']['uid'] == appUser?.uid &&
                                  articleData['is_adopted'] == false)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(
                                          QuEditPage(articleId: articleId),
                                          fullscreenDialog: true,
                                        );
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
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.quDelete(articleId);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            top: 10, left: 7),
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
                                          style: TextStyle(
                                            fontSize: 13,
                                          ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller.updateLike(articleId);
                                  },
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: controller
                                            .articleData.value!['likes_uid']
                                            .contains(appUser?.uid),
                                        replacement: Icon(
                                          Icons.favorite_border_outlined,
                                          size: 19,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                        child: Icon(
                                          Icons.favorite,
                                          size: 19,
                                          color: Colors.red.withOpacity(0.8),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${articleData['like'] ?? 0}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Icon(
                                  Icons.mode_comment_outlined,
                                  size: 19,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${answersData.length}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.ios_share,
                              size: 17,
                              color: Colors.black.withOpacity(0.7),
                            )
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
                      for (var answer in answersData)
                        _answerWidget(answer, articleData, articleId,
                            controller, context),
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

  Widget _answerWidget(Map<String, dynamic> answer,
      Map<String, dynamic> articleData, String articleId, controller, context) {
    List<dynamic> answerImages = answer['images'] ?? [];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: 30.0, // 원하는 폭
          height: 30.0, // 원하는 높이
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.fill, // 원하는 BoxFit 설정
              image: AssetImage(answer['user']['avatar']),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 20),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: answer['is_adopted'] == true
                  ? const Color.fromARGB(35, 157, 0, 0)
                  : Colors.grey[50],
              border: Border.all(
                color: Colors.grey[100]!,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: appUser?.uid == articleData['user']['uid'] &&
                      appUser?.uid != answer['user']['uid'] &&
                      articleData['is_adopted'] == false,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    padding: const EdgeInsets.all(5),
                    width: 160,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(20, 157, 0, 0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: InkWell(
                      onTap: () {
                        controller.is_adopted(articleId, answer['id']);
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Icon(CupertinoIcons.checkmark,
                              size: 15, color: Color.fromARGB(255, 146, 0, 0)),
                          SizedBox(width: 3),
                          Text(
                            '도움이 되었다면 채택하기',
                            style: TextStyle(
                              fontSize: 11,
                              // fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 146, 0, 0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: articleData['is_adopted'] == true &&
                      answer['is_adopted'] == true,
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                    // padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      // color: Colors.red[100],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  color: Color.fromARGB(255, 157, 0, 0)),
                            ),
                          ],
                        ),
                        Visibility(
                            visible: appUser?.uid == answer['user']['uid'] ||
                                appUser?.uid == articleData['user']['uid'],
                            replacement: const SizedBox.shrink(),
                            child:
                                _goChatwithAnswerWriter(controller, articleId)),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${answer['user']['name']}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  formatTimestamp(answer['created_at']),
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      answer['content'],
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    _buildImageList(context, answerImages, 0.6, 0.4)
                  ],
                ),
                Visibility(
                  visible: answer['user']['uid'] == appUser?.uid &&
                      articleData['is_adopted'] == false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.to(AnsEditPage(
                            articleId: articleId,
                            answerId: answer['id'],
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          child: const Text(
                            '수정',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      InkWell(
                        onTap: () {
                          controller.ansDelete(articleId, answer['id']);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(
                              color: Colors.grey[300]!,
                            ),
                          ),
                          child: const Text(
                            '삭제',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageList(
      BuildContext context, List<dynamic> files, var width, var height) {
    List<String> imageUrls =
        files.map((file) => file['url'].toString()).toList();

    if (imageUrls.isEmpty) {
      return const SizedBox(); // 이미지가 없으면 빈 위젯 반환
    }

    return InkWell(
      onTap: () {
        Get.to(ImageViewer(imageUrls: imageUrls));
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrls[0],
              width: MediaQuery.of(context).size.width * width,
              height: MediaQuery.of(context).size.width * height,
              fit: BoxFit.cover,
            ),
          ),
          Visibility(
            visible: imageUrls.length > 1,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '클릭하면 나머지 ${imageUrls.length - 1}개 사진을 더 볼 수 있어요',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goChatwithAnswerWriter(
      AnsDetailController controller, String articleId) {
    final currentUserUid = appUser?.uid ?? '';
    final isCurrentUserQuestioner =
        controller.articleData.value!['user']['uid'] == currentUserUid;

    // firstWhere에 orElse를 추가하여 예외 방지
    final adoptedAnswer = controller.answersData.firstWhere(
      (answer) => answer['is_adopted'] == true,
      orElse: () => null, // 조건을 만족하는 요소가 없으면 null 반환
    );

    // adoptedAnswer가 null인 경우 처리 로직 추가
    if (adoptedAnswer == null) {
      return const SizedBox.shrink(); // 또는 다른 위젯 반환
    }

    String senderName, receiverName, senderProfile, receiverProfile;

    if (isCurrentUserQuestioner) {
      // 현재 사용자가 질문자일 경우
      senderName = controller.articleData.value!['user']['name'];
      senderProfile = controller.articleData.value!['user']['avatar'];
      receiverName = adoptedAnswer['user']['name'];
      receiverProfile = adoptedAnswer['user']['avatar'];
    } else {
      // 현재 사용자가 답변자일 경우
      senderName = adoptedAnswer['user']['name'];
      senderProfile = adoptedAnswer['user']['avatar'];
      receiverName = controller.articleData.value!['user']['name'];
      receiverProfile = controller.articleData.value!['user']['avatar'];
    }

    return InkWell(
      onTap: () async {
        String chatRoomId = await _createOrGetChatRoom(controller, articleId);
        if (chatRoomId.isNotEmpty) {
          // 채팅방 페이지로 이동
          Get.to(() => ChatPage(
                chatRoomId: chatRoomId,
                senderId: currentUserUid,
                receiverId: isCurrentUserQuestioner
                    ? adoptedAnswer['user']['uid']
                    : controller.articleData.value!['user']['uid'],
                senderName: senderName,
                receiverName: receiverName,
                senderProfile: senderProfile,
                receiverProfile: receiverProfile,
              ));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(20, 157, 0, 0),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Icon(CupertinoIcons.chat_bubble,
                size: 15, color: Color.fromARGB(255, 146, 0, 0)),
            SizedBox(width: 3),
            Text(
              '추가 질문하기',
              style: TextStyle(
                fontSize: 11,
                color: Color.fromARGB(255, 146, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _createOrGetChatRoom(
      AnsDetailController controller, String articleId) async {
    final String senderId = controller.articleData.value!['user']['uid'];
    final String receiverId = controller.answersData
        .firstWhere((answer) => answer['is_adopted'] == true)['user']['uid'];

    // 채팅방 ID 생성 (senderId와 receiverId를 기반으로 생성)
    String chatRoomId = senderId.compareTo(receiverId) > 0
        ? '${senderId}_$receiverId'
        : '${receiverId}_$senderId';

    // Firestore에 채팅방 정보 저장
    final chatRoomRef =
        FirebaseFirestore.instance.collection('chatRooms').doc(chatRoomId);
    final chatRoomSnapshot = await chatRoomRef.get();

    if (!chatRoomSnapshot.exists) {
      // 채팅방이 존재하지 않으면 생성
      await chatRoomRef.set({
        'users': [senderId, receiverId],
        'lastMessage': '',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });
    }

    return chatRoomId;
  }
}
