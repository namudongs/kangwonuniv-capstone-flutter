// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:capstone/timetable/lecture_slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List week = ['월', '화', '수', '목', '금', '토'];
List<LectureSlot> selectedLectures = [];

double kColumnLength = 16;
double kFirstColumnHeight = 20;
double kBoxSize = 55;

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  void addLectureToTimetable(LectureSlot lecture) {
    setState(() {
      selectedLectures.add(lecture);
      print(selectedLectures);
      setTimetableLength();
    });
  }

  Future<List<LectureSlot>> loadAllTimeSlots() async {
    String jsonString =
        await rootBundle.loadString('assets/tuning_lectureDB_updated.json');

    List<dynamic> lecturesList = jsonDecode(jsonString);

    List<LectureSlot> allTimeSlots =
        lecturesList.map((lecture) => LectureSlot.fromJson(lecture)).toList();

    return allTimeSlots;
  }

  void setTimetableLength() {
    setState(() {
      double latestEndTime = 0;

      for (var lecture in selectedLectures) {
        for (int i = 0; i < lecture.day.length; i++) {
          if (lecture.end[i] > latestEndTime) {
            latestEndTime = lecture.end[i];
          }
        }
      }
      if (latestEndTime <= 480) {
        kColumnLength = 16;
      } else {
        kColumnLength = (latestEndTime / 60) * 2;
        if (kColumnLength % 2 != 0) {
          kColumnLength += 1;
        }
      }
    });
  }

  void tappedPlus() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        ValueNotifier<String> searchTermNotifier = ValueNotifier<String>("");
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
                        onChanged: (value) => searchTermNotifier.value = value,
                        decoration: const InputDecoration(
                          labelText: '과목명',
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
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      List<LectureSlot> allSubjects = snapshot.data!;

                      return ValueListenableBuilder<String>(
                        valueListenable: searchTermNotifier,
                        builder: (context, value, child) {
                          List<LectureSlot> filteredSubjects = allSubjects
                              .where((subject) => subject.lname.contains(value))
                              .toList();

                          return ListView.builder(
                            itemCount: filteredSubjects.length,
                            itemBuilder: (context, index) {
                              return buildLectureWidget(
                                  filteredSubjects[index], context);
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setTimetableLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(),
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10),
                const Text(
                  '2023년 2학기',
                  style: TextStyle(color: Colors.blue, fontSize: 13),
                ),
                const Text(
                  '시간표',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 23),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                tappedPlus();
              },
              icon: const Icon(CupertinoIcons.plus_square),
              color: Colors.black,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(0))),
                  width: MediaQuery.of(context).size.width - 20,
                  height:
                      (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight + 1,
                  child: Row(
                    children: [
                      buildTimeColumn(),
                      ...buildDayColumn(0),
                      ...buildDayColumn(1),
                      ...buildDayColumn(2),
                      ...buildDayColumn(3),
                      ...buildDayColumn(4),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildTimeColumn() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: kFirstColumnHeight,
          ),
          ...List.generate(
            kColumnLength.toInt(),
            (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.grey,
                  height: 0,
                );
              }
              return SizedBox(
                height: kBoxSize,
                child: Center(child: Text('${index ~/ 2 + 9}')),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> buildDayColumn(int index) {
    String currentDay = week[index];
    List<Widget> lecturesForTheDay = [];

    for (var lecture in selectedLectures) {
      for (int i = 0; i < lecture.day.length; i++) {
        double top = kFirstColumnHeight + (lecture.start[i] / 60.0) * kBoxSize;
        double height = ((lecture.end[i] - lecture.start[i]) / 60.0) * kBoxSize;

        if (lecture.day[i] == currentDay) {
          var classroom = lecture.classroom[i];
          if (classroom.isEmpty) {
            classroom = '';
          }

          lecturesForTheDay.add(
            Positioned(
              top: top,
              left: 0,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedLectures.remove(lecture);
                      setTimetableLength();
                    });
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 40) / 5,
                    height: height,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 2.0,
                        left: 1.0,
                        right: 1.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lecture.lname,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            classroom,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          );
        }
      }
    }

    return [
      const VerticalDivider(
        color: Colors.grey,
        width: 0,
      ),
      Expanded(
        flex: 4,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    '${week[index]}',
                  ),
                ),
                ...List.generate(
                  kColumnLength.toInt(),
                  (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.grey,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: kBoxSize,
                      child: Container(),
                    );
                  },
                ),
              ],
            ),
            ...lecturesForTheDay, // 현재 요일에 해당하는 모든 강의를 Stack에 추가
          ],
        ),
      ),
    ];
  }

  Widget buildLectureWidget(LectureSlot lecture, BuildContext context) {
    return ListTile(
      title: Text(lecture.lname),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lecture.professor),
          lecture.day.length == lecture.classroom.length
              ? Text(List.generate(
                  lecture.day.length,
                  (index) =>
                      '${lecture.day[index]}(${lecture.classroom[index]})',
                ).join(', '))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lecture.day.join(', ')),
                    const Text('이러닝 강의'),
                  ],
                ),
        ],
      ),
      onTap: () {
        addLectureToTimetable(lecture);
      },
    );
  }
}
