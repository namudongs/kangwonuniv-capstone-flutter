// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:capstone/main.dart';
import 'package:capstone/timetable/lecture_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/timetable/lecture_slot.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  final String userId = appUser?.uid ?? '';

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

  bool isAddWidgetVisible = false;

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
    _loadWeekLists();
  }

  void _loadWeekLists() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('timetable')
        .doc('data')
        .get()
        .then((doc) {
      if (doc.exists) {
        setState(() {
          weekLists = Map<String, List<LectureSlot>>.from(doc
              .data()?['weekLists']
              .map((k, v) => MapEntry(
                  k,
                  List<LectureSlot>.from(
                      v.map((x) => LectureSlot.fromJson(x))))));
          latestEnd = doc.data()?['latestEnd'];
        });
      }
    });
  }

  void _saveWeekLists() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('timetable')
        .doc('data')
        .set({
      'weekLists': weekLists
          .map((k, v) => MapEntry(k, v.map((x) => x.toJson()).toList())),
      'latestEnd': latestEnd,
    });
  }

  // ListTile을 빌드하는 별도의 메서드
  Widget _buildLectureTile(LectureSlot subject) {
    List<String> subjectTime = convertSubjectTime(subject.start, subject.end);
    return ListTile(
      title: Text(subject.lname),
      subtitle: Text(
          "${subject.division}분반, ${subject.professor} 교수\n${subject.day}요일\n(${subjectTime.join("), (")})\n${subject.classroom.join(", ")}"),
      onTap: () {
        // 각 리스트타일을 클릭하면 발생하는 이벤트
        // 클릭한 리스트타일의 과목 정보를 시간표에 추가한다.
        setState(() {
          setState(() {
            for (int i = 0; i < subject.day.length; i++) {
              weekLists[subject.day[i]]?.add(LectureSlot(
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
            _saveWeekLists();
          });
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // 과목 추가 버튼 클릭

            showModalBottomSheet(
              context: context,
              builder: (context) {
                ValueNotifier<String> searchTermNotifier =
                    ValueNotifier<String>("");
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged: (value) =>
                                    searchTermNotifier.value = value,
                                decoration: const InputDecoration(
                                  labelText: 'Search',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<LectureSlot>>(
                          future: loadAllTimeSlots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return Text("Error: ${snapshot.error}");
                              }

                              List<LectureSlot> allSubjects = snapshot.data!;

                              return ValueListenableBuilder<String>(
                                valueListenable: searchTermNotifier,
                                builder: (context, value, child) {
                                  List<LectureSlot> filteredSubjects =
                                      allSubjects
                                          .where((subject) =>
                                              subject.lname.contains(value))
                                          .toList();

                                  return ListView.builder(
                                    itemCount: filteredSubjects.length,
                                    itemBuilder: (context, index) {
                                      return _buildLectureTile(
                                          filteredSubjects[index]);
                                    },
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child:
                                      CircularProgressIndicator()); // 로딩 인디케이터 표시
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          label: const Text('ADD LECTURE'),
          icon: const Icon(Icons.add),
          backgroundColor: Colors.lightBlueAccent,
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
                      ]),
                ))));
  }

  Widget weekTable(String week, List<LectureSlot> lectureSlots) {
    return Expanded(
        child: Stack(children: [
      Table(
        border: TableBorder(
          right: BorderSide(
            color: week == "금" ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            children: [
              SizedBox(
                height: 30.0,
                child: Center(
                  child: Text(
                    week,
                  ),
                ),
              ),
            ],
          ),
          for (int i = 0; i <= latestEnd; i++)
            TableRow(
              children: [
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
                                : Colors.transparent,
                          ),
                          bottom: const BorderSide(
                            width: 0,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      height: 10.0,
                    ),
                    ...lectureSlots.map((slot) {
                      if (i >= slot.start[0] && i < slot.end[0]) {
                        return Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              // 강의를 클릭하면 발생하는 이벤트
                              // 클릭한 강의를 시간표에서 삭제한다.
                              int currentNumber = slot.number;

                              setState(() {
                                weekLists.forEach((day, slots) {
                                  slots.removeWhere(
                                      (slot) => slot.number == currentNumber);
                                });
                                updateTimeTableEnd();
                                _saveWeekLists();
                              });
                            },
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    color: Colors.blue,
                                  ),
                                ),
                                if (slot.start[0] == i)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      color: Colors.blue,
                                      child: Text(
                                        slot.lname,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (slot.start[0] + 1 == i)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      color: Colors.blue,
                                      child: Text(
                                        slot.classroom[0],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (slot.start[0] + 2 == i)
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      color: Colors.blue,
                                      child: Text(
                                        slot.professor,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }).toList(),
                  ],
                ),
              ],
            ),
        ],
      ),
    ]));
  }
}
