// ignore_for_file: avoid_print, file_names

import 'package:capstone/main.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 104, 0, 123).withOpacity(1),
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 10),
              const Text(
                '홈',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SizedBox(
              // color: Colors.grey[300],
              height: 150,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: const Color.fromARGB(255, 104, 0, 123)
                            .withOpacity(0.3),
                        child: Center(
                          child: Text(
                            '${appUser?.university ?? '사용자 정보 로딩 중'}\n${appUser?.email ?? '사용자 정보 로딩 중'} \n${appUser?.userName}\n$index',
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        // Image.network(
                        //   "https://picsum.photos/400/200?random=$index",
                        //   fit: BoxFit.fill,
                        // ),
                      ));
                },
                itemCount: 3,
                itemHeight: 150,
                viewportFraction: 0.7,
                scale: 0.7,
                fade: 0.5,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  // color: Colors.grey[300],
                  // border: Border.all(color: Colors.grey),
                  // borderRadius: BorderRadius.circular(20),
                  ),
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "🔥인기있는 질문",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 155,
                    padding: const EdgeInsets.all(9),
                    child: ListView.separated(
                      itemCount: 10,
                      itemBuilder: (BuildContext ctx, int idx) {
                        return Text('$idx번째 게시글입니다. 반갑습니다. 안녕하세요.');
                      },
                      separatorBuilder: (BuildContext ctx, int idx) {
                        return const Divider();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}