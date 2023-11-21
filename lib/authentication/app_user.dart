class AppUser {
  final String uid;
  final String email;
  final String userName;
  final String university;
  final int grade;
  final String major;
  List<Map<String, dynamic>>? timetable;

  AppUser({
    required this.uid,
    required this.email,
    required this.userName,
    required this.university,
    required this.grade,
    required this.major,
    this.timetable,
  });

  // JSON 형식으로 변환
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'university': university,
      'grade': grade,
      'major': major,
      'timetable': timetable,
    };
  }

  // Map에서 AppUser를 생성
  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'],
      email: map['email'],
      userName: map['userName'],
      university: map['university'],
      grade: map['grade'],
      major: map['major'],
      timetable: List<Map<String, dynamic>>.from(map['timetable'] ?? []),
    );
  }
}
