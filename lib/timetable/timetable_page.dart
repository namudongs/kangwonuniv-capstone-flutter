// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:capstone/main.dart';
import 'package:capstone/timetable/lecture_helper.dart';
import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:capstone/timetable/lecture_slot.dart';
import 'package:capstone/components/custom_search_bar.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  double latestEnd = 24;
  void updateTimeTableEnd() {
    double tempLatestEnd = 24;
    weekLists.forEach((day, slots) {
      for (var slot in slots) {
        if (slot.end.isNotEmpty && slot.end.last > tempLatestEnd) {
          tempLatestEnd = slot.end.last;
        }
      }
    });
    latestEnd = tempLatestEnd;
  }

  String _searchTerm = ''; // 검색어 상태 변수 추가

  Map<String, List<LectureSlot>> weekLists = {
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
            elevation: 0.0,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  // AppBar의 + 버튼을 누르면 발생하는 이벤트
                },
                icon: const Icon(
                  CupertinoIcons.plus_square,
                ),
                color: Colors.black,
              ),
              IconButton(
                onPressed: () {
                  // AppBar의 ⚙️ 버튼을 누르면 발생하는 이벤트
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
                      // AppBar의 - 버튼을 누르면 발생하는 이벤트
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
                              weekTable("월", weekLists["월"] ?? []),
                              weekTable("화", weekLists["화"] ?? []),
                              weekTable("수", weekLists["수"] ?? []),
                              weekTable("목", weekLists["목"] ?? []),
                              weekTable("금", weekLists["금"] ?? []),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: CustomSearchBar(
                            onSearchTermChanged: (term) {
                              setState(() {
                                _searchTerm = term;
                              });
                            },
                          ),
                        ),
                        FutureBuilder<List<LectureSlot>>(
                          future: loadAllTimeSlots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              }

                              List<LectureSlot> allSubjects = snapshot.data!;

                              // 검색어로 필터링
                              List<LectureSlot> filteredSubjects = allSubjects
                                  .where((subject) =>
                                      subject.lname.contains(_searchTerm))
                                  .toList();

                              return SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  itemCount: filteredSubjects.length,
                                  itemBuilder: (context, index) {
                                    LectureSlot subject =
                                        filteredSubjects[index];
                                    List<String> subjectTime =
                                        convertSubjectTime(
                                            subject.start, subject.end);

                                    return ListTile(
                                      title: Text(subject.lname),
                                      subtitle: Text(
                                          "${subject.division}분반, ${subject.professor} 교수\n${subject.day}요일\n(${subjectTime.join("), (")})\n${subject.classroom.join(", ")}"),
                                      onTap: () {
                                        // 각 리스트타일을 클릭하면 발생하는 이벤트
                                        // 클릭한 리스트타일의 과목 정보를 시간표에 추가한다.

                                        setState(() {
                                          for (int i = 0;
                                              i < subject.day.length;
                                              i++) {
                                            weekLists[subject.day[i]]
                                                ?.add(LectureSlot(
                                              category: subject.category,
                                              code: subject.code,
                                              division: subject.division,
                                              lname: subject.lname,
                                              peoplecount: subject.peoplecount,
                                              college: subject.college,
                                              department: subject.department,
                                              major: subject.major,
                                              procode: subject.procode,
                                              professor: subject.professor,
                                              prowork: subject.prowork,
                                              day: [subject.day[i]],
                                              classroom: [subject.classroom[i]],
                                              start: [subject.start[i]],
                                              end: [subject.end[i]],
                                              number: subject.number,
                                            ));
                                          }
                                          updateTimeTableEnd();
                                        });
                                      },
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator(); // Show a loading indicator while waiting
                            }
                          },
                        ),
                      ]),
                ))));
  }

  Widget weekTable(String week, List<LectureSlot> lectureSlots) {
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
                  ...lectureSlots.map((slot) {
                    if (i >= slot.start[0] && i < slot.end[0]) {
                      return Positioned.fill(
                          child: GestureDetector(
                        onTap: () {
                          // 과목을 클릭하면 발생하는 이벤트
                          // 클릭한 과목을 시간표에서 삭제한다.

                          int currentNumber = slot.number;

                          setState(() {
                            weekLists.forEach((day, slots) {
                              slots.removeWhere(
                                  (slot) => slot.number == currentNumber);
                            });
                            updateTimeTableEnd();
                          });
                        },
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            color: const Color.fromRGBO(
                                74, 86, 255, 0.637), // 과목 색상
                            height: 10.0,
                          ),
                        ),
                      ));
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
