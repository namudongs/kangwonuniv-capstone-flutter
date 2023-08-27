// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:capstone/main.dart';
import 'package:capstone/timetable/time_table.dart';
import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:capstone/timetable/time_slot.dart';

class TimePage extends StatefulWidget {
  const TimePage({super.key});

  @override
  State<TimePage> createState() => _TimePageState();
}

class _TimePageState extends State<TimePage> {
  var lectureName = "";
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
                  // 시간표 강의 추가 버튼이 할일
                  // 1. JSON DB를 불러와 강의 정보를 리스트로 시간표 하단에 띄워준다. (카테고리, 강의명, 교수명, 강의실, 시간, 분반, 부서, 전공)
                  //      (리스트는 10개를 표시하며 스크롤이 가능하고, 맨 밑으로 스크롤하여 마지막 항목이 표시되면 다시 새로운 항목 10개를 불러온다.)
                  // 2. 강의명을 클릭하면 선택 여부를 표시하고 (선택한 항목의 배경색이 변하고, 항목의 정보를 표시하는 UI 밑에 '강의 추가' 버튼을 표시한다.) 시간표의 강의에 해당하는 시간을 회색으로 표시한다.
                  // 3. 강의명을 다시 클릭하면 선택 여부를 해제하고 시간표에 표시된 회색을 없애고 원래대로 돌린다.
                  // 4. 시간표 하단에 있는 강의 추가 버튼을 누르면 시간표에 선택한 강의와 시간이 겹치는 강의가 있는지 확인하고, 겹치는 강의가 없으면 시간표의 강의에 해당하는 시간을 파란색으로 변경하고 시간표에 과목을 추가한다.
                  // 5. '강의 추가' 버튼을 눌렀을 때에 시간이 겹치는 강의가 있다면 겹치는 강의가 있다는 메시지를 띄운다.
                  // 6. 사용자는 여러 강의를 추가할 수 있고, 겹치는 강의가 없을 때에만 추가할 수 있다.
                  // 7. 강의 정보 리스트 우측 상단에 '시간표 저장' 버튼을 누르면 추가한 강의들을 포함한 현재 시간표를 DB에 저장한다.
                  // 8. '시간표 저장' 버튼을 누르면 강의 정보 리스트를 닫는다.
                  // 9. 강의 정보 리스트 우측 상단 '시간표 저장' 버튼 옆에 있는 '닫기' 버튼을 누르면 강의 정보 리스트를 닫는다.
                  // 10. 언제든 시간표에 추가된 강의들을 클릭하면 삭제 여부를 묻는 팝업이 뜨고, '삭제' 버튼을 누르면 시간표에서 해당 강의를 삭제한다.

                  TimeSlot randomTimeSlot = await loadRandomTimeSlot();
                  lectureName = randomTimeSlot.lname;
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
                    updateLatestEnd();
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
                      slots.removeWhere((slot) => slot.lname == lectureName);
                    });

                    updateLatestEnd();
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
