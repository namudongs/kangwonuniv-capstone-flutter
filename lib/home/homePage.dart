// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';

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
        centerTitle: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: MediaQuery.of(context).size.height / 4 - 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/background_1.png'),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  height: MediaQuery.of(context).size.height / 4 - 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    image: const DecorationImage(
                        image: AssetImage('assets/images/background_2.png'),
                        fit: BoxFit.cover),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(
              height: 30,
              thickness: 1,
              color: Colors.grey.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }
}
