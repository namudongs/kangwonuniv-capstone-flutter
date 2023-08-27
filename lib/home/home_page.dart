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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // color: Colors.grey[300],
              height: 200,
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
                itemHeight: 200,
                viewportFraction: 0.5,
                scale: 0.6,
                fade: 0.5,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              color: Colors.grey[300],
              child: const Text(
                "capstone_0828",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
