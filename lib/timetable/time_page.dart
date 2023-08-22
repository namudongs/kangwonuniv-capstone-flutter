// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  List friends = ["남동현", "김은희", "손민주", "", ""];

  int latestEnd = 24;
  void updateLatestEnd() {
    int tempLatestEnd = 24;
    daySubjects.forEach((day, slots) {
      for (var slot in slots) {
        if (slot.end > tempLatestEnd) {
          tempLatestEnd = slot.end;
        }
      }
    });
    latestEnd = tempLatestEnd;
  }

  // 각 요일별로 과목 정보를 저장하는 Map
  Map<String, List<TimeSlot>> daySubjects = {
    "월": [],
    "화": [],
    "수": [],
    "목": [],
    "금": [],
  };

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
                    '2023년 2학기',
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
                  print('시간표 추가 버튼 클릭');

                  setState(() {
                    daySubjects["월"] = [
                      TimeSlot("운영체제", 0, 9, Colors.red.shade200),
                      TimeSlot("컴퓨터구조", 9, 18, Colors.blue.shade200),
                      TimeSlot("모바일프로그래밍", 27, 36, Colors.green.shade200),
                    ];
                    daySubjects["목"] = [
                      TimeSlot("운영체제", 0, 9, Colors.red.shade200),
                      TimeSlot("컴퓨터구조", 9, 18, Colors.blue.shade200),
                      TimeSlot("모바일프로그래밍", 27, 36, Colors.green.shade200),
                    ];
                    daySubjects["금"] = [
                      TimeSlot("캡스톤프로젝트2", 0, 24, Colors.brown.shade200),
                    ];

                    updateLatestEnd(); // 끝나는 시간 계산
                  });
                },
                icon: const Icon(
                  CupertinoIcons.plus_square,
                ),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    daySubjects.forEach((day, slots) {
                      slots.removeWhere((slot) => slot.subject == "캡스톤프로젝트2");
                    });

                    updateLatestEnd(); // 끝나는 시간 계산
                  });
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
                              myTable("월", daySubjects["월"] ?? []),
                              myTable("화", daySubjects["화"] ?? []),
                              myTable("수", daySubjects["수"] ?? []),
                              myTable("목", daySubjects["목"] ?? []),
                              myTable("금", daySubjects["금"] ?? []),
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
                color:
                    week == "금" ? Colors.transparent : Colors.grey.shade300)),
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
          for (int i = 0; i <= latestEnd; i++)
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
                        bottom: const BorderSide(
                            width: 0, color: Colors.transparent),
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
}

class TimeSlot {
  final String subject;
  final int start;
  final int end;
  final Color color;

  TimeSlot(this.subject, this.start, this.end, this.color);
}
