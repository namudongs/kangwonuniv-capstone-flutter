// ignore_for_file: avoid_print, file_names

import 'package:capstone/ans/detail/ansDetailPage.dart';
import 'package:capstone/group/groupListPage.dart';
import 'package:capstone/home/homeController.dart';
import 'package:capstone/notfiy/notificationController.dart';
import 'package:capstone/timetable/timeTablePage.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final NotificationController notificationController =
      Get.find<NotificationController>();
  Timer? _timer;
  int totalArticles = 0;
  var messageString = "";

  @override
  void initState() {
    super.initState();
    notificationController.saveDeviceToken();

    // 5초마다 페이지 전환
    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   if (_pageController.hasClients && totalArticles > 0) {
    //     int nextPage = (_pageController.page!.toInt() + 1) % totalArticles;
    //     _pageController.animateToPage(
    //       nextPage,
    //       duration: const Duration(milliseconds: 400),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Image.asset(
              'assets/icons/qu_icon.png',
              width: 40,
              fit: BoxFit.cover,
            ),
            // const Padding(
            //   padding: EdgeInsets.only(left: 8),
            //   child: Text(''),
            // ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 4 - 20,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/images/background_1.png'),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '전공 재학생들에게\n궁금한 것을 물어보세요!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'HomeTitleFont',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '대학교 전공에 대해 궁금한 것을\n전공자에게 직접 질문하고 답변을 받아보세요.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'HomeTitleFont',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print('시간표를 탭했습니다.');
                        Get.to(const TimeTablePage(), fullscreenDialog: true);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(
                                  0xFFB76652), // This is the color at the top edge of the image
                              Color.fromARGB(255, 157, 76,
                                  55), // This is the color at the bottom edge of the image
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset.zero,
                            ),
                          ],
                          // image: const DecorationImage(
                          //   image: AssetImage('assets/images/background_1.png'),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 0, 6, 10),
                        width: MediaQuery.of(context).size.width / 2 - 21,
                        height: MediaQuery.of(context).size.height / 6,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '시간표',
                              style: TextStyle(
                                fontFamily: 'HomeTitleFont',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(Icons.calendar_today_rounded,
                                color: Colors.white, size: 70),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const GroupListPage());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          borderRadius: BorderRadius.circular(15),
                          gradient: const LinearGradient(
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                            colors: [
                              Color(
                                  0xFFB76652), // This is the color at the top edge of the image
                              Color.fromARGB(255, 158, 62,
                                  35), // This is the color at the bottom edge of the image
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 1,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.fromLTRB(6, 0, 15, 10),
                        width: MediaQuery.of(context).size.width / 2 - 21,
                        height: MediaQuery.of(context).size.height / 6,
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '스터디',
                              style: TextStyle(
                                fontFamily: 'HomeTitleFont',
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Icon(Icons.group, color: Colors.white, size: 70),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 30,
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '🔥질문에 답변하고 QU를 얻어보세요!',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: StreamBuilder<List<Map<String, dynamic>?>>(
                          stream: HomeController().getRecentArticlesStream(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Text('Loading...');
                            }

                            totalArticles = snapshot.data?.length ?? 0;
                            int itemCount =
                                totalArticles < 3 ? totalArticles : 3;

                            return ListView.builder(
                              controller: _pageController,
                              itemCount: itemCount,
                              itemBuilder: (context, index) {
                                var article = snapshot.data?[index];
                                if (article == null) {
                                  return const SizedBox.shrink();
                                }
                                return GestureDetector(
                                  onTap: () {
                                    // AnsDetailPage로 이동
                                    Get.to(AnsDetailPage(
                                        articleId: article['id']));
                                  },
                                  child: buildArticleItem(article, context),
                                ); // 각 문서를 위젯으로 변환
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildArticleItem(Map<String, dynamic> article, context) {
    return Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color.fromARGB(19, 102, 30, 30),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                article['category'],
                style: const TextStyle(
                    fontSize: 8,
                    color: Color.fromARGB(200, 106, 0, 0),
                    fontFamily: 'NanumSquare'),
              ),
            ),
            const SizedBox(height: 5),
            if (article['title'].isNotEmpty)
              Text(article['title'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  )),
            Visibility(
              visible: article['title'].isNotEmpty,
              replacement: Text(
                article['content'].replaceAll('\n', ' '),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              child: Text(
                article['content'].replaceAll('\n', ' '),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
