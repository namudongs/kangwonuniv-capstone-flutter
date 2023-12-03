// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:capstone/components/utils.dart';
import 'package:capstone/main.dart';
import 'package:capstone/timetable/lectureAddForm.dart';
import 'package:capstone/timetable/lectureSlot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  // 분을 시간 형식(HH:mm)으로 변환하는 함수
  String formatTime(double minutes) {
    final int totalMinutes = minutes.toInt();
    final int hours = (totalMinutes / 60).floor() + 9; // 9:00부터 시작
    final int remainingMinutes = totalMinutes % 60;
    final String hourString = hours.toString().padLeft(2, '0');
    final String minuteString = remainingMinutes.toString().padLeft(2, '0');
    return '$hourString:$minuteString';
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
                snackBar('오류', '이미 추가된 강의입니다.');
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

      bool? shouldProceed = await showDialog(
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
                  snackBar('강의 추가', '강의가 추가되었습니다.');
                },
                child: const Text('예'),
              ),
            ],
          );
        },
      );

      if (shouldProceed == null) {
        snackBar('시간을 확인해주세요', '해당 시간대에 이미 강의가 있습니다.');
        return;
      } else if (shouldProceed == true) {
        _removeConflictingLectures(conflictingLectures);
        snackBar('겹친 강의 삭제', '강의가 삭제되었습니다.');
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
        if (lecture.day.isNotEmpty && lecture.end.isNotEmpty) {
          for (int i = 0; i < lecture.day.length; i++) {
            if (lecture.end[i] > latestEndTime) {
              latestEndTime = lecture.end[i];
            }
          }
        }
      }

      // 기존 로직 유지
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

  void _tappedLectureAdd() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.91,
          child: LectureAddForm(
            onSubmit: (LectureSlot newLecture) {
              _addLectureToTimetable(newLecture);
              _setTimetableLength();
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  void _tappedPlus() {
    TextEditingController searchController = TextEditingController();
    List<LectureSlot> filteredLectures = [];

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          margin: const EdgeInsets.only(top: 5),
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                    ),
                    const Text(
                      '강의 추가',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _tappedLectureAdd();
                      },
                      icon: const Icon(CupertinoIcons.add_circled),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: '강의명 검색',
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
                    (context as Element).markNeedsBuild();
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredLectures.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (filteredLectures.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    if (index <= filteredLectures.length &&
                        index >= 0 &&
                        filteredLectures[index].lname.isNotEmpty &&
                        filteredLectures[index].professor.isNotEmpty &&
                        filteredLectures[index].day.isNotEmpty &&
                        filteredLectures[index].start.isNotEmpty &&
                        filteredLectures[index].end.isNotEmpty &&
                        filteredLectures[index].classroom.isNotEmpty) {
                      final professor = filteredLectures[index].professor;
                      final days = filteredLectures[index].day;
                      final startTimes = filteredLectures[index].start;
                      final endTimes = filteredLectures[index].end;

                      String scheduleString = '';
                      for (int i = 0; i < days.length; i++) {
                        final day = days[i];
                        final classroom = filteredLectures[index].classroom[i];
                        final startTime = formatTime(startTimes[i].toDouble());
                        final endTime = formatTime(endTimes[i].toDouble());

                        if (day.isNotEmpty &&
                            classroom.isNotEmpty &&
                            startTime.isNotEmpty &&
                            endTime.isNotEmpty) {
                          scheduleString +=
                              '$day/$classroom/$startTime~$endTime';

                          if (i < days.length - 1) {
                            scheduleString += '\n';
                          }
                        }
                      }

                      return ListTile(
                        title: Text(filteredLectures[index].lname),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              professor,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              scheduleString,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          snackBar('강의 추가', '강의가 추가되었습니다.');
                          _addLectureToTimetable(filteredLectures[index]);
                          _setTimetableLength();
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
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
                if (appUser?.university == '강원대학교') {
                  _tappedPlus();
                  snackBar('강원대학교', '강원대학교 학생은 과목명 검색이 가능합니다.',
                      duration: const Duration(seconds: 2));
                } else {
                  _tappedLectureAdd();
                }
              },
              icon: const Icon(CupertinoIcons.add),
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('강의 삭제'),
                          content: const Text('강의를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 알림 닫기
                              },
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // 알림 닫기
                                setState(() {
                                  _selectedLectures.remove(lecture); // 강의 삭제
                                  _saveTimetable();
                                  _setTimetableLength();
                                });
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
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
                      child: SingleChildScrollView(
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
}
