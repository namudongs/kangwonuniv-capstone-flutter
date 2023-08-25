// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:capstone/main.dart';
import 'package:capstone/timetable/time_table.dart';
import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capstone/timetable/time_slot.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  double latestEnd = 24;
  void updateLatestEnd() {
    double tempLatestEnd = 24;
    daySubjects.forEach((day, slots) {
      for (var slot in slots) {
        if (slot.end.isNotEmpty && slot.end.last > tempLatestEnd) {
          tempLatestEnd = slot.end.last;
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
  void initState() {
    super.initState();
    print(appUser?.uid);
  }

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
                onPressed: () async {
                  // setState(() {
                  //   daySubjects["월"] = [];
                  //   daySubjects["화"] = [];
                  //   daySubjects["수"] = [];
                  //   daySubjects["목"] = [];
                  //   daySubjects["금"] = [];

                  //   saveDaySubjectsToFirestore(appUser?.uid, daySubjects);
                  //   updateLatestEnd(); // 끝나는 시간 계산
                  // });

                  TimeSlot randomTimeSlot = await loadRandomTimeSlot();
                  print(randomTimeSlot.lname);
                  print(randomTimeSlot.professor);
                  print(randomTimeSlot.day);
                  print(randomTimeSlot.classroom);
                  print(randomTimeSlot.start);
                  print(randomTimeSlot.end);

                  for (int i = 0; i < randomTimeSlot.day.length; i++) {
                    daySubjects[randomTimeSlot.day[i]]?.add(TimeSlot(
                      category: randomTimeSlot.category,
                      code: randomTimeSlot.code,
                      division: randomTimeSlot.division,
                      lname: randomTimeSlot.lname,
                      peoplecount: randomTimeSlot.peoplecount,
                      college: randomTimeSlot.college,
                      department: randomTimeSlot.department,
                      major: randomTimeSlot.major,
                      procode: randomTimeSlot.procode,
                      professor: randomTimeSlot.professor,
                      prowork: randomTimeSlot.prowork,
                      day: [randomTimeSlot.day[i]],
                      classroom: [randomTimeSlot.classroom[i]],
                      start: [randomTimeSlot.start[i]],
                      end: [randomTimeSlot.end[i]],
                    ));
                  }

                  setState(() {
                    updateLatestEnd(); // Calculate the ending time
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
                      slots.removeWhere((slot) => slot.lname == "캡스톤프로젝트2");
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
                      ]),
                ))));
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
                    if (i >= slot.start[0] && i < slot.end[0]) {
                      return Positioned.fill(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: const Color.fromRGBO(
                                74, 86, 255, 0.637), // 과목 색상
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
