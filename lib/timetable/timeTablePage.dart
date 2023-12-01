// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:capstone/main.dart';
import 'package:capstone/timetable/lectureSlot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

List week = ['월', '화', '수', '목', '금'];
List<LectureSlot> _selectedLectures = [];

double _kColumnLength = 16;
double _kFirstColumnHeight = 20;
double _kBoxSize = 55;

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({super.key});

  @override
  State<TimeTablePage> createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  void _saveTimetable() {
    appUser!.timetable = _selectedLectures.map((e) => e.toJson()).toList();
    FirebaseFirestore.instance
        .collection('users')
        .doc(appUser!.uid)
        .update(appUser!.toMap());
  }

  void _fetchTimetable() {
    _selectedLectures =
        appUser!.timetable.map((e) => LectureSlot.fromJson(e)).toList();
  }

  List<LectureSlot> _findConflictingLectures(LectureSlot lecture) {
    List<LectureSlot> conflictingLectures = [];

    for (var selectedLecture in _selectedLectures) {
      for (int i = 0; i < selectedLecture.day.length; i++) {
        for (int j = 0; j < lecture.day.length; j++) {
          // 같은 요일에 시간이 겹치는 경우
          if (selectedLecture.day[i] == lecture.day[j] &&
              ((lecture.start[j] < selectedLecture.end[i] &&
                      lecture.end[j] > selectedLecture.start[i]) ||
                  (lecture.end[j] > selectedLecture.start[i] &&
                      lecture.start[j] < selectedLecture.end[i]))) {
            if (!conflictingLectures.contains(selectedLecture)) {
              if (lecture.lname == selectedLecture.lname) {
                print('이미 추가된 강의입니다.');
                break;
              } else {
                conflictingLectures.add(selectedLecture);
              }
            }
          }
        }
      }
    }

    return conflictingLectures;
  }

  void _removeConflictingLectures(List<LectureSlot> conflictingLectures) {
    setState(() {
      _selectedLectures
          .removeWhere((element) => conflictingLectures.contains(element));
    });
  }

  void _addLectureToTimetable(LectureSlot lecture) async {
    List<LectureSlot> conflictingLectures = _findConflictingLectures(lecture);

    if (conflictingLectures.isNotEmpty) {
      String conflictingLectureDetails = conflictingLectures.map((e) {
        return '${e.lname}, ${e.professor}';
      }).join("\n");

      bool shouldProceed = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('강의 시간 겹침'),
            content: Text(
                '다음 강의와 시간이 겹칩니다:\n$conflictingLectureDetails\n그래도 계속하시겠습니까?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('아니요'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('예'),
              ),
            ],
          );
        },
      );

      if (shouldProceed == true) {
        _removeConflictingLectures(conflictingLectures);
      } else {
        return;
      }
    }

    setState(() {
      _selectedLectures.add(lecture);
      _saveTimetable();
      _setTimetableLength();
    });
  }

  Future<List<LectureSlot>> _loadAllTimeSlots() async {
    String jsonString = await rootBundle
        .loadString('assets/timetable/tuning_lectureDB_updated.json');

    List<dynamic> lecturesList = jsonDecode(jsonString);

    List<LectureSlot> allTimeSlots =
        lecturesList.map((lecture) => LectureSlot.fromJson(lecture)).toList();

    return allTimeSlots;
  }

  void _setTimetableLength() {
    setState(() {
      double latestEndTime = 0;

      for (var lecture in _selectedLectures) {
        for (int i = 0; i < lecture.day.length; i++) {
          if (lecture.end[i] > latestEndTime) {
            latestEndTime = lecture.end[i];
          }
        }
      }
      if (latestEndTime <= 480) {
        _kColumnLength = 16;
      } else {
        _kColumnLength = (latestEndTime / 60) * 2;
        if (_kColumnLength % 2 != 0) {
          _kColumnLength += 1;
        }
      }
    });
  }

  void _tappedPlus() {
    TextEditingController searchController = TextEditingController();
    List<LectureSlot> filteredLectures = [];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '강의 추가',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Get.to();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: '과목명 검색',
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      List<LectureSlot> allTimeSlots =
                          await _loadAllTimeSlots();
                      filteredLectures = allTimeSlots
                          .where((lecture) => lecture.lname
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    } else {
                      filteredLectures = [];
                    }
                    (context as Element).markNeedsBuild(); // UI 업데이트
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredLectures.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(filteredLectures[index].lname),
                        subtitle: Text(filteredLectures[index].professor),
                        onTap: () {
                          _addLectureToTimetable(filteredLectures[index]);
                          _setTimetableLength();
                        });
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

    _fetchTimetable();
    _setTimetableLength();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
              children: [
                Container(height: 10),
                const Text(
                  '2023년 2학기',
                  style: TextStyle(
                      color: Color.fromARGB(255, 157, 1, 1), fontSize: 13),
                ),
                const Text(
                  '시간표',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                _tappedPlus();
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
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  width: MediaQuery.of(context).size.width - 20,
                  height: (_kColumnLength / 2 * _kBoxSize) +
                      _kFirstColumnHeight +
                      1,
                  child: Row(
                    children: [
                      _buildTimeColumn(),
                      ..._buildDayColumn(0),
                      ..._buildDayColumn(1),
                      ..._buildDayColumn(2),
                      ..._buildDayColumn(3),
                      ..._buildDayColumn(4),
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

  Expanded _buildTimeColumn() {
    return Expanded(
      child: Column(
        children: [
          SizedBox(
            height: _kFirstColumnHeight,
          ),
          ...List.generate(
            _kColumnLength.toInt(),
            (index) {
              if (index % 2 == 0) {
                return const Divider(
                  color: Colors.black12,
                  height: 0,
                );
              }
              return SizedBox(
                height: _kBoxSize,
                child: Text('${index ~/ 2 + 9}'),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDayColumn(int index) {
    String currentDay = week[index];
    List<Widget> lecturesForTheDay = [];

    for (var lecture in _selectedLectures) {
      for (int i = 0; i < lecture.day.length; i++) {
        double top =
            _kFirstColumnHeight + (lecture.start[i] / 60.0) * _kBoxSize;
        double height =
            ((lecture.end[i] - lecture.start[i]) / 60.0) * _kBoxSize;

        // 강의실 없는 경우 대응
        if (lecture.classroom.isEmpty || lecture.classroom[i].isEmpty) {
          lecture.classroom.add('이러닝');
          print(lecture.classroom);
        }

        if (lecture.day[i] == currentDay) {
          var classroom = lecture.classroom[i];

          lecturesForTheDay.add(
            Positioned(
              top: top,
              left: 0,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLectures.remove(lecture);
                      _saveTimetable();
                      _setTimetableLength();
                    });
                  },
                  child: Container(
                    width: (MediaQuery.of(context).size.width - 40) / 5,
                    height: height,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 153, 92, 92),
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
                          Text(
                            lecture.professor,
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
        color: Colors.black12,
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
                  _kColumnLength.toInt(),
                  (index) {
                    if (index % 2 == 0) {
                      return const Divider(
                        color: Colors.black12,
                        height: 0,
                      );
                    }
                    return SizedBox(
                      height: _kBoxSize,
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

  Widget _buildLectureWidget(LectureSlot lecture, BuildContext context) {
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
        _addLectureToTimetable(lecture);
      },
    );
  }
}
