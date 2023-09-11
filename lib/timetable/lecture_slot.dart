class LectureSlot {
  final String category;
  final int code;
  final int division;
  final String lname;
  final int peoplecount;
  final String college;
  final String department;
  final String major;
  final int procode;
  final String professor;
  final String prowork;
  final List<String> day;
  final List<String> classroom;
  final List<double> start;
  final List<double> end;
  final int number;

  LectureSlot({
    required this.category,
    required this.code,
    required this.division,
    required this.lname,
    required this.peoplecount,
    required this.college,
    required this.department,
    required this.major,
    required this.procode,
    required this.professor,
    required this.prowork,
    required this.day,
    required this.classroom,
    required this.start,
    required this.end,
    required this.number,
  });

  factory LectureSlot.fromJson(Map<String, dynamic> map) {
    return LectureSlot(
      category: map['category'] ?? '',
      code: map['code'] ?? 0,
      division: map['division'] ?? 0,
      lname: map['lname'] ?? '',
      peoplecount: map['peoplecount'] ?? 0,
      college: map['college'] ?? '',
      department: map['department'] ?? '',
      major: map['major'] ?? '',
      procode: map['procode'] ?? 0,
      professor: map['professor'] ?? '',
      prowork: map['prowork'] ?? '',
      day: map['day'] != null ? List<String>.from(map['day']) : [],
      classroom:
          map['classroom'] != null ? List<String>.from(map['classroom']) : [],
      start: map['start'] != null
          ? List<double>.from(map['start'].map((e) => e.toDouble()))
          : [],
      end: map['end'] != null
          ? List<double>.from(map['end'].map((e) => e.toDouble()))
          : [],
      number: map['number'] ?? 0,
    );
  }

  @override
  String toString() {
    return '\n선택된 강의 : $lname, $day, $start, $end, $classroom';
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'code': code,
      'division': division,
      'lname': lname,
      'peoplecount': peoplecount,
      'college': college,
      'department': department,
      'major': major,
      'procode': procode,
      'professor': professor,
      'prowork': prowork,
      'day': day,
      'classroom': classroom,
      'start': start,
      'end': end,
      'number': number,
    };
  }
}

final Map<String, List<double>> convertTimeMap = {
  'A1': [0, 7.5],
  'A2': [9, 16.5],
  'A3': [18, 25.5],
  'A4': [27, 34.5],
  'A5': [36, 43.5],
  'A6': [48, 55.5],
  '1': [0, 5],
  '2': [5, 10],
  '3': [10, 15],
  '4': [15, 20],
  '5': [20, 25],
  '6': [25, 30],
  '7': [30, 35],
  '8': [35, 40],
  '9': [40, 45],
  '10': [45, 50],
  '11': [50, 55],
  '12': [55, 60],
  '13': [60, 65],
  '14': [65, 70],
};
