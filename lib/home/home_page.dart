// ignore_for_file: avoid_print

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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              // color: Colors.grey[300],
              height: 150,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      "https://picsum.photos/400/200?random=$index",
                      fit: BoxFit.fill,
                    ),
                  );
                },
                itemCount: 3,
                itemHeight: 150,
                viewportFraction: 0.7,
                scale: 0.7,
                fade: 0.5,
              ),
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      "🔥최근 게시글",
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
