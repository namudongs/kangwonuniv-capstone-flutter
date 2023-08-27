class TimeSlot {
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

  TimeSlot({
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

  factory TimeSlot.fromJson(Map<String, dynamic> map) {
    return TimeSlot(
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
}
