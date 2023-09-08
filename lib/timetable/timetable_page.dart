// ignore_for_file: avoid_unnecessary_containers, avoid_print

import 'package:capstone/main.dart';
import 'package:capstone/timetable/lecture_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:capstone/components/color.dart';
import 'package:flutter/cupertino.dart';
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

                                    List<LectureSlot> allSubjects =
                                        snapshot.data!;

                                    return ValueListenableBuilder<String>(
                                      valueListenable: searchTermNotifier,
                                      builder: (context, value, child) {
                                        List<LectureSlot> filteredSubjects =
                                            allSubjects
                                                .where((subject) => subject
                                                    .lname
                                                    .contains(value))
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
                            _saveWeekLists();
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