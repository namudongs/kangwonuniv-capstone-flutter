import 'package:capstone/components/utils.dart';
import 'package:capstone/timetable/lectureSlot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LectureAddForm extends StatefulWidget {
  final Function(LectureSlot) onSubmit;

  const LectureAddForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _LectureAddFormState createState() => _LectureAddFormState();
}

class _LectureAddFormState extends State<LectureAddForm> {
  final _formKey = GlobalKey<FormState>();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final _lnameController = TextEditingController();
  final _classroomController = TextEditingController();
  final _professorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Column(
        children: [
          Row(
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
                  try {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      List<String> selectedDays = days.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList();

                      // classroom, start, end 리스트 초기화
                      List<String> classrooms = [];
                      List<double> startTimes = [];
                      List<double> endTimes = [];

                      // 선택한 요일에 따라 classroom, start, end를 중복해서 추가
                      for (var _ in selectedDays) {
                        classrooms.add(_classroomController.text);
                        startTimes.add(_convertTime(_startTime));
                        endTimes.add(_convertTime(_endTime));
                      }

                      LectureSlot newLecture = LectureSlot(
                        category: '기본값',
                        code: 0,
                        division: 0,
                        lname: _lnameController.text,
                        classroom: classrooms,
                        professor: _professorController.text,
                        day: selectedDays,
                        start: startTimes,
                        end: endTimes,
                        number: 0,
                        peoplecount: 0,
                        college: '',
                        department: '',
                        major: '',
                        procode: 0,
                        prowork: '',
                      );

                      widget.onSubmit(newLecture);
                      snackBar('강의 추가', '강의가 추가되었습니다.');
                      Get.back();
                    }
                  } catch (e) {
                    print(e);
                    snackBar('강의 추가', '강의 추가에 실패했습니다.');
                  }
                },
                icon: const Icon(CupertinoIcons.add_circled),
              ),
            ],
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _lnameController,
                      decoration: const InputDecoration(labelText: '과목명'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '과목명을 입력해주세요.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _classroomController,
                      decoration: const InputDecoration(labelText: '강의실'),
                    ),
                    TextFormField(
                      controller: _professorController,
                      decoration: const InputDecoration(labelText: '교수명'),
                    ),
                    _buildDayCheckboxes(),
                    // 시작 시간 및 종료 시간 선택기를 여기에 추가합니다.
                    ListTile(
                      title: const Text('시작 시간'),
                      trailing: Text(
                        _startTime?.format(context) ?? '시간 선택',
                      ),
                      onTap: () {
                        _selectTime(context, true);
                      },
                    ),
                    ListTile(
                      title: const Text('종료 시간'),
                      trailing: Text(
                        _endTime?.format(context) ?? '시간 선택',
                      ),
                      onTap: () {
                        _selectTime(context, false);
                      },
                    ),
                    // const SizedBox(height: 10),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //     foregroundColor: Colors.white,
                    //     backgroundColor: const Color.fromARGB(150, 157, 0, 0),
                    //   ),
                    //   onPressed: () {},
                    //   child: SizedBox(
                    //     width: MediaQuery.of(context).size.width * 0.7,
                    //     child: const Text(
                    //       '추가하기',
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(fontSize: 16),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _convertTime(TimeOfDay? time) {
    if (time == null || time.hour < 9) {
      return 0.0;
    }

    return (time.hour - 9) * 60.0 + time.minute;
  }

  Map<String, bool> days = {
    '월': false,
    '화': false,
    '수': false,
    '목': false,
    '금': false,
  };

  Widget _buildDayCheckboxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: days.keys.map((String key) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(key),
            Checkbox(
              shape: const CircleBorder(
                side: BorderSide(color: Colors.black),
              ),
              value: days[key],
              onChanged: (bool? value) {
                setState(() {
                  days[key] = value!;
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? _startTime ?? TimeOfDay.now()
          : _endTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial, // 아침 시간대(AM)를 기본으로 표시
    );

    if (picked != null) {
      // 선택한 시간이 9시부터 19시 사이인지 확인
      if (picked.hour >= 9 &&
          (picked.hour < 19 || (picked.hour == 19 && picked.minute == 0))) {
        setState(() {
          if (isStartTime) {
            _startTime = picked;
          } else {
            _endTime = picked;
          }
        });
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('선택할 수 없는 시간'),
              content: const Text('시간은 오전 9시부터 오후 7시 사이만 선택 가능합니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
