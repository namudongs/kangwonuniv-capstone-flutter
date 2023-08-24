import 'dart:ui';

class TimeSlot {
  final int start = 0;
  final int end = 9;
  final Color color = const Color.fromARGB(215, 0, 81, 255);

  final String category; // 구분
  final int subjectCode; // 과목코드
  final int division; // 분반
  final String lectureName; // 과목명
  final String creditHours; // 시수
  final String section; // 부문
  final String targetMajorAndYear; // 대상학과 및 학년
  final int targetPeople; // 대상인원
  final String college; // 대학
  final String department; // 학과
  final String major; // 전공
  final int professorId; // 교번
  final String professorName; // 담당교수
  final String jobType; // 직종
  final String classroom; // 강의실
  final String remarks; // 비고
  final String eLearning; // 이러닝 강좌
  final String specialLecture; // 수강용과목
  final String closed; // 폐강여부

  TimeSlot({
    required this.category,
    required this.subjectCode,
    required this.division,
    required this.lectureName,
    required this.creditHours,
    required this.section,
    required this.targetMajorAndYear,
    required this.targetPeople,
    required this.college,
    required this.department,
    required this.major,
    required this.professorId,
    required this.professorName,
    required this.jobType,
    required this.classroom,
    required this.remarks,
    required this.eLearning,
    required this.specialLecture,
    required this.closed,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> map) {
    return TimeSlot(
      category: map['구분'],
      subjectCode: map['과목코드'],
      division: map['분반'],
      lectureName: map['과목명'],
      creditHours: map['시수'],
      section: map['부문'],
      targetMajorAndYear: map['대상학과 및\n학년'],
      targetPeople: map['대상\n인원'],
      college: map['대학'],
      department: map['학과'],
      major: map['전공'],
      professorId: map['교번'],
      professorName: map['담당교수'],
      jobType: map['직종'],
      classroom: map['강의실'],
      remarks: map['비고'] ?? "",
      eLearning: map['이러닝\n강좌'],
      specialLecture: map['수강용과목'] ?? "",
      closed: map['폐강여부'],
    );
  }
}
