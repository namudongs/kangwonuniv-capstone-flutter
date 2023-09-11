// ignore_for_file: avoid_print

import 'package:capstone/timetable/lecture_helper.dart';
import 'package:capstone/timetable/lecture_slot.dart';
import 'package:flutter/material.dart';

List week = ['월', '화', '수', '목', '금', '토'];
List<LectureSlot> selectedLectures = [];

double kColumnLength = 16;
double kFirstColumnHeight = 20;
double kBoxSize = 60;

class SubTable extends StatefulWidget {
  const SubTable({super.key});

  @override
  State<SubTable> createState() => _SubTableState();
}

class _SubTableState extends State<SubTable> {
  void addLectureToTimetable(LectureSlot lecture) {
    setState(() {
      selectedLectures.add(lecture);
      print(selectedLectures);
      setTimetableLength();
    });
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

  Widget buildLectureWidget(LectureSlot lecture, BuildContext context) {
    return ListTile(
      title: Text(lecture.lname),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Professor: ${lecture.professor}'),
          Text('Day: ${lecture.day.join(', ')}'),
          Text('Classroom: ${lecture.classroom.join(', ')}'),
        ],
      ),
      onTap: () {
        addLectureToTimetable(lecture);
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
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}");
                            }

                            List<LectureSlot> allSubjects = snapshot.data!;

                            return ValueListenableBuilder<String>(
                              valueListenable: searchTermNotifier,
                              builder: (context, value, child) {
                                List<LectureSlot> filteredSubjects = allSubjects
                                    .where((subject) =>
                                        subject.lname.contains(value))
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
                            return const Center(
                                child: CircularProgressIndicator());
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: (kColumnLength / 2 * kBoxSize) + kFirstColumnHeight,
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
          lecturesForTheDay.add(
            Positioned(
              top: top,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLectures.remove(lecture);
                    setTimetableLength();
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: height,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                  child: Text(
                    "${lecture.lname}\n${lecture.classroom[i]}",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
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
}
