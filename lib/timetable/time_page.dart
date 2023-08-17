// ignore_for_file: avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  List friends = ["고양이1", "고양이2", "고양이3", "고양이4", "고양이5"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(),
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 10),
                  const Text(
                    '2021년 2학기',
                    style: TextStyle(color: Palette.everyRed, fontSize: 13),
                  ),
                  const Text(
                    '시간표 🍒',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 23),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0.0,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimePage()));
                },
                icon: const Icon(
                  CupertinoIcons.plus_square,
                ),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimePage()));
                },
                icon: const Icon(
                  CupertinoIcons.gear,
                ),
                color: Colors.black,
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TimePage()));
                    },
                    icon: const Icon(
                      CupertinoIcons.list_bullet,
                    ),
                    color: Colors.black,
                  ))
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 400,
                          margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              myTable("월", [
                                TimeSlot(6, 15, Colors.red),
                                TimeSlot(40, 45, Colors.blue),
                              ]),
                              myTable("화", [
                                TimeSlot(12, 24, Colors.green),
                                TimeSlot(0, 6, Colors.purple),
                                TimeSlot(36, 48, Colors.greenAccent),
                              ]),
                              myTable("수", [
                                TimeSlot(10, 20, Colors.brown),
                                TimeSlot(40, 45, Colors.pink),
                              ]),
                              myTable("목", [
                                TimeSlot(10, 20, Colors.yellow),
                                TimeSlot(40, 45, Colors.teal),
                              ]),
                              myTable("금", [
                                TimeSlot(10, 20, Colors.limeAccent),
                                TimeSlot(40, 45, Colors.orangeAccent),
                              ])
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            height: 60 + 60.0 * friends.length,
                            width: 400,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('친구 시간표',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TimePage()));
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.plus_square,
                                            ),
                                            color: Colors.black,
                                          ),
                                        )
                                      ]),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  friendName(friends[0]),
                                  friendName(friends[1]),
                                  friendName(friends[2]),
                                  friendName(friends[3]),
                                  friendName(friends[4]),
                                ])),
                        Container(
                            margin: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                            height: 150,
                            width: 400,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('학점계산기',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold)),
                                        Container(
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const TimePage()));
                                            },
                                            icon: const Icon(
                                                CupertinoIcons.pencil),
                                            color: Colors.black,
                                          ),
                                        )
                                      ]),
                                  TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero),
                                      child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "평균 학점  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              "4.5",
                                              style: TextStyle(
                                                  color: Palette.everyRed,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              " / 4.5",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0),
                                            ),
                                            Text(
                                              "  취득 학점  ",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              "130",
                                              style: TextStyle(
                                                  color: Palette.everyRed,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0),
                                            ),
                                            Text(
                                              " / 130",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 15.0),
                                            ),
                                          ])),
                                ])),
                      ]),
                ))));
  }
}

Widget friendName(String name) {
  return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(color: Colors.black, fontSize: 17.0),
            ),
          ]));
}

Widget myTable(String week, List<TimeSlot> timeSlots) {
  return Expanded(
    child: Table(
      border: TableBorder(
          right: BorderSide(
              color: week == "금" ? Colors.transparent : Colors.grey.shade300)),
      children: [
        TableRow(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            children: [
              SizedBox(
                  height: 30.0,
                  child: Center(
                      child: Text(
                    week,
                  ))),
            ]),
        for (int i = 0; i < 60; i++)
          TableRow(children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(
                          width: 0.50,
                          color: i % 6 == 0
                              ? Colors.grey.shade300
                              : Colors.transparent),
                      bottom:
                          const BorderSide(width: 0, color: Colors.transparent),
                    ),
                  ),
                  height: 10.0,
                ),
                ...timeSlots.map((slot) {
                  if (i >= slot.start && i < slot.end) {
                    return Positioned.fill(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          color: slot.color, // 과목 색상
                          height: 10.0,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }).toList(),
              ],
            ),
          ]),
      ],
    ),
  );
}

class TimeSlot {
  final int start;
  final int end;
  final Color color;

  TimeSlot(this.start, this.end, this.color);
}
